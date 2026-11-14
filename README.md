# AnatoXplore

AnatoXplore is an anatomy learning website. Students explore interactive 3D models of the human body, take quizzes to earn XP, compete on a leaderboard, ask questions in a discussion forum, and chat with an AI assistant.

Group project for **CT050-3-2 Web Applications (WAPP)** at Asia Pacific University (APU), 2026.

**Live Demo:** [anatoxplore.runasp.net](http://anatoxplore.runasp.net/Default.aspx)
*(Free hosting. The AI chat is not available on the live version.)*

## Features

- **3D anatomy models**: Skeletal, Muscular, Nervous and Cardiovascular systems, built with Three.js
- **Quizzes and XP**: students earn XP and level up as they learn
- **Leaderboard**: top 10 students ranked by XP, with a podium for the top 3
- **Discussion forum**: create, edit and delete posts, reply, search, filter by topic and sort
- **Feedback**: users and guests can send feedback to the admin
- **AI assistant**: anatomy chat powered by Google Gemini
- **Admin dashboard**: manage users, learning content, discussions and feedback
- **Security**: SHA-256 password hashing, parameterized SQL queries, HTML encoding, and client-side and server-side validation

## Screenshots

### Home
<img width="1917" height="1007" alt="image" src="https://github.com/user-attachments/assets/0c819753-087d-422c-a050-a11f5725e6a1" />

### Body Systems
<img width="1881" height="982" alt="image" src="https://github.com/user-attachments/assets/57ab5535-5f06-4506-a1c5-0160b3f02be6" />

### 3D Anatomy Model
<img width="1916" height="995" alt="image" src="https://github.com/user-attachments/assets/91f4685f-18b0-4284-b39b-4800e4ceb5b5" />


### Quiz
<img width="1917" height="1017" alt="image" src="https://github.com/user-attachments/assets/624ab2b3-4f65-4a97-b0b7-4fba95b181d2" />

### Student Dashboard
<img width="1912" height="973" alt="image" src="https://github.com/user-attachments/assets/382c69b5-9ffe-4e77-90db-ad3456c6547b" />

### Leaderboard
<img width="1892" height="997" alt="image" src="https://github.com/user-attachments/assets/81221ab6-4f1a-4100-aafe-f7e2031ef1ca" />

### Discussion Forum
<img width="1897" height="976" alt="image" src="https://github.com/user-attachments/assets/f63fb0ef-36ae-4907-b673-e310fa1673b5" />

## Tech Stack

- ASP.NET Web Forms (.NET Framework 4.7.2), C#
- Microsoft SQL Server (LocalDB)
- HTML, CSS, JavaScript, Bootstrap
- Three.js for the 3D models
- Google Gemini API

## How to Run

1. Clone the repository and open `AnatoXplore.slnx` in Visual Studio 2022 or later.
2. Restore the NuGet packages (right-click the solution, then **Restore NuGet Packages**).
3. Create the database `AnatoXploreDB.mdf` in `App_Data` and run the scripts in `App_Data/Database` (Schema first, then Migrations).
4. (Optional) To use the AI chat, set the environment variable `GEMINI_API_KEY` to your own Google AI Studio key.
5. Press **F5** to run.

## Team

Developed by Group 7, APU.
