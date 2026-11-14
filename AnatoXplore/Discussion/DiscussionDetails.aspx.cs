using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace AnatoXplore
{
    public partial class DiscussionDetails : System.Web.UI.Page
    {
        // The post shown on this page, from DiscussionDetails.aspx?id=5
        private int PostID
        {
            get
            {
                return ViewState["PostID"] == null
                    ? 0
                    : (int)ViewState["PostID"];
            }
            set
            {
                ViewState["PostID"] = value;
            }
        }

        // Kept so replies can be saved with the title "RE: <post title>".
        private string PostTitle
        {
            get { return Convert.ToString(ViewState["PostTitle"]); }
            set { ViewState["PostTitle"] = value; }
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

        private bool IsLoggedIn
        {
            get { return Session["UserID"] != null; }
        }

        private int CurrentUserID
        {
            get { return IsLoggedIn ? Convert.ToInt32(Session["UserID"]) : 0; }
        }

        private bool IsAdmin()
        {
            string role = Convert.ToString(Session["Role"]);
            return role.Equals("Admin", StringComparison.OrdinalIgnoreCase)
                || role.Equals("Administrator", StringComparison.OrdinalIgnoreCase);
        }

        // True when the logged-in user wrote this item, or is an admin.
        protected bool CanManage(object ownerId)
        {
            if (!IsLoggedIn)
                return false;

            return Convert.ToInt32(ownerId) == CurrentUserID || IsAdmin();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Guests can read, but only logged-in users can reply.
            pnlReplyForm.Visible = IsLoggedIn;
            pnlLoginToReply.Visible = !IsLoggedIn;

            txtReply.Attributes["maxlength"] = "2000";

            if (!IsPostBack)
            {
                int id;
                if (!int.TryParse(Request.QueryString["id"], out id))
                {
                    ShowNotFound();
                    return;
                }

                PostID = id;
                ShowStatusMessage();
                LoadPost();
            }
        }

        // ---------------------------------------------------------
        // READ: the post and its replies
        // ---------------------------------------------------------

        private void LoadPost()
        {
            string query = @"
                SELECT d.DiscussionID, d.UserID, d.Title, d.PostContent,
                       d.CreatedAt, d.UpdatedAt,
                       u.FullName AS AuthorName,
                       u.ProfilePhotoPath,
                       ISNULL(pf.FrameKey, N'default-blue') AS ProfileFrameKey,
                       bs.SystemName
                FROM Discussions d
                INNER JOIN Users u ON u.UserID = d.UserID
                LEFT JOIN dbo.UserProfileFrames upf ON upf.UserID = u.UserID AND upf.IsEquipped = 1
                LEFT JOIN dbo.ProfileFrames pf ON pf.FrameID = upf.FrameID
                LEFT JOIN BodySystems bs ON bs.SystemID = d.SystemID
                WHERE d.DiscussionID = @ID
                  AND d.ParentDiscussionID IS NULL";

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.Add("@ID", SqlDbType.Int).Value = PostID;
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            ShowNotFound();
                            return;
                        }

                        string title = reader["Title"].ToString();
                        string author = reader["AuthorName"].ToString();
                        PostTitle = title;

                        Page.Title = title + " | AnatoXplore";
                        litTitle.Text = Server.HtmlEncode(title);
                        litAuthor.Text = Server.HtmlEncode(author);
                        litAvatar.Text = ProfileBadgeRenderer.Render(
                            reader["ProfilePhotoPath"], reader["ProfileFrameKey"], author, "dd-avatar");
                        litContent.Text = FormatContent(reader["PostContent"]);
                        litTopic.Text = GetTopicBadge(reader["SystemName"]);

                        // "Posted 2 hours ago · edited 5 minutes ago"
                        string meta = "Posted " + GetTimeAgo(reader["CreatedAt"]);
                        if (reader["UpdatedAt"] != DBNull.Value)
                        {
                            meta += " &bull; <span class=\"dd-edited\">edited " +
                                    GetTimeAgo(reader["UpdatedAt"]) + "</span>";
                        }
                        litPostMeta.Text = meta;

                        // Edit and Delete buttons for the author or an admin.
                        pnlOwnerActions.Visible = CanManage(reader["UserID"]);
                        lnkEdit.NavigateUrl = "~/Discussion/CreateDiscussion.aspx?id=" + PostID;
                    }
                }
            }
            catch (Exception)
            {
                ShowError("Could not load this discussion. Please try again.");
                return;
            }

            LoadReplies();
        }

        private void LoadReplies()
        {
            string query = @"
                SELECT r.DiscussionID, r.UserID, r.PostContent, r.CreatedAt,
                       u.FullName AS AuthorName, u.ProfilePhotoPath,
                       ISNULL(pf.FrameKey, N'default-blue') AS ProfileFrameKey
                FROM Discussions r
                INNER JOIN Users u ON u.UserID = r.UserID
                LEFT JOIN dbo.UserProfileFrames upf ON upf.UserID = u.UserID AND upf.IsEquipped = 1
                LEFT JOIN dbo.ProfileFrames pf ON pf.FrameID = upf.FrameID
                WHERE r.ParentDiscussionID = @ID
                ORDER BY r.CreatedAt ASC";

            DataTable replies = new DataTable();

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                using (SqlDataAdapter adapter = new SqlDataAdapter(command))
                {
                    command.Parameters.Add("@ID", SqlDbType.Int).Value = PostID;
                    adapter.Fill(replies);
                }
            }
            catch (Exception)
            {
                ShowError("Could not load the replies. Please try again.");
                return;
            }

            rptReplies.DataSource = replies;
            rptReplies.DataBind();

            litReplyCount.Text = replies.Rows.Count.ToString();
            pnlNoReplies.Visible = replies.Rows.Count == 0;
        }

        // ---------------------------------------------------------
        // CREATE: add a reply
        // ---------------------------------------------------------

        protected void btnReply_Click(object sender, EventArgs e)
        {
            if (!IsLoggedIn)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!Page.IsValid)
                return;

            string reply = txtReply.Text.Trim();
            if (reply.Length < 2)
            {
                ShowError("Your reply is too short.");
                return;
            }

            // Replies are stored in the same table, linked to the post
            // through ParentDiscussionID.
            string title = "RE: " + PostTitle;
            if (title.Length > 200)
                title = title.Substring(0, 200);

            string query = @"
                INSERT INTO Discussions
                    (UserID, ParentDiscussionID, Title, PostContent, CreatedAt)
                VALUES
                    (@UserID, @ParentID, @Title, @PostContent, GETDATE())";

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                    command.Parameters.Add("@ParentID", SqlDbType.Int).Value = PostID;
                    command.Parameters.Add("@Title", SqlDbType.NVarChar, 200).Value = title;
                    command.Parameters.Add("@PostContent", SqlDbType.NVarChar, -1).Value = reply;

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception)
            {
                ShowError("Your reply could not be saved. Please try again.");
                return;
            }

            // Reload the page, so pressing F5 does not post the reply twice.
            RedirectToThisPost("replied");
        }

        // ---------------------------------------------------------
        // DELETE: a reply, or the whole post
        // ---------------------------------------------------------

        protected void rptReplies_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteReply" || !IsLoggedIn)
                return;

            int replyId = Convert.ToInt32(e.CommandArgument);

            // The WHERE makes sure users can only delete their own replies
            // (admins can delete any reply).
            string query = @"
                DELETE FROM Discussions
                WHERE DiscussionID = @ReplyID
                  AND ParentDiscussionID = @PostID
                  AND (UserID = @UserID OR @IsAdmin = 1)";

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.Add("@ReplyID", SqlDbType.Int).Value = replyId;
                    command.Parameters.Add("@PostID", SqlDbType.Int).Value = PostID;
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                    command.Parameters.Add("@IsAdmin", SqlDbType.Bit).Value = IsAdmin();

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception)
            {
                ShowError("The reply could not be deleted. Please try again.");
                return;
            }

            RedirectToThisPost("replydeleted");
        }

        protected void btnDeletePost_Click(object sender, EventArgs e)
        {
            if (!IsLoggedIn)
                return;

            // First the replies are deleted, then the post itself
            // (a post cannot be deleted while replies still point to it).
            // Nothing is deleted unless the user owns the post or is an admin.
            string query = @"
                IF EXISTS (SELECT 1 FROM Discussions
                           WHERE DiscussionID = @ID
                             AND ParentDiscussionID IS NULL
                             AND (UserID = @UserID OR @IsAdmin = 1))
                BEGIN
                    DELETE FROM Discussions WHERE ParentDiscussionID = @ID;
                    DELETE FROM Discussions WHERE DiscussionID = @ID;
                END";

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.Add("@ID", SqlDbType.Int).Value = PostID;
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                    command.Parameters.Add("@IsAdmin", SqlDbType.Bit).Value = IsAdmin();

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }
            catch (Exception)
            {
                ShowError("The post could not be deleted. Please try again.");
                return;
            }

            Response.Redirect("~/Discussion/Discussions.aspx?msg=deleted", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        // ---------------------------------------------------------
        // HELPERS
        // ---------------------------------------------------------

        private void RedirectToThisPost(string message)
        {
            Response.Redirect("~/Discussion/DiscussionDetails.aspx?id=" + PostID +
                              "&msg=" + message + "#replies", false);
            Context.ApplicationInstance.CompleteRequest();
        }

        private void ShowStatusMessage()
        {
            string msg = Request.QueryString["msg"];

            if (msg == "updated")
                lblStatus.Text = "Your post was updated.";
            else if (msg == "replied")
                lblStatus.Text = "Your reply was posted.";
            else if (msg == "replydeleted")
                lblStatus.Text = "The reply was deleted.";

            lblStatus.Visible = lblStatus.Text != "";
        }

        private void ShowError(string message)
        {
            lblStatus.Text = message;
            lblStatus.CssClass = "dd-alert error";
            lblStatus.Visible = true;
        }

        private void ShowNotFound()
        {
            pnlDiscussion.Visible = false;
            pnlNotFound.Visible = true;
        }

        // Safe text with line breaks kept: "<b>" stays as text, Enter becomes a new line.
        protected string FormatContent(object value)
        {
            string text = Server.HtmlEncode(Convert.ToString(value));
            return text.Replace("\r\n", "\n").Replace("\n", "<br />");
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

        // "Marwa Abdelkaoui" -> "MA"
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

        // Same colours as the Discussions page, so each author keeps their colour.
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

        //topic label
        private string GetTopicBadge(object value)
        {
            if (value == null || value == DBNull.Value)
                return "";

            string name = value.ToString();
            name = name.Replace("System", "").Trim();

            return "<span class=\"dd-topic\">" +
                   Server.HtmlEncode(name) +
                   "</span>";
        }
    }
}