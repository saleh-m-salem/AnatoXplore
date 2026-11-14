using System;

using System.Configuration;

using System.Data;

using System.Data.SqlClient;

using System.Web.UI;

using System.Web.UI.WebControls;



namespace AnatoXplore

{

    public partial class Leaderboard : Page

    {

        private int? CurrentUserId

        {

            get

            {

                if (Session["UserID"] == null) return null;

                int userId;

                return int.TryParse(Convert.ToString(Session["UserID"]), out userId)

                    ? (int?)userId : null;

            }

        }



        protected void Page_Load(object sender, EventArgs e)

        {

            if (!IsPostBack) LoadLeaderboard();

        }



        private void LoadLeaderboard()

        {

            bool isLoggedIn = Session["UserID"] != null;

            pnlGuest.Visible = !isLoggedIn;

            pnlLeaderboard.Visible = isLoggedIn;

            if (!isLoggedIn) return;



            string connectionString = ConfigurationManager.ConnectionStrings["AnatoXploreConnection"].ConnectionString;

            string query = @" 

                ;WITH RankedUsers AS 

                ( 

                    SELECT U.UserID, U.FullName, U.ProfilePhotoPath,
                        ISNULL(F.FrameKey, N'default-blue') AS ProfileFrameKey,
                        ISNULL(G.CurrentLevel, 1) AS CurrentLevel, 

                        ISNULL(G.TotalXP, 0) AS TotalXP, 

                        ROW_NUMBER() OVER 

                        (ORDER BY ISNULL(G.TotalXP, 0) DESC, U.FullName ASC, U.UserID ASC) AS [Rank] 

                    FROM dbo.Users AS U 

                    INNER JOIN dbo.UserGamification AS G ON U.UserID = G.UserID
                    LEFT JOIN dbo.UserProfileFrames AS UF ON UF.UserID = U.UserID AND UF.IsEquipped = 1
                    LEFT JOIN dbo.ProfileFrames AS F ON F.FrameID = UF.FrameID
                    WHERE ISNULL(G.TotalXP, 0) > 0 AND U.Role NOT IN (N'Admin', N'Administrator')
                ) 

                SELECT UserID, [Rank], FullName, ProfilePhotoPath, ProfileFrameKey, CurrentLevel, TotalXP 

                FROM RankedUsers WHERE [Rank] <= 10 ORDER BY [Rank];";



            DataTable leaderboard = new DataTable();

            using (SqlConnection connection = new SqlConnection(connectionString))

            using (SqlCommand command = new SqlCommand(query, connection))

            using (SqlDataAdapter adapter = new SqlDataAdapter(command))

                try
                {
                    adapter.Fill(leaderboard);
                }
                catch (Exception)
                {
                    pnlNoPodium.Controls.Clear();
                    pnlNoPodium.Controls.Add(new LiteralControl("The leaderboard could not be loaded. Please try again later."));
                    pnlNoPodium.Visible = true;
                    return;
                }



            leaderboard.Columns.Add("Initials", typeof(string));

            foreach (DataRow row in leaderboard.Rows)

                row["Initials"] = GetInitials(Convert.ToString(row["FullName"]));



            DataTable podium = leaderboard.Clone();

            DataTable remaining = leaderboard.Clone();

            foreach (DataRow row in leaderboard.Rows)

            {

                if (Convert.ToInt32(row["Rank"]) <= 3) podium.ImportRow(row);

                else remaining.ImportRow(row);

            }



            // Order cards as 2nd, 1st, 3rd so first place appears in the center. 

            DataTable podiumDisplay = podium.Clone();

            AddRankToPodium(podiumDisplay, podium, 2);

            AddRankToPodium(podiumDisplay, podium, 1);

            AddRankToPodium(podiumDisplay, podium, 3);



            rptPodium.DataSource = podiumDisplay;

            rptPodium.DataBind();

            // Option B: show all top 10 in the table, including the podium users. 

            gvLeaderboard.DataSource = leaderboard;

            gvLeaderboard.DataBind();



            pnlNoPodium.Visible = podium.Rows.Count == 0;

            pnlCurrentUserOutsideTopTen.Visible = IsCurrentUserOutsideTopTen(leaderboard);

        }



        private void AddRankToPodium(DataTable target, DataTable source, int rank)

        {

            foreach (DataRow row in source.Rows)

                if (Convert.ToInt32(row["Rank"]) == rank) { target.ImportRow(row); return; }

        }



        private bool IsCurrentUserOutsideTopTen(DataTable topTen)

        {

            if (!CurrentUserId.HasValue) return false;

            foreach (DataRow row in topTen.Rows)

                if (Convert.ToInt32(row["UserID"]) == CurrentUserId.Value) return false;

            return true;

        }



        private string GetInitials(string fullName)

        {

            if (String.IsNullOrWhiteSpace(fullName)) return "AX";

            string[] parts = fullName.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            if (parts.Length == 1)

                return parts[0].Length >= 2 ? parts[0].Substring(0, 2).ToUpperInvariant() : parts[0].ToUpperInvariant();

            return (parts[0][0].ToString() + parts[parts.Length - 1][0].ToString()).ToUpperInvariant();

        }



        protected void gvLeaderboard_RowDataBound(object sender, GridViewRowEventArgs e)

        {

            if (e.Row.RowType != DataControlRowType.DataRow || !CurrentUserId.HasValue) return;

            int rowUserId = Convert.ToInt32(gvLeaderboard.DataKeys[e.Row.RowIndex].Value);

            if (rowUserId == CurrentUserId.Value)

            {

                e.Row.CssClass = (e.Row.CssClass + " lb-current-user").Trim();

                Label youLabel = e.Row.FindControl("lblYou") as Label;

                if (youLabel != null) youLabel.Visible = true;

            }

        }

    }

}