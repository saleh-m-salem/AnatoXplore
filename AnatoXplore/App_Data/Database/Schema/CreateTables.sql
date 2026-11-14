SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO


-- 1. USERS
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    Role NVARCHAR(20) NOT NULL DEFAULT 'Student',
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    ProfilePhotoPath NVARCHAR(500) NULL
);

-- 2. BODY SYSTEMS
CREATE TABLE BodySystems (
    SystemID INT IDENTITY(1,1) PRIMARY KEY,
    SystemName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(500),
    IsFreeDemo BIT NOT NULL DEFAULT 0,
    ImagePath NVARCHAR(255)
);

-- 3. VIDEOS
CREATE TABLE Videos (
    VideoID INT IDENTITY(1,1) PRIMARY KEY,
    SystemID INT NOT NULL,
    VideoTitle NVARCHAR(150) NOT NULL,
    VideoURL NVARCHAR(500) NOT NULL,
    Description NVARCHAR(500),
    FOREIGN KEY (SystemID) REFERENCES BodySystems(SystemID)
);

-- 4. QUIZ QUESTIONS
CREATE TABLE Questions (
    QuestionID INT IDENTITY(1,1) PRIMARY KEY,
    SystemID INT NOT NULL,
    QuestionText NVARCHAR(1000) NOT NULL,
    OptionA NVARCHAR(300) NOT NULL,
    OptionB NVARCHAR(300) NOT NULL,
    OptionC NVARCHAR(300) NOT NULL,
    OptionD NVARCHAR(300) NOT NULL,
    CorrectAnswer CHAR(1) NOT NULL,
    Explanation NVARCHAR(1000),
    FOREIGN KEY (SystemID) REFERENCES BodySystems(SystemID),
    CONSTRAINT CK_Questions_CorrectAnswer
        CHECK (CorrectAnswer IN ('A','B','C','D'))
);

-- 5. QUIZ RESULTS
CREATE TABLE QuizResults (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    SystemID INT NOT NULL,
    Score INT NOT NULL,
    TotalQuestions INT NOT NULL,
    AttemptDate DATETIME NOT NULL DEFAULT GETDATE(),
    DurationSeconds INT NULL,
    CONSTRAINT CK_QuizResults_Duration CHECK (DurationSeconds IS NULL OR DurationSeconds >= 0),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (SystemID) REFERENCES BodySystems(SystemID),
    CONSTRAINT CK_QuizResults_Score
        CHECK (Score >= 0 AND Score <= TotalQuestions),
    CONSTRAINT CK_QuizResults_Total
        CHECK (TotalQuestions > 0)
);

-- 6. DISCUSSIONS AND REPLIES
CREATE TABLE Discussions (
    DiscussionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    ParentDiscussionID INT NULL,
    Title NVARCHAR(200) NOT NULL,
    PostContent NVARCHAR(MAX) NOT NULL,
    SystemID INT NULL,
    UpdatedAt DATETIME NULL,
    FOREIGN KEY (SystemID) REFERENCES BodySystems(SystemID),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ParentDiscussionID)
        REFERENCES Discussions(DiscussionID)
);

-- 7. FEEDBACK
CREATE TABLE Feedback (
    FeedbackID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NULL,
    FeedbackType NVARCHAR(50) NOT NULL DEFAULT 'General Feedback', 
    Subject NVARCHAR(200) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT 'Pending',
    SubmittedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 8. FLASHCARDS
CREATE TABLE Flashcards (
    FlashcardID INT IDENTITY(1,1) PRIMARY KEY,
    SystemID INT NOT NULL,
    QuestionText NVARCHAR(500) NOT NULL,
    AnswerText NVARCHAR(1000) NOT NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    FOREIGN KEY (SystemID) REFERENCES BodySystems(SystemID)
);

-- 10. ADMIN AUDIT LOG
CREATE TABLE AdminAuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    AdminUserID INT NULL,
    ActionName NVARCHAR(100) NOT NULL,
    Details NVARCHAR(1000) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (AdminUserID) REFERENCES Users(UserID)
);

-- 9. GAMIFICATION AND PROFILE FRAMES
CREATE TABLE dbo.UserGamification
(
    UserID INT NOT NULL PRIMARY KEY,
    TotalXP INT NOT NULL DEFAULT (0),
    CurrentLevel INT NOT NULL DEFAULT (1),
    UpdatedAt DATETIME NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT FK_UserGamification_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT CK_UserGamification_XP CHECK (TotalXP >= 0),
    CONSTRAINT CK_UserGamification_Level CHECK (CurrentLevel BETWEEN 1 AND 6)
);

CREATE TABLE dbo.XPTransactions
(
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    QuizResultID INT NULL,
    BaseXP INT NOT NULL DEFAULT (0),
    SpeedBonusXP INT NOT NULL DEFAULT (0),
    TotalXP AS (BaseXP + SpeedBonusXP) PERSISTED,
    TransactionType NVARCHAR(30) NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT (GETDATE()),
    CONSTRAINT FK_XPTransactions_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_XPTransactions_QuizResults FOREIGN KEY (QuizResultID) REFERENCES dbo.QuizResults(ResultID),
    CONSTRAINT CK_XPTransactions_BaseXP CHECK (BaseXP >= 0),
    CONSTRAINT CK_XPTransactions_SpeedBonusXP CHECK (SpeedBonusXP >= 0)
);
CREATE UNIQUE INDEX UX_XPTransactions_QuizResultID
    ON dbo.XPTransactions(QuizResultID) WHERE QuizResultID IS NOT NULL;

CREATE TABLE dbo.ProfileFrames
(
    FrameID INT IDENTITY(1,1) PRIMARY KEY,
    FrameKey NVARCHAR(50) NOT NULL UNIQUE,
    FrameName NVARCHAR(100) NOT NULL,
    RequiredLevel INT NOT NULL,
    DisplayOrder INT NOT NULL,
    IsDefault BIT NOT NULL DEFAULT (0),
    CONSTRAINT CK_ProfileFrames_RequiredLevel CHECK (RequiredLevel BETWEEN 1 AND 6)
);

INSERT INTO dbo.ProfileFrames (FrameKey, FrameName, RequiredLevel, DisplayOrder, IsDefault)
VALUES
    (N'default-blue', N'Default Blue', 1, 1, 1),
    (N'teal-frost', N'Teal Frost', 2, 2, 0),
    (N'silver-frost', N'Silver Frost', 3, 3, 0),
    (N'royal-blue', N'Royal Blue', 4, 4, 0),
    (N'rose-pink', N'Rose Pink', 5, 5, 0),
    (N'master-gold', N'Master Gold', 6, 6, 0);

CREATE TABLE dbo.UserProfileFrames
(
    UserID INT NOT NULL,
    FrameID INT NOT NULL,
    UnlockedAt DATETIME NOT NULL DEFAULT (GETDATE()),
    IsEquipped BIT NOT NULL DEFAULT (0),
    CONSTRAINT PK_UserProfileFrames PRIMARY KEY (UserID, FrameID),
    CONSTRAINT FK_UserProfileFrames_Users FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
    CONSTRAINT FK_UserProfileFrames_ProfileFrames FOREIGN KEY (FrameID) REFERENCES dbo.ProfileFrames(FrameID)
);
CREATE UNIQUE INDEX UX_UserProfileFrames_OneEquippedPerUser
    ON dbo.UserProfileFrames(UserID) WHERE IsEquipped = 1;

-- =========================================
-- INSERT BODY SYSTEMS
-- =========================================

INSERT INTO BodySystems
    (SystemName, Description, IsFreeDemo, ImagePath)
VALUES
    ('Skeletal System', 'Learn about bones and joints.', 1, 'Images/skeletal-system.png'),
    ('Cardiovascular System', 'Explore the heart and blood circulation.', 0, 'Images/heart.png'),
    ('Nervous System', 'Explore the brain, spinal cord and nerves.', 0, 'Images/brain.png'),
    ('Muscular System', 'Learn about muscles and movement.', 0, 'Images/muscular-system.png');


-- =========================================
-- INSERT VIDEOS 
-- =========================================

INSERT INTO Videos (SystemID, VideoTitle, VideoURL, Description)
SELECT
    bs.SystemID,
    v.VideoTitle,
    v.VideoURL,
    v.Description
FROM BodySystems bs
INNER JOIN (
    SELECT
        'Skeletal System' AS SystemName,
        'Skeletal System Anatomy' AS VideoTitle,
        'https://www.youtube.com/watch?v=NHECopO6L3g' AS VideoURL,
        'Educational video about the human skeletal system.' AS Description

    UNION ALL

    SELECT
        'Cardiovascular System',
        'Cardiovascular System Anatomy',
        'https://youtu.be/4OwS3NKiwhA?si=iia8Hq3BnXgaPXKc',
        'Educational video about the human cardiovascular system.'

    UNION ALL

    SELECT
        'Nervous System',
        'Nervous System Anatomy',
        'https://youtu.be/RNLceVI8jcc?si=JHJTcJVSZjQFltpS',
        'Educational video about the human nervous system.'

    UNION ALL

    SELECT
        'Muscular System',
        'Muscular System Anatomy',
        'https://youtu.be/q_TuNJN9nXM?si=i0MpxroeqhP3cFi3',
        'Educational video about the human muscular system.'
) AS v
    ON bs.SystemName = v.SystemName
WHERE NOT EXISTS (
    SELECT 1
    FROM Videos existing
    WHERE existing.SystemID = bs.SystemID
      AND existing.VideoTitle = v.VideoTitle
);

-- =========================================
-- INSERT QUESTIONS 
-- =========================================

INSERT INTO Questions
    (SystemID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer, Explanation)
SELECT
    bs.SystemID,
    q.QuestionText,
    q.OptionA,
    q.OptionB,
    q.OptionC,
    q.OptionD,
    q.CorrectAnswer,
    q.Explanation
FROM BodySystems bs
INNER JOIN (
    SELECT
        'Skeletal System' AS SystemName,
        'What is the main function of the human skeleton?' AS QuestionText,
        'Produce hormones only' AS OptionA,
        'Support the body and protect organs' AS OptionB,
        'Digest food' AS OptionC,
        'Pump blood' AS OptionD,
        'B' AS CorrectAnswer,
        'The skeleton supports the body, protects organs, and helps movement.' AS Explanation

    UNION ALL SELECT 'Skeletal System',
        'Which type of joint is found at the shoulder?',
        'Hinge joint', 'Pivot joint', 'Ball-and-socket joint', 'Fixed joint',
        'C', 'The shoulder is a ball-and-socket joint that allows movement in many directions.'

    UNION ALL SELECT 'Skeletal System',
        'Which bone protects the brain?',
        'Femur', 'Rib', 'Pelvis', 'Skull',
        'D', 'The skull surrounds and protects the brain.'

    UNION ALL SELECT 'Skeletal System',
        'Which is the longest bone in the human body?',
        'Femur', 'Humerus', 'Tibia', 'Radius',
        'A', 'The femur, located in the thigh, is the longest bone in the body.'

    UNION ALL SELECT 'Skeletal System',
        'Which mineral is important for strong bones?',
        'Iron', 'Calcium', 'Sodium', 'Iodine',
        'B', 'Calcium is a major mineral component of bones.'

    UNION ALL SELECT 'Cardiovascular System',
        'What is the main function of the heart?',
        'Filter urine', 'Produce bile', 'Pump blood', 'Digest proteins',
        'C', 'The heart pumps blood through the pulmonary and systemic circulations.'

    UNION ALL SELECT 'Cardiovascular System',
        'Which blood vessels carry blood away from the heart?',
        'Arteries', 'Veins', 'Capillaries', 'Lymph vessels',
        'A', 'Arteries carry blood away from the heart.'

    UNION ALL SELECT 'Cardiovascular System',
        'Which chamber pumps blood to the lungs?',
        'Left atrium', 'Left ventricle', 'Right atrium', 'Right ventricle',
        'D', 'The right ventricle pumps blood to the lungs through the pulmonary arteries.'

    UNION ALL SELECT 'Cardiovascular System',
        'What is the main function of red blood cells?',
        'Fight all infections directly', 'Transport oxygen', 'Produce hormones', 'Digest fats',
        'B', 'Red blood cells contain haemoglobin, which transports oxygen.'

    UNION ALL SELECT 'Cardiovascular System',
        'Where does exchange of gases and nutrients mainly occur?',
        'Large arteries', 'Heart valves', 'Capillaries', 'Large veins',
        'C', 'Thin capillary walls allow substances to move between blood and tissues.'

    UNION ALL SELECT 'Nervous System',
        'What is the basic functional cell of the nervous system?',
        'Neuron', 'Osteocyte', 'Red blood cell', 'Platelet',
        'A', 'Neurons transmit electrical and chemical signals.'

    UNION ALL SELECT 'Nervous System',
        'Which structures make up the central nervous system?',
        'Nerves and muscles', 'Brain and spinal cord', 'Heart and brain', 'Brain and glands',
        'B', 'The central nervous system consists of the brain and spinal cord.'

    UNION ALL SELECT 'Nervous System',
        'Which part of the brain helps coordinate balance and movement?',
        'Hypothalamus', 'Medulla', 'Cerebellum', 'Thalamus',
        'C', 'The cerebellum plays an important role in coordination, balance, and motor control.'

    UNION ALL SELECT 'Nervous System',
        'Which cells support and protect neurons?',
        'Osteoblasts', 'Erythrocytes', 'Chondrocytes', 'Glial cells',
        'D', 'Glial cells support, protect, and help maintain the nervous system.'

    UNION ALL SELECT 'Nervous System',
        'Which structure carries signals away from a neuron cell body?',
        'Axon', 'Dendrite', 'Synapse', 'Nucleus only',
        'A', 'An axon carries signals away from the neuron cell body toward its targets.'

    UNION ALL SELECT 'Muscular System',
        'Which type of muscle is usually under voluntary control?',
        'Smooth muscle', 'Skeletal muscle', 'Cardiac muscle', 'All muscle types',
        'B', 'Skeletal muscles are generally under voluntary control.'

    UNION ALL SELECT 'Muscular System',
        'Where is cardiac muscle found?',
        'Stomach', 'Biceps', 'Heart', 'Bladder',
        'C', 'Cardiac muscle forms the muscular wall of the heart.'

    UNION ALL SELECT 'Muscular System',
        'Which type of muscle is found in the walls of many internal organs?',
        'Skeletal muscle', 'Cardiac muscle', 'Tendon tissue', 'Smooth muscle',
        'D', 'Smooth muscle is found in structures such as the intestines and blood vessels.'

    UNION ALL SELECT 'Muscular System',
        'What connects a skeletal muscle to a bone?',
        'Tendon', 'Ligament', 'Cartilage', 'Nerve cell',
        'A', 'Tendons connect muscles to bones; ligaments connect bones to other bones.'

    UNION ALL SELECT 'Muscular System',
        'What is the main role of the muscular system in movement?',
        'Produce red blood cells', 'Contract to generate force', 'Filter blood', 'Store oxygen only',
        'B', 'Muscle contraction generates force to move body parts and support posture.'
) AS q
    ON bs.SystemName = q.SystemName
WHERE NOT EXISTS (
    SELECT 1
    FROM Questions existing
    WHERE existing.SystemID = bs.SystemID
      AND existing.QuestionText = q.QuestionText
);

-- =========================================
-- INSERT FLASHCARDS    
-- =========================================

-- 1. Skeletal System
INSERT INTO [dbo].[Flashcards]
    ([SystemID], [QuestionText], [AnswerText], [DisplayOrder], [IsActive])
VALUES
    (1, N'What is the main function of the skull?',
        N'The skull protects the brain and supports the structures of the face.',
        1, 1),

    (1, N'How many bones are in the adult human skeleton?',
        N'The typical adult human skeleton contains 206 bones.',
        2, 1),

    (1, N'What connects one bone to another?',
        N'Ligaments connect bones to other bones and help stabilise joints.',
        3, 1),

    (1, N'What is the function of cartilage in a joint?',
        N'Cartilage reduces friction and helps cushion the ends of bones.',
        4, 1),

    (1, N'What is the function of bone marrow?',
        N'Red bone marrow produces blood cells.',
        5, 1),

    (1, N'What connects muscles to bones?',
        N'Tendons attach muscles to bones and help produce movement.',
        6, 1);

-- 2. Cardiovascular System
INSERT INTO [dbo].[Flashcards]
    (SystemID, QuestionText, AnswerText, DisplayOrder, IsActive)
VALUES
    (2, 'What is the main function of the cardiovascular system?',
        'It transports oxygen, nutrients, hormones, and waste products throughout the body.',
        1, 1),

    (2, 'What are the four chambers of the heart?',
        'The right atrium, right ventricle, left atrium, and left ventricle.',
        2, 1),

    (2, 'Which blood vessels carry blood away from the heart?',
        'Arteries carry blood away from the heart.',
        3, 1),

    (2, 'Which blood vessels carry blood back to the heart?',
        'Veins carry blood back to the heart.',
        4, 1),

    (2, 'What is the function of red blood cells?',
        'They transport oxygen using haemoglobin.',
        5, 1),

    (2, 'What is the function of heart valves?',
        'They prevent the backward flow of blood through the heart.',
        6, 1);

-- 3. Nervous System
INSERT INTO [dbo].[Flashcards]
    (SystemID, QuestionText, AnswerText, DisplayOrder, IsActive)
VALUES
    (3, 'What is the main function of the nervous system?',
        'It receives and processes information and coordinates the body responses.',
        1, 1),

    (3, 'What are the two main parts of the nervous system?',
        'The central nervous system and the peripheral nervous system.',
        2, 1),

    (3, 'What organs make up the central nervous system?',
        'The brain and spinal cord.',
        3, 1),

    (3, 'What is the basic functional unit of the nervous system?',
        'The neuron, a specialised cell that transmits nerve signals.',
        4, 1),

    (3, 'What is the function of the spinal cord?',
        'It transmits signals between the brain and body and coordinates some reflexes.',
        5, 1),

    (3, 'What is a synapse?',
        'A junction where a neuron communicates with another cell.',
        6, 1);

-- 4. Muscular System
INSERT INTO [dbo].[Flashcards]
    (SystemID, QuestionText, AnswerText, DisplayOrder, IsActive)
VALUES
    (4, 'What is the main function of the muscular system?',
        'It enables movement, maintains posture, and produces body heat.',
        1, 1),

    (4, 'What are the three types of muscle tissue?',
        'Skeletal muscle, smooth muscle, and cardiac muscle.',
        2, 1),

    (4, 'Which type of muscle is under voluntary control?',
        'Skeletal muscle is generally under voluntary control.',
        3, 1),

    (4, 'What is the function of cardiac muscle?',
        'It contracts rhythmically to pump blood through the heart.',
        4, 1),

    (4, 'What connects muscles to bones?',
        'Tendons attach muscles to bones.',
        5, 1),

    (4, 'What is the function of smooth muscle?',
        'It moves substances through internal organs, such as food through the digestive tract.',
        6, 1);