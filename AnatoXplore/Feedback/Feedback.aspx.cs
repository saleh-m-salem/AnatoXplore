using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AnatoXplore
{
    public partial class Feedback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
         
        }

        protected void btnSubmitFeedback_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                // Pull connection string from Web.config
                string connString = ConfigurationManager.ConnectionStrings["AnatoXploreConnection"].ConnectionString;

                string query = "INSERT INTO Feedback (UserID, FeedbackType, Subject, Message, SubmittedAt, Status) " +
                               "VALUES (@UserID, @FeedbackType, @Subject, @Message, GETDATE(), 'Pending')";

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        // Handle user ID: if logged in, save their ID; otherwise write DBNull for guest feedback
                        if (Session["UserID"] != null)
                        {
                            cmd.Parameters.AddWithValue("@UserID", Convert.ToInt32(Session["UserID"]));
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@UserID", DBNull.Value);
                        }

                        cmd.Parameters.AddWithValue("@FeedbackType", ddlFeedbackType.SelectedValue);
                        cmd.Parameters.AddWithValue("@Subject", txtSubject.Text.Trim());
                        cmd.Parameters.AddWithValue("@Message", txtMessage.Text.Trim());

                        try
                        {
                            conn.Open();
                            int rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected > 0)
                            {
                                pnlSuccess.Visible = true;
                                pnlError.Visible = false;

                                // Clear the form fields after successful submission
                                txtSubject.Text = "";
                                txtMessage.Text = "";
                                ddlFeedbackType.SelectedIndex = 0;
                            }
                            else
                            {
                                pnlSuccess.Visible = false;
                                pnlError.Visible = true;
                            }
                        }
                        catch (Exception)
                        {
                            pnlSuccess.Visible = false;
                            pnlError.Visible = true;
                        }
                    }
                }
            }
        }
    }
}