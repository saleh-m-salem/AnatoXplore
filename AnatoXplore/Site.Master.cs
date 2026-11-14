using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;

namespace AnatoXplore
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool isLoggedIn = Session["UserID"] != null;
            LoggedOutLinks.Visible = !isLoggedIn;
            LoggedInLinks.Visible = isLoggedIn;
            lnkAdminDashboard.Visible = false;
            if (!isLoggedIn) return;

            lnkAdminDashboard.Visible = IsDatabaseAdmin();

            EnsureProfileBadgeLoaded();
            string fullName = (Convert.ToString(Session["FullName"]) ?? String.Empty).Trim();
            if (fullName.Length > 0)
                fullName = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(fullName.ToLowerInvariant());
            else
                fullName = "User";

            lblUserName.Text = Server.HtmlEncode(fullName);
            litUserAvatar.Text = ProfileBadgeRenderer.Render(
                Session["ProfilePhotoPath"], Session["ProfileFrameKey"], fullName, "site-avatar");
        }

        private bool IsDatabaseAdmin()
        {
            int userID;
            if (!Int32.TryParse(Convert.ToString(Session["UserID"]), out userID)) return false;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AnatoXploreConnection"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand("SELECT Role FROM dbo.Users WHERE UserID=@UserID", connection))
                {
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                    connection.Open();
                    string role = Convert.ToString(command.ExecuteScalar());
                    return String.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase)
                        || String.Equals(role, "Administrator", StringComparison.OrdinalIgnoreCase);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Checking dashboard link role failed: " + ex);
                return false;
            }
        }

        private void EnsureProfileBadgeLoaded()
        {
            if (Session["ProfileBadgeLoaded"] != null) return;
            int userID;
            if (!Int32.TryParse(Convert.ToString(Session["UserID"]), out userID)) return;

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AnatoXploreConnection"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                using (SqlCommand command = new SqlCommand(@"
                    SELECT U.ProfilePhotoPath, ISNULL(F.FrameKey, N'default-blue') AS FrameKey
                    FROM dbo.Users AS U
                    LEFT JOIN dbo.UserProfileFrames AS UF ON UF.UserID = U.UserID AND UF.IsEquipped = 1
                    LEFT JOIN dbo.ProfileFrames AS F ON F.FrameID = UF.FrameID
                    WHERE U.UserID = @UserID;", connection))
                {
                    command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            Session["ProfilePhotoPath"] = reader["ProfilePhotoPath"] == DBNull.Value ? null : reader["ProfilePhotoPath"].ToString();
                            Session["ProfileFrameKey"] = reader["FrameKey"].ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Loading profile badge failed: " + ex);
                Session["ProfilePhotoPath"] = null;
                Session["ProfileFrameKey"] = "default-blue";
            }
            Session["ProfileBadgeLoaded"] = true;
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect(ResolveUrl("~/Default.aspx"), false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}
