using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Net.Mail;

namespace AnatoXplore
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (String.IsNullOrWhiteSpace(fullName) || String.IsNullOrWhiteSpace(email) ||
                String.IsNullOrWhiteSpace(password) || String.IsNullOrWhiteSpace(confirmPassword))
            {
                ShowMessage("Please fill in all fields.", false);
                return;
            }

            try
            {
                MailAddress address = new MailAddress(email);
                if (!String.Equals(address.Address, email, StringComparison.OrdinalIgnoreCase))
                {
                    ShowMessage("Please enter a valid email address.", false);
                    return;
                }
            }
            catch
            {
                ShowMessage("Please enter a valid email address.", false);
                return;
            }

            if (password.Length < 8)
            {
                ShowMessage("Your password must contain at least 8 characters.", false);
                return;
            }
            if (password != confirmPassword)
            {
                ShowMessage("The passwords do not match.", false);
                return;
            }

            try
            {
                string connectionString = ConfigurationManager.ConnectionStrings["AnatoXploreConnection"].ConnectionString;
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    using (SqlTransaction transaction = connection.BeginTransaction())
                    {
                        try
                        {
                            using (SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM dbo.Users WHERE Email = @Email", connection, transaction))
                            {
                                check.Parameters.Add("@Email", SqlDbType.NVarChar, 150).Value = email;
                                if (Convert.ToInt32(check.ExecuteScalar()) > 0)
                                {
                                    transaction.Rollback();
                                    ShowMessage("This email is already registered. Please log in.", false);
                                    return;
                                }
                            }

                            int userID;
                            const string insertUser = @"INSERT INTO dbo.Users (FullName, Email, Password, Role)
                                VALUES (@FullName, @Email, @Password, @Role);
                                SELECT CAST(SCOPE_IDENTITY() AS INT);";
                            using (SqlCommand insert = new SqlCommand(insertUser, connection, transaction))
                            {
                                insert.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = fullName;
                                insert.Parameters.Add("@Email", SqlDbType.NVarChar, 150).Value = email;
                                insert.Parameters.Add("@Password", SqlDbType.NVarChar, 255).Value = PasswordHasher.Hash(password);
                                insert.Parameters.Add("@Role", SqlDbType.NVarChar, 20).Value = "Student";
                                userID = Convert.ToInt32(insert.ExecuteScalar());
                            }

                            using (SqlCommand init = new SqlCommand(@"INSERT INTO dbo.UserGamification (UserID, TotalXP, CurrentLevel, UpdatedAt)
                                VALUES (@UserID, 0, 1, GETDATE());", connection, transaction))
                            {
                                init.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                                init.ExecuteNonQuery();
                            }

                            int defaultFrameRows;
                            using (SqlCommand initFrame = new SqlCommand(@"INSERT INTO dbo.UserProfileFrames (UserID, FrameID, IsEquipped)
                                SELECT @UserID, FrameID, 1 FROM dbo.ProfileFrames WHERE IsDefault = 1;", connection, transaction))
                            {
                                initFrame.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                                defaultFrameRows = initFrame.ExecuteNonQuery();
                            }
                            if (defaultFrameRows != 1)
                                throw new InvalidOperationException("The Default Blue profile frame is not configured.");

                            transaction.Commit();
                        }
                        catch
                        {
                            if (transaction.Connection != null) transaction.Rollback();
                            throw;
                        }
                    }
                }

                ShowMessage("Your account has been created successfully! You can now log in.", true);
                txtPassword.Text = String.Empty;
                txtConfirmPassword.Text = String.Empty;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Registration failed: " + ex);
                ShowMessage("Registration failed. Please check your database setup and try again.", false);
            }
        }

        private void ShowMessage(string message, bool success)
        {
            lblMessage.Text = message;
            lblMessage.ForeColor = success ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        }
    }
}
