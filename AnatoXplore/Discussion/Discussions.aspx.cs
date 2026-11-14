using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace AnatoXplore
{
    public partial class Discussions : System.Web.UI.Page
    {
        // Which sort/filter tab is selected: "" (none), newest, replies, unanswered or mine.
        // ViewState remembers it between clicks on the same page.
        private string CurrentFilter
        {
            get
            {
                return ViewState["Filter"] == null
                    ? ""
                    : ViewState["Filter"].ToString();
            }
            set
            {
                ViewState["Filter"] = value;
            }
        }

        // Which topic chip is selected (0 = no topic filter).
        private int CurrentTopic
        {
            get
            {
                return ViewState["Topic"] == null
                    ? 0
                    : (int)ViewState["Topic"];
            }
            set
            {
                ViewState["Topic"] = value;
            }
        }

        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["AnatoXploreConnection"]
                    .ConnectionString;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool isLoggedIn = Session["UserID"] != null;

            // Guests can read posts, but must log in before posting.
            pnlGuestNote.Visible = !isLoggedIn;
            lnkNewPost.NavigateUrl = isLoggedIn
                ? "~/Discussion/CreateDiscussion.aspx"
                : "~/Login.aspx";

            // "My posts" only makes sense for logged-in students.
            btnMyPosts.Visible = isLoggedIn;

            if (!IsPostBack)
            {
                // Other pages can open this page already filtered,
                // for example Discussions.aspx?topic=1
                int topicFromUrl;
                if (int.TryParse(Request.QueryString["topic"], out topicFromUrl))
                {
                    CurrentTopic = topicFromUrl;
                }

                ShowStatusMessage();
                LoadDiscussions();
            }
        }

        // Shows one chip for each body system in the BodySystems table.
        private void LoadTopicChips()
        {
            DataTable topics = new DataTable();

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(
                    "SELECT SystemID, SystemName FROM BodySystems ORDER BY SystemName",
                    connection))
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    adapter.Fill(topics);
                }
            }
            catch (Exception)
            {
                // If topics cannot be loaded, the page still works without chips.
            }

            rptTopics.DataSource = topics;
            rptTopics.DataBind();
        }

        // Reads the main posts (not replies) using the search box,
        // the selected topic chip and the selected sort/filter tab.
        private void LoadDiscussions()
        {
            string search = txtSearch.Text.Trim();
            int topicId = CurrentTopic;
            string filter = CurrentFilter;

            // "My posts" needs a logged-in user.
            if (filter == "mine" && Session["UserID"] == null)
            {
                filter = "";
                CurrentFilter = filter;
            }

            LoadTopicChips();
            HighlightFilterButton(filter);

            string query = @"
                SELECT d.DiscussionID,
                       d.Title,
                       d.CreatedAt,
                       u.FullName AS AuthorName,
                       u.ProfilePhotoPath AS AuthorPhotoPath,
                       ISNULL(pf.FrameKey, N'default-blue') AS AuthorFrameKey,
                       bs.SystemName,
                       (SELECT COUNT(*)
                        FROM Discussions r
                        WHERE r.ParentDiscussionID = d.DiscussionID) AS ReplyCount
                FROM Discussions d
                INNER JOIN Users u ON u.UserID = d.UserID
                LEFT JOIN dbo.UserProfileFrames upf ON upf.UserID = u.UserID AND upf.IsEquipped = 1
                LEFT JOIN dbo.ProfileFrames pf ON pf.FrameID = upf.FrameID
                LEFT JOIN BodySystems bs ON bs.SystemID = d.SystemID
                WHERE d.ParentDiscussionID IS NULL";

            // Extra conditions are added only when they are needed.
            if (search != "")
                query += " AND (d.Title LIKE @Search OR d.PostContent LIKE @Search)";

            if (topicId > 0)
                query += " AND d.SystemID = @SystemID";

            if (filter == "unanswered")
                query += @" AND NOT EXISTS (SELECT 1 FROM Discussions r
                                            WHERE r.ParentDiscussionID = d.DiscussionID)";

            if (filter == "mine")
                query += " AND d.UserID = @UserID";

            // Newest posts first, unless "Most replies" is selected.
            if (filter == "replies")
                query += " ORDER BY ReplyCount DESC, d.CreatedAt DESC";
            else
                query += " ORDER BY d.CreatedAt DESC";

            DataTable discussions = new DataTable();

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    // Parameters keep the query safe from SQL injection.
                    if (search != "")
                        command.Parameters.Add("@Search", SqlDbType.NVarChar, 110).Value =
                            "%" + search + "%";

                    if (topicId > 0)
                        command.Parameters.Add("@SystemID", SqlDbType.Int).Value = topicId;

                    if (filter == "mine")
                        command.Parameters.Add("@UserID", SqlDbType.Int).Value =
                            Convert.ToInt32(Session["UserID"]);

                    using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                    {
                        adapter.Fill(discussions);
                    }
                }
            }
            catch (Exception)
            {
                litResultCount.Text = "Could not load discussions.";
                return;
            }

            rptDiscussions.DataSource = discussions;
            rptDiscussions.DataBind();

            int count = discussions.Rows.Count;
            litResultCount.Text = "Showing " + count +
                (count == 1 ? " discussion" : " discussions");

            bool isFiltered = search != "" || topicId > 0 || filter != "";
            btnClear.Visible = isFiltered;

            pnlEmpty.Visible = count == 0;
            litEmpty.Text = isFiltered
                ? "No discussions match your search or filters."
                : "No discussions yet. Be the first to start one!";
        }

        // Makes the selected sort/filter tab white with blue text.
        private void HighlightFilterButton(string filter)
        {
            btnNewest.CssClass = filter == "newest" ? "disc-sort-btn active" : "disc-sort-btn";
            btnMostReplies.CssClass = filter == "replies" ? "disc-sort-btn active" : "disc-sort-btn";
            btnUnanswered.CssClass = filter == "unanswered" ? "disc-sort-btn active" : "disc-sort-btn";
            btnMyPosts.CssClass = filter == "mine" ? "disc-sort-btn active" : "disc-sort-btn";
        }

        // Search button clicked (or Enter pressed in the search box).
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadDiscussions();
        }

        // A topic chip clicked. Clicking the selected chip again turns it off.
        protected void Topic_Command(object sender, CommandEventArgs e)
        {
            int topicId = Convert.ToInt32(e.CommandArgument);
            CurrentTopic = CurrentTopic == topicId ? 0 : topicId;
            LoadDiscussions();
        }

        // A sort/filter tab clicked. Clicking the selected tab again turns it off.
        protected void Filter_Command(object sender, CommandEventArgs e)
        {
            string filter = e.CommandArgument.ToString();
            CurrentFilter = CurrentFilter == filter ? "" : filter;
            LoadDiscussions();
        }

        // Resets the search box, topic chips and sort tabs.
        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            CurrentTopic = 0;
            CurrentFilter = "";
            LoadDiscussions();
        }

        // CSS class for a topic chip.
        protected string GetTopicChipClass(object systemId)
        {
            return Convert.ToInt32(systemId) == CurrentTopic
                ? "disc-chip active"
                : "disc-chip";
        }

        // An icon for each body system (Font Awesome class names).
        protected string GetTopicIcon(object systemName)
        {
            string name = Convert.ToString(systemName);

            if (name.Contains("Skeletal")) return "fa-solid fa-bone";
            if (name.Contains("Cardio")) return "fa-solid fa-heart-pulse";
            if (name.Contains("Nervous")) return "fa-solid fa-brain";
            if (name.Contains("Muscular")) return "fa-solid fa-dumbbell";
            if (name.Contains("Respiratory")) return "fa-solid fa-lungs";
            if (name.Contains("Digestive")) return "fa-solid fa-utensils";

            return "fa-solid fa-book-medical";
        }

        // Light background and dark text colour for each body system.
        // Used by the topic chips and by the topic labels in the list.
        private string[] GetTopicPalette(string name)
        {
            if (name.Contains("Skeletal")) return new[] { "#f6efe4", "#7a5a2b" };
            if (name.Contains("Cardio")) return new[] { "#fdecec", "#c03535" };
            if (name.Contains("Nervous")) return new[] { "#fdeef3", "#b83268" };
            if (name.Contains("Muscular")) return new[] { "#fff1e6", "#c2570c" };
            if (name.Contains("Respiratory")) return new[] { "#e7f6f8", "#0f7488" };
            if (name.Contains("Digestive")) return new[] { "#e6f6ef", "#1e7a45" };

            return new[] { "#eaf4ff", "#1674df" };
        }

        // Icon colour for a topic chip.
        protected string GetTopicColour(object systemName)
        {
            string[] palette = GetTopicPalette(Convert.ToString(systemName));
            return "color:" + palette[1] + ";";
        }

        // "Skeletal System" -> "Skeletal".
        protected string GetShortTopicName(object systemName)
        {
            return Convert.ToString(systemName).Replace(" System", "");
        }

        // Shows a green message after a post is created, updated or deleted.
        private void ShowStatusMessage()
        {
            string msg = Request.QueryString["msg"];

            if (msg == "created")
                lblStatus.Text = "Your post was published.";
            else if (msg == "updated")
                lblStatus.Text = "Your post was updated.";
            else if (msg == "deleted")
                lblStatus.Text = "The post was deleted.";

            lblStatus.Visible = lblStatus.Text != "";
        }

        // Turns a date into "2 hours ago", "3 days ago", etc.
        protected string GetTimeAgo(object value)
        {
            DateTime date = Convert.ToDateTime(value);
            TimeSpan difference = DateTime.Now - date;

            if (difference.TotalMinutes < 1)
                return "just now";
            if (difference.TotalMinutes < 60)
                return Plural((int)difference.TotalMinutes, "minute") + " ago";
            if (difference.TotalHours < 24)
                return Plural((int)difference.TotalHours, "hour") + " ago";
            if (difference.TotalDays < 7)
                return Plural((int)difference.TotalDays, "day") + " ago";

            return date.ToString("d MMM yyyy");
        }

        private string Plural(int number, string word)
        {
            return number + " " + word + (number == 1 ? "" : "s");
        }

        // Shows the topic as a small coloured label with its icon
        // (nothing if the post has no topic).
        protected string GetTopicBadge(object value)
        {
            if (value == null || value == DBNull.Value)
                return "";

            string name = value.ToString();
            name = name.Replace("System", "").Trim();

            return "<span class=\"disc-topic\">" +
                   Server.HtmlEncode(name) +
                   "</span>";
        }
        protected string GetInitials(object value)
        {
            string name = Convert.ToString(value).Trim();
            if (name == "")
                return "?";

            string[] parts = name.Split(new[] { ' ' },
                StringSplitOptions.RemoveEmptyEntries);

            string initials = parts[0].Substring(0, 1);
            if (parts.Length > 1)
                initials += parts[parts.Length - 1].Substring(0, 1);

            return initials.ToUpper();
        }

        // Gives each author the same colour every time, based on their name.
        protected string GetAvatarStyle(object value)
        {
            string[] backgrounds = { "#eaf4ff", "#e6f6ef", "#fff1e6", "#f1ecfd", "#fdeef3", "#e7f6f8" };
            string[] colours = { "#1674df", "#1e7a45", "#c2570c", "#6b46c1", "#b83268", "#0f7488" };

            string name = Convert.ToString(value);
            int total = 0;
            foreach (char letter in name)
                total += letter;

            int index = total % backgrounds.Length;
            return "background:" + backgrounds[index] + ";color:" + colours[index] + ";";
        }

        // "No replies yet" for 0, otherwise a blue reply count.
        protected string GetRepliesBadge(object value)
        {
            int replies = Convert.ToInt32(value);

            if (replies == 0)
                return "<span class=\"disc-noreply\">No replies yet</span>";

            return "<span class=\"disc-replies\" title=\"Replies\">" +
                   "<i class=\"fa-regular fa-comment\"></i> " + replies +
                   "</span>";
        }
    }
}