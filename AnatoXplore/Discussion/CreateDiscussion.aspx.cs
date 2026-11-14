using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using WebGrease.Activities;

namespace AnatoXplore
{
    public partial class CreateDiscussion : System.Web.UI.Page
    {
        private string ConnectionString
        {
            get
            {
                return ConfigurationManager
                    .ConnectionStrings["AnatoXploreConnection"]
                    .ConnectionString;
            }
        }

        // The post being edited (0 = we are creating a new post).
        // Kept in ViewState so it is still known after the Post button is clicked.
        private int EditDiscussionID
        {
            get
            {
                return ViewState["EditID"] == null
                    ? 0
                    : (int)ViewState["EditID"];
            }
            set
            {
                ViewState["EditID"] = value;
            }
        }

        private bool IsAdmin()
        {
            string role = Convert.ToString(Session["Role"]);
            return role.Equals("Admin", StringComparison.OrdinalIgnoreCase)
                || role.Equals("Administrator", StringComparison.OrdinalIgnoreCase);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Only logged-in users can create or edit posts.
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            // The browser will not let the user type more than 4000 characters.
            txtMessage.Attributes["maxlength"] = "4000";

            // Keep the browser tab title correct in edit mode after a postback.
            if (EditDiscussionID > 0)
                Page.Title = "Edit Post | AnatoXplore";

            if (!IsPostBack)
            {
                LoadTopics();

                // CreateDiscussion.aspx?id=5 means "edit post 5".
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    LoadPostForEditing(id);
                }
            }
        }

        // Fills the topic choices from the BodySystems table.
        private void LoadTopics()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(
                    "SELECT SystemID, SystemName FROM BodySystems ORDER BY SystemName",
                    connection))
                {
                    connection.Open();
                    rblTopic.DataSource = command.ExecuteReader();
                    rblTopic.DataTextField = "SystemName";
                    rblTopic.DataValueField = "SystemID";
                    rblTopic.DataBind();
                }
            }
            catch (Exception)
            {
                // If topics cannot be loaded, students can still post without a topic.
            }

            rblTopic.Items.Insert(0, new ListItem("No specific topic", "0"));
            rblTopic.SelectedIndex = 0;
        }

        // Reads an existing post and puts it in the form (edit mode).
        private void LoadPostForEditing(int id)
        {
            string query = @"
                SELECT UserID, Title, PostContent, SystemID
                FROM Discussions
                WHERE DiscussionID = @ID
                  AND ParentDiscussionID IS NULL";

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    command.Parameters.Add("@ID", SqlDbType.Int).Value = id;
                    connection.Open();

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            // The post does not exist.
                            Response.Redirect("~/Discussion/Discussions.aspx", false);
                            Context.ApplicationInstance.CompleteRequest();
                            return;
                        }

                        // Only the author or an admin can edit a post.
                        int ownerId = Convert.ToInt32(reader["UserID"]);
                        int currentUserId = Convert.ToInt32(Session["UserID"]);

                        if (ownerId != currentUserId && !IsAdmin())
                        {
                            Response.Redirect("~/Discussion/Discussions.aspx", false);
                            Context.ApplicationInstance.CompleteRequest();
                            return;
                        }

                        txtTitle.Text = reader["Title"].ToString();
                        txtMessage.Text = reader["PostContent"].ToString();

                        if (reader["SystemID"] != DBNull.Value &&
                            rblTopic.Items.FindByValue(reader["SystemID"].ToString()) != null)
                        {
                            rblTopic.SelectedValue = reader["SystemID"].ToString();
                        }
                    }
                }
            }
            catch (Exception)
            {
                ShowError("Could not load the post. Please try again.");
                return;
            }

            // Switch the page into edit mode.
            EditDiscussionID = id;
            Page.Title = "Edit Post | AnatoXplore";
            litHeading.Text = "Edit your post";
            litSubtitle.Text = "Update your question or discussion.";
            btnPost.Text = "Save changes";

            string postUrl = "~/Discussion/DiscussionDetails.aspx?id=" + id;
            lnkCancel.NavigateUrl = postUrl;
            lnkBack.NavigateUrl = postUrl;
            litBack.Text = "Back to post";
        }

        protected void btnPost_Click(object sender, EventArgs e)
        {
            // Server-side check of the validators (in case JavaScript is turned off).
            if (!Page.IsValid)
                return;

            string title = txtTitle.Text.Trim();
            string message = txtMessage.Text.Trim();

            // Extra check: spaces alone do not count as text.
            if (title.Length < 5 || message.Length < 20)
            {
                ShowError("Please write a longer title (5+ characters) and message (20+ characters).");
                return;
            }

            int topicId = Convert.ToInt32(rblTopic.SelectedValue);
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    connection.Open();

                    if (EditDiscussionID == 0)
                    {
                        // CREATE: insert a new post.
                        string insertQuery = @"
                            INSERT INTO Discussions
                                (UserID, ParentDiscussionID, Title, PostContent, SystemID, CreatedAt)
                            VALUES
                                (@UserID, NULL, @Title, @PostContent, @SystemID, GETDATE())";

                        using (SqlCommand command = new SqlCommand(insertQuery, connection))
                        {
                            AddPostParameters(command, title, message, topicId);
                            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                            command.ExecuteNonQuery();
                        }

                        Response.Redirect("~/Discussion/Discussions.aspx?msg=created", false);
                    }
                    else
                    {
                        // UPDATE: save changes. The WHERE makes sure only
                        // the author (or an admin) can change the post.
                        string updateQuery = @"
                            UPDATE Discussions
                            SET Title = @Title,
                                PostContent = @PostContent,
                                SystemID = @SystemID,
                                UpdatedAt = GETDATE()
                            WHERE DiscussionID = @ID
                              AND (UserID = @UserID OR @IsAdmin = 1)";

                        using (SqlCommand command = new SqlCommand(updateQuery, connection))
                        {
                            AddPostParameters(command, title, message, topicId);
                            command.Parameters.Add("@ID", SqlDbType.Int).Value = EditDiscussionID;
                            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                            command.Parameters.Add("@IsAdmin", SqlDbType.Bit).Value = IsAdmin();
                            command.ExecuteNonQuery();
                        }

                        Response.Redirect(
                            "~/Discussion/DiscussionDetails.aspx?id=" + EditDiscussionID + "&msg=updated", false);
                    }

                    Context.ApplicationInstance.CompleteRequest();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Saving discussion post failed: " + ex);
                ShowError("Your post could not be saved. Please try again.");
            }
        }

        // Parameters used by both INSERT and UPDATE.
        private void AddPostParameters(SqlCommand command, string title, string message, int topicId)
        {
            command.Parameters.Add("@Title", SqlDbType.NVarChar, 200).Value = title;
            command.Parameters.Add("@PostContent", SqlDbType.NVarChar, -1).Value = message;

            // 0 means "No specific topic", which is saved as NULL.
            command.Parameters.Add("@SystemID", SqlDbType.Int).Value =
                topicId > 0 ? (object)topicId : DBNull.Value;
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Visible = true;
        }
    }
}