/*
    AnatoXplore gamification and profile-frame migration.
    Run once against the current AnatoXploreDB from SQL Server Management Studio.
    The migration starts all existing accounts at 0 XP / Level 1, as requested.
    Historical XPTransactions are retained; only UserGamification totals reset.
*/
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

IF OBJECT_ID(N'dbo.AppMigrations', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AppMigrations
    (
        MigrationKey NVARCHAR(100) NOT NULL PRIMARY KEY,
        AppliedAt DATETIME2 NOT NULL CONSTRAINT DF_AppMigrations_AppliedAt DEFAULT SYSUTCDATETIME()
    );
END;
GO

IF COL_LENGTH(N'dbo.Users', N'ProfilePhotoPath') IS NULL
    ALTER TABLE dbo.Users ADD ProfilePhotoPath NVARCHAR(500) NULL;
GO

IF OBJECT_ID(N'dbo.UserGamification', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserGamification
    (
        UserID INT NOT NULL PRIMARY KEY,
        TotalXP INT NOT NULL CONSTRAINT DF_UserGamification_TotalXP DEFAULT (0),
        CurrentLevel INT NOT NULL CONSTRAINT DF_UserGamification_CurrentLevel DEFAULT (1),
        UpdatedAt DATETIME NOT NULL CONSTRAINT DF_UserGamification_UpdatedAt DEFAULT (GETDATE()),
        CONSTRAINT FK_UserGamification_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
        CONSTRAINT CK_UserGamification_XP CHECK (TotalXP >= 0),
        CONSTRAINT CK_UserGamification_Level CHECK (CurrentLevel BETWEEN 1 AND 6)
    );
END;
GO

IF OBJECT_ID(N'dbo.XPTransactions', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.XPTransactions
    (
        TransactionID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        UserID INT NOT NULL,
        QuizResultID INT NULL,
        BaseXP INT NOT NULL CONSTRAINT DF_XPTransactions_BaseXP DEFAULT (0),
        SpeedBonusXP INT NOT NULL CONSTRAINT DF_XPTransactions_SpeedBonusXP DEFAULT (0),
        TotalXP AS (BaseXP + SpeedBonusXP) PERSISTED,
        TransactionType NVARCHAR(30) NOT NULL,
        Description NVARCHAR(255) NULL,
        CreatedAt DATETIME NOT NULL CONSTRAINT DF_XPTransactions_CreatedAt DEFAULT (GETDATE()),
        CONSTRAINT FK_XPTransactions_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_XPTransactions_QuizResults FOREIGN KEY (QuizResultID) REFERENCES dbo.QuizResults(ResultID),
        CONSTRAINT CK_XPTransactions_BaseXP CHECK (BaseXP >= 0),
        CONSTRAINT CK_XPTransactions_SpeedBonusXP CHECK (SpeedBonusXP >= 0)
    );
END;
GO

IF OBJECT_ID(N'dbo.ProfileFrames', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ProfileFrames
    (
        FrameID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        FrameKey NVARCHAR(50) NOT NULL,
        FrameName NVARCHAR(100) NOT NULL,
        RequiredLevel INT NOT NULL,
        DisplayOrder INT NOT NULL,
        IsDefault BIT NOT NULL CONSTRAINT DF_ProfileFrames_IsDefault DEFAULT (0),
        CONSTRAINT UQ_ProfileFrames_FrameKey UNIQUE (FrameKey),
        CONSTRAINT CK_ProfileFrames_RequiredLevel CHECK (RequiredLevel BETWEEN 1 AND 6)
    );
END;
GO

INSERT INTO dbo.ProfileFrames (FrameKey, FrameName, RequiredLevel, DisplayOrder, IsDefault)
SELECT V.FrameKey, V.FrameName, V.RequiredLevel, V.DisplayOrder, V.IsDefault
FROM (VALUES
    (N'default-blue', N'Default Blue', 1, 1, CAST(1 AS BIT)),
    (N'teal-frost', N'Teal Frost', 2, 2, CAST(0 AS BIT)),
    (N'silver-frost', N'Silver Frost', 3, 3, CAST(0 AS BIT)),
    (N'royal-blue', N'Royal Blue', 4, 4, CAST(0 AS BIT)),
    (N'rose-pink', N'Rose Pink', 5, 5, CAST(0 AS BIT)),
    (N'master-gold', N'Master Gold', 6, 6, CAST(0 AS BIT))
) AS V(FrameKey, FrameName, RequiredLevel, DisplayOrder, IsDefault)
WHERE NOT EXISTS (SELECT 1 FROM dbo.ProfileFrames AS F WHERE F.FrameKey = V.FrameKey);
GO

IF OBJECT_ID(N'dbo.UserProfileFrames', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.UserProfileFrames
    (
        UserID INT NOT NULL,
        FrameID INT NOT NULL,
        UnlockedAt DATETIME NOT NULL CONSTRAINT DF_UserProfileFrames_UnlockedAt DEFAULT (GETDATE()),
        IsEquipped BIT NOT NULL CONSTRAINT DF_UserProfileFrames_IsEquipped DEFAULT (0),
        CONSTRAINT PK_UserProfileFrames PRIMARY KEY (UserID, FrameID),
        CONSTRAINT FK_UserProfileFrames_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_UserProfileFrames_ProfileFrames FOREIGN KEY (FrameID) REFERENCES dbo.ProfileFrames(FrameID)
    );
END;
GO

IF EXISTS (SELECT QuizResultID FROM dbo.XPTransactions WHERE QuizResultID IS NOT NULL GROUP BY QuizResultID HAVING COUNT(*) > 1)
    THROW 50020, 'Duplicate XPTransactions exist for a QuizResultID; review them before creating the one-award index.', 1;
GO
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.XPTransactions') AND name = N'UX_XPTransactions_QuizResultID')
    CREATE UNIQUE INDEX UX_XPTransactions_QuizResultID ON dbo.XPTransactions(QuizResultID) WHERE QuizResultID IS NOT NULL;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'dbo.UserProfileFrames') AND name = N'UX_UserProfileFrames_OneEquippedPerUser')
    CREATE UNIQUE INDEX UX_UserProfileFrames_OneEquippedPerUser
        ON dbo.UserProfileFrames(UserID) WHERE IsEquipped = 1;
GO

/* Existing XPTransactions are retained, but totals start from zero for all accounts. */
IF NOT EXISTS (SELECT 1 FROM dbo.AppMigrations WHERE MigrationKey = N'20261030_ProfileFrames_Gamification_v1')
BEGIN
    BEGIN TRANSACTION;

    INSERT INTO dbo.UserGamification (UserID, TotalXP, CurrentLevel)
    SELECT U.UserID, 0, 1
    FROM dbo.Users AS U
    WHERE NOT EXISTS (SELECT 1 FROM dbo.UserGamification AS G WHERE G.UserID = U.UserID);

    UPDATE dbo.UserGamification SET TotalXP = 0, CurrentLevel = 1, UpdatedAt = GETDATE();

    /* Every account starts with only the Default Blue frame unlocked and equipped. */
    INSERT INTO dbo.UserProfileFrames (UserID, FrameID, IsEquipped)
    SELECT U.UserID, F.FrameID, 1
    FROM dbo.Users AS U
    CROSS JOIN dbo.ProfileFrames AS F
    WHERE F.IsDefault = 1
      AND NOT EXISTS (SELECT 1 FROM dbo.UserProfileFrames AS UF WHERE UF.UserID = U.UserID AND UF.FrameID = F.FrameID);

    UPDATE UF SET IsEquipped = CASE WHEN F.IsDefault = 1 THEN 1 ELSE 0 END
    FROM dbo.UserProfileFrames AS UF
    INNER JOIN dbo.ProfileFrames AS F ON F.FrameID = UF.FrameID
    WHERE F.IsDefault = 1;

    INSERT INTO dbo.AppMigrations (MigrationKey) VALUES (N'20261030_ProfileFrames_Gamification_v1');
    COMMIT TRANSACTION;
END;
GO

CREATE OR ALTER PROCEDURE dbo.AwardXPAndUpdateLevel
    @UserID INT,
    @QuizResultID INT,
    @BaseXP INT,
    @SpeedBonusXP INT,
    @Description NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @BaseXP < 0 OR @SpeedBonusXP < 0
        THROW 50001, 'XP values cannot be negative.', 1;

    IF @@TRANCOUNT = 0
        THROW 50002, 'AwardXPAndUpdateLevel must be called within the quiz-result transaction.', 1;

    IF NOT EXISTS (SELECT 1 FROM dbo.QuizResults WHERE ResultID = @QuizResultID AND UserID = @UserID)
        THROW 50003, 'The quiz result does not belong to this user.', 1;

    /* Makes a repeated award call for this exact result harmless. A retake has a new ResultID. */
    IF EXISTS (SELECT 1 FROM dbo.XPTransactions WITH (UPDLOCK, HOLDLOCK) WHERE QuizResultID = @QuizResultID)
        RETURN;

    INSERT INTO dbo.XPTransactions (UserID, QuizResultID, BaseXP, SpeedBonusXP, TransactionType, Description, CreatedAt)
    VALUES (@UserID, @QuizResultID, @BaseXP, @SpeedBonusXP, N'Quiz', @Description, GETDATE());

    IF NOT EXISTS (SELECT 1 FROM dbo.UserGamification WITH (UPDLOCK, HOLDLOCK) WHERE UserID = @UserID)
        INSERT INTO dbo.UserGamification (UserID, TotalXP, CurrentLevel, UpdatedAt) VALUES (@UserID, 0, 1, GETDATE());

    UPDATE dbo.UserGamification
    SET TotalXP = TotalXP + @BaseXP + @SpeedBonusXP,
        UpdatedAt = GETDATE()
    WHERE UserID = @UserID;

    UPDATE dbo.UserGamification
    SET CurrentLevel = CASE
        WHEN TotalXP >= 800 THEN 6
        WHEN TotalXP >= 550 THEN 5
        WHEN TotalXP >= 350 THEN 4
        WHEN TotalXP >= 200 THEN 3
        WHEN TotalXP >= 100 THEN 2
        ELSE 1 END
    WHERE UserID = @UserID;

    DECLARE @CurrentLevel INT;
    SELECT @CurrentLevel = CurrentLevel FROM dbo.UserGamification WHERE UserID = @UserID;

    INSERT INTO dbo.UserProfileFrames (UserID, FrameID, IsEquipped)
    SELECT @UserID, F.FrameID, 0
    FROM dbo.ProfileFrames AS F
    WHERE F.RequiredLevel <= @CurrentLevel
      AND NOT EXISTS (SELECT 1 FROM dbo.UserProfileFrames AS UF WHERE UF.UserID = @UserID AND UF.FrameID = F.FrameID);
END;
GO

CREATE OR ALTER PROCEDURE dbo.EquipProfileFrame
    @UserID INT,
    @FrameID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM dbo.UserProfileFrames WITH (UPDLOCK, HOLDLOCK) WHERE UserID = @UserID AND FrameID = @FrameID)
            THROW 50011, 'That profile frame is not unlocked for this user.', 1;

        UPDATE dbo.UserProfileFrames SET IsEquipped = 0 WHERE UserID = @UserID AND IsEquipped = 1;
        UPDATE dbo.UserProfileFrames SET IsEquipped = 1 WHERE UserID = @UserID AND FrameID = @FrameID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
