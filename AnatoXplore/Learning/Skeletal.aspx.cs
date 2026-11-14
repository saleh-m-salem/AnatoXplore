using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Collections;
using System.IO;
using System.Net;
using System.Text;

namespace AnatoXplore.Learning
{
    public partial class Skeletal : Page
    {

        private const int SkeletalSystemID = 1;
        private const int XPPerCorrectAnswer = 10;

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["AnatoXploreConnection"]
                    .ConnectionString;
            }
        }

        private class SubmittedAnswer
        {
            public int questionID { get; set; }
            public string answer { get; set; }
            public int secondsRemaining { get; set; }
        }

        private class FlashcardItem
        {
            public int FlashcardID { get; set; }
            public string QuestionText { get; set; }
            public string AnswerText { get; set; }
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSkeletalQuestions();
                LoadAnatomyReads();
                LoadFlashcards();
            }
            LoadVideos();
        }

        private void LoadVideos()
        {
            DataTable videos = VideoLibrary.GetVideos(ConnectionString, 1);
            rptVideos.DataSource = videos;
            rptVideos.DataBind();
            pnlNoVideos.Visible = videos.Rows.Count == 0;
        }

        private static bool TryBuildVideoUrls(string source, out string embedUrl, out string watchUrl)
        {
            embedUrl = String.Empty;
            watchUrl = String.Empty;
            Uri uri;
            if (!Uri.TryCreate(source, UriKind.Absolute, out uri) || uri.Scheme != Uri.UriSchemeHttps)
                return false;

            string host = uri.Host.ToLowerInvariant();
            if (host == "youtu.be" || host == "youtube.com" || host == "www.youtube.com" ||
                host == "m.youtube.com" || host == "youtube-nocookie.com" || host == "www.youtube-nocookie.com")
            {
                string videoId = null;
                string[] segments = uri.AbsolutePath.Trim('/').Split('/');
                if (host == "youtu.be")
                {
                    if (segments.Length > 0) videoId = segments[0];
                }
                else if (segments.Length >= 2 &&
                    (segments[0] == "embed" || segments[0] == "shorts" || segments[0] == "live"))
                {
                    videoId = segments[1];
                }
                else
                {
                    videoId = System.Web.HttpUtility.ParseQueryString(uri.Query).Get("v");
                }

                if (!IsValidYouTubeId(videoId)) return false;
                embedUrl = "https://www.youtube-nocookie.com/embed/" + videoId;
                watchUrl = "https://www.youtube.com/watch?v=" + videoId;
                return true;
            }

            if (host == "vimeo.com" || host == "www.vimeo.com" || host == "player.vimeo.com")
            {
                string[] segments = uri.AbsolutePath.Trim('/').Split('/');
                string videoId = segments.Length == 0 ? String.Empty : segments[segments.Length - 1];
                int numericId;
                if (!Int32.TryParse(videoId, out numericId) || numericId <= 0) return false;
                embedUrl = "https://player.vimeo.com/video/" + numericId;
                watchUrl = "https://vimeo.com/" + numericId;
                return true;
            }

            // For other providers, enter an HTTPS embed URL in Videos.VideoURL.
            embedUrl = uri.AbsoluteUri;
            watchUrl = uri.AbsoluteUri;
            return true;
        }

        private static bool IsValidYouTubeId(string value)
        {
            if (String.IsNullOrEmpty(value) || value.Length != 11) return false;
            foreach (char character in value)
            {
                if (!((character >= 'A' && character <= 'Z') ||
                      (character >= 'a' && character <= 'z') ||
                      (character >= '0' && character <= '9') || character == '_' || character == '-'))
                    return false;
            }
            return true;
        }
        private Control FindControlRecursive(Control root, string controlId)
        {
            if (root == null)
                return null;

            if (String.Equals(root.ID, controlId, StringComparison.Ordinal))
                return root;

            foreach (Control child in root.Controls)
            {
                Control found = FindControlRecursive(child, controlId);
                if (found != null)
                    return found;
            }

            return null;
        }

        private void LoadFlashcards()
        {
            List<FlashcardItem> flashcards = new List<FlashcardItem>();

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(@"
                    SELECT FlashcardID, QuestionText, AnswerText
                    FROM dbo.Flashcards
                    WHERE SystemID = @SystemID
                      AND IsActive = 1
                    ORDER BY DisplayOrder, FlashcardID;", connection))
                {
                    command.Parameters.Add("@SystemID", SqlDbType.Int).Value =
                        SkeletalSystemID;

                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            flashcards.Add(new FlashcardItem
                            {
                                FlashcardID = Convert.ToInt32(reader["FlashcardID"]),
                                QuestionText = Convert.ToString(reader["QuestionText"]),
                                AnswerText = Convert.ToString(reader["AnswerText"])
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Flashcard loading error: " + ex);
            }

            System.Web.UI.WebControls.HiddenField field =
                FindControlRecursive(this, "hiddenFlashcards")
                as System.Web.UI.WebControls.HiddenField;

            if (field != null)
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                field.Value = serializer.Serialize(flashcards);
            }
        }

        private void LoadSkeletalQuestions()
        {
            try
            {
                DataTable questions = new DataTable();

                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(@"
                    SELECT QuestionID, QuestionText, OptionA, OptionB, OptionC, OptionD
                    FROM dbo.Questions
                    WHERE SystemID = @SystemID
                    ORDER BY QuestionID;", connection))
                {
                    command.Parameters.Add("@SystemID", SqlDbType.Int).Value = SkeletalSystemID;

                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(questions);
                    }
                }

                rptSkeletalQuestions.DataSource = questions;
                rptSkeletalQuestions.DataBind();

                lblQuestionCount.Text = questions.Rows.Count + " questions available";
                lblQuizError.Text = "";
            }
            catch (Exception ex)
            {
                lblQuestionCount.Text = "";
                lblQuizError.Text = "Unable to load quiz questions. Please check the database connection.";
                System.Diagnostics.Debug.WriteLine("Skeletal quiz loading error: " + ex);
            }
        }

        protected void SubmitSkeletalQuiz(object sender, EventArgs e)
        {
            List<SubmittedAnswer> submittedAnswers;

            try
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                submittedAnswers = serializer.Deserialize<List<SubmittedAnswer>>(
                    hiddenQuizAnswers.Value ?? "[]");

                if (submittedAnswers == null)
                    submittedAnswers = new List<SubmittedAnswer>();
            }
            catch
            {
                lblQuizError.Text = "Your answers could not be read. Please try the quiz again.";
                return;
            }

            Dictionary<int, SubmittedAnswer> answerByQuestion =
                new Dictionary<int, SubmittedAnswer>();

            foreach (SubmittedAnswer answer in submittedAnswers)
            {
                if (answer == null || answer.questionID <= 0)
                    continue;

                if (answer.secondsRemaining < 0 || answer.secondsRemaining > 15)
                    answer.secondsRemaining = 0;

                if (answer.answer == null)
                    answer.answer = "";

                answer.answer = answer.answer.Trim().ToUpperInvariant();

                if (answer.answer != "A" && answer.answer != "B" &&
                    answer.answer != "C" && answer.answer != "D" && answer.answer != "")
                    answer.answer = "";

                answerByQuestion[answer.questionID] = answer;
            }

            int totalQuestions = 0;
            int correctAnswers = 0;
            int baseXP = 0;
            int speedBonusXP = 0;
            int elapsedSeconds = 0;

            using (SqlConnection connection = new SqlConnection(ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
                SELECT QuestionID, CorrectAnswer, OptionA, OptionB, OptionC, OptionD
                FROM dbo.Questions
                WHERE SystemID = @SystemID
                ORDER BY QuestionID;", connection))
            {
                command.Parameters.Add("@SystemID", SqlDbType.Int).Value = SkeletalSystemID;
                connection.Open();

                using (SqlDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        totalQuestions++;

                        int questionID = Convert.ToInt32(reader["QuestionID"]);
                            SubmittedAnswer submitted;
                            if (!answerByQuestion.TryGetValue(questionID, out submitted))
                            {
                                elapsedSeconds += 15;
                                continue;
                            }
                            elapsedSeconds += 15 - submitted.secondsRemaining;
                            if (String.IsNullOrWhiteSpace(submitted.answer))
                                continue;

                        string selectedLetter = submitted.answer;
                        string selectedColumn = "Option" + selectedLetter;
                        string selectedText = Convert.ToString(reader[selectedColumn]).Trim();
                        string correct = Convert.ToString(reader["CorrectAnswer"]).Trim();

                        bool isCorrect =
                            String.Equals(correct, selectedLetter, StringComparison.OrdinalIgnoreCase) ||
                            String.Equals(correct, selectedColumn, StringComparison.OrdinalIgnoreCase) ||
                            String.Equals(correct, selectedText, StringComparison.OrdinalIgnoreCase);

                        if (isCorrect)
                        {
                            correctAnswers++;
                            baseXP += XPPerCorrectAnswer;

                            // 0-5 bonus XP based on time remaining when answer was selected.
                            speedBonusXP += Math.Min(5, submitted.secondsRemaining / 3);
                        }
                    }
                }
            }

            if (totalQuestions == 0)
            {
                lblQuizError.Text = "No questions are available for this quiz.";
                return;
            }

            int totalXP = baseXP + speedBonusXP;

            double percentage = Math.Round(correctAnswers * 100.0 / totalQuestions, 1);
            lblQuizScore.Text = correctAnswers + " / " + totalQuestions;
            lblQuizPercentage.Text = percentage.ToString("0.#") + "%";
            lblCorrectCount.Text = correctAnswers.ToString();
            lblTotalQuestions.Text = totalQuestions.ToString();
            lblAccuracyStat.Text = percentage.ToString("0.#") + "%";
            lblBaseXP.Text = baseXP.ToString();
            lblSpeedBonusXP.Text = speedBonusXP.ToString();
            lblSpeedBonusBreakdown.Text = speedBonusXP.ToString();
            lblTotalXP.Text = totalXP.ToString();
            lblTotalXPBreakdown.Text = totalXP.ToString();

            quizScoreRing.Style["--score"] = percentage.ToString(
                System.Globalization.CultureInfo.InvariantCulture) + "%";

            int xpTotal = baseXP + speedBonusXP;
            double baseWidth = xpTotal > 0 ? baseXP * 100.0 / xpTotal : 0;
            double speedWidth = xpTotal > 0 ? speedBonusXP * 100.0 / xpTotal : 0;
            xpBaseBar.Style["width"] = baseWidth.ToString(
                System.Globalization.CultureInfo.InvariantCulture) + "%";
            xpSpeedBar.Style["width"] = speedWidth.ToString(
                System.Globalization.CultureInfo.InvariantCulture) + "%";

            if (percentage >= 80)
                lessonResultTitle.InnerText = "Amazing work!";
            else if (percentage >= 50)
                lessonResultTitle.InnerText = "Good effort!";
            else
                lessonResultTitle.InnerText = "Keep practising!";

            object sessionUserID = Session["UserID"];

            if (sessionUserID == null)
            {
                lblQuizSaveMessage.Text =
                    "Guest result: your score and estimated XP have not been saved.";
            }
            else
            {
                int userID;

                if (!Int32.TryParse(Convert.ToString(sessionUserID), out userID))
                {
                    lblQuizSaveMessage.Text =
                        "Your login session could not be verified. No results were saved.";
                    ShowQuizResults();
                    return;
                }

                try
                {
                    SaveQuizResult(userID, correctAnswers, totalQuestions, baseXP, speedBonusXP, elapsedSeconds);
                    lblQuizSaveMessage.Text =
                        "Your score and XP have been saved to your account.";
                }
                catch (Exception ex)
                {
                    lblQuizSaveMessage.Text =
                        "Your score was calculated, but it could not be saved. Please try again.";
                    System.Diagnostics.Debug.WriteLine("Saving quiz result failed: " + ex);
                }
            }

            ShowQuizResults();
        }

        private void SaveQuizResult(int userID, int score, int totalQuestions, int baseXP, int speedBonusXP, int elapsedSeconds)
        {
            QuizService.SaveResult(ConnectionString, userID, 1, score, totalQuestions, baseXP, speedBonusXP, elapsedSeconds, "Skeletal System Quiz");
        }

        private void ShowQuizResults()
        {
            pnlQuizPlay.Visible = false;
            pnlQuizResults.Visible = true;

            string script = @"
                (function () {
                    var page = document.querySelector('.lesson-page');
                    if (page) page.classList.add('lesson-gaming-mode');

                    document.querySelectorAll('.lesson-tab').forEach(function (tab) {
                        var active = tab.getAttribute('data-panel') === 'quiz';
                        tab.classList.toggle('active', active);
                        tab.setAttribute('aria-selected', active ? 'true' : 'false');
                    });

                    document.querySelectorAll('.lesson-panel').forEach(function (panel) {
                        panel.classList.toggle('active', panel.id === 'panel-quiz');
                    });
                })();";

            ClientScript.RegisterStartupScript(
                GetType(), "ShowQuizResults", script, true);
        }

        protected void btnTryAgain_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Learning/Skeletal.aspx?showQuiz=1#panel-quiz", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void btnFinishQuiz_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Learning/Skeletal.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        // API Integration: Wikipedia — Skeletal System
        private void LoadAnatomyReads()
        {
            string[,] topics = new string[,]
            {
                { "Why bones constantly remodel themselves", "Bone_remodeling" },
                { "Why do joints crack?", "Joint" },
                { "How do fractures heal?", "Bone_fracture" },
                { "How do synovial joints work?", "Synovial_joint" }
            };
            DataTable articles = WikipediaArticleService.GetArticles(topics);
            rptAnatomyReads.DataSource = articles;
            rptAnatomyReads.DataBind();
            lblAnatomyReadsMessage.Text = articles.Rows.Count > 0
                ? "Discover fascinating facts about the skeletal system through articles from Wikipedia."
                : "Anatomy articles could not be loaded right now. Please try again later.";
        }
    }
}
