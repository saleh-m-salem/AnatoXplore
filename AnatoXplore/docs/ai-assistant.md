# AnatoXplore AI assistant setup

The floating chat widget uses the Gemini Developer API `generateContent` endpoint through `Services/AIChatHandler.ashx`. The browser never receives the API key, and chat messages are not written to the AnatoXplore database.

## Configure the free tier for local IIS Express

1. Open [Google AI Studio](https://aistudio.google.com/app/apikey), create an API key, and check that your project has Gemini API free-tier access.
2. In Windows, add a user environment variable named `GEMINI_API_KEY` with the key as its value. Do not put the key in this repository or in `Web.config`.
3. Close Visual Studio completely and reopen it so IIS Express inherits the environment variable, then run the website again.
4. The default model is `gemini-3.5-flash-lite`. To change it, update the `GeminiChatModel` setting in `Web.config` to a model available to your API project.

The free tier has model and rate limits that may change, and free-tier prompts and responses may be used by Google to improve its products. The widget tells users not to include personal or health details. The endpoint validates message count and size and limits requests per IP address. Review your active limits in Google AI Studio. Keep the key in a protected environment or secret store when deploying.
