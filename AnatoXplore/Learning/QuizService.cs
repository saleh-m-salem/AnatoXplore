using System;
using System.Data;
using System.Data.SqlClient;

namespace AnatoXplore.Learning
{
    public static class QuizService
    {
        public static void SaveResult(string connectionString, int userID, int systemID, int score, int totalQuestions, int baseXP, int speedBonusXP, int durationSeconds, string description)
        {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlTransaction transaction = connection.BeginTransaction())
                {
                    try
                    {
                        int resultID;
                        using (SqlCommand command = new SqlCommand(@"INSERT INTO dbo.QuizResults (UserID, SystemID, Score, TotalQuestions, DurationSeconds, AttemptDate) VALUES (@UserID, @SystemID, @Score, @TotalQuestions, @DurationSeconds, GETDATE()); SELECT CAST(SCOPE_IDENTITY() AS INT);", connection, transaction))
                        {
                            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                            command.Parameters.Add("@SystemID", SqlDbType.Int).Value = systemID;
                            command.Parameters.Add("@Score", SqlDbType.Int).Value = score;
                            command.Parameters.Add("@TotalQuestions", SqlDbType.Int).Value = totalQuestions;
                            command.Parameters.Add("@DurationSeconds", SqlDbType.Int).Value = durationSeconds;
                            resultID = Convert.ToInt32(command.ExecuteScalar());
                        }
                        using (SqlCommand command = new SqlCommand("dbo.AwardXPAndUpdateLevel", connection, transaction))
                        {
                            command.CommandType = CommandType.StoredProcedure;
                            command.Parameters.Add("@UserID", SqlDbType.Int).Value = userID;
                            command.Parameters.Add("@QuizResultID", SqlDbType.Int).Value = resultID;
                            command.Parameters.Add("@BaseXP", SqlDbType.Int).Value = baseXP;
                            command.Parameters.Add("@SpeedBonusXP", SqlDbType.Int).Value = speedBonusXP;
                            command.Parameters.Add("@Description", SqlDbType.NVarChar, 255).Value = description ?? String.Empty;
                            command.ExecuteNonQuery();
                        }
                        transaction.Commit();
                    }
                    catch { transaction.Rollback(); throw; }
                }
            }
        }
    }
}
