/* Run once against the same AnatoXplore database used by the website. */
IF COL_LENGTH(N'dbo.QuizResults', N'DurationSeconds') IS NULL
    ALTER TABLE dbo.QuizResults ADD DurationSeconds INT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = N'CK_QuizResults_Duration')
    ALTER TABLE dbo.QuizResults ADD CONSTRAINT CK_QuizResults_Duration
        CHECK (DurationSeconds IS NULL OR DurationSeconds >= 0);
GO
