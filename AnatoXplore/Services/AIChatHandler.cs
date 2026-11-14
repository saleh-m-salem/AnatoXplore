using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace AnatoXplore.Services
{
    public sealed class AIChatHandler : IHttpHandler
    {
        private const int MaxRequestCharacters = 16000;
        private const int MaxMessages = 8;
        private const int MaxMessageCharacters = 1200;
        private const int MaxConversationCharacters = 6000;
        private const int RequestsPerMinute = 8;
        private const int RequestsPerHour = 50;

        private const string AssistantInstructions = @"You are AnatoXplore's friendly anatomy learning assistant. Answer in clear, concise English. Help with educational human anatomy questions and with using the AnatoXplore website. The site has Skeletal, Cardiovascular, Nervous, and Muscular learning sections with structures, videos, flashcards, and quizzes, plus discussions, a leaderboard, profile and quiz history, and feedback. Do not claim to see a user's private account, current scores, or live database. If asked for a diagnosis, treatment, or urgent medical advice, explain that you provide educational information only and recommend a qualified healthcare professional; for emergencies recommend local emergency services. Be honest when uncertain and keep answers appropriate for students.";

        public bool IsReusable { get { return true; } }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            context.Response.ContentEncoding = Encoding.UTF8;
            context.Response.TrySkipIisCustomErrors = true;
            context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            context.Response.Cache.SetNoStore();

            if (!String.Equals(context.Request.HttpMethod, "POST", StringComparison.OrdinalIgnoreCase))
            {
                WriteError(context, 405, "Send a message using the chat window.");
                return;
            }

            string apiKey = Environment.GetEnvironmentVariable("GEMINI_API_KEY");
            if (String.IsNullOrWhiteSpace(apiKey))
            {
                WriteError(context, 503, "AI chat needs an API key before it can answer. Set GEMINI_API_KEY for the web app, then restart IIS Express.");
                return;
            }

            if (!IsWithinRateLimit(context.Request.UserHostAddress))
            {
                WriteError(context, 429, "You have sent several messages quickly. Please wait a minute and try again.");
                return;
            }

            try
            {
                string json = ReadRequestBody(context.Request);
                JObject body = JObject.Parse(json);
                JArray messages = ValidateMessages(body["messages"] as JArray);
                if (messages == null)
                {
                    WriteError(context, 400, "Please send a message of up to 1,200 characters.");
                    return;
                }

                string model = ConfigurationManager.AppSettings["GeminiChatModel"];
                if (String.IsNullOrWhiteSpace(model)) model = "gemini-3.5-flash-lite";

                JArray contents = new JArray();
                foreach (JToken message in messages)
                {
                    contents.Add(new JObject
                    {
                        ["role"] = Convert.ToString(message["role"]) == "assistant" ? "model" : "user",
                        ["parts"] = new JArray(new JObject { ["text"] = Convert.ToString(message["content"]) })
                    });
                }

                JObject payload = new JObject
                {
                    ["systemInstruction"] = new JObject
                    {
                        ["parts"] = new JArray(new JObject { ["text"] = AssistantInstructions })
                    },
                    ["contents"] = contents,
                    ["generationConfig"] = new JObject { ["maxOutputTokens"] = 500 }
                };

                string reply = RequestGemini(apiKey.Trim(), model, payload);
                if (String.IsNullOrWhiteSpace(reply))
                {
                    WriteError(context, 502, "The assistant did not return an answer. Please try again.");
                    return;
                }

                context.Response.StatusCode = 200;
                context.Response.Write(JsonConvert.SerializeObject(new { reply = reply.Trim() }));
            }
            catch (InvalidDataException)
            {
                WriteError(context, 413, "That message is too long. Please shorten it and try again.");
            }
            catch (JsonException)
            {
                WriteError(context, 400, "I couldn't read that message. Please try again.");
            }
            catch (WebException ex)
            {
                HttpWebResponse providerResponse = ex.Response as HttpWebResponse;
                int providerStatus = providerResponse == null ? 0 : (int)providerResponse.StatusCode;
                System.Diagnostics.Debug.WriteLine("Gemini request failed. Status: " + ex.Status + "; HTTP: " + providerStatus);
                WriteError(context, 502, GetProviderErrorMessage(ex, providerStatus));
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("AI chat request failed: " + ex);
                WriteError(context, 500, "The assistant is temporarily unavailable. Please try again.");
            }
        }

        private static string ReadRequestBody(HttpRequest request)
        {
            if (request.ContentLength > MaxRequestCharacters)
                throw new InvalidDataException();

            StringBuilder body = new StringBuilder();
            char[] buffer = new char[2048];
            using (StreamReader reader = new StreamReader(request.InputStream, Encoding.UTF8))
            {
                int read;
                while ((read = reader.Read(buffer, 0, buffer.Length)) > 0)
                {
                    body.Append(buffer, 0, read);
                    if (body.Length > MaxRequestCharacters)
                        throw new InvalidDataException();
                }
            }
            return body.ToString();
        }

        private static JArray ValidateMessages(JArray incoming)
        {
            if (incoming == null || incoming.Count == 0 || incoming.Count > MaxMessages)
                return null;

            JArray clean = new JArray();
            int totalCharacters = 0;
            string lastRole = null;
            foreach (JToken token in incoming)
            {
                JObject message = token as JObject;
                if (message == null) return null;
                string role = Convert.ToString(message["role"]);
                string content = Convert.ToString(message["content"]);
                if ((role != "user" && role != "assistant") || String.IsNullOrWhiteSpace(content)) return null;
                content = content.Trim();
                if (content.Length > MaxMessageCharacters) return null;
                totalCharacters += content.Length;
                if (totalCharacters > MaxConversationCharacters) return null;
                clean.Add(new JObject { ["role"] = role, ["content"] = content });
                lastRole = role;
            }
            return lastRole == "user" ? clean : null;
        }

        private static string RequestGemini(string apiKey, string model, JObject payload)
        {
            if (!System.Text.RegularExpressions.Regex.IsMatch(model, @"^[A-Za-z0-9._-]+$"))
                model = "gemini-3.5-flash-lite";

            byte[] requestBytes = Encoding.UTF8.GetBytes(payload.ToString(Formatting.None));
            string url = "https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Method = "POST";
            request.ContentType = "application/json";
            request.Accept = "application/json";
            request.Headers["x-goog-api-key"] = apiKey;
            request.Timeout = 30000;
            request.ReadWriteTimeout = 30000;
            request.ContentLength = requestBytes.Length;

            using (Stream stream = request.GetRequestStream())
                stream.Write(requestBytes, 0, requestBytes.Length);

            using (HttpWebResponse response = (HttpWebResponse)request.GetResponse())
            using (Stream stream = response.GetResponseStream())
            using (StreamReader reader = new StreamReader(stream, Encoding.UTF8))
            {
                JObject result = JObject.Parse(reader.ReadToEnd());
                JArray candidates = result["candidates"] as JArray;
                if (candidates == null || candidates.Count == 0) return String.Empty;
                JObject content = candidates[0]["content"] as JObject;
                JArray parts = content == null ? null : content["parts"] as JArray;
                if (parts == null) return String.Empty;

                StringBuilder output = new StringBuilder();
                foreach (JToken part in parts)
                {
                    string text = Convert.ToString(part["text"]);
                    if (text.Length == 0) continue;
                    if (output.Length > 0) output.AppendLine();
                    output.Append(text);
                }
                return output.ToString();
            }
        }
        private static string GetProviderErrorMessage(WebException exception, int statusCode)
        {
            if (statusCode == 401 || statusCode == 403)
                return "Gemini rejected the API key. Create a new key in Google AI Studio, update GEMINI_API_KEY, and restart Visual Studio.";
            if (statusCode == 429)
                return "The Gemini free-tier request limit was reached. Check your active limits in Google AI Studio and try again later.";
            if (statusCode == 400 || statusCode == 404)
                return "Gemini rejected the model or request. Check the GeminiChatModel setting in Web.config.";
            if (statusCode >= 500)
                return "Google Gemini is temporarily unavailable. Please try again in a moment.";
            if (exception.Status == WebExceptionStatus.Timeout)
                return "Gemini took too long to respond. Please try again.";
            if (exception.Status == WebExceptionStatus.NameResolutionFailure || exception.Status == WebExceptionStatus.ConnectFailure)
                return "The website could not reach Gemini. Check the server internet connection and try again.";
            return "The Gemini service could not answer. Check the API key and Google AI Studio project, then try again.";
        }
        private static bool IsWithinRateLimit(string address)
        {
            string key = "AnatoXploreAIChat:" + (String.IsNullOrWhiteSpace(address) ? "unknown" : address);
            System.Web.Caching.Cache cache = HttpRuntime.Cache;
            RateWindow window = cache[key] as RateWindow;
            if (window == null)
            {
                RateWindow newWindow = new RateWindow();
                cache.Insert(key, newWindow, null, DateTime.Now.AddMinutes(1), System.Web.Caching.Cache.NoSlidingExpiration);
                window = cache[key] as RateWindow ?? newWindow;
            }

            lock (window)
            {
                DateTime hourCutoff = DateTime.UtcNow.AddHours(-1);
                while (window.Requests.Count > 0 && window.Requests.Peek() < hourCutoff)
                    window.Requests.Dequeue();
                DateTime minuteCutoff = DateTime.UtcNow.AddMinutes(-1);
                int recentCount = 0;
                foreach (DateTime requestTime in window.Requests)
                    if (requestTime >= minuteCutoff) recentCount++;
                if (recentCount >= RequestsPerMinute || window.Requests.Count >= RequestsPerHour) return false;
                window.Requests.Enqueue(DateTime.UtcNow);
                return true;
            }
        }

        private static void WriteError(HttpContext context, int statusCode, string message)
        {
            context.Response.StatusCode = statusCode;
            context.Response.Write(JsonConvert.SerializeObject(new { error = message }));
        }

        private sealed class RateWindow
        {
            public Queue<DateTime> Requests = new Queue<DateTime>();
        }
    }
}




