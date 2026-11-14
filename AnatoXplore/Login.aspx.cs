using System;

using System.Configuration;

using System.Data;

using System.Data.SqlClient;



namespace AnatoXplore

{

    public partial class Login : System.Web.UI.Page

    {

        protected void Page_Load(object sender, EventArgs e)

        {

        }



        protected void btnLogin_Click(object sender, EventArgs e)

        {

            string email = txtEmail.Text.Trim();

            string password = txtPassword.Text;



            if (string.IsNullOrWhiteSpace(email) ||

                string.IsNullOrWhiteSpace(password))

            {

                ShowMessage("Please enter your email and password.", false);

                return;

            }



            try

            {

                string connectionString =

                    ConfigurationManager

                    .ConnectionStrings["AnatoXploreConnection"]

                    .ConnectionString;



                using (SqlConnection connection =

                    new SqlConnection(connectionString))

                {

                    connection.Open();



                    string query = @" 

                        SELECT U.UserID, U.FullName, U.Email, U.Role, U.ProfilePhotoPath,
                               ISNULL(F.FrameKey, N'default-blue') AS ProfileFrameKey
                        FROM dbo.Users AS U
                        LEFT JOIN dbo.UserProfileFrames AS UF ON UF.UserID = U.UserID AND UF.IsEquipped = 1
                        LEFT JOIN dbo.ProfileFrames AS F ON F.FrameID = UF.FrameID
                        WHERE U.Email = @Email
                        AND U.Password = @Password";



                    using (SqlCommand command =

                        new SqlCommand(query, connection))

                    {

                        command.Parameters.Add(

                            "@Email", SqlDbType.NVarChar, 255).Value = email;



                        command.Parameters.Add(

                            "@Password", SqlDbType.NVarChar, 128).Value = PasswordHasher.Hash(password);



                        using (SqlDataReader reader = command.ExecuteReader())

                        {

                            if (reader.Read())

                            {

                                Session["UserID"] = reader["UserID"];

                                Session["FullName"] = reader["FullName"].ToString();

                                Session["Email"] = reader["Email"].ToString();

                                Session["Role"] = reader["Role"].ToString();
                                Session["ProfilePhotoPath"] = reader["ProfilePhotoPath"] == DBNull.Value ? null : reader["ProfilePhotoPath"].ToString();
                                Session["ProfileFrameKey"] = reader["ProfileFrameKey"].ToString();
                                Session["ProfileBadgeLoaded"] = true;



                                string returnUrl = Request.QueryString["returnUrl"];
                                string destination = IsLocalRedirect(returnUrl)
                                    ? returnUrl
                                    : ResolveUrl("~/Default.aspx");
                                Response.Redirect(destination, false);



                                Context.ApplicationInstance.CompleteRequest();

                                return;

                            }

                            else

                            {

                                ShowMessage(

                                    "Incorrect email or password.", false);

                            }

                        }

                    }

                }

            }

            catch (Exception)

            {

                ShowMessage(

                    "Login failed. Please try again later.",

                    false);

            }

        }



        private bool IsLocalRedirect(string url)
        {
            return !string.IsNullOrWhiteSpace(url)
                && url[0] == '/'
                && (url.Length == 1 || (url[1] != '/' && url[1] != '\\'));
        }
        private void ShowMessage(string message, bool success)

        {

            lblMessage.Text = message;



            lblMessage.ForeColor = success

                ? System.Drawing.Color.Green

                : System.Drawing.Color.Red;

        }

    }

}