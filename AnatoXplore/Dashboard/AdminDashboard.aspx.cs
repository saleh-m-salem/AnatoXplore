using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Net;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AnatoXplore
{
    public partial class AdminDashboard : Page
    {
        private string ConnectionString { get { return ConfigurationManager.ConnectionStrings["AnatoXploreConnection"].ConnectionString; } }
        private int CurrentUserID { get { int id; return Int32.TryParse(Convert.ToString(Session["UserID"]), out id) ? id : 0; } }
        private string ActiveSection { get { return Convert.ToString(ViewState["AdminSection"] ?? "Overview"); } set { ViewState["AdminSection"] = value; } }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!RequireAdmin()) return;
            if (!IsPostBack)
            {
                ActiveSection = "Overview";
                SetSection(ActiveSection);
                BindSystems();
                BindUserSuggestions();
                BindOverview();
            }
            else HideMessage();
        }

        private bool RequireAdmin()
        {
            if (CurrentUserID <= 0) { RedirectToLogin(); return false; }
            try
            {
                using (SqlConnection c = new SqlConnection(ConnectionString))
                using (SqlCommand q = new SqlCommand("SELECT Role FROM dbo.Users WHERE UserID=@id", c))
                {
                    q.Parameters.Add("@id", SqlDbType.Int).Value = CurrentUserID;
                    c.Open();
                    string role = Convert.ToString(q.ExecuteScalar());
                    if (String.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase) || String.Equals(role, "Administrator", StringComparison.OrdinalIgnoreCase)) return true;
                }
            }
            catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Admin authorization check failed: " + ex); }
            Session.Remove("Role");
            Response.StatusCode = 403;
            Response.Redirect(ResolveUrl("~/Default.aspx?admin=denied"), false);
            Context.ApplicationInstance.CompleteRequest();
            return false;
        }

        private void RedirectToLogin()
        {
            string target = ResolveUrl("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl));
            Response.Redirect(target, false);
            Context.ApplicationInstance.CompleteRequest();
        }

        protected void Navigate_Click(object sender, EventArgs e)
        {
            if (!RequireAdmin()) return;
            ActiveSection = ((LinkButton)sender).CommandArgument;
            SetSection(ActiveSection);
            BindActive();
        }

        private void SetSection(string section)
        {
            string[] names = { "Overview", "Users", "Content", "Discussions", "Feedback", "Results" };
            LinkButton[] links = { navOverview, navUsers, navContent, navDiscussions, navFeedback, navResults };
            for (int i = 0; i < names.Length; i++) links[i].CssClass = names[i] == section ? "admin-nav active" : "admin-nav";
            mvAdmin.ActiveViewIndex = Array.IndexOf(names, section);
            if (mvAdmin.ActiveViewIndex < 0) mvAdmin.ActiveViewIndex = 0;
        }

        private void BindActive()
        {
            switch (ActiveSection)
            {
                case "Users": BindUsers(); break;
                case "Content": BindContent(); break;
                case "Discussions": BindDiscussions(); break;
                case "Feedback": BindFeedback(); break;
                case "Results": BindResults(); break;
                default: BindOverview(); break;
            }
        }

        private void BindSystems()
        {
            DataTable systems = Read("SELECT SystemID,SystemName FROM dbo.BodySystems ORDER BY SystemName");
            ddlContentSystem.DataSource = systems; ddlContentSystem.DataTextField = "SystemName"; ddlContentSystem.DataValueField = "SystemID"; ddlContentSystem.DataBind();
        }

        private void BindOverview()
        {
            try
            {
                litStudents.Text = Scalar("SELECT COUNT(*) FROM dbo.Users WHERE Role NOT IN (N'Admin',N'Administrator')").ToString("N0");
                litSystems.Text = Scalar("SELECT COUNT(*) FROM dbo.BodySystems").ToString("N0");
                litQuestions.Text = Scalar("SELECT COUNT(*) FROM dbo.Questions").ToString("N0");
                litContentQuestions.Text = litQuestions.Text;
                litDiscussions.Text = Scalar("SELECT COUNT(*) FROM dbo.Discussions WHERE ParentDiscussionID IS NULL").ToString("N0");
                litContentSystems.Text = litSystems.Text;
                litVideos.Text = Scalar("SELECT COUNT(*) FROM dbo.Videos").ToString("N0");
                litFlashcards.Text = Scalar("SELECT COUNT(*) FROM dbo.Flashcards WHERE IsActive=1").ToString("N0");
                DataTable activity = Read(@"SELECT TOP (12) ActivityName AS ActionName,Details,CreatedAt,ActorName
                    FROM
                    (
                        SELECT N'Student registered' AS ActivityName,
                               U.FullName + N' joined AnatoXplore' AS Details,
                               U.CreatedAt,
                               U.FullName AS ActorName
                        FROM dbo.Users U
                        WHERE U.Role NOT IN (N'Admin',N'Administrator')
                        UNION ALL
                        SELECT N'Quiz completed',
                               U.FullName + N' scored ' + CONVERT(NVARCHAR(20),Q.Score) + N'/' + CONVERT(NVARCHAR(20),Q.TotalQuestions) + N' in ' + B.SystemName,
                               Q.AttemptDate,
                               U.FullName
                        FROM dbo.QuizResults Q
                        INNER JOIN dbo.Users U ON U.UserID=Q.UserID
                        INNER JOIN dbo.BodySystems B ON B.SystemID=Q.SystemID
                        UNION ALL
                        SELECT CASE WHEN D.ParentDiscussionID IS NULL THEN N'Discussion posted' ELSE N'Reply added' END,
                               U.FullName + N': ' + LEFT(D.Title,160),
                               D.CreatedAt,
                               U.FullName
                        FROM dbo.Discussions D
                        INNER JOIN dbo.Users U ON U.UserID=D.UserID
                        UNION ALL
                        SELECT A.ActionName,A.Details,A.CreatedAt,ISNULL(U.FullName,N'Admin')
                        FROM dbo.AdminAuditLog A
                        LEFT JOIN dbo.Users U ON U.UserID=A.AdminUserID
                    ) RecentActivity
                    ORDER BY CreatedAt DESC");
                gvActivity.DataSource = activity; gvActivity.DataBind();
                DataTable summary = Read("SELECT FeedbackType,COUNT(*) AS ItemCount FROM dbo.Feedback WHERE Status=N'Pending' GROUP BY FeedbackType ORDER BY FeedbackType");
                System.Text.StringBuilder html = new System.Text.StringBuilder();
                int total = 0;
                foreach (DataRow row in summary.Rows) { int count = Convert.ToInt32(row["ItemCount"]); total += count; html.Append("<div class=\"admin-count-list\"><div><span>").Append(Server.HtmlEncode(Convert.ToString(row["FeedbackType"]))).Append("</span><strong>").Append(count.ToString("N0")).Append("</strong></div></div>"); }
                litFeedbackSummary.Text = "<p><span class=\"status-badge status-pending\">" + total.ToString("N0") + " pending</span></p>" + (html.Length == 0 ? "<p class=\"admin-note\">No pending reports or feedback.</p>" : html.ToString());
                HideMessage();
            }
            catch (Exception ex) { ShowError("Dashboard data could not be loaded. Apply the AdminDashboard.sql migration and confirm the database schema."); System.Diagnostics.Debug.WriteLine(ex); }
        }

        private bool TableExists(string name)
        {
            using (SqlConnection c = new SqlConnection(ConnectionString)) using (SqlCommand q = new SqlCommand("SELECT CASE WHEN OBJECT_ID(@name,'U') IS NULL THEN 0 ELSE 1 END", c)) { q.Parameters.Add("@name", SqlDbType.NVarChar, 128).Value = "dbo." + name; c.Open(); return Convert.ToInt32(q.ExecuteScalar()) == 1; }
        }
        private int Scalar(string sql) { using (SqlConnection c = new SqlConnection(ConnectionString)) using (SqlCommand q = new SqlCommand(sql, c)) { c.Open(); return Convert.ToInt32(q.ExecuteScalar()); } }
        private DataTable Read(string sql, Action<SqlCommand> parameters = null)
        {
            DataTable t = new DataTable(); using (SqlConnection c = new SqlConnection(ConnectionString)) using (SqlCommand q = new SqlCommand(sql, c)) { if (parameters != null) parameters(q); using (SqlDataAdapter a = new SqlDataAdapter(q)) a.Fill(t); } return t;
        }
        private void ExecuteAudited(string sql, Action<SqlCommand> parameters, string action, string details)
        {
            using (SqlConnection c = new SqlConnection(ConnectionString))
            {
                c.Open(); using (SqlTransaction tx = c.BeginTransaction())
                {
                    try
                    {
                        using (SqlCommand q = new SqlCommand(sql, c, tx)) { if (parameters != null) parameters(q); q.ExecuteNonQuery(); }
                        using (SqlCommand audit = new SqlCommand("INSERT dbo.AdminAuditLog(AdminUserID,ActionName,Details,CreatedAt) VALUES(@Admin,@Action,@Details,GETDATE())", c, tx))
                        {
                            audit.Parameters.Add("@Admin", SqlDbType.Int).Value = CurrentUserID;
                            audit.Parameters.Add("@Action", SqlDbType.NVarChar, 100).Value = action;
                            audit.Parameters.Add("@Details", SqlDbType.NVarChar, 1000).Value = details.Length > 1000 ? details.Substring(0, 1000) : details;
                            audit.ExecuteNonQuery();
                        }
                        tx.Commit();
                    }
                    catch { tx.Rollback(); throw; }
                }
            }
        }

        private void BindUsers()
        {
            string search = txtUserSearch.Text.Trim();
            DataTable t = Read(@"SELECT UserID,FullName,Email,Role,CreatedAt FROM dbo.Users
                WHERE (@s=N'' OR FullName LIKE @like OR Email LIKE @like) ORDER BY CreatedAt DESC,UserID DESC", q => { q.Parameters.Add("@s", SqlDbType.NVarChar, 150).Value = search; q.Parameters.Add("@like", SqlDbType.NVarChar, 302).Value = "%" + search + "%"; });
            gvUsers.DataSource = t; gvUsers.DataBind();
        }
        private void BindUserSuggestions()
        {
            DataTable users = Read("SELECT FullName,Email FROM dbo.Users ORDER BY FullName,Email");
            rptUserSuggestions.DataSource = users;
            rptUserSuggestions.DataBind();
        }
        protected void UserSearch_Click(object s, EventArgs e) { if (!RequireAdmin()) return; gvUsers.PageIndex = 0; BindUsers(); }
        protected void UserClear_Click(object s, EventArgs e) { if (!RequireAdmin()) return; txtUserSearch.Text = ""; gvUsers.PageIndex = 0; BindUsers(); }
        protected void Users_PageIndexChanging(object s, GridViewPageEventArgs e) { if (!RequireAdmin()) return; gvUsers.PageIndex = e.NewPageIndex; BindUsers(); }
        protected void Users_RowCommand(object s, GridViewCommandEventArgs e)
        {
            if (!RequireAdmin() || e.CommandName != "EditUser") return;
            int id; if (!Int32.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            DataTable t = Read("SELECT UserID,FullName,Email,Role FROM dbo.Users WHERE UserID=@id", q => q.Parameters.Add("@id", SqlDbType.Int).Value = id);
            if (t.Rows.Count == 0) { ShowError("That user could not be found."); return; }
            DataRow r = t.Rows[0]; hfUserID.Value = Convert.ToString(r["UserID"]); txtEditName.Text = Convert.ToString(r["FullName"]); txtEditEmail.Text = Convert.ToString(r["Email"]);
            ddlEditRole.SelectedValue = String.Equals(Convert.ToString(r["Role"]), "Admin", StringComparison.OrdinalIgnoreCase) || String.Equals(Convert.ToString(r["Role"]), "Administrator", StringComparison.OrdinalIgnoreCase) ? "Admin" : "Student";
            pnlUserEdit.Visible = true;
        }
        protected void SaveUser_Click(object s, EventArgs e)
        {
            if (!RequireAdmin()) return;
            int id; string name = txtEditName.Text.Trim(); string email = txtEditEmail.Text.Trim(); string role = ddlEditRole.SelectedValue;
            if (!Int32.TryParse(hfUserID.Value, out id) || name.Length == 0 || name.Length > 100 || email.Length == 0 || email.Length > 150 || !email.Contains("@") || (role != "Admin" && role != "Student")) { ShowError("Enter a valid name, email and role."); return; }
            try
            {
                string oldRole; using (SqlConnection c = new SqlConnection(ConnectionString)) using (SqlCommand q = new SqlCommand("SELECT Role FROM dbo.Users WHERE UserID=@id", c)) { q.Parameters.Add("@id", SqlDbType.Int).Value = id; c.Open(); oldRole = Convert.ToString(q.ExecuteScalar()); }
                if (id == CurrentUserID && role != "Admin") { ShowError("You cannot remove your own administrator access."); return; }
                if ((String.Equals(oldRole, "Admin", StringComparison.OrdinalIgnoreCase) || String.Equals(oldRole, "Administrator", StringComparison.OrdinalIgnoreCase)) && role == "Student" && Scalar("SELECT COUNT(*) FROM dbo.Users WHERE Role IN (N'Admin',N'Administrator')") <= 1) { ShowError("The last administrator cannot be demoted."); return; }
                ExecuteAudited("UPDATE dbo.Users SET FullName=@name,Email=@email,Role=@role WHERE UserID=@id", q => { q.Parameters.Add("@name", SqlDbType.NVarChar, 100).Value = name; q.Parameters.Add("@email", SqlDbType.NVarChar, 150).Value = email; q.Parameters.Add("@role", SqlDbType.NVarChar, 20).Value = role; q.Parameters.Add("@id", SqlDbType.Int).Value = id; }, oldRole == role ? "User updated" : "User role changed", "Updated account " + email + "; role " + oldRole + " â†’ " + role + ".");
                pnlUserEdit.Visible = false; BindUsers(); ShowSuccess("User account saved.");
            }
            catch (SqlException ex) { ShowError(ex.Number == 2627 || ex.Number == 2601 ? "That email address is already in use." : "The user could not be saved. Check the database and audit migration."); System.Diagnostics.Debug.WriteLine(ex); }
        }
        protected void CancelUser_Click(object s, EventArgs e) { if (!RequireAdmin()) return; pnlUserEdit.Visible = false; }

        private void BindContent()
        {
            try
            {
                if (ddlContentSystem.Items.Count == 0) BindSystems();
                string type = ddlContentType.SelectedValue; int system; Int32.TryParse(ddlContentSystem.SelectedValue, out system);
                string sql;
                if (type == "Questions") sql = @"SELECT Q.QuestionID AS ItemID,B.SystemName AS [Body system],Q.QuestionText AS Question,Q.OptionA AS [Option A],Q.OptionB AS [Option B],Q.OptionC AS [Option C],Q.OptionD AS [Option D],Q.CorrectAnswer AS [Correct answer]
                    FROM dbo.Questions Q INNER JOIN dbo.BodySystems B ON B.SystemID=Q.SystemID WHERE Q.SystemID=@system ORDER BY Q.QuestionID DESC";
                else if (type == "Videos") sql = @"SELECT V.VideoID AS ItemID,B.SystemName AS [Body system],V.VideoTitle AS Title,V.VideoURL AS Link,V.Description
                    FROM dbo.Videos V INNER JOIN dbo.BodySystems B ON B.SystemID=V.SystemID WHERE V.SystemID=@system ORDER BY V.VideoID DESC";
                else sql = @"SELECT F.FlashcardID AS ItemID,B.SystemName AS [Body system],F.QuestionText AS Question,F.AnswerText AS Answer,F.DisplayOrder AS [Display order],CASE WHEN F.IsActive=1 THEN N'Active' ELSE N'Archived' END AS Status,F.IsActive
                    FROM dbo.Flashcards F INNER JOIN dbo.BodySystems B ON B.SystemID=F.SystemID WHERE F.SystemID=@system ORDER BY F.IsActive DESC,F.DisplayOrder,F.FlashcardID";
                DataTable t = Read(sql, q => q.Parameters.Add("@system", SqlDbType.Int).Value = system);
                gvContent.DataSource = t; gvContent.DataBind(); SetContentFields();
            }
            catch (Exception ex) { ShowError("Content could not be loaded. Confirm that the flashcard table migration has been applied."); System.Diagnostics.Debug.WriteLine(ex); }
        }
        private void SetContentFields()
        {
            string type = ddlContentType.SelectedValue; pnlFlashcardFields.Visible = type == "Flashcards"; pnlQuestionFields.Visible = type == "Questions"; pnlVideoFields.Visible = type == "Videos";
            litContentFormTitle.Text = (String.IsNullOrEmpty(hfContentID.Value) ? "Add " : "Edit ") + (type == "Questions" ? "quiz question" : type == "Videos" ? "video" : "flashcard");
        }
        protected void ContentType_Changed(object s, EventArgs e) { if (!RequireAdmin()) return; hfContentID.Value = ""; hfQuestionExplanation.Value = ""; txtContentTitle.Text = ""; SetContentFields(); BindContent(); }
        protected void ContentFilter_Click(object s, EventArgs e) { if (!RequireAdmin()) return; gvContent.PageIndex = 0; BindContent(); }
        protected void Content_PageIndexChanging(object s, GridViewPageEventArgs e) { if (!RequireAdmin()) return; gvContent.PageIndex = e.NewPageIndex; BindContent(); }
        protected void Content_RowCreated(object s, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    string header = e.Row.Cells[i].Text;
                    if (header == "ItemID" || header == "IsActive") e.Row.Cells[i].Visible = false;
                }
                return;
            }
            if (e.Row.RowType == DataControlRowType.DataRow && gvContent.HeaderRow != null)
            {
                for (int i = 0; i < e.Row.Cells.Count && i < gvContent.HeaderRow.Cells.Count; i++)
                {
                    string header = gvContent.HeaderRow.Cells[i].Text;
                    if (header == "ItemID" || header == "IsActive") e.Row.Cells[i].Visible = false;
                }
            }
        }
        protected void Content_RowDataBound(object s, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow) return;
            LinkButton archive = e.Row.FindControl("btnArchiveContent") as LinkButton;
            LinkButton restore = e.Row.FindControl("btnRestoreContent") as LinkButton;
            if (archive != null) archive.Text = ddlContentType.SelectedValue == "Flashcards" ? "Archive" : "Delete";
            if (ddlContentType.SelectedValue != "Flashcards") return;
            object active = DataBinder.Eval(e.Row.DataItem, "IsActive");
            bool isActive = active != DBNull.Value && Convert.ToBoolean(active);
            if (archive != null) archive.Visible = isActive;
            if (restore != null) restore.Visible = !isActive;
        }
        protected void CancelContent_Click(object s, EventArgs e) { if (!RequireAdmin()) return; hfContentID.Value = ""; hfQuestionExplanation.Value = ""; txtContentTitle.Text = ""; txtFlashAnswer.Text = ""; txtVideoUrl.Text = ""; txtVideoDescription.Text = ""; pnlContentForm.Visible = true; SetContentFields(); }
        protected void Content_RowCommand(object s, GridViewCommandEventArgs e)
        {
            if (!RequireAdmin()) return;
            int id; if (!Int32.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            string type = ddlContentType.SelectedValue; string table = type == "Questions" ? "Questions" : type == "Videos" ? "Videos" : "Flashcards"; string pk = type == "Questions" ? "QuestionID" : type == "Videos" ? "VideoID" : "FlashcardID";
            try
            {
                if (e.CommandName == "EditContent")
                {
                    DataTable t = Read("SELECT * FROM dbo." + table + " WHERE " + pk + "=@id", q => q.Parameters.Add("@id", SqlDbType.Int).Value = id);
                    if (t.Rows.Count == 0) { ShowError("That content item was not found."); return; }
                    DataRow r=t.Rows[0]; hfContentID.Value=id.ToString(CultureInfo.InvariantCulture); ddlContentSystem.SelectedValue=Convert.ToString(r["SystemID"]);
                    txtContentTitle.Text=Convert.ToString(r[type=="Videos"?"VideoTitle":"QuestionText"]);
                    if(type=="Flashcards"){txtFlashAnswer.Text=Convert.ToString(r["AnswerText"]);txtFlashOrder.Text=Convert.ToString(r["DisplayOrder"]);}
                    if(type=="Questions"){txtOptionA.Text=Convert.ToString(r["OptionA"]);txtOptionB.Text=Convert.ToString(r["OptionB"]);txtOptionC.Text=Convert.ToString(r["OptionC"]);txtOptionD.Text=Convert.ToString(r["OptionD"]);ddlCorrectAnswer.SelectedValue=Convert.ToString(r["CorrectAnswer"]);hfQuestionExplanation.Value=r["Explanation"]==DBNull.Value?String.Empty:Convert.ToString(r["Explanation"]);}
                    if(type=="Videos"){txtVideoUrl.Text=Convert.ToString(r["VideoURL"]);txtVideoDescription.Text=Convert.ToString(r["Description"]);}
                    pnlContentForm.Visible=true; SetContentFields();
                }
                else if (e.CommandName == "DeleteContent")
                {
                    if(type=="Flashcards") ExecuteAudited("UPDATE dbo.Flashcards SET IsActive=0 WHERE FlashcardID=@id",q=>q.Parameters.Add("@id",SqlDbType.Int).Value=id,"Flashcard archived","Archived flashcard #"+id.ToString(CultureInfo.InvariantCulture)+".");
                    else ExecuteAudited("DELETE dbo."+table+" WHERE "+pk+"=@id",q=>q.Parameters.Add("@id",SqlDbType.Int).Value=id,"Lesson content deleted","Deleted "+table+" item #"+id.ToString(CultureInfo.InvariantCulture)+".");
                    BindContent(); ShowSuccess(type=="Flashcards"?"Flashcard archived.":"Content deleted.");
                }
                else if (e.CommandName == "RestoreContent" && type == "Flashcards")
                {
                    ExecuteAudited("UPDATE dbo.Flashcards SET IsActive=1 WHERE FlashcardID=@id",q=>q.Parameters.Add("@id",SqlDbType.Int).Value=id,"Flashcard restored","Restored flashcard #"+id.ToString(CultureInfo.InvariantCulture)+".");
                    BindContent(); ShowSuccess("Flashcard restored.");
                }
            }
            catch(Exception ex){ShowError("The content action failed. No changes were committed.");System.Diagnostics.Debug.WriteLine(ex);}
        }
        protected void SaveContent_Click(object s, EventArgs e)
        {
            if(!RequireAdmin())return;
            int system,id; if(!Int32.TryParse(ddlContentSystem.SelectedValue,out system)||!Int32.TryParse(hfContentID.Value,out id)) id=0;
            if(system<=0){ShowError("Select a body system.");return;}
            string type=ddlContentType.SelectedValue,title=txtContentTitle.Text.Trim();
            if(title.Length==0||(type=="Questions"&&title.Length>1000)||(type=="Videos"&&title.Length>150)){ShowError("Enter a title or question within the allowed length.");return;}
            try
            {
                if(type=="Flashcards")
                {
                    int order; if(title.Length>1000||txtFlashAnswer.Text.Trim().Length==0||txtFlashAnswer.Text.Length>4000||!Int32.TryParse(txtFlashOrder.Text,out order)||order<1){ShowError("Enter a question, answer and positive display order.");return;}
                    string sql=id==0?"INSERT dbo.Flashcards(SystemID,QuestionText,AnswerText,DisplayOrder,IsActive) VALUES(@sys,@title,@answer,@ord,1)":"UPDATE dbo.Flashcards SET SystemID=@sys,QuestionText=@title,AnswerText=@answer,DisplayOrder=@ord WHERE FlashcardID=@id";
                    ExecuteAudited(sql,q=>{q.Parameters.Add("@sys",SqlDbType.Int).Value=system;q.Parameters.Add("@title",SqlDbType.NVarChar,1000).Value=title;q.Parameters.Add("@answer",SqlDbType.NVarChar,-1).Value=txtFlashAnswer.Text.Trim();q.Parameters.Add("@ord",SqlDbType.Int).Value=order;if(id>0)q.Parameters.Add("@id",SqlDbType.Int).Value=id;},id==0?"Flashcard created":"Flashcard updated",(id==0?"Created":"Updated")+" flashcard: "+title);
                }
                else if(type=="Questions")
                {
                    if(txtOptionA.Text.Trim().Length==0||txtOptionB.Text.Trim().Length==0||txtOptionC.Text.Trim().Length==0||txtOptionD.Text.Trim().Length==0){ShowError("Fill in all four answer options.");return;}
                    string sql=id==0?"INSERT dbo.Questions(SystemID,QuestionText,OptionA,OptionB,OptionC,OptionD,CorrectAnswer,Explanation) VALUES(@sys,@title,@a,@b,@c,@d,@correct,@explain)":"UPDATE dbo.Questions SET SystemID=@sys,QuestionText=@title,OptionA=@a,OptionB=@b,OptionC=@c,OptionD=@d,CorrectAnswer=@correct,Explanation=@explain WHERE QuestionID=@id";
                    string explanation=id>0?hfQuestionExplanation.Value:String.Empty;
                    ExecuteAudited(sql,q=>{q.Parameters.Add("@sys",SqlDbType.Int).Value=system;q.Parameters.Add("@title",SqlDbType.NVarChar,1000).Value=title;q.Parameters.Add("@a",SqlDbType.NVarChar,300).Value=txtOptionA.Text.Trim();q.Parameters.Add("@b",SqlDbType.NVarChar,300).Value=txtOptionB.Text.Trim();q.Parameters.Add("@c",SqlDbType.NVarChar,300).Value=txtOptionC.Text.Trim();q.Parameters.Add("@d",SqlDbType.NVarChar,300).Value=txtOptionD.Text.Trim();q.Parameters.Add("@correct",SqlDbType.Char,1).Value=ddlCorrectAnswer.SelectedValue;q.Parameters.Add("@explain",SqlDbType.NVarChar,1000).Value=String.IsNullOrWhiteSpace(explanation)?(object)DBNull.Value:explanation;if(id>0)q.Parameters.Add("@id",SqlDbType.Int).Value=id;},id==0?"Quiz question created":"Quiz question updated",(id==0?"Created":"Updated")+" quiz question: "+title);
                }
                else
                {
                    Uri uri; if(!Uri.TryCreate(txtVideoUrl.Text.Trim(),UriKind.Absolute,out uri)||uri.Scheme!=Uri.UriSchemeHttps||txtVideoDescription.Text.Length>500){ShowError("Enter a valid HTTPS video URL and description under 500 characters.");return;}
                    string sql=id==0?"INSERT dbo.Videos(SystemID,VideoTitle,VideoURL,Description) VALUES(@sys,@title,@url,@description)":"UPDATE dbo.Videos SET SystemID=@sys,VideoTitle=@title,VideoURL=@url,Description=@description WHERE VideoID=@id";
                    ExecuteAudited(sql,q=>{q.Parameters.Add("@sys",SqlDbType.Int).Value=system;q.Parameters.Add("@title",SqlDbType.NVarChar,150).Value=title;q.Parameters.Add("@url",SqlDbType.NVarChar,500).Value=uri.AbsoluteUri;q.Parameters.Add("@description",SqlDbType.NVarChar,500).Value=txtVideoDescription.Text.Trim();if(id>0)q.Parameters.Add("@id",SqlDbType.Int).Value=id;},id==0?"Video created":"Video updated",(id==0?"Created":"Updated")+" video: "+title);
                }
                hfContentID.Value="";hfQuestionExplanation.Value="";txtContentTitle.Text="";txtFlashAnswer.Text="";txtVideoUrl.Text="";txtVideoDescription.Text="";pnlContentForm.Visible=true;BindContent();ShowSuccess("Lesson content saved.");
            }
            catch(Exception ex){ShowError("Content could not be saved. Check that the migration is applied and the values meet database rules.");System.Diagnostics.Debug.WriteLine(ex);}
        }

        private void BindDiscussions()
        {
            string search=txtDiscussionSearch.Text.Trim();
            DataTable t=Read(@"SELECT D.DiscussionID,D.Title,D.PostContent,D.CreatedAt,U.FullName AS Author FROM dbo.Discussions D INNER JOIN dbo.Users U ON U.UserID=D.UserID
                WHERE @s=N'' OR D.Title LIKE @like OR D.PostContent LIKE @like OR U.FullName LIKE @like ORDER BY D.CreatedAt DESC",q=>{q.Parameters.Add("@s",SqlDbType.NVarChar,200).Value=search;q.Parameters.Add("@like",SqlDbType.NVarChar,402).Value="%"+search+"%";});gvDiscussions.DataSource=t;gvDiscussions.DataBind();
        }
        protected void DiscussionSearch_Click(object s,EventArgs e){if(!RequireAdmin())return;gvDiscussions.PageIndex=0;BindDiscussions();}
        protected void DiscussionClear_Click(object s,EventArgs e){if(!RequireAdmin())return;txtDiscussionSearch.Text="";gvDiscussions.PageIndex=0;BindDiscussions();}
        protected void Discussions_PageIndexChanging(object s,GridViewPageEventArgs e){if(!RequireAdmin())return;gvDiscussions.PageIndex=e.NewPageIndex;BindDiscussions();}
        protected void Discussions_RowCommand(object s,GridViewCommandEventArgs e)
        {
            if(!RequireAdmin()||e.CommandName!="DeletePost")return;int id;if(!Int32.TryParse(Convert.ToString(e.CommandArgument),out id))return;
            try{ExecuteAudited(@";WITH PostTree AS(SELECT DiscussionID FROM dbo.Discussions WHERE DiscussionID=@id UNION ALL SELECT d.DiscussionID FROM dbo.Discussions d INNER JOIN PostTree p ON d.ParentDiscussionID=p.DiscussionID) DELETE FROM dbo.Discussions WHERE DiscussionID IN(SELECT DiscussionID FROM PostTree) OPTION(MAXRECURSION 100)",q=>q.Parameters.Add("@id",SqlDbType.Int).Value=id,"Discussion deleted","Deleted discussion #"+id.ToString(CultureInfo.InvariantCulture)+" and its replies.");BindDiscussions();ShowSuccess("Discussion and its replies deleted.");}catch(Exception ex){ShowError("The discussion could not be deleted.");System.Diagnostics.Debug.WriteLine(ex);}
        }

        private void BindFeedback()
        {
            string search=txtFeedbackSearch.Text.Trim(),status=ddlFeedbackStatus.SelectedValue;
            DataTable t=Read(@"SELECT F.FeedbackID,F.FeedbackType,F.Subject,F.Message,ISNULL(U.FullName,N'Guest') AS Sender,F.SubmittedAt,F.Status FROM dbo.Feedback F LEFT JOIN dbo.Users U ON U.UserID=F.UserID
                WHERE (@status=N'' OR F.Status=@status) AND (@s=N'' OR F.Subject LIKE @like OR F.Message LIKE @like OR F.FeedbackType LIKE @like) ORDER BY CASE WHEN F.Status=N'Pending' THEN 0 ELSE 1 END,F.SubmittedAt DESC",q=>{q.Parameters.Add("@status",SqlDbType.NVarChar,30).Value=status;q.Parameters.Add("@s",SqlDbType.NVarChar,200).Value=search;q.Parameters.Add("@like",SqlDbType.NVarChar,402).Value="%"+search+"%";});gvFeedback.DataSource=t;gvFeedback.DataBind();
        }
        protected void FeedbackSearch_Click(object s,EventArgs e){if(!RequireAdmin())return;gvFeedback.PageIndex=0;BindFeedback();}
        protected void FeedbackClear_Click(object s,EventArgs e){if(!RequireAdmin())return;txtFeedbackSearch.Text="";ddlFeedbackStatus.SelectedIndex=0;gvFeedback.PageIndex=0;BindFeedback();}
        protected void Feedback_PageIndexChanging(object s,GridViewPageEventArgs e){if(!RequireAdmin())return;gvFeedback.PageIndex=e.NewPageIndex;BindFeedback();}
        protected void Feedback_RowDataBound(object s,GridViewRowEventArgs e){if(e.Row.RowType==DataControlRowType.DataRow){string status=Convert.ToString(DataBinder.Eval(e.Row.DataItem,"Status"));TableCell cell=e.Row.Cells[6];cell.Text="<span class=\"status-badge "+(status=="Pending"?"status-pending":"status-reviewed")+"\">"+Server.HtmlEncode(status)+"</span>";LinkButton b=e.Row.FindControl("btnReviewed") as LinkButton;if(b!=null)b.Visible=status=="Pending";}}
        protected void Feedback_RowCommand(object s,GridViewCommandEventArgs e){if(!RequireAdmin()||e.CommandName!="MarkReviewed")return;int id;if(!Int32.TryParse(Convert.ToString(e.CommandArgument),out id))return;try{ExecuteAudited("UPDATE dbo.Feedback SET Status=N'Reviewed' WHERE FeedbackID=@id AND Status=N'Pending'",q=>q.Parameters.Add("@id",SqlDbType.Int).Value=id,"Feedback reviewed","Marked feedback #"+id.ToString(CultureInfo.InvariantCulture)+" as reviewed.");BindFeedback();ShowSuccess("Feedback status updated to Reviewed.");}catch(Exception ex){ShowError("Feedback status could not be updated.");System.Diagnostics.Debug.WriteLine(ex);}}

        private void BindResults()
        {
            string search=txtResultSearch.Text.Trim();DataTable t=Read(@"SELECT U.FullName AS Student,B.SystemName,Q.Score,Q.TotalQuestions,CAST(100.0*Q.Score/NULLIF(Q.TotalQuestions,0) AS DECIMAL(5,1)) AS PercentScore,ISNULL(X.TotalXP,0) AS XP,ISNULL(G.CurrentLevel,1) AS CurrentLevel,Q.AttemptDate
                FROM dbo.QuizResults Q INNER JOIN dbo.Users U ON U.UserID=Q.UserID INNER JOIN dbo.BodySystems B ON B.SystemID=Q.SystemID LEFT JOIN dbo.XPTransactions X ON X.QuizResultID=Q.ResultID LEFT JOIN dbo.UserGamification G ON G.UserID=Q.UserID
                WHERE (@s=N'' OR U.FullName LIKE @like OR B.SystemName LIKE @like OR U.Email LIKE @like) ORDER BY Q.AttemptDate DESC,Q.ResultID DESC",q=>{q.Parameters.Add("@s",SqlDbType.NVarChar,200).Value=search;q.Parameters.Add("@like",SqlDbType.NVarChar,402).Value="%"+search+"%";});gvResults.DataSource=t;gvResults.DataBind();
        }
        protected void ResultSearch_Click(object s,EventArgs e){if(!RequireAdmin())return;gvResults.PageIndex=0;BindResults();}
        protected void ResultClear_Click(object s,EventArgs e){if(!RequireAdmin())return;txtResultSearch.Text="";gvResults.PageIndex=0;BindResults();}
        protected void Results_PageIndexChanging(object s,GridViewPageEventArgs e){if(!RequireAdmin())return;gvResults.PageIndex=e.NewPageIndex;BindResults();}

        private void ShowSuccess(string message){lblMessage.CssClass="admin-message";lblMessage.Attributes["data-autohide"]="true";lblMessage.Text=Server.HtmlEncode(message);lblMessage.Visible=true;}
        private void ShowError(string message){lblMessage.CssClass="admin-message error";lblMessage.Attributes["data-autohide"]="false";lblMessage.Text=Server.HtmlEncode(message);lblMessage.Visible=true;}
        private void HideMessage(){lblMessage.Visible=false;}
    }
}

