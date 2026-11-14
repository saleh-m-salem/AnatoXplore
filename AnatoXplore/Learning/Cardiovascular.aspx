
<%@ Page Title="Cardiovascular System | AnatoXplore" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cardiovascular.aspx.cs" Inherits="AnatoXplore.Learning.Cardiovascular" %>

<asp:Content ID="CardiovascularContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .lesson-page {
        --navy: #12365b;
        --blue: #1688e8;
        --light-blue: #eaf4ff;
        --text: #243b53;
        --muted: #718198;
        color: var(--text);
        font-family: "Segoe UI", Arial, sans-serif;
        width: 100%;
        max-width: 1440px;
        margin: 0 auto;
        padding: 28px 24px 35px;
    }

    .lesson-page * {
        box-sizing: border-box;
    }

    .lesson-page button,
    .lesson-page input {
        font: inherit;
    }

    .lesson-heading {
        margin: 10px 0 22px;
    }

    .lesson-heading h1 {
        color: var(--navy);
        font-size: 30px;
        margin: 0 0 7px;
    }

    .lesson-heading p {
        color: var(--muted);
        margin: 0;
        line-height: 1.6;
    }

    .lesson-layout {
        display: grid;
        grid-template-columns: 205px minmax(0, 1fr);
        gap: 24px;
        align-items: start;
    }

    /* LEFT SIDEBAR */
    .lesson-sidebar {
        background: #fff;
        border: 1px solid #e2eaf3;
        border-radius: 14px;
        padding: 12px;
        position: sticky;
        top: 15px;
    }

    .lesson-tab {
        display: flex;
        align-items: center;
        gap: 12px;
        width: 100%;
        padding: 13px 12px;
        margin: 3px 0;
        border: 0;
        border-radius: 9px;
        background: transparent;
        color: #526780;
        text-align: left;
        cursor: pointer;
        font-size: 14px;
        transition: background .2s, color .2s;
    }

    .lesson-tab:hover {
        background: #f1f7ff;
        color: var(--navy);
    }

    .lesson-tab.active {
        background: #e5f1ff;
        color: #0876d1;
        font-weight: 700;
    }

    .lesson-tab-icon {
        width: 22px;
        text-align: center;
        font-size: 17px;
    }

    /* MAIN CONTENT */
    .lesson-main {
        min-width: 0;
    }

    .lesson-panel {
        display: none;
        animation: lessonFadeIn .2s ease;
    }

    .lesson-panel.active {
        display: block;
    }

    @keyframes lessonFadeIn {
        from { opacity: .55; transform: translateY(3px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .lesson-panel-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        gap: 18px;
        margin-bottom: 22px;
    }

    .lesson-panel-header h2 {
        color: var(--navy);
        font-size: 27px;
        margin: 0 0 9px;
    }

    .lesson-panel-header p {
        color: #657991;
        line-height: 1.7;
        margin: 0;
        max-width: 690px;
    }

    .lesson-card {
        background: #fff;
        border: 1px solid #e3ebf4;
        border-radius: 14px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 4px 15px rgba(24, 57, 90, .035);
    }

    .lesson-card h3 {
        color: var(--navy);
        font-size: 18px;
        margin: 0 0 12px;
    }

    .lesson-card p {
        color: #64778c;
        line-height: 1.7;
    }

    /* RESERVED ANATOMY VIEWER */
    .lesson-anatomy-viewer {
        min-height: 340px;
        border: 2px dashed #b8cce2;
        border-radius: 13px;
        background: linear-gradient(145deg, #f7fbff, #edf5ff);
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: 28px;
        margin-bottom: 20px;
    }

    .lesson-viewer-icon {
        font-size: 52px;
        margin-bottom: 15px;
    }

    .lesson-anatomy-viewer h3 {
        color: var(--navy);
        margin: 0 0 10px;
        font-size: 20px;
    }

    .lesson-anatomy-viewer p {
        max-width: 450px;
        color: var(--muted);
        line-height: 1.7;
        margin: 0;
    }

    .lesson-viewer-label {
        display: inline-block;
        background: #dceeff;
        color: #176fc1;
        border-radius: 20px;
        padding: 6px 12px;
        margin-top: 16px;
        font-size: 12px;
        font-weight: 700;
    }

    /* KEY FUNCTIONS */
    .lesson-function-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 12px;
    }

    .lesson-function {
        background: #f5f9ff;
        border: 1px solid #e6effa;
        padding: 15px;
        border-radius: 10px;
    }

    .lesson-function strong {
        display: block;
        color: var(--navy);
        margin-bottom: 5px;
    }

    .lesson-function span {
        color: #6b7d91;
        font-size: 14px;
        line-height: 1.5;
    }

    .lesson-system-introduction p,
    .lesson-system-introduction li {
        color: #64778c;
        font-weight: 400;
        line-height: 1.7;
    }

    .lesson-system-introduction p { margin: 0 0 14px; }
    .lesson-system-introduction ul { padding-left: 24px; margin: 0; }
    .lesson-system-introduction li { margin-bottom: 10px; padding-left: 4px; }
    .lesson-system-introduction li:last-child { margin-bottom: 0; }
    .lesson-system-introduction strong { font-weight: 400; }

    .lesson-publications-placeholder {
        padding: 24px;
        margin-top: 16px;
        text-align: center;
        background: #f5f9ff;
        border: 1px dashed #b8cce2;
        border-radius: 12px;
    }

    .lesson-publications-placeholder h4 {
        color: #12365b;
        font-size: 17px;
        margin: 0 0 8px;
    }

    .lesson-publications-placeholder p {
        color: #718198;
        line-height: 1.7;
        margin: 0;
    }
    .lesson-publication-message {
    display: block;
    margin-top: 16px;
    color: #718198;
    line-height: 1.6;
}

.lesson-publication-list {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 16px;
    margin-top: 18px;
}

.lesson-publication-item {
    padding: 20px;
    background: #f8faff;
    border: 1px solid #dce7f5;
    border-radius: 12px;
}

.lesson-publication-item h4 {
    margin: 0 0 12px;
    font-size: 17px;
    line-height: 1.5;
}

.lesson-publication-item h4 a {
    color: #12365b;
    text-decoration: none;
}

.lesson-publication-item h4 a:hover {
    color: #1688e8;
}

.lesson-publication-meta {
    margin: 6px 0;
    color: #718198;
    font-size: 13px;
    line-height: 1.6;
}

.lesson-publication-abstract {
    margin: 14px 0;
    color: #52677e;
    font-size: 14px;
    line-height: 1.7;
}

.lesson-publication-link {
    display: inline-block;
    margin-top: 6px;
    color: #1675cf;
    font-weight: 600;
    font-size: 14px;
    text-decoration: none;
}

@media (max-width: 768px) {
    .lesson-publication-list {
        grid-template-columns: 1fr;
    }
}

    /* STRUCTURE CATEGORIES AND BONE LISTS */
    .lesson-category-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px;
    }

    .lesson-category {
        background: #fff;
        border: 1px solid #e0eaf4;
        border-radius: 12px;
        padding: 20px;
    }

    .lesson-category > .lesson-number {
        display: inline-flex;
        width: 34px;
        height: 34px;
        align-items: center;
        justify-content: center;
        background: #e5f1ff;
        color: #0876d1;
        border-radius: 9px;
        font-weight: 700;
        margin-bottom: 10px;
    }
        .lesson-category h3 {
        color: var(--navy);
        font-size: 17px;
        margin: 0 0 8px;
    }

    .lesson-category > p {
        color: #657991;
        font-size: 14px;
        line-height: 1.65;
        margin: 0 0 14px;
    }

    .lesson-bone-list {
        display: flex;
        flex-direction: column;
        gap: 7px;
    }

    .lesson-structure-item {
        display: flex;
        align-items: center;
        gap: 10px;
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #e4edf7;
        border-radius: 8px;
        background: #f8fbff;
        color: #344f6b;
        text-align: left;
        cursor: pointer;
        font-size: 14px;
        transition: background .2s, border-color .2s;
    }

    .lesson-structure-item span {
        color: #176fc1;
        font-weight: 700;
        font-size: 12px;
        min-width: 32px;
    }

    .lesson-structure-item:hover,
    .lesson-structure-item:focus-visible {
        background: #eaf4ff;
        border-color: #91bdf2;
        outline: none;
    }

    /* STRUCTURES */
    .lesson-structure-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 15px;
    }

    .lesson-structure {
        display: block;
        width: 100%;
        font: inherit;
        text-align: left;
        color: inherit;
        cursor: pointer;
        background: #fff;
        border: 1px solid #e0eaf4;
        border-radius: 12px;
        padding: 18px;
        transition: border-color .2s, box-shadow .2s, transform .2s;
    }

    .lesson-structure:hover,
    .lesson-structure:focus-visible {
        border-color: #8bb8ef;
        box-shadow: 0 6px 18px rgba(24, 57, 90, .08);
        transform: translateY(-2px);
        outline: none;
    }

    .lesson-lesson-back {
        margin-bottom: 18px;
    }

    .lesson-lesson-image-placeholder {
        display: flex;
        min-height: 220px;
        align-items: center;
        justify-content: center;
        flex-direction: column;
        padding: 24px;
        margin-bottom: 20px;
        text-align: center;
        background: linear-gradient(145deg, #f7fbff, #edf5ff);
        border: 1px dashed #b8cce2;
        border-radius: 13px;
    }

    .lesson-lesson-image-placeholder .lesson-viewer-icon {
        font-size: 46px;
    }

    .lesson-reference-figure { display:none; width:min(100%,560px); margin:0 auto 12px; }
    .lesson-reference-figure img { display:block; max-width:100%; max-height:420px; width:auto; height:auto; margin:0 auto; object-fit:contain; border-radius:10px; background:#fff; }
    .lesson-reference-figure figcaption { margin-top:8px; color:#60768d; font-size:12px; }
    .lesson-reference-figure a { color:#1265a6; }

    .lesson-lesson-columns {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 15px;
    }

    .lesson-lesson-detail {
        padding: 16px;
        background: #f5f9ff;
        border: 1px solid #e6effa;
        border-radius: 10px;
    }

    .lesson-lesson-detail h3 {
        margin-bottom: 8px;
    }

    .lesson-lesson-detail p,
    .lesson-lesson-detail ul {
        margin-bottom: 0;
    }

    @media (max-width: 760px) {
        .lesson-page {
            padding: 20px 14px 30px;
        }

        .lesson-lesson-columns {
            grid-template-columns: 1fr;
        }
    }

    .lesson-structure .lesson-number {
        display: inline-flex;
        width: 32px;
        height: 32px;
        align-items: center;
        justify-content: center;
        background: #e5f1ff;
        color: #0876d1;
        border-radius: 9px;
        font-weight: 700;
        margin-bottom: 10px;
    }

    .lesson-structure h3 {
        color: var(--navy);
        font-size: 17px;
        margin: 0 0 8px;
    }

    .lesson-structure p {
        color: #657991;
        font-size: 14px;
        line-height: 1.65;
        margin: 0;
    }

    /* VIDEO */
    .lesson-video-frame {
        width: 100%;
        aspect-ratio: 16 / 9;
        border: 0;
        border-radius: 12px;
        background: #102b48;
    }

    .lesson-video-note {
        color: var(--muted);
        font-size: 13px;
        line-height: 1.6;
        margin-top: 12px;
    }

    .lesson-primary-btn,
    .lesson-secondary-btn {
        display: inline-block;
        border-radius: 8px;
        padding: 11px 17px;
        border: 1px solid var(--blue);
        cursor: pointer;
        font-weight: 650;
        text-decoration: none;
    }

    .lesson-primary-btn {
        color: #fff;
        background: var(--blue);
    }

    .lesson-primary-btn:hover {
        background: #0874cb;
        color: #fff;
    }

    .lesson-secondary-btn {
        background: #fff;
        color: #176fc1;
    }

    .lesson-button-row {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        margin-top: 18px;
    }

    /* FLASHCARDS */
    .lesson-flashcard {
        max-width: 600px;
        min-height: 235px;
        margin: 0 auto;
        padding: 30px;
        border: 1px solid #dbe8f7;
        border-radius: 16px;
        background: linear-gradient(145deg, #f4f9ff, #e7f2ff);
        text-align: center;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    .lesson-flashcard small {
        color: #718198;
        text-transform: uppercase;
        letter-spacing: 1px;
        margin-bottom: 14px;
    }

    .lesson-flashcard h3 {
        color: var(--navy);
        font-size: 24px;
        margin: 0 0 15px;
    }

    .lesson-flashcard p {
        color: #536981;
        line-height: 1.7;
        margin: 0;
    }

    .lesson-flash-count {
        text-align: center;
        color: var(--muted);
        font-size: 13px;
        margin-top: 12px;
    }

    /* QUIZ */
    .lesson-question {
        border: 1px solid #e2eaf3;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 16px;
        background: #fff;
    }

    .lesson-question h3 {
        color: var(--navy);
        font-size: 17px;
        margin: 0 0 15px;
        line-height: 1.5;
    }

    .lesson-answer {
        display: flex;
        gap: 10px;
        align-items: flex-start;
        padding: 11px;
        border: 1px solid #e4ebf3;
        border-radius: 8px;
        margin: 8px 0;
        cursor: pointer;
        line-height: 1.5;
    }

    .lesson-answer:hover {
        background: #f4f9ff;
    }

    .lesson-answer input {
        margin-top: 4px;
    }
    .lesson-answer input[type="radio"] {
    accent-color: #60a5fa;
    cursor: pointer;
}

    .lesson-feedback {
        display: none;
        margin-top: 16px;
        padding: 15px;
        border-radius: 9px;
        line-height: 1.6;
    }

    .lesson-feedback.visible {
        display: block;
    }

    .lesson-feedback.success {
        background: #e5f8ed;
        color: #17683b;
    }

    .lesson-feedback.review {
        background: #fff3df;
        color: #805313;
    }

    .lesson-progress-track {
        height: 8px;
        background: #e8eff7;
        border-radius: 20px;
        overflow: hidden;
        margin: 12px 0 20px;
    }

    .lesson-progress-fill {
        height: 100%;
        width: 0;
        background: #1688e8;
        transition: width .2s;
    }

    .lesson-muted {
        color: var(--muted);
        font-size: 13px;
        line-height: 1.6;
    }

    @media (max-width: 760px) {
        .lesson-layout {
            grid-template-columns: 1fr;
            gap: 18px;
        }

        .lesson-sidebar {
            position: static;
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 4px;
        }

        .lesson-tab {
            justify-content: center;
            flex-direction: column;
            text-align: center;
            padding: 10px 4px;
            gap: 5px;
            font-size: 12px;
        }

        .lesson-panel-header {
            flex-direction: column;
        }

        .lesson-function-grid,
        .lesson-category-grid,
        .lesson-structure-grid {
            grid-template-columns: 1fr;
        }

        .lesson-heading h1 {
            font-size: 26px;
        }
    }
     /* GAMING QUIZ THEME */
.lesson-page.lesson-gaming-mode {
    --text: #f0edff;
    --muted: #C0D8ED;
    color: #f0edff;
    background: radial-gradient(
        ellipse at top left,
        #102F50 0%,
        #12365b 48%,
        #071a2e 100%
    );
    transition: background .25s ease;
    width: 100%;
    max-width: none;
    margin-left: 0;
    margin-right: 0;
    box-sizing: border-box;
}
.lesson-page.lesson-gaming-mode .lesson-layout {
    min-width: 0;
}

.lesson-page.lesson-gaming-mode .lesson-main {
    min-width: 0;
}

.lesson-gaming-mode .lesson-heading h1,
.lesson-gaming-mode .lesson-panel-header h2 {
    color: #F0F7FF;
}

.lesson-gaming-mode .lesson-heading p,
.lesson-gaming-mode .lesson-panel-header p {
    color: #C0D8ED;
}

.lesson-gaming-mode .lesson-sidebar,
.lesson-gaming-mode .lesson-card,
.lesson-gaming-mode .lesson-question {
    background: #102F50;
    border-color: #24618C;
    color: #F0F7FF;
}

.lesson-gaming-mode .lesson-tab {
    color: #C0D8ED;
}

.lesson-gaming-mode .lesson-tab.active {
    color: #fff;
    background: linear-gradient(100deg, #168FE5, #0867B0);
}

.lesson-gaming-mode .lesson-question h3 {
    color: #F0F7FF;
}

.lesson-gaming-mode .lesson-answer {
    color: #C0D8ED;
    background: #0b2742;
    border-color: #24618C;
}

.lesson-gaming-mode .lesson-answer:hover {
    background: #102F50;
    border-color: #168FE5;
}

.lesson-gaming-mode .lesson-primary-btn {
    color: #fff;
    background: linear-gradient(100deg, #168FE5, #0867B0);
    border-color: #168FE5;
}

.lesson-gaming-mode .lesson-progress-track {
    background: #244563;
}

.lesson-gaming-mode .lesson-progress-fill {
    background: linear-gradient(90deg, #168FE5, #8ACBFF);
}

.lesson-quiz-status {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 12px;
    color: #C0D8ED;
}

.lesson-quiz-timer {
    display: inline-block;
    padding: 8px 14px;
    border-radius: 20px;
    background: #102F50;
    border: 1px solid #168FE5;
    color: #fff;
    font-weight: 700;
}

.lesson-quiz-timer.warning {
    background: #7f1d1d;
    border-color: #f87171;
}

.lesson-quiz-result {
    color: #F0F7FF;
    margin-top: 14px;
    line-height: 1.6;
}

.lesson-result-actions input[id$="btnTryAgain"],
.lesson-result-actions input[id$="btnFinishQuiz"] { background-repeat: no-repeat; background-position: 16px center; background-size: 18px 18px; padding-left: 44px; }
.lesson-result-actions input[id$="btnTryAgain"] { background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23fff' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='M20 7v5h-5'/%3E%3Cpath d='M19 12a7 7 0 1 0 1.5 4.5'/%3E%3C/svg%3E"); }
.lesson-result-actions input[id$="btnFinishQuiz"] { background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%230f3153' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpath d='m5 12 4 4L19 6'/%3E%3C/svg%3E"); }
.lesson-question.lesson-question-hidden {
    display: none;
}   

    .lesson-gaming-mode .lesson-answer:has(input[type="radio"]:checked) {
    background: #1e355e;
    border-color: #60a5fa;
    color: #eff6ff;
}

    .lesson-quiz-result h2 {
        color: #F0F7FF;
        margin-top: 0;
    }

    .lesson-quiz-result p {
        color: #C0D8ED;
        font-size: 16px;
    }

    .lesson-quiz-result .lesson-muted {
        display: block;
        margin-top: 12px;
    }

    .lesson-gaming-mode .lesson-quiz-result {
        background: #102F50;
        border-color: #24618C;
    }

    .lesson-gaming-mode .lesson-quiz-result .lesson-secondary-btn {
        background: #102F50;
        color: #fff;
        border-color: #168FE5;
    }


    /* POLISHED QUIZ RESULTS */
    .lesson-quiz-result {
        padding: clamp(22px, 4vw, 42px);
    }

    .lesson-result-heading {
        text-align: center;
        margin-bottom: 30px;
    }

    .lesson-result-eyebrow {
        display: inline-block;
        color: #8ACBFF;
        font-size: 11px;
        font-weight: 800;
        letter-spacing: 2px;
        margin-bottom: 10px;
    }

    .lesson-result-heading h2 {
        color: #FFFFFF;
        font-size: clamp(26px, 3vw, 36px);
        margin: 0 0 8px;
    }

    .lesson-result-subtitle {
        color: #C0D8ED !important;
        margin: 0;
        font-size: 14px;
    }

    .lesson-result-overview {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: clamp(24px, 5vw, 55px);
        padding: 26px;
        margin-bottom: 24px;
        border: 1px solid #24618C;
        border-radius: 20px;
        background: linear-gradient(120deg, rgba(22,143,229,.13), rgba(8,103,176,.06));
    }

    .lesson-result-ring {
        --score: 0%;
        width: 168px;
        height: 168px;
        flex: 0 0 168px;
        display: grid;
        place-items: center;
        border-radius: 50%;
        background: conic-gradient(from -90deg, #168FE5 0 var(--score), #244563 var(--score) 100%);
        box-shadow: 0 0 35px rgba(22,143,229,.18);
        position: relative;
    }

    .lesson-result-ring::before {
        content: "";
        position: absolute;
        inset: 10px;
        border-radius: 50%;
        background: #102F50;
        border: 1px solid rgba(138,203,255,.18);
    }

    .lesson-result-ring-inner {
        z-index: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 2px;
    }

    .lesson-result-percent {
        color: #fff;
        font-size: 36px;
        font-weight: 800;
        line-height: 1.15;
    }

    .lesson-result-ring-inner span {
        color: #C0D8ED;
        font-size: 12px;
        letter-spacing: .5px;
    }

    .lesson-result-message {
        max-width: 400px;
    }

    .lesson-result-pill {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        padding: 7px 11px;
        border-radius: 999px;
        background: rgba(22,143,229,.14);
        border: 1px solid rgba(22,143,229,.35);
        color: #C0D8ED;
        font-size: 12px;
        font-weight: 700;
    }

    .lesson-result-dot {
        width: 7px;
        height: 7px;
        border-radius: 50%;
        background: #168FE5;
        box-shadow: 0 0 8px #168FE5;
    }

    .lesson-result-message h3 {
        color: #fff;
        font-size: 26px;
        margin: 13px 0 8px;
    }

    .lesson-result-message p {
        color: #C0D8ED;
        margin: 7px 0;
        line-height: 1.6;
    }

    .lesson-result-message strong {
        color: #8ACBFF;
    }

    .lesson-result-message .lesson-result-small {
        color: #aaa4cc;
        font-size: 13px;
        margin-top: 12px;
    }

    .lesson-result-stats {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 12px;
        margin: 0 0 22px;
    }

    .lesson-result-stat {
        min-width: 0;
        padding: 18px 15px;
        border: 1px solid #24618C;
        border-radius: 15px;
        background: #211d42;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        gap: 7px;
    }

    .lesson-stat-icon {
        width: 35px;
        height: 35px;
        border-radius: 11px;
        display: grid;
        place-items: center;
        font-size: 17px;
        font-weight: 800;
        margin-bottom: 4px;
    }

    .lesson-stat-purple { background: #183D5E; color: #8ACBFF; }
    .lesson-stat-blue { background: #183D5E; color: #8ACBFF; }
    .lesson-stat-green { background: #16483f; color: #86efac; }
    .lesson-stat-pink { background: #183D5E; color: #8ACBFF; }

    .lesson-stat-label {
        color: #C0D8ED;
        font-size: 12px;
        line-height: 1.4;
    }

    .lesson-result-stat strong {
        color: #fff;
        font-size: 27px;
        line-height: 1.2;
        overflow-wrap: anywhere;
    }

    .lesson-result-stat small {
        color: #9189b6;
        font-size: 11px;
    }

    .lesson-result-xp-breakdown {
        padding: 20px;
        border-radius: 15px;
        border: 1px solid #24618C;
        background: rgba(15, 13, 35, .4);
    }

    .lesson-xp-breakdown-top,
    .lesson-xp-legend {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 12px;
        flex-wrap: wrap;
    }

    .lesson-xp-breakdown-top {
        color: #dcd6fa;
        font-size: 13px;
        margin-bottom: 14px;
    }

    .lesson-xp-breakdown-top strong {
        color: #fff;
        font-size: 17px;
    }

    .lesson-xp-bar {
        height: 10px;
        display: flex;
        overflow: hidden;
        border-radius: 99px;
        background: #244563;
        margin-bottom: 13px;
    }

    .lesson-xp-base {
        width: 0;
        background: linear-gradient(90deg, #168FE5, #168FE5);
    }

    .lesson-xp-speed {
        width: 0;
        background: linear-gradient(90deg, #34d399, #86efac);
    }

    .lesson-xp-legend {
        color: #C0D8ED;
        font-size: 12px;
    }

    .lesson-xp-legend span {
        display: inline-flex;
        align-items: center;
        gap: 7px;
    }

    .lesson-legend-dot {
        width: 8px;
        height: 8px;
        display: inline-block;
        border-radius: 50%;
    }

    .lesson-legend-base { background: #168FE5; }
    .lesson-legend-speed { background: #4ade80; }

    .lesson-result-save-message {
        display: block;
        margin-top: 18px;
        color: #8ACBFF;
        font-size: 13px;
        line-height: 1.6;
    }

    .lesson-result-actions {
        justify-content: center;
        margin-top: 24px;
    }

    .lesson-result-actions input {
        min-width: 145px;
        padding: 13px 20px;
        border-radius: 11px;
    }

    @media (max-width: 850px) {
        .lesson-result-stats { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    }

    @media (max-width: 560px) {
        .lesson-result-overview { flex-direction: column; text-align: center; }
        .lesson-result-message { max-width: none; }
        .lesson-result-ring { width: 145px; height: 145px; flex-basis: 145px; }
        .lesson-result-percent { font-size: 31px; }
        .lesson-result-stats { gap: 9px; }
        .lesson-result-stat { padding: 14px 12px; }
        .lesson-result-stat strong { font-size: 23px; }
        .lesson-xp-legend { flex-direction: column; align-items: flex-start; }
    }
    html,
body {
    margin: 0;
    min-height: 100%;
}

.lesson-page {
    margin-bottom: 0;
}

#MainContent {
    padding-bottom: 0;
}

    /* Compact interactive model in the two existing cardiovascular visualisation spaces. */
.lesson-anatomy-viewer.lesson-model-slot { display:block; min-height:0; padding:0; overflow:hidden; text-align:left; border:1px solid #d8e5f2; background:#fff; }
.lesson-model-shell { width:100%; overflow:hidden; border-radius:11px; color:#243b53; background:#fff; }
.lesson-model-toolbar { display:flex; align-items:center; justify-content:space-between; gap:12px; padding:11px 14px; border-bottom:1px solid #e3ebf4; }
.lesson-model-toolbar strong { color:#12365b; font-size:14px; }
.lesson-model-actions { display:flex; gap:8px; }
.lesson-model-button { border:1px solid #c8d8e9; border-radius:7px; padding:7px 10px; color:#24577f; background:#fff; cursor:pointer; font-size:13px; }
.lesson-model-button:hover { background:#f1f7ff; }
#cardiovascularViewerCanvas { position:relative; width:100%; height:440px; min-height:340px; overflow:hidden; background:#d8e3ed; touch-action:none; }
#cardiovascularViewerCanvas canvas { display:block; width:100%; height:100%; outline:none; }
#cardiovascularViewerStatus { position:absolute; inset:0; display:flex; align-items:center; justify-content:center; padding:20px; color:#526780; text-align:center; font-size:14px; }
#cardiovascularViewerStatus.lesson-error { color:#9b3333; }
.lesson-model-footer { display:flex; flex-wrap:wrap; justify-content:space-between; gap:8px 16px; padding:10px 14px; color:#667b91; font-size:12px; line-height:1.5; }
#cardiovascularSelectedName { color:#244a70; font-weight:600; }
@media (max-width:560px) {
    .lesson-model-toolbar { align-items:flex-start; flex-direction:column; }
    #cardiovascularViewerCanvas { height:370px; min-height:300px; }
}
<!-- id="lesson-model-fullscreen-filters-css" -->
/* Part filters and true viewport-filling fullscreen layout for the cardiovascular viewer. */
.lesson-model-toolbar { flex-wrap:wrap; }
.lesson-model-filters { display:flex; flex-wrap:wrap; align-items:center; gap:8px 13px; color:#64778c; font-size:12px; }
.lesson-model-filters-label { color:#526780; font-weight:600; }
.lesson-model-filters label { display:inline-flex; align-items:center; gap:5px; cursor:pointer; white-space:nowrap; }
.lesson-model-filters input { margin:0; accent-color:#1688e8; }
.lesson-model-actions { margin-left:auto; }
#cardiovascularModelViewer:fullscreen {
    position:fixed;
    inset:0;
    display:flex;
    flex-direction:column;
    width:100vw;
    height:100vh;
    height:100dvh;
    max-width:none;
    max-height:none;
    border-radius:0;
    overflow:hidden;
    background:#d8e3ed;
}
#cardiovascularModelViewer:fullscreen .lesson-model-toolbar { flex:0 0 auto; }
#cardiovascularModelViewer:fullscreen #cardiovascularViewerCanvas {
    flex:1 1 auto;
    width:100%;
    height:auto;
    min-height:0;
}
#cardiovascularModelViewer:fullscreen .lesson-model-footer { flex:0 0 auto; background:#fff; }
.lesson-video-placeholder { display:flex; align-items:center; justify-content:center; color:#fff; font-weight:600; text-align:center; }


    /* CARDIOVASCULAR QUIZ INTRO SCREEN */
    .lesson-gaming-mode .lesson-quiz-start {
        padding: 34px 28px;
        text-align: center;
        background: #102F50;
        border: 1px solid #24618C;
        border-radius: 15px;
    }
    .lesson-gaming-mode .lesson-quiz-start-icon {
        width: 58px;
        height: 58px;
        margin: 0 auto 16px;
        display: grid;
        place-items: center;
        border-radius: 16px;
        background: #183D5E;
        color: #8ACBFF;
    }
    .lesson-gaming-mode .lesson-quiz-start h3 {
        color: #FFFFFF;
        font-size: 23px;
        margin: 0 0 10px;
    }
    .lesson-gaming-mode .lesson-quiz-start p {
        color: #C0D8ED;
        max-width: 520px;
        margin: 0 auto 20px;
        line-height: 1.7;
    }
    .lesson-gaming-mode .lesson-quiz-start .lesson-primary-btn {
        min-width: 150px;
    }
    .lesson-gaming-mode .lesson-result-stat .lesson-stat-icon {
        background: #183D5E !important;
        color: #8ACBFF !important;
    }
    .lesson-gaming-mode .lesson-result-actions .lesson-secondary-btn {
        background: linear-gradient(100deg, #168FE5, #0867B0);
        border: 1px solid #168FE5;
        color: #FFFFFF;
    }
    .lesson-gaming-mode .lesson-result-actions .lesson-secondary-btn:hover {
        background: #0867B0;
        border-color: #65C5F5;
        color: #FFFFFF;
    }
    .lesson-gaming-mode .lesson-xp-base,
    .lesson-gaming-mode .lesson-legend-base { background: #168FE5; }
    .lesson-gaming-mode .lesson-xp-speed,
    .lesson-gaming-mode .lesson-legend-speed { background: #8ACBFF; }

    .lesson-gaming-mode .lesson-result-ring {
        background: conic-gradient(from -90deg, #168FE5 0 var(--score), #244563 var(--score) 100%);
        box-shadow: 0 0 35px rgba(22,143,229,.18);
    }
    .lesson-gaming-mode .lesson-result-ring::before {
        background: #102F50;
        border-color: rgba(138,203,255,.18);
    }
    .lesson-gaming-mode .lesson-result-pill {
        background: rgba(22,143,229,.14);
        border-color: rgba(22,143,229,.35);
        color: #C0D8ED;
    }
    .lesson-gaming-mode .lesson-result-overview {
        border-color: #24618C;
        background: linear-gradient(120deg, rgba(22,143,229,.13), rgba(8,103,176,.06));
    }
    .lesson-gaming-mode .lesson-result-xp-breakdown {
        background: #102F50;
        border-color: #24618C;
    }
    .lesson-gaming-mode .lesson-result-stat {
        background: #102F50;
        border-color: #24618C;
    }
    .lesson-gaming-mode .lesson-result-save-message {
        color: #8ACBFF;
    }
    .lesson-gaming-mode .lesson-quiz-timer {
        background: #183D5E;
        border-color: #168FE5;
    }
    .lesson-gaming-mode .lesson-quiz-timer.warning {
        background: #7f1d1d;
        border-color: #f87171;
    }

.lesson-page.lesson-gaming-mode .lesson-result-actions input[id$="btnFinishQuiz"] {
    background-image: none !important; background-color: #168FE5; color: #FFFFFF; border-color: #168FE5; padding-left: 20px !important; transition: background-color .18s ease, border-color .18s ease, transform .18s ease;
}
.lesson-page.lesson-gaming-mode .lesson-result-actions input[id$="btnFinishQuiz"]:hover { background-color: #0867B0; border-color: #65C5F5; transform: translateY(-1px); }
.lesson-page:not(.lesson-gaming-mode) .lesson-result-actions input[id$="btnFinishQuiz"] {
    background-image: none !important; background-color: #E7F1FB; color: #12395F; border-color: #B8D5F1; padding-left: 20px !important; transition: background-color .18s ease, border-color .18s ease, transform .18s ease;
}
.lesson-page:not(.lesson-gaming-mode) .lesson-result-actions input[id$="btnFinishQuiz"]:hover { background-color: #D5E9FA; border-color: #168FE5; transform: translateY(-1px); }
.lesson-page .lesson-result-actions input[id$="btnTryAgain"] { background-color: #168FE5; color: #FFFFFF; border-color: #168FE5; transition: background-color .18s ease, border-color .18s ease, transform .18s ease; }
.lesson-page .lesson-result-actions input[id$="btnTryAgain"]:hover { background-color: #0867B0; border-color: #65C5F5; transform: translateY(-1px); }
</style>

<div class="lesson-page">

    <div class="lesson-heading">
        <h1>Cardiovascular System</h1>
        <p>Explore the heart, blood vessels and structures that transport blood throughout the human body.</p>
    </div>

    <div class="lesson-layout">

        <!-- LEFT SIDEBAR -->
        <aside class="lesson-sidebar" aria-label="Cardiovascular system sections">

            <button type="button" class="lesson-tab active"
                    data-panel="overview" aria-selected="true">
                <span class="lesson-tab-icon">&#9638;</span>
                <span>Overview</span>
            </button>

            <button type="button" class="lesson-tab"
                    data-panel="structures" aria-selected="false">
                <span class="lesson-tab-icon">&#10022;</span>
                <span>Structures</span>
            </button>

            <button type="button" class="lesson-tab"
                    data-panel="video" aria-selected="false">
                <span class="lesson-tab-icon">&#9654;</span>
                <span>Video</span>
            </button>

            <button type="button" class="lesson-tab"
                    data-panel="flashcards" aria-selected="false">
                <span class="lesson-tab-icon">&#9635;</span>
                <span>Flashcards</span>
            </button>

            <button type="button" class="lesson-tab"
                    data-panel="quiz" aria-selected="false">
                <span class="lesson-tab-icon">&#10003;</span>
                <span>Quiz</span>
            </button>

        </aside>

        <!-- MAIN CONTENT -->
        <main class="lesson-main">

            <!-- OVERVIEW -->
            <section class="lesson-panel active" id="panel-overview">

                <div class="lesson-panel-header">
                    <div>
                        <h2>Cardiovascular System Overview</h2>
                        <p>The cardiovascular system circulates blood throughout the body, delivers oxygen and nutrients, removes waste products and helps regulate body temperature.</p>
                    </div>
                </div>

                <!-- Interactive cardiovascular model -->
<div class="lesson-anatomy-viewer lesson-model-slot" id="lessonModelSlotOverview" aria-label="Interactive cardiovascular model">
    <div id="cardiovascularModelViewer" class="lesson-model-shell">
        <div class="lesson-model-toolbar">
            <strong>Interactive Cardiovascular Model</strong>
            <div class="lesson-model-filters" role="group" aria-label="Filter cardiovascular model parts">
                <span class="lesson-model-filters-label">Show:</span>
                <label><input type="checkbox" data-cardiovascular-category="arteries" checked="checked" /> Arteries</label>
                <label><input type="checkbox" data-cardiovascular-category="veins" checked="checked" /> Veins</label>
                <label><input type="checkbox" data-cardiovascular-category="heart" checked="checked" /> Heart</label>
                <label><input type="checkbox" data-cardiovascular-category="other" checked="checked" /> Other</label>
            </div>
            <div class="lesson-model-actions">
                <button type="button" class="lesson-model-button" id="cardiovascularResetView">Reset view</button>
                <button type="button" class="lesson-model-button" id="cardiovascularFullscreen">Full screen</button>
            </div>
        </div>
        <div id="cardiovascularViewerCanvas" role="region" aria-label="Interactive 3D cardiovascular model. Drag to rotate, scroll or pinch to zoom, and click a structure to select it." tabindex="0">
            <div id="cardiovascularViewerStatus" role="status" aria-live="polite">Loading the cardiovascular model…</div>
        </div>
        <div class="lesson-model-footer">
            <span id="cardiovascularSelectedName">Selected structure: None</span>
            <span>Drag to rotate · scroll or pinch to zoom · click a structure to select it. L = left, R = right; numbers are part of the model labels.</span>
        </div>
    </div>
</div>

<div class="lesson-card">
                    <h3>Key Functions</h3>

                    <div class="lesson-function-grid">
                        <div class="lesson-function">
                            <strong>Oxygen Transport</strong><span>Red blood cells carry oxygen from the lungs to body tissues.</span>
                        </div>

                        <div class="lesson-function">
                            <strong>Nutrient delivery</strong><span>Blood delivers nutrients absorbed from food to cells throughout the body.</span>
                        </div>

                        <div class="lesson-function">
                            <strong>Waste removal</strong><span>Blood carries carbon dioxide and other waste products to organs that remove them.</span>
                        </div>

                        <div class="lesson-function">
                            <strong>Hormone transport</strong><span>Blood transports hormones from endocrine glands to their target cells and organs.</span>
                        </div>

                        <div class="lesson-function">
                            <strong>Temperature regulation</strong><span>Blood flow helps distribute heat and maintain a stable body temperature.</span>
                        </div>

                        <div class="lesson-function">
                            <strong>Protection and clotting</strong><span>White blood cells help fight infection, while platelets help stop bleeding.</span>
                        </div>
                    </div>
                </div>

                <div class="lesson-card lesson-system-introduction">
                    <h3>Understanding the Cardiovascular System</h3>
                    <p>The cardiovascular system transports blood throughout the body, supplying cells with oxygen and nutrients while removing carbon dioxide and other waste products. It consists of the heart, blood vessels and blood. The heart acts as a muscular pump, while blood vessels provide pathways for circulation. Together, these structures help maintain the body's internal balance and support the proper functioning of organs and tissues.</p>
                    <ul><li>The heart is a muscular organ with four chambers: two atria and two ventricles. It pumps blood to the lungs for oxygenation and then to the rest of the body.</li><li>Arteries carry blood away from the heart toward body tissues. Most arteries carry oxygen-rich blood, although the pulmonary arteries carry oxygen-poor blood to the lungs.</li><li>Veins and capillaries help complete circulation. Veins return blood toward the heart, while capillaries are tiny vessels where oxygen, nutrients and waste products are exchanged between blood and surrounding tissues.</li><li>Blood is a specialized connective tissue made up of plasma, red blood cells, white blood cells and platelets. These components transport substances, support immune defense and help control bleeding.</li></ul>
                </div>

<div class="lesson-card lesson-publications">
    <h3>Some Articles You Might Find Interesting</h3>
    <p>Explore interesting reads about the heart, blood vessels, and how blood circulates throughout the body.</p>

    <asp:Label ID="lblAnatomyReadsMessage" runat="server"
        CssClass="lesson-publication-message" />

    <asp:Repeater ID="rptAnatomyReads" runat="server">
        <HeaderTemplate>
            <div class="lesson-publication-list">
        </HeaderTemplate>
        <ItemTemplate>
            <article class="lesson-publication-item">
                <h4><%#: Eval("Title") %></h4>
                <p class="lesson-publication-abstract"><%#: Eval("Summary") %></p>
                <a class="lesson-publication-link"
                   href="<%#: Eval("Link") %>"
                   target="_blank"
                   rel="noopener noreferrer">
                    Read article <span aria-hidden="true">&#8594;</span>
                </a>
            </article>
        </ItemTemplate>
        <FooterTemplate>
            </div>
        </FooterTemplate>
    </asp:Repeater>
</div>

<div class="lesson-card">
                    <h3>What You Will Learn</h3>
                    <p>Understand the structure of the heart, explore blood vessels, learn how blood circulates throughout the body and discover how the cardiovascular system supports vital functions.</p>

                    <div class="lesson-button-row">
                        <button type="button" class="lesson-primary-btn"
                                data-go="structures">
                            Explore Structures &#8594;
                        </button>

                        <button type="button" class="lesson-secondary-btn"
                                data-go="video">
                            Watch Video
                        </button>
                    </div>
                </div>

            </section>

            <!-- STRUCTURES -->
            <section class="lesson-panel" id="panel-structures">

                <div class="lesson-panel-header">
                    <div>
                        <h2>Major Cardiovascular Structures</h2>
                        <p>Learn about the heart, major blood vessels and pathways of blood circulation. Use the interactive 3D model below to explore the cardiovascular structures.</p>
                    </div>
                </div>

                <div class="lesson-anatomy-viewer lesson-model-slot" id="lessonModelSlotStructures" aria-label="Interactive Cardiovascular System Model">
</div>

<div class="lesson-category-grid">
                    <div class="lesson-category"><span class="lesson-number">01</span><h3>Heart</h3><p>Explore the organ that pumps blood to the lungs and the rest of the body.</p><div class="lesson-bone-list">
                        <button type="button" class="lesson-structure-item" data-lesson="heartChambers"><span>01.1</span> Heart Chambers</button>
                        <button type="button" class="lesson-structure-item" data-lesson="heartValves"><span>01.2</span> Heart Valves</button>
                    </div></div>
                    <div class="lesson-category"><span class="lesson-number">02</span><h3>Blood Vessels</h3><p>Explore the vessels that transport blood between the heart and the tissues throughout the body.E</p><div class="lesson-bone-list">
                        <button type="button" class="lesson-structure-item" data-lesson="arteries"><span>02.1</span> Arteries and Arterioles</button>
                        <button type="button" class="lesson-structure-item" data-lesson="veins"><span>02.2</span> Veins and Venules</button>
                    </div></div>
                    <div class="lesson-category"><span class="lesson-number">03</span><h3>Blood</h3><p>Learn how blood transports essential substances, supports immune defense and helps prevent excessive bleeding.</p><div class="lesson-bone-list">
                        <button type="button" class="lesson-structure-item" data-lesson="bloodComponents"><span>03.1</span> Blood Components</button>
                        <button type="button" class="lesson-structure-item" data-lesson="bloodTypes"><span>03.2</span> Blood Types</button>
                    </div></div>
                    <div class="lesson-category"><span class="lesson-number">04</span><h3>Circulation</h3><p>Understand how blood moves through the heart, lungs and body to deliver oxygen and remove waste products.</p><div class="lesson-bone-list">
                        <button type="button" class="lesson-structure-item" data-lesson="circulation"><span>04.1</span> Pulmonary and Systemic Circulation</button>
                    </div></div>
                </div>

<div class="lesson-card" style="margin-top:20px;"><h3>Cardiovascular System Summary</h3><p>The cardiovascular system consists of the heart, blood vessels and blood. The heart pumps blood through pulmonary and systemic circulation, delivering oxygen and nutrients to body tissues while removing carbon dioxide and other waste products. Blood vessels transport blood throughout the body, while blood supports immune defense, clotting and the transport of essential substances.</p></div>

            </section>
                <!-- INDIVIDUAL STRUCTURE LESSON -->
            <section class="lesson-panel" id="panel-lesson">
                <button type="button" class="lesson-secondary-btn lesson-lesson-back" id="lessonBackToStructures">&#8592; Back to Structures</button>

                <div class="lesson-panel-header">
                    <div>
                        <h2 id="lessonLessonTitle">Structure Lesson</h2>
                        <p id="lessonLessonIntro">Select a structure from the Structures tab to begin.</p>
                    </div>
                </div>

                <div class="lesson-lesson-image-placeholder">
                    <figure id="lessonReferenceFigure" class="lesson-reference-figure"><img id="lessonReferenceImage" alt=""><figcaption>Image credit: <a id="lessonReferenceSource" href="#" target="_blank" rel="noopener">OpenStax source · CC BY-NC-SA 4.0</a></figcaption></figure>
                    <h3 id="lessonLessonImageTitle">Select a structure</h3>
                    <p id="lessonLessonImageNote" class="lesson-muted" hidden>Choose a structure to view its labelled anatomy reference.</p>
                </div>

                <div class="lesson-lesson-columns">
                    <div class="lesson-lesson-detail">
                        <h3>Key structures</h3>
                        <ul id="lessonLessonStructures"></ul>
                    </div>

                    <div class="lesson-lesson-detail">
                        <h3>Functions</h3>
                        <p id="lessonLessonFunctions"></p>
                    </div>
                </div>

                <div class="lesson-card" style="margin-top:18px;">
                    <h3>Remember</h3>
                    <p id="lessonLessonRemember"></p>
                </div>
            </section>

            <!-- VIDEOS: loaded from dbo.Videos for this body system. -->
            <section class="lesson-panel" id="panel-video">
                <div class="lesson-panel-header">
                    <div>
                        <h2>Cardiovascular System Video</h2>
                        <p>Watch a video to review key cardiovascular system structures and functions.</p>
                    </div>
                </div>
                <asp:Repeater ID="rptVideos" runat="server">
                    <ItemTemplate>
                        <div class="lesson-card lesson-video-card">
                            <h3><%#: Eval("VideoTitle") %></h3>
                            <iframe class="lesson-video-frame"
                                src='<%#: Eval("EmbedURL") %>'
                                title='<%#: Eval("VideoTitle") %>'
                                loading="lazy"
                                allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
                                referrerpolicy="strict-origin-when-cross-origin"
                                allowfullscreen>
                            </iframe>
                            <p class="lesson-video-note"><%#: Eval("Description") %></p>
                            <div class="lesson-button-row">
                                <a class="lesson-primary-btn" href='<%#: Eval("WatchURL") %>' target="_blank" rel="noopener noreferrer">Open video source &#8599;</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoVideos" runat="server" CssClass="lesson-card lesson-video-empty" Visible="false">
                    <p>No videos are available for this system yet.</p>
                </asp:Panel>
            </section>

           
<!-- FLASHCARDS -->
<section class="lesson-panel" id="panel-flashcards">

    <div class="lesson-panel-header">
        <div>
            <h2>Cardiovascular System Flashcards</h2>
            <p>Review key cardiovascular system terms. Reveal each answer as you study.</p>
        </div>
    </div>

    <div class="lesson-card">
        <asp:HiddenField
            ID="hiddenFlashcards"
            runat="server"
            ClientIDMode="Static"
            Value="[]" />

        <div class="lesson-flashcard">
            <small id="lessonFlashLabel">Question</small>
            <h3 id="lessonFlashQuestion">Select a flashcard to begin.</h3>
            <p id="lessonFlashAnswer" hidden></p>
        </div>

        <div class="lesson-flash-count" id="lessonFlashCount">Flashcards will appear here.</div>

        <div class="lesson-button-row" style="justify-content:center;">
            <button type="button" class="lesson-secondary-btn" id="lessonPreviousCard">
                &#8592; Previous
            </button>
            <button type="button" class="lesson-primary-btn" id="lessonRevealCard">
                Reveal Answer
            </button>
            <button type="button" class="lesson-secondary-btn" id="lessonNextCard">
                Next &#8594;
            </button>
        </div>
    </div>
</section>

            <!-- QUIZ -->
            <section class="lesson-panel" id="panel-quiz">

                <div class="lesson-panel-header">
                    <div>
                        <h2>Cardiovascular System Quiz</h2>
                        <p>Test your knowledge of the heart, blood vessels and circulation in a timed quiz.</p>
                    </div>
                </div>

                <asp:Panel ID="pnlQuizPlay" runat="server" CssClass="lesson-card">

                    <div id="lessonQuizStartScreen" class="lesson-quiz-start">
                        <div class="lesson-quiz-start-icon" aria-hidden="true">
                            <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10" />
                                <path d="m9 12 2 2 4-4" />
                            </svg>
                        </div>
                        <h3>Ready to test your cardiovascular knowledge?</h3>
                        <p>You will answer each question one at a time. You have 15 seconds for each question. Your score and XP will be shown when you finish.</p>
                        <button type="button" class="lesson-primary-btn" id="lessonBeginQuiz">Begin Quiz</button>
                    </div>

                    <asp:Label ID="lblQuestionCount" runat="server" CssClass="lesson-muted"></asp:Label>
                    <asp:Label ID="lblQuizError" runat="server" ForeColor="Red"></asp:Label>

                    <asp:HiddenField ID="hiddenQuizAnswers" runat="server" ClientIDMode="Static" />

                    <asp:Button ID="btnSubmitQuizServer"
                        runat="server"
                        ClientIDMode="Static"
                        Text="Submit Quiz"
                        OnClick="SubmitCardiovascularQuiz"
                        UseSubmitBehavior="false"
                        Style="display:none;" />

                    <div id="lessonQuizContainer">
                        <asp:Repeater ID="rptCardiovascularQuestions" runat="server">
                            <ItemTemplate>
                                <div class="lesson-question" data-question-id='<%# Eval("QuestionID") %>'>
                                    <h3><%# Eval("QuestionText") %></h3>

                                    <label class="lesson-answer">
                                        <asp:RadioButton ID="rbOptionA" runat="server"
                                            GroupName='<%# "q" + Eval("QuestionID") %>'
                                            Text='<%# Eval("OptionA") %>' />
                                    </label>

                                    <label class="lesson-answer">
                                        <asp:RadioButton ID="rbOptionB" runat="server"
                                            GroupName='<%# "q" + Eval("QuestionID") %>'
                                            Text='<%# Eval("OptionB") %>' />
                                    </label>

                                    <label class="lesson-answer">
                                        <asp:RadioButton ID="rbOptionC" runat="server"
                                            GroupName='<%# "q" + Eval("QuestionID") %>'
                                            Text='<%# Eval("OptionC") %>' />
                                    </label>

                                    <label class="lesson-answer">
                                        <asp:RadioButton ID="rbOptionD" runat="server"
                                            GroupName='<%# "q" + Eval("QuestionID") %>'
                                            Text='<%# Eval("OptionD") %>' />
                                    </label>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    <div class="lesson-progress-track">
                        <div class="lesson-progress-fill" id="lessonQuizProgress"></div>
                    </div>

                    <button type="button" class="lesson-primary-btn" id="lessonSubmitQuiz">
                        Next Question
                    </button>

                    <div class="lesson-feedback" id="lessonQuizFeedback" role="status" aria-live="polite"></div>
                </asp:Panel>

                <asp:Panel ID="pnlQuizResults"
                    runat="server"
                    CssClass="lesson-card lesson-quiz-result"
                    Visible="false">

                    <div class="lesson-result-heading">
                        <span class="lesson-result-eyebrow">CARDIOVASCULAR SYSTEM &middot; QUIZ SUMMARY</span>
                        <h2>Quiz Completed!</h2>
                        <p class="lesson-result-subtitle">Your cardiovascular system quiz results</p>
                    </div>

                    <div class="lesson-result-overview">
                        <div class="lesson-result-ring" id="quizScoreRing" runat="server">
                            <div class="lesson-result-ring-inner">
                                <asp:Label ID="lblQuizPercentage" runat="server" CssClass="lesson-result-percent" />
                                <span>accuracy</span>
                            </div>
                        </div>

                        <div class="lesson-result-message">
                            <span class="lesson-result-pill"><span class="lesson-result-dot"></span> Attempt complete</span>
                            <h3 id="lessonResultTitle" runat="server">Nice work!</h3>
                            <p>You answered <strong><asp:Label ID="lblQuizScore" runat="server" /></strong> questions correctly.</p>
                            <p class="lesson-result-small">Review the result below, then try again to beat your score.</p>
                        </div>
                    </div>

                    <div class="lesson-result-stats">
                        <div class="lesson-result-stat">
                            <div class="lesson-stat-icon" aria-hidden="true"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#8ACBFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m16 9-5.5 5.5L8 12"/></svg></div>
                            <span class="lesson-stat-label">Correct answers</span>
                            <strong><asp:Label ID="lblCorrectCount" runat="server" /></strong>
                            <small>out of <asp:Label ID="lblTotalQuestions" runat="server" /></small>
                        </div>

                        <div class="lesson-result-stat">
                            <div class="lesson-stat-icon" aria-hidden="true"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#8ACBFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="12" r="6"/><circle cx="12" cy="12" r="2"/></svg></div>
                            <span class="lesson-stat-label">Accuracy</span>
                            <strong><asp:Label ID="lblAccuracyStat" runat="server" /></strong>
                            <small>overall result</small>
                        </div>

                        <div class="lesson-result-stat">
                            <div class="lesson-stat-icon" aria-hidden="true"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#8ACBFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15.914 4a1.5 1.5 0 00-2.474-1.561l-9 9A1.5 1.5 0 005.5 14h4.002a.5.5 0 01.471.666L8.086 20a1.5 1.5 0 002.475 1.56l9-9A1.5 1.5 0 0018.5 10h-3.997a.5.5 0 01-.472-.667z"/></svg></div>
                            <span class="lesson-stat-label">XP earned</span>
                            <strong>+<asp:Label ID="lblTotalXP" runat="server" /></strong>
                            <small>total reward</small>
                        </div>

                        <div class="lesson-result-stat">
                            <div class="lesson-stat-icon" aria-hidden="true"><svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#8ACBFF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 6v6l3.644 1.822"/><path d="M16 19h6"/><path d="M19 16v6"/><path d="M21.92 13.267a10 10 0 1 0-8.653 8.653"/></svg></div>
                            <span class="lesson-stat-label">Speed bonus</span>
                            <strong>+<asp:Label ID="lblSpeedBonusXP" runat="server" /></strong>
                            <small>quick answers</small>
                        </div>
                    </div>

                    <div class="lesson-result-xp-breakdown">
                        <div class="lesson-xp-breakdown-top">
                            <span>XP breakdown</span>
                            <strong><asp:Label ID="lblTotalXPBreakdown" runat="server" /> XP</strong>
                        </div>
                        <div class="lesson-xp-bar">
                            <div class="lesson-xp-base" id="xpBaseBar" runat="server"></div>
                            <div class="lesson-xp-speed" id="xpSpeedBar" runat="server"></div>
                        </div>
                        <div class="lesson-xp-legend">
                            <span><i class="lesson-legend-dot lesson-legend-base"></i> Base XP: <asp:Label ID="lblBaseXP" runat="server" /></span>
                            <span><i class="lesson-legend-dot lesson-legend-speed"></i> Speed bonus: <asp:Label ID="lblSpeedBonusBreakdown" runat="server" /></span>
                        </div>
                    </div>

                    <asp:Label ID="lblQuizSaveMessage" runat="server" CssClass="lesson-result-save-message" />

                    <div class="lesson-button-row lesson-result-actions">
                        <asp:Button ID="btnTryAgain" runat="server" Text="Try Again"
                            CssClass="lesson-primary-btn" OnClick="btnTryAgain_Click" />
                        <asp:Button ID="btnFinishQuiz" runat="server" Text="Finish"
                            CssClass="lesson-secondary-btn" OnClick="btnFinishQuiz_Click" />
                    </div>
                </asp:Panel>
            </section>

        </main>
    </div>
</div>
    <script>
(function () {
    var page = document.querySelector(".lesson-page");
    if (!page) return;

    /* SIDEBAR TAB SWITCHING */
    var tabs = page.querySelectorAll(".lesson-tab");
    var panels = page.querySelectorAll(".lesson-panel");

    function showPanel(name) {
        tabs.forEach(function (tab) {
            var active = tab.getAttribute("data-panel") === name;
            tab.classList.toggle("active", active);
            tab.setAttribute("aria-selected", active ? "true" : "false");
        });

        panels.forEach(function (panel) {
            panel.classList.toggle("active", panel.id === "panel-" + name);
        });

        // Enable the gaming theme only in the Quiz tab.
        page.classList.toggle("lesson-gaming-mode", name === "quiz");

    }

    tabs.forEach(function (tab) {
        tab.addEventListener("click", function () {
            showPanel(tab.getAttribute("data-panel"));
        });
    });

    page.querySelectorAll("[data-go]").forEach(function (button) {
        button.addEventListener("click", function () {
            showPanel(button.getAttribute("data-go"));
        });
    });
/* FLASHCARDS */
    var hiddenFlashcards = page.querySelector("#hiddenFlashcards");
    var flashcards = [];

    try {
        flashcards = JSON.parse(hiddenFlashcards ? (hiddenFlashcards.value || "[]") : "[]")
            .map(function (card) {
                return {
                    question: card.QuestionText,
                    answer: card.AnswerText
                };
            });
    } catch (error) {
        flashcards = [];
    }

    var flashIndex = 0;
    var flashQuestion = page.querySelector("#lessonFlashQuestion");
    var flashAnswer = page.querySelector("#lessonFlashAnswer");
    var flashLabel = page.querySelector("#lessonFlashLabel");
    var flashCount = page.querySelector("#lessonFlashCount");
    var revealButton = page.querySelector("#lessonRevealCard");
    var previousButton = page.querySelector("#lessonPreviousCard");
    var nextButton = page.querySelector("#lessonNextCard");

    function renderFlashcard() {
        if (!flashcards.length) {
            flashQuestion.textContent = "No flashcards available yet.";
            flashAnswer.textContent = "";
            flashAnswer.hidden = true;
            flashLabel.textContent = "Flashcards";
            flashCount.textContent = "0 cards available";
            revealButton.disabled = true;
            previousButton.disabled = true;
            nextButton.disabled = true;
            return;
        }

        flashQuestion.textContent = flashcards[flashIndex].question;
        flashAnswer.textContent = flashcards[flashIndex].answer;
        flashAnswer.hidden = true;
        flashLabel.textContent = "Question";
        revealButton.textContent = "Reveal Answer";
        flashCount.textContent =
            "Card " + (flashIndex + 1) + " of " + flashcards.length;
        revealButton.disabled = false;
        previousButton.disabled = false;
        nextButton.disabled = false;
    }

    revealButton.addEventListener("click", function () {
        if (!flashcards.length) return;
        var revealing = flashAnswer.hidden;
        flashAnswer.hidden = !revealing;
        flashLabel.textContent = revealing ? "Answer" : "Question";
        revealButton.textContent = revealing ? "Hide Answer" : "Reveal Answer";
    });

    previousButton.addEventListener("click", function () {
        if (!flashcards.length) return;
        flashIndex = (flashIndex - 1 + flashcards.length) % flashcards.length;
        renderFlashcard();
    });

    nextButton.addEventListener("click", function () {
        if (!flashcards.length) return;
        flashIndex = (flashIndex + 1) % flashcards.length;
        renderFlashcard();
    });

    renderFlashcard();

    /* INDIVIDUAL STRUCTURE LESSONS */
    var lessonData = {
        heartChambers: {
            title: "Heart Chambers",
            intro: "The heart has four chambers that work together to receive blood and pump it to the lungs and the rest of the body.",
            structures: ["Right atrium", "Right ventricle", "Left atrium", "Left ventricle"],
            functions: "The atria receive blood returning to the heart. The right ventricle pumps blood to the lungs, while the left ventricle pumps oxygen-rich blood around the body. The left ventricle has a thicker muscular wall because it must generate greater pressure.",
            remember: "Atria receive blood; ventricles pump blood. The right side sends blood to the lungs, and the left side sends it to the body."
        },
        heartValves: {
            title: "Heart Valves",
            intro: "Four main valves open and close as the heart beats, helping blood move forward through the heart in one direction.",
            structures: ["Tricuspid valve", "Pulmonary valve", "Mitral (bicuspid) valve", "Aortic valve"],
            functions: "The tricuspid valve controls flow from the right atrium to the right ventricle. The pulmonary valve controls flow into the pulmonary artery. The mitral valve controls flow from the left atrium to the left ventricle, and the aortic valve controls flow into the aorta.",
            remember: "The tricuspid and mitral valves lie between the atria and ventricles. The pulmonary and aortic valves are at the exits of the ventricles."
        },
        arteries: {
            title: "Arteries and Arterioles",
            intro: "Arteries carry blood away from the heart. Smaller branches called arterioles help control how much blood reaches individual tissues.",
            structures: ["Tunica intima (inner layer)", "Tunica media (smooth-muscle layer)", "Tunica externa (outer layer)", "Arterioles"],
            functions: "Artery walls are strong and elastic to withstand the pressure created by the heart. Smooth muscle in the vessel wall can narrow or widen the vessel, while arterioles help regulate blood distribution and blood pressure.",
            remember: "Arteries are defined by carrying blood away from the heart, not by oxygen content. The pulmonary arteries carry oxygen-poor blood to the lungs."
        },
        veins: {
            title: "Veins and Venules",
            intro: "Veins return blood toward the heart. Small vessels called venules collect blood from capillaries and join to form larger veins.",
            structures: ["Tunica intima (inner layer)", "Tunica media (smooth-muscle layer)", "Tunica externa (outer layer)", "Venous valves and venules"],
            functions: "Veins generally have thinner walls and wider lumens than comparable arteries. Many veins, especially in the limbs, contain valves that help prevent backward flow. Skeletal-muscle contractions and breathing movements also assist blood return to the heart.",
            remember: "Veins carry blood toward the heart. Pulmonary veins are an important exception to the usual oxygen pattern because they carry oxygen-rich blood from the lungs to the heart."
        },
        bloodComponents: {
            title: "Blood Components",
            intro: "Blood is a connective tissue made up of plasma and formed elements that transport substances, defend the body and help prevent blood loss.",
            structures: ["Plasma", "Red blood cells (erythrocytes)", "White blood cells (leukocytes)", "Platelets (thrombocytes)"],
            functions: "Plasma carries water, proteins, nutrients, hormones and waste products. Red blood cells transport oxygen using haemoglobin. White blood cells help defend against infection, while platelets contribute to clot formation when a blood vessel is damaged.",
            remember: "Red blood cells mainly transport oxygen, white blood cells support immune defence, and platelets help blood clot. Plasma is the liquid portion of blood."
        },
        bloodTypes: {
            title: "Blood Types",
            intro: "The ABO and Rh systems classify blood according to specific antigens on red blood cells. These markers are important when matching blood for transfusion.",
            structures: ["Type A: A antigen", "Type B: B antigen", "Type AB: A and B antigens", "Type O: neither A nor B antigen; Rh may be positive or negative"],
            functions: "Blood typing helps healthcare professionals select compatible blood for transfusions. Compatibility depends on the donor and recipient blood groups and other clinical factors, so transfusions require appropriate testing and professional checks.",
            remember: "ABO type is based on A and B antigens, while the Rh label indicates whether the Rh(D) antigen is present. Never assume compatibility from ABO type alone."
        },
        circulation: {
            title: "Pulmonary and Systemic Circulation",
            intro: "Blood travels through two connected circuits: pulmonary circulation between the heart and lungs, and systemic circulation between the heart and the rest of the body.",
            structures: ["Pulmonary arteries and lung capillaries", "Pulmonary veins", "Aorta and systemic arteries", "Venae cavae and systemic veins"],
            functions: "In pulmonary circulation, the right ventricle sends oxygen-poor blood to the lungs, where gas exchange occurs; oxygen-rich blood then returns to the left atrium. In systemic circulation, the left ventricle pumps oxygen-rich blood through the aorta to body tissues, and oxygen-poor blood returns to the right atrium through the veins and venae cavae.",
            remember: "Pulmonary circulation connects the heart and lungs. Systemic circulation connects the heart and body tissues. Both circuits operate as one continuous pathway."
        }
    };

    var lessonImageSystem = "cardiovascular";

    var illustrationRequestVersion = 0;
    function loadStructureIllustration(key, title) {
        var requestVersion = ++illustrationRequestVersion;
        var figure = page.querySelector("#lessonReferenceFigure");
        var image = page.querySelector("#lessonReferenceImage");
        var source = page.querySelector("#lessonReferenceSource");
        var note = page.querySelector("#lessonLessonImageNote");
        figure.style.display = "none";
        image.removeAttribute("src");
        source.removeAttribute("href");
        note.textContent = "Loading curated OpenStax illustration for " + title + "...";

        var request = new XMLHttpRequest();
        request.open("GET", "<%= ResolveUrl("~/Learning/AnatomyImageSearch.ashx") %>?system=" + encodeURIComponent(lessonImageSystem) + "&structure=" + encodeURIComponent(key), true);
        request.onreadystatechange = function () {
            if (request.readyState !== 4 || requestVersion !== illustrationRequestVersion) return;
            var result = null;
            try { if (request.status === 200) result = JSON.parse(request.responseText); } catch (ignore) { }
            if (!result || !result.found) {
                note.textContent = "No curated illustration is available for this structure. The lesson text is still available below.";
                return;
            }
            image.alt = "Anatomy illustration of " + title;
            source.href = result.sourceUrl;
            source.textContent = result.sourceName + (result.artist ? " · " + result.artist : "") + (result.license ? " · " + result.license : "");
            image.onerror = function () {
                if (requestVersion !== illustrationRequestVersion) return;
                figure.style.display = "none";
                note.textContent = "This image could not be loaded. The lesson text is still available below.";
            };
            image.onload = function () {
                if (requestVersion === illustrationRequestVersion) {
                    figure.style.display = "block";
                    note.textContent = "Curated OpenStax illustration for " + title + ". Licensed CC BY-NC-SA 4.0.";
                }
            };
            image.src = result.imageUrl;
        };
        request.onerror = function () {
            if (requestVersion === illustrationRequestVersion) note.textContent = "The illustration could not be loaded. The lesson text is still available below.";
        };
        request.send();
    }

    function openStructureLesson(key) {
        var lesson = lessonData[key];
        if (!lesson) return;

        page.querySelector("#lessonLessonTitle").textContent = lesson.title;
        page.querySelector("#lessonLessonIntro").textContent = lesson.intro;
        page.querySelector("#lessonLessonImageTitle").textContent = lesson.title + " illustration";
        loadStructureIllustration(key, lesson.title);
        page.querySelector("#lessonLessonFunctions").textContent = lesson.functions;
        page.querySelector("#lessonLessonRemember").textContent = lesson.remember;

        var structuresList = page.querySelector("#lessonLessonStructures");
        structuresList.textContent = "";

        lesson.structures.forEach(function (structure) {
            var item = document.createElement("li");
            item.textContent = structure;
            structuresList.appendChild(item);
        });

        showPanel("lesson");
    }

    page.querySelectorAll("[data-lesson]").forEach(function (button) {
        button.addEventListener("click", function () {
            openStructureLesson(button.getAttribute("data-lesson"));
        });

        button.addEventListener("keydown", function (event) {
            if (event.key === "Enter" || event.key === " ") {
                event.preventDefault();
                openStructureLesson(button.getAttribute("data-lesson"));
            }
        });
    });

    page.querySelector("#lessonBackToStructures").addEventListener("click", function () {
        showPanel("structures");
    });

    /* CARDIOVASCULAR QUIZ */
    var submitQuiz = page.querySelector("#lessonSubmitQuiz");
    var quizFeedback = page.querySelector("#lessonQuizFeedback");
    var quizProgress = page.querySelector("#lessonQuizProgress");
    var quizContainer = page.querySelector("#lessonQuizContainer");
    var hiddenAnswers = page.querySelector("#hiddenQuizAnswers");
    var serverSubmit = page.querySelector("#btnSubmitQuizServer");
    var quizStartScreen = page.querySelector("#lessonQuizStartScreen");
    var beginQuizButton = page.querySelector("#lessonBeginQuiz");

    var quizQuestions = [];
    var currentQuestion = 0;
    var secondsLeft = 15;
    var timerId = null;
    var quizStarted = false;
    var quizFinished = false;
    var answerData = {};

    var quizStatus = document.createElement("div");
    quizStatus.className = "lesson-quiz-status";
    quizStatus.innerHTML =
        '<span id="lessonQuestionNumber">Question 1</span>' +
        '<span class="lesson-quiz-timer" id="lessonTimer">15 seconds</span>';

    quizContainer.parentNode.insertBefore(quizStatus, quizContainer);

    var questionNumber = page.querySelector("#lessonQuestionNumber");
    var timerDisplay = page.querySelector("#lessonTimer");

    // Keep quiz questions and controls hidden until the learner chooses to begin.
    quizContainer.style.display = "none";
    quizStatus.style.display = "none";
    quizProgress.parentNode.style.display = "none";
    submitQuiz.style.display = "none";

    function stopQuizTimer() {
        if (timerId !== null) {
            clearInterval(timerId);
            timerId = null;
        }
    }

    function updateQuizProgress() {
        if (!quizQuestions.length) return;
        var percentage = Math.round((currentQuestion / quizQuestions.length) * 100);
        quizProgress.style.width = percentage + "%";
        questionNumber.textContent =
            "Question " + (currentQuestion + 1) + " of " + quizQuestions.length;
    }

    function getQuestionId(question) {
        return question.getAttribute("data-question-id");
    }

    function getSelectedOption(question) {
        var radios = question.querySelectorAll('input[type="radio"]');
        for (var i = 0; i < radios.length; i++) {
            if (radios[i].checked) {
                var suffix = ["A", "B", "C", "D"][i];
                return suffix;
            }
        }
        return "";
    }

    function recordCurrentAnswer() {
        var question = quizQuestions[currentQuestion];
        if (!question) return;

        var id = getQuestionId(question);
        var selected = getSelectedOption(question);

        // Keep the time remaining when the selected answer is submitted.
        if (selected) {
            answerData[id] = {
                questionID: parseInt(id, 10),
                answer: selected,
                secondsRemaining: secondsLeft
            };
        } else if (!answerData[id]) {
            answerData[id] = {
                questionID: parseInt(id, 10),
                answer: "",
                secondsRemaining: 0
            };
        }
    }

    function showCurrentQuestion() {
        quizQuestions.forEach(function (question, index) {
            question.classList.toggle("lesson-question-hidden", index !== currentQuestion);
        });

        secondsLeft = 15;
        timerDisplay.textContent = secondsLeft + " seconds";
        timerDisplay.classList.remove("warning");
        updateQuizProgress();
    }

    function startQuestionTimer() {
        stopQuizTimer();
        timerId = setInterval(function () {
            secondsLeft--;
            timerDisplay.textContent = secondsLeft + " seconds";

            if (secondsLeft <= 5) {
                timerDisplay.classList.add("warning");
            }

            if (secondsLeft <= 0) {
                stopQuizTimer();
                recordCurrentAnswer();
                moveToNextQuestion();
            }
        }, 1000);
    }

    function finishQuiz() {
        stopQuizTimer();
        quizFinished = true;
        recordCurrentAnswer();

        quizQuestions.forEach(function (question) {
            var id = getQuestionId(question);
            if (!answerData[id]) {
                answerData[id] = {
                    questionID: parseInt(id, 10),
                    answer: "",
                    secondsRemaining: 0
                };
            }
        });

        hiddenAnswers.value = JSON.stringify(
            Object.keys(answerData).map(function (key) {
                return answerData[key];
            })
        );

        quizProgress.style.width = "100%";
        quizStatus.style.display = "none";
        submitQuiz.disabled = true;
        submitQuiz.textContent = "Submitting...";

        // The server checks answers and saves registered users' results.
        serverSubmit.click();
    }

    function moveToNextQuestion() {
        stopQuizTimer();
        recordCurrentAnswer();

        if (currentQuestion < quizQuestions.length - 1) {
            currentQuestion++;
            showCurrentQuestion();
            startQuestionTimer();
        } else {
            finishQuiz();
        }
    }

    function startCardiovascularQuiz() {
        if (quizStarted || quizFinished) return;

        quizQuestions = Array.prototype.slice.call(
            page.querySelectorAll("#lessonQuizContainer .lesson-question")
        );

        if (!quizQuestions.length) {
            quizFeedback.className = "lesson-feedback visible review";
            quizFeedback.textContent =
                "No quiz questions were loaded. Please check the database connection.";
            return;
        }

        quizStarted = true;
        currentQuestion = 0;

        if (quizStartScreen) quizStartScreen.style.display = "none";
        quizContainer.style.display = "block";
        quizStatus.style.display = "flex";
        quizProgress.parentNode.style.display = "block";
        submitQuiz.style.display = "inline-block";

        quizQuestions.forEach(function (question) {
            question.classList.add("lesson-question-hidden");

            question.querySelectorAll('input[type="radio"]').forEach(function (radio) {
                radio.addEventListener("change", function () {
                    var id = getQuestionId(question);
                    answerData[id] = {
                        questionID: parseInt(id, 10),
                        answer: getSelectedOption(question),
                        secondsRemaining: secondsLeft
                    };
                });
            });
        });

        quizFeedback.className = "lesson-feedback";
        submitQuiz.textContent = "Next Question";
        showCurrentQuestion();
        startQuestionTimer();
    }

    window.startCardiovascularQuiz = startCardiovascularQuiz;

    if (beginQuizButton) {
        beginQuizButton.addEventListener("click", function () {
            startCardiovascularQuiz();
        });
    }

    submitQuiz.addEventListener("click", function () {
        if (!quizStarted || quizFinished) return;
        moveToNextQuestion();
    });
    // Open the quiz automatically when Try Again is clicked.
    if (window.location.search.indexOf("showQuiz=1") !== -1) {
        var quizTab = page.querySelector('.lesson-tab[data-panel="quiz"]');

        if (quizTab) {
            quizTab.click();
        }

        setTimeout(function () {
            var quizPanel = page.querySelector("#panel-quiz");

            if (quizPanel) {
                quizPanel.scrollIntoView({
                    behavior: "smooth",
                    block: "start"
                });
            }
        }, 100);
    }

    renderFlashcard();
})();
</script>

    <script type="importmap">
{
    "imports": {
        "three": "https://cdn.jsdelivr.net/npm/three@0.160.0/build/three.module.js",
        "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.160.0/examples/jsm/"
    }
}
</script>
<script type="module">
import * as THREE from "three";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader.js";
import { OrbitControls } from "three/addons/controls/OrbitControls.js";

const viewer = document.getElementById("cardiovascularModelViewer");
const canvasHost = document.getElementById("cardiovascularViewerCanvas");
const status = document.getElementById("cardiovascularViewerStatus");
const selectedName = document.getElementById("cardiovascularSelectedName");
if (!viewer || !canvasHost || !status) throw new Error("Cardiovascular model viewer elements were not found.");

const filterToggles = new Map(
  Array.from(viewer.querySelectorAll("[data-cardiovascular-category]"))
    .map((input) => [input.dataset.cardiovascularCategory, input])
);

const scene = new THREE.Scene();
scene.background = new THREE.Color("#d8e3ed");
const camera = new THREE.PerspectiveCamera(35, 1, 0.01, 10000);
const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: false });
renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
renderer.outputColorSpace = THREE.SRGBColorSpace;
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = 1.15;
canvasHost.prepend(renderer.domElement);
scene.add(new THREE.HemisphereLight(0xffffff, 0x8090a0, 2.2));
const keyLight = new THREE.DirectionalLight(0xffffff, 2.1);
keyLight.position.set(3, 5, 4);
scene.add(keyLight);
const fillLight = new THREE.DirectionalLight(0xffffff, 0.8);
fillLight.position.set(-4, 2, -3);
scene.add(fillLight);

const controls = new OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;
controls.dampingFactor = 0.07;
controls.zoomSpeed = 1.7;

let modelRoot = null;
const pickableMeshes = [];
const categoryColors = { arteries: "#c94b52", veins: "#4c78b8", heart: "#d87879", other: "#c9a9a0" };
let pointerDown = null;

function isHelperObject(object) {
  const name = object.name || "";
  if (/(?:[._])(?:j|t|st)$/i.test(name)) return true;
  if (object.isMesh && /(?:[._])g$/i.test(name)) return true;
  if (/cross[ _.-]*section|take[ _.-]*a[ _.-]*picture|label|annotation|callout|leader[ _.-]*line/i.test(name)) return true;
  let parent = object.parent;
  while (parent && parent !== modelRoot) {
    const parentName = parent.name || "";
    if (/(?:[._])(?:j|t|st)$/i.test(parentName) ||
        /cross[ _.-]*section|label|annotation|callout|leader[ _.-]*line/i.test(parentName)) return true;
    parent = parent.parent;
  }
  return false;
}

function categoryFor(object) {
  const materials = Array.isArray(object.material) ? object.material : [object.material];
  const names = ((object.name || "") + " " + materials.map((material) => material?.name || "").join(" ")).toLowerCase();
  if (/vein|venae|venous/.test(names)) return "veins";
  if (/artery|arteries|arterial|aorta|aortic/.test(names)) return "arteries";
  if (/heart|atrium|atria|ventricle|ventricles|valve|myocardium|cardiac/.test(names)) return "heart";
  return "other";
}

function updateFilters() {
  if (!modelRoot) return;
  modelRoot.traverse((object) => {
    if (!object.isMesh || object.userData.anatomyHelper) return;
    object.visible = filterToggles.get(object.userData.anatomyCategory)?.checked ?? true;
  });
}

function resize() {
  const width = canvasHost.clientWidth;
  const height = canvasHost.clientHeight;
  if (!width || !height) return;
  renderer.setSize(width, height, false);
  camera.aspect = width / height;
  camera.updateProjectionMatrix();
}

function frameModel() {
  if (!modelRoot) return;
  modelRoot.updateMatrixWorld(true);
  const bounds = new THREE.Box3();
  modelRoot.traverse((object) => {
    if (object.isMesh && object.visible) bounds.expandByObject(object);
  });
  if (bounds.isEmpty()) return;
  const center = bounds.getCenter(new THREE.Vector3());
  const size = bounds.getSize(new THREE.Vector3());
  const maxDimension = Math.max(size.x, size.y, size.z) || 1;
  const halfVerticalFov = THREE.MathUtils.degToRad(camera.fov) / 2;
  const halfHorizontalFov = Math.atan(Math.tan(halfVerticalFov) * camera.aspect);
  const distance = Math.max(
    (size.y / 2) / Math.tan(halfVerticalFov),
    (size.x / 2) / Math.tan(halfHorizontalFov),
    size.z / 2
  );
  controls.target.copy(center);
  camera.position.set(center.x, center.y + size.y * 0.035, center.z - distance * 1.18);
  camera.near = Math.max(maxDimension / 2000, 0.001);
  camera.far = maxDimension * 30;
  camera.updateProjectionMatrix();
  controls.update();
  resize();
}

document.getElementById("cardiovascularResetView").addEventListener("click", () => {
  filterToggles.forEach((input) => { input.checked = true; });
  updateFilters();
  if (selectedName) selectedName.textContent = "Selected structure: None";
  frameModel();
});
document.getElementById("cardiovascularFullscreen").addEventListener("click", async () => {
  try {
    if (!document.fullscreenElement) await viewer.requestFullscreen();
    else await document.exitFullscreen();
  } catch (error) {
    console.error(error);
  }
});

filterToggles.forEach((input) => input.addEventListener("change", updateFilters));

renderer.domElement.addEventListener("pointerdown", (event) => {
  pointerDown = { x: event.clientX, y: event.clientY };
});
renderer.domElement.addEventListener("click", (event) => {
  if (!modelRoot || !selectedName ||
      (pointerDown && Math.hypot(event.clientX - pointerDown.x, event.clientY - pointerDown.y) > 5)) return;
  const rect = renderer.domElement.getBoundingClientRect();
  const pointer = new THREE.Vector2(
    ((event.clientX - rect.left) / rect.width) * 2 - 1,
    -((event.clientY - rect.top) / rect.height) * 2 + 1
  );
  const raycaster = new THREE.Raycaster();
  raycaster.setFromCamera(pointer, camera);
  const hit = raycaster.intersectObjects(pickableMeshes, false)[0];
  selectedName.textContent = hit
    ? "Selected structure: " + (hit.object.userData.displayName || hit.object.name || "Unnamed structure")
    : "Selected structure: None";
});

const loader = new GLTFLoader();
loader.load(
  new URL("../Learning/Models/Cardiovascular.glb", import.meta.url).href,
  (gltf) => {
    modelRoot = new THREE.Group();
    modelRoot.rotation.y = Math.PI;
    modelRoot.add(gltf.scene);
    modelRoot.traverse((object) => {
      if (isHelperObject(object)) {
        object.visible = false;
        object.userData.anatomyHelper = true;
        return;
      }
      if (!object.isMesh) return;
      object.userData.displayName = (object.name || "Unnamed structure").trim();
      const category = categoryFor(object);
      object.userData.anatomyCategory = category;
      const originals = Array.isArray(object.material) ? object.material : [object.material];
      const coloredMaterials = originals.map((material) => {
        const copy = material.clone();
        if (copy.color) copy.color.set(categoryColors[category] || categoryColors.other);
        return copy;
      });
      object.material = Array.isArray(object.material) ? coloredMaterials : coloredMaterials[0];
      pickableMeshes.push(object);
    });
    scene.add(modelRoot);
    updateFilters();
    status.remove();
    requestAnimationFrame(() => {
      resize();
      frameModel();
    });
  },
  (event) => {
    if (event.total) status.textContent = "Loading cardiovascular model… " + Math.round(event.loaded / event.total * 100) + "%";
  },
  (error) => {
    console.error(error);
    status.classList.add("lesson-error");
    status.textContent = "Could not load Cardiovascular.glb. Check that the model file is included in the web project.";
  }
);

new ResizeObserver(resize).observe(canvasHost);
window.addEventListener("resize", resize);
document.addEventListener("fullscreenchange", () => {
  requestAnimationFrame(() => {
    resize();
    frameModel();
  });
});
renderer.setAnimationLoop(() => {
  controls.update();
  renderer.render(scene, camera);
});

function moveViewerToCurrentSlot() {
  const activePanel = document.querySelector(".lesson-panel.active");
  const targetSlot = activePanel && activePanel.querySelector(".lesson-model-slot");
  if (targetSlot && viewer.parentElement !== targetSlot) {
    targetSlot.appendChild(viewer);
    requestAnimationFrame(resize);
  }
}
document.querySelectorAll(".lesson-panel").forEach((panel) => {
  new MutationObserver(moveViewerToCurrentSlot).observe(panel, { attributes: true, attributeFilter: ["class"] });
});
moveViewerToCurrentSlot();
</script>
</asp:Content>

