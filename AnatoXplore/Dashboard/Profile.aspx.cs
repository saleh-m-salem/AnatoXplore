using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Net.Mail;
using System.Text;
using System.Web.UI;

namespace AnatoXplore
{
    public partial class Profile : Page
    {
        private int CurrentUserID
        {
            get
            {
                int userID;
                return Int32.TryParse(Convert.ToString(Session["UserID"]), out userID) ? userID : 0;
            }
        }

        private string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["AnatoXploreConnection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (CurrentUserID <= 0)
            {
                Response.Redirect(ResolveUrl("~/Login.aspx"), false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
                BindDashboardHistory();
            }
        }

        /*Load Profile*/
        private void LoadProfile()
        {
            int totalXP = 0;
            int currentLevel = 1;
            string equippedFrameKey = "default-blue";

            using (SqlConnection connection = new SqlConnection(ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
                SELECT U.FullName, U.Email, U.ProfilePhotoPath,
                       ISNULL(G.TotalXP, 0) AS TotalXP,
                       ISNULL(G.CurrentLevel, 1) AS CurrentLevel,
                       ISNULL(F.FrameKey, N'default-blue') AS FrameKey
                FROM dbo.Users AS U
                LEFT JOIN dbo.UserGamification AS G ON G.UserID = U.UserID
                LEFT JOIN dbo.UserProfileFrames AS UF ON UF.UserID = U.UserID AND UF.IsEquipped = 1
                LEFT JOIN dbo.ProfileFrames AS F ON F.FrameID = UF.FrameID
                WHERE U.UserID = @UserID;", connection))
            {
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                connection.Open();
                using (SqlDataReader reader = command.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        Session.Clear();
                        Response.Redirect(ResolveUrl("~/Login.aspx"), false);
                        Context.ApplicationInstance.CompleteRequest();
                        return;
                    }

                    string fullName = Convert.ToString(reader["FullName"]);
                    string email = Convert.ToString(reader["Email"]);
                    lblProfileName.Text = Server.HtmlEncode(fullName);
                    lblProfileInitial.Text = Server.HtmlEncode(GetInitial(fullName));
                    txtEditFullName.Text = fullName;
                    txtEditEmail.Text = email;
                    totalXP = Convert.ToInt32(reader["TotalXP"]);
                    currentLevel = Convert.ToInt32(reader["CurrentLevel"]);
                    equippedFrameKey = Convert.ToString(reader["FrameKey"]);
                    string photoPath = reader["ProfilePhotoPath"] == DBNull.Value ? null : Convert.ToString(reader["ProfilePhotoPath"]);
                    Session["ProfilePhotoPath"] = photoPath;
                    Session["ProfileFrameKey"] = equippedFrameKey;
                    Session["ProfileBadgeLoaded"] = true;

                    if (!String.IsNullOrWhiteSpace(photoPath) && photoPath.StartsWith("~/Images/ProfilePhotos/", StringComparison.OrdinalIgnoreCase))
                    {
                        imgProfilePhoto.ImageUrl = ResolveUrl(photoPath);
                        imgProfilePhoto.Visible = true;
                        lblProfileInitial.Visible = false;
                    }
                    else
                    {
                        imgProfilePhoto.Visible = false;
                        lblProfileInitial.Visible = true;
                    }
                }
            }

            avatarFrame.Attributes["class"] = "profile-avatar-frame " + GetFrameCss(equippedFrameKey);
            lblProfileLevel.Text = "Level " + currentLevel;
            lblTotalXP.Text = totalXP.ToString("N0");
            lblProgressLevel.Text = "Level " + currentLevel;
            int[] thresholds = { 0, 100, 200, 350, 550, 800 };
            if (currentLevel >= 6)
            {
                lblNextLevel.Text = "Maximum level";
                lblProgressNote.Text = "You are at the highest level. Keep earning XP for the leaderboard.";
                progressFill.Style["width"] = "100%";
            }
            else
            {
                int start = thresholds[Math.Max(0, currentLevel - 1)];
                int target = thresholds[currentLevel];
                int earnedInLevel = Math.Max(0, totalXP - start);
                int range = target - start;
                int percent = range <= 0 ? 0 : Math.Min(100, earnedInLevel * 100 / range);
                progressFill.Style["width"] = percent.ToString(CultureInfo.InvariantCulture) + "%";
                lblNextLevel.Text = (target - totalXP).ToString("N0") + " XP to Level " + (currentLevel + 1);
                lblProgressNote.Text = totalXP.ToString("N0") + " / " + target.ToString("N0") + " XP toward Level " + (currentLevel + 1);
            }
            BindFrames();
        }

        private void BindDashboardHistory()
        {
            BindQuizHistory();
            BindFeedbackHistory();
        }

        /*Showing quiz and feedback histrory*/

        private void BindQuizHistory()
        {
            DataTable history = new DataTable();
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
                SELECT TOP (25) Q.ResultID, B.SystemName, Q.Score, Q.TotalQuestions,
                       CAST(100.0 * Q.Score / NULLIF(Q.TotalQuestions, 0) AS DECIMAL(5,1)) AS PercentScore,
                       Q.DurationSeconds, Q.AttemptDate,
                       ISNULL(X.SpeedBonusXP, 0) AS SpeedBonusXP,
                       ISNULL(X.TotalXP, 0) AS XPgained
                FROM dbo.QuizResults AS Q
                INNER JOIN dbo.BodySystems AS B ON B.SystemID = Q.SystemID
                LEFT JOIN dbo.XPTransactions AS X ON X.QuizResultID = Q.ResultID
                WHERE Q.UserID = @UserID
                ORDER BY Q.AttemptDate DESC, Q.ResultID DESC;", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                adapter.Fill(history);
            }

            rptQuizHistory.DataSource = history;
            rptQuizHistory.DataBind();
            pnlNoQuizHistory.Visible = history.Rows.Count == 0;
            pnlQuizHistoryTable.Visible = history.Rows.Count > 0;
            pnlNoQuizChart.Visible = history.Rows.Count == 0;
            litQuizChart.Text = history.Rows.Count == 0 ? String.Empty : BuildQuizChart(history);
        }

        private static string BuildQuizChart(DataTable history)
        {
            DataRow[] rows = history.Select(String.Empty, "AttemptDate ASC, ResultID ASC");
            int count = rows.Length;
            const double left = 48, right = 780, top = 28, bottom = 218;
            double step = count <= 1 ? 0 : (right - left) / (count - 1);
            StringBuilder svg = new StringBuilder();
            svg.Append("<svg class=\"profile-chart\" viewBox=\"0 0 800 270\" role=\"img\" aria-label=\"Quiz scores over time\">");
            for (int value = 0; value <= 100; value += 25)
            {
                double y = bottom - value * (bottom - top) / 100.0;
                svg.AppendFormat(CultureInfo.InvariantCulture, "<line class=\"grid-line\" x1=\"{0:0}\" y1=\"{1:0.0}\" x2=\"{2:0}\" y2=\"{1:0.0}\"/><text x=\"4\" y=\"{3:0.0}\">{4}%</text>", left, y, right, y + 4, value);
            }

            StringBuilder points = new StringBuilder();
            for (int i = 0; i < count; i++)
            {
                double score = Convert.ToDouble(rows[i]["PercentScore"]);
                double x = count == 1 ? (left + right) / 2.0 : left + step * i;
                double y = bottom - score * (bottom - top) / 100.0;
                if (i > 0) points.Append(' ');
                points.AppendFormat(CultureInfo.InvariantCulture, "{0:0.0},{1:0.0}", x, y);
            }
            svg.Append("<polyline class=\"score-line\" points=\"").Append(points).Append("\"/>");
            for (int i = 0; i < count; i++)
            {
                double score = Convert.ToDouble(rows[i]["PercentScore"]);
                double x = count == 1 ? (left + right) / 2.0 : left + step * i;
                double y = bottom - score * (bottom - top) / 100.0;
                svg.AppendFormat(CultureInfo.InvariantCulture, "<circle class=\"score-point\" cx=\"{0:0.0}\" cy=\"{1:0.0}\" r=\"6\"/><text class=\"score-label\" text-anchor=\"middle\" x=\"{0:0.0}\" y=\"{2:0.0}\">{3:0.#}%</text><text text-anchor=\"middle\" x=\"{0:0.0}\" y=\"246\">{4}</text>", x, y, Math.Max(18, y - 11), score, i + 1);
            }
            svg.Append("<text x=\"48\" y=\"265\">Attempt (oldest to newest)</text></svg>");
            return svg.ToString();
        }

        private void BindFeedbackHistory()
        {
            DataTable feedback = new DataTable();
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
                SELECT Subject, FeedbackType, Status, SubmittedAt
                FROM dbo.Feedback
                WHERE UserID = @UserID
                ORDER BY SubmittedAt DESC, FeedbackID DESC;", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                adapter.Fill(feedback);
            }
            rptFeedback.DataSource = feedback;
            rptFeedback.DataBind();
            pnlNoFeedback.Visible = feedback.Rows.Count == 0;
            pnlFeedbackCard.Visible = feedback.Rows.Count > 0;
        }

        protected string GetSystemImage(object name)
        {
            switch (Convert.ToString(name))
            {
                case "Skeletal System": return ResolveUrl("~/Images/skeletal-system.png");
                case "Cardiovascular System": return ResolveUrl("~/Images/heart.png");
                case "Nervous System": return ResolveUrl("~/Images/brain.png");
                case "Muscular System": return ResolveUrl("~/Images/muscular-system.png");
                default: return ResolveUrl("~/Images/logo.png");
            }
        }

        protected string GetLessonUrl(object name)
        {
            switch (Convert.ToString(name))
            {
                case "Skeletal System": return ResolveUrl("~/Learning/Skeletal.aspx");
                case "Cardiovascular System": return ResolveUrl("~/Learning/Cardiovascular.aspx");
                case "Nervous System": return ResolveUrl("~/Learning/Nervous.aspx");
                case "Muscular System": return ResolveUrl("~/Learning/Muscular.aspx");
                default: return ResolveUrl("~/Default.aspx");
            }
        }

        private void BindFrames()
        {
            DataTable frames = new DataTable();
            using (SqlConnection connection = new SqlConnection(ConnectionString))
            using (SqlCommand command = new SqlCommand(@"
                SELECT F.FrameID, F.FrameKey, F.FrameName, F.RequiredLevel,
                       CAST(CASE WHEN UF.UserID IS NULL THEN 0 ELSE 1 END AS BIT) AS IsUnlocked,
                       ISNULL(UF.IsEquipped, 0) AS IsEquipped
                FROM dbo.ProfileFrames AS F
                LEFT JOIN dbo.UserProfileFrames AS UF ON UF.FrameID = F.FrameID AND UF.UserID = @UserID
                ORDER BY F.DisplayOrder;", connection))
            using (SqlDataAdapter adapter = new SqlDataAdapter(command))
            {
                command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                adapter.Fill(frames);
            }
            rptFrames.DataSource = frames;
            rptFrames.DataBind();
        }

        protected void rptFrames_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (!String.Equals(e.CommandName, "EquipFrame", StringComparison.Ordinal)) return;
            int frameID;
            if (!Int32.TryParse(Convert.ToString(e.CommandArgument), out frameID)) return;
            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand("dbo.EquipProfileFrame", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                    command.Parameters.Add("@FrameID", SqlDbType.Int).Value = frameID;
                    connection.Open();
                    command.ExecuteNonQuery();
                }
                lblProfileMessage.Text = "Your profile frame has been updated.";
                LoadProfile();
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine("Equipping profile frame failed: " + ex);
                lblProfileMessage.Text = "That frame is locked or could not be equipped.";
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            string fullName = txtEditFullName.Text.Trim();
            string email = txtEditEmail.Text.Trim();
            string newPassword = txtNewPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (String.IsNullOrWhiteSpace(fullName) || String.IsNullOrWhiteSpace(email))
            {
                ShowEditMessage("Enter your name and email address.", false);
                return;
            }
            try
            {
                MailAddress address = new MailAddress(email);
                if (!String.Equals(address.Address, email, StringComparison.OrdinalIgnoreCase))
                    throw new FormatException();
            }
            catch
            {
                ShowEditMessage("Enter a valid email address.", false);
                return;
            }
            if (fullName.Length > 100 || email.Length > 150)
            {
                ShowEditMessage("Your name or email is too long.", false);
                return;
            }
            if (newPassword.Length > 0 && newPassword.Length < 8)
            {
                ShowEditMessage("A new password must contain at least 8 characters.", false);
                return;
            }
            if (newPassword != confirmPassword)
            {
                if (newPassword.Length > 0 || confirmPassword.Length > 0)
                {
                    ShowEditMessage("The new passwords do not match.", false);
                    return;
                }
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            using (SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM dbo.Users WHERE Email = @Email AND UserID <> @UserID;", connection, transaction))
                            {
                                check.Parameters.Add("@Email", SqlDbType.NVarChar, 150).Value = email;
                                check.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                                if (Convert.ToInt32(check.ExecuteScalar()) > 0)
                                {
                                    transaction.Rollback();
                                    ShowEditMessage("That email address is already used by another account.", false);
                                    return;
                                }
                            }
                            using (SqlCommand update = new SqlCommand(@"
                                UPDATE dbo.Users
                                SET FullName = @FullName,
                                    Email = @Email,
                                    Password = CASE WHEN @Password IS NULL THEN Password ELSE @Password END
                                WHERE UserID = @UserID;", connection, transaction))
                            {
                                update.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = fullName;
                                update.Parameters.Add("@Email", SqlDbType.NVarChar, 150).Value = email;
                                update.Parameters.Add("@Password", SqlDbType.NVarChar, 255).Value = newPassword.Length == 0 ? (object)DBNull.Value : PasswordHasher.Hash(newPassword);
                                update.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                                if (update.ExecuteNonQuery() != 1) throw new InvalidOperationException("The profile was not updated.");
                            }
                            transaction.Commit();
                        }
                        catch
                        {
                            if (transaction.Connection != null) transaction.Rollback();
                            throw;
                        }
                    }
                }
                Session["FullName"] = fullName;
                Session["Email"] = email;
                txtNewPassword.Text = String.Empty;
                txtConfirmPassword.Text = String.Empty;
                ShowEditMessage("Your profile details have been updated.", true);
                LoadProfile();
            }
            catch (SqlException ex)
            {
                System.Diagnostics.Debug.WriteLine("Updating profile details failed: " + ex);
                ShowEditMessage("Your profile could not be updated. Check that the email is not already in use.", false);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Updating profile details failed: " + ex);
                ShowEditMessage("Your profile could not be updated. Please try again.", false);
            }
        }

        private void ShowEditMessage(string message, bool success)
        {
            lblEditProfileMessage.Text = Server.HtmlEncode(message);
            lblEditProfileMessage.Style["color"] = success ? "#197044" : "#a82a2a";
        }

        /*Uploading Profile Picture*/

        protected void btnUploadPhoto_Click(object sender, EventArgs e)
        {
            if (!profilePhotoUpload.HasFile)
            {
                lblProfileMessage.Text = "Choose a JPG or PNG image first.";
                return;
            }
            string extension = Path.GetExtension(profilePhotoUpload.FileName).ToLowerInvariant();
            if ((extension != ".jpg" && extension != ".jpeg" && extension != ".png") ||
                profilePhotoUpload.PostedFile.ContentLength <= 0 || profilePhotoUpload.PostedFile.ContentLength > 5 * 1024 * 1024 ||
                !HasAllowedImageHeader(profilePhotoUpload.PostedFile.InputStream, extension))
            {
                lblProfileMessage.Text = "Use a valid JPG or PNG image smaller than 5 MB.";
                return;
            }

            string relativePath = "~/Images/ProfilePhotos/" + Guid.NewGuid().ToString("N") + extension;
            string directory = Server.MapPath("~/Images/ProfilePhotos/");
            Directory.CreateDirectory(directory);
            string fullPath = Server.MapPath(relativePath);
            try
            {
                profilePhotoUpload.SaveAs(fullPath);
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                using (SqlCommand command = new SqlCommand("UPDATE dbo.Users SET ProfilePhotoPath = @Path WHERE UserID = @UserID", connection))
                {
                    command.Parameters.Add("@Path", SqlDbType.NVarChar, 500).Value = relativePath;
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = CurrentUserID;
                    connection.Open();
                    if (command.ExecuteNonQuery() != 1) throw new InvalidOperationException("User profile was not updated.");
                }
                lblProfileMessage.Text = "Profile photo updated.";
                LoadProfile();
            }
            catch (Exception ex)
            {
                if (File.Exists(fullPath)) File.Delete(fullPath);
                System.Diagnostics.Debug.WriteLine("Profile photo upload failed: " + ex);
                lblProfileMessage.Text = "The photo could not be saved. Please try again.";
            }
        }

        private static bool HasAllowedImageHeader(Stream stream, string extension)
        {
            if (stream == null || !stream.CanRead) return false;
            long originalPosition = stream.CanSeek ? stream.Position : 0;
            byte[] header = new byte[8];
            int read = stream.Read(header, 0, header.Length);
            if (stream.CanSeek) stream.Position = originalPosition;
            if (extension == ".png")
                return read == 8 && header[0] == 137 && header[1] == 80 && header[2] == 78 && header[3] == 71 && header[4] == 13 && header[5] == 10 && header[6] == 26 && header[7] == 10;
            return read >= 3 && header[0] == 255 && header[1] == 216 && header[2] == 255;
        }
        /*Profile Frames*/
        protected string GetFrameCss(object key)
        {
            switch (Convert.ToString(key))
            {
                case "teal-frost": return "frame-teal-frost";
                case "silver-frost": return "frame-silver-frost";
                case "royal-blue": return "frame-royal-blue";
                case "rose-pink": return "frame-rose-pink";
                case "master-gold": return "frame-master-gold";
                default: return "frame-default-blue";
            }
        }

        protected bool IsFrameUnlocked(object value)
        {
            return value != DBNull.Value && Convert.ToBoolean(value);
        }

        protected string GetFrameStatus(object unlockedValue, object equippedValue, object requiredLevelValue)
        {
            if (!IsFrameUnlocked(unlockedValue)) return "Unlocks at Level " + Convert.ToInt32(requiredLevelValue);
            return Convert.ToBoolean(equippedValue) ? "In use" : "Unlocked";
        }

        protected string GetFrameAction(object unlockedValue, object equippedValue)
        {
            if (!IsFrameUnlocked(unlockedValue)) return "Locked";
            return Convert.ToBoolean(equippedValue) ? "Using" : "Use frame";
        }

        private static string GetInitial(string name)
        {
            return String.IsNullOrWhiteSpace(name) ? "A" : name.Trim().Substring(0, 1).ToUpperInvariant();
        }
    }
}