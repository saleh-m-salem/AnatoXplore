using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace AnatoXplore.Learning
{
    public static class VideoLibrary
    {
        public static DataTable GetVideos(string connectionString, int systemID)
        {
            DataTable videos = new DataTable();
            using (SqlConnection connection = new SqlConnection(connectionString))
            using (SqlCommand command = new SqlCommand("SELECT VideoTitle, VideoURL, Description FROM dbo.Videos WHERE SystemID = @SystemID ORDER BY VideoID;", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.Parameters.Add("@SystemID", SqlDbType.Int).Value = systemID;
                adapter.Fill(videos);
            }
            videos.Columns.Add("EmbedURL", typeof(string));
            videos.Columns.Add("WatchURL", typeof(string));
            for (int i = videos.Rows.Count - 1; i >= 0; i--)
            {
                string embed, watch;
                if (!TryBuildUrls(Convert.ToString(videos.Rows[i]["VideoURL"]), out embed, out watch)) { videos.Rows.RemoveAt(i); continue; }
                videos.Rows[i]["EmbedURL"] = embed; videos.Rows[i]["WatchURL"] = watch;
            }
            return videos;
        }
        public static bool TryBuildUrls(string source, out string embed, out string watch)
        {
            embed = watch = String.Empty; Uri uri;
            if (!Uri.TryCreate(source, UriKind.Absolute, out uri) || uri.Scheme != Uri.UriSchemeHttps) return false;
            string host = uri.Host.ToLowerInvariant();
            if (host == "youtu.be" || host == "youtube.com" || host == "www.youtube.com" || host == "m.youtube.com" || host == "youtube-nocookie.com" || host == "www.youtube-nocookie.com")
            {
                string[] segments = uri.AbsolutePath.Trim('/').Split('/');
                string id = host == "youtu.be" ? (segments.Length > 0 ? segments[0] : null) : (segments.Length >= 2 && (segments[0] == "embed" || segments[0] == "shorts" || segments[0] == "live") ? segments[1] : HttpUtility.ParseQueryString(uri.Query).Get("v"));
                if (String.IsNullOrEmpty(id) || id.Length != 11) return false;
                foreach (char c in id) if (!Char.IsLetterOrDigit(c) && c != '_' && c != '-') return false;
                embed = "https://www.youtube-nocookie.com/embed/" + id; watch = "https://www.youtube.com/watch?v=" + id; return true;
            }
            if (host == "vimeo.com" || host == "www.vimeo.com" || host == "player.vimeo.com")
            {
                string[] segments = uri.AbsolutePath.Trim('/').Split('/'); int id;
                if (segments.Length == 0 || !Int32.TryParse(segments[segments.Length - 1], out id) || id <= 0) return false;
                embed = "https://player.vimeo.com/video/" + id; watch = "https://vimeo.com/" + id; return true;
            }
            embed = watch = uri.AbsoluteUri; return true;
        }
    }
}
