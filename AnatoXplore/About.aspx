
<%@ Page Title="About AnatoXplore" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="AnatoXplore.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main class="about-page">

        <!-- HERO BANNER -->
        <section class="about-hero" role="img"
            aria-label="About AnatoXplore: interactive anatomy learning for medical students">
        </section>

        <!-- INTRODUCTION -->
        <section class="about-intro">
            <h2>What is AnatoXplore?</h2>
            <p>
                AnatoXplore is an interactive anatomy learning platform designed to help
                medical students understand and explore the human body. It provides
                educational resources in one place, allowing students to learn at their
                own pace and test their knowledge.
            </p>
        </section>

        <!-- FEATURES -->
        <section class="about-features">
            <h2>What Can You Do on AnatoXplore?</h2>

            <div class="about-feature-grid">

                <article class="about-feature-card">
                    <div class="about-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <circle cx="12" cy="4.5" r="2.5"/>
                            <path d="M7 9h10M12 7v14M8 21l4-7 4 7M7 10l-3 5M17 10l3 5"/>
                        </svg>
                    </div>
                    <div>
                        <h3>Explore Body Systems</h3>
                        <p>Discover different systems of the human body, including the skeletal, cardiovascular, nervous, and muscular systems.</p>
                    </div>
                </article>

                <article class="about-feature-card">
                    <div class="about-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="M12 6C9 3.5 5 4 3 5v15c3-1.5 6-1.5 9 1 3-2.5 6-2.5 9-1V5c-2-1-6-1.5-9 1Z"/>
                            <path d="M12 6v15"/>
                        </svg>
                    </div>
                    <div>
                        <h3>Study Lessons</h3>
                        <p>Access organized anatomy lessons to understand important structures and functions of the human body.</p>
                    </div>
                </article>

                <article class="about-feature-card">
                    <div class="about-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <circle cx="12" cy="12" r="9"/>
                            <path d="m10 8 6 4-6 4z"/>
                        </svg>
                    </div>
                    <div>
                        <h3>Watch Educational Videos</h3>
                        <p>Support your learning through videos that help explain anatomy topics in a visual and engaging way.</p>
                    </div>
                </article>

                <article class="about-feature-card">
                    <div class="about-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="M7 3h8l5 5v13H7z"/>
                            <path d="M15 3v5h5M10 13h7M10 17h7M10 9h1"/>
                        </svg>
                    </div>
                    <div>
                        <h3>Test Your Knowledge</h3>
                        <p>Complete quizzes to review what you have learned and evaluate your understanding of anatomy.</p>
                    </div>
                </article>

                <article class="about-feature-card">
                    <div class="about-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <path d="M4 20V12h4v8zM10 20V7h4v13zM16 20V3h4v17z"/>
                        </svg>
                    </div>
                    <div>
                        <h3>Track Your Progress</h3>
                        <p>Earn experience points, progress through levels, and view your learning achievements.</p>
                    </div>
                </article>

                <article class="about-feature-card">
                    <div class="about-icon" aria-hidden="true">
                        <svg viewBox="0 0 24 24">
                            <circle cx="9" cy="8" r="3"/>
                            <circle cx="17" cy="9" r="2.5"/>
                            <path d="M3 20v-2a6 6 0 0 1 12 0v2zM15 14a5 5 0 0 1 6 5v1h-4"/>
                        </svg>
                    </div>
                    <div>
                        <h3>Join Discussions</h3>
                        <p>Share ideas, ask questions, and interact with other students through the discussion section.</p>
                    </div>
                </article>

            </div>
        </section>

        <!-- PURPOSE -->
        <section class="about-purpose">

            <div class="about-purpose-image" role="img"
                aria-label="Anatomical heart illustration highlighting learning and understanding">
            </div>

            <div class="about-purpose-text">
                <h2>Our Purpose</h2>
                <p>
                    AnatoXplore aims to make anatomy education more accessible and
                    enjoyable by combining learning materials, interactive quizzes,
                    and progress tracking in a single platform. It encourages students
                    to become more active in their learning and build a stronger
                    understanding of human anatomy.
                </p>
            </div>

        </section>

        <!-- PLATFORM BENEFITS -->
        <section class="about-benefits">

            <div class="about-benefit">
                <div class="about-benefit-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24">
                        <path d="m2 8 10-5 10 5-10 5zM6 10v6c4 3 8 3 12 0v-6M22 8v7"/>
                    </svg>
                </div>
                <div>
                    <h3>All in One Place</h3>
                    <p>Lessons, videos, quizzes, and discussions</p>
                </div>
            </div>

            <div class="about-benefit">
                <div class="about-benefit-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24">
                        <path d="m13 2-9 12h7l-1 8 10-13h-7z"/>
                    </svg>
                </div>
                <div>
                    <h3>Interactive Learning</h3>
                    <p>Visual and engaging educational resources</p>
                </div>
            </div>

            <div class="about-benefit">
                <div class="about-benefit-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24">
                        <circle cx="12" cy="7" r="3"/>
                        <circle cx="5" cy="10" r="2"/>
                        <circle cx="19" cy="10" r="2"/>
                        <path d="M6 21v-2a6 6 0 0 1 12 0v2zM1 20v-2a4 4 0 0 1 4-4M23 20v-2a4 4 0 0 0-4-4"/>
                    </svg>
                </div>
                <div>
                    <h3>Student Community</h3>
                    <p>Connect and learn together</p>
                </div>
            </div>

            <div class="about-benefit">
                <div class="about-benefit-icon" aria-hidden="true">
                    <svg viewBox="0 0 24 24">
                        <path d="M3 20v-7h4v7zM10 20V8h4v12zM17 20V3h4v17z"/>
                    </svg>
                </div>
                <div>
                    <h3>Track Your Growth</h3>
                    <p>Monitor your progress and achievements</p>
                </div>
            </div>

        </section>

        <!-- CALL TO ACTION -->
        <section class="about-ending">
            <div class="about-ending-content">
                <h2>Start Exploring!</h2>
                <p>Learn, practise, and discover the human body with AnatoXplore.</p>
                <a href="<%= ResolveUrl("~/Default.aspx") %>" class="about-cta-button">
                    Explore Topics
                </a>
            </div>
        </section>

    </main>

    <style>
        /* ABOUT PAGE */
        .about-page {
            width: min(1100px, calc(100% - 40px));
            margin: 18px auto 24px;
            color: #294361;
            font-family: inherit;
            box-sizing: border-box;
        }

        .about-page *,
        .about-page *::before,
        .about-page *::after {
            box-sizing: border-box;
        }

        .about-page h2,
        .about-page h3,
        .about-page p {
            margin-top: 0;
        }

        .about-page h2 {
            color: #123762;
            font-size: 23px;
            font-weight: 750;
            line-height: 1.3;
            margin-bottom: 10px;
        }

        .about-page p {
            font-size: 13px;
            line-height: 1.75;
            margin-bottom: 0;
        }

        /* HERO IMAGE */
        .about-hero {
            width: 100%;
            aspect-ratio: 3.7 / 1;
            min-height: 190px;
            max-height: 270px;
            margin-bottom: 28px;
            border-radius: 10px;
            background-color: #dceeff;
            background-image: url('Images/about-hero.png');
            background-repeat: no-repeat;
            background-position: center;
            background-size: cover;
            overflow: hidden;
        }

        /* INTRODUCTION */
        .about-intro {
            margin-bottom: 32px;
        }

        /* FEATURE CARDS */
        .about-features {
            margin-bottom: 30px;
        }

        .about-features > h2 {
            margin-bottom: 12px;
        }

        .about-feature-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
        }

        .about-feature-card {
            display: flex;
            align-items: flex-start;
            gap: 16px;
            min-width: 0;
            min-height: 112px;
            padding: 16px;
            background: #fff;
            border: 1px solid #e0eaf5;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(24, 67, 110, 0.045);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .about-feature-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 7px 18px rgba(24, 67, 110, 0.09);
        }

        .about-icon,
        .about-benefit-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            width: 52px;
            height: 52px;
            color: #087ce5;
            background: #e5f2ff;
            border-radius: 50%;
        }

        .about-icon svg,
        .about-benefit-icon svg {
            width: 27px;
            height: 27px;
            fill: none;
            stroke: currentColor;
            stroke-width: 2;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .about-feature-card h3 {
            color: #164b83;
            font-size: 13px;
            font-weight: 750;
            line-height: 1.4;
            margin: 5px 0 6px;
        }

        .about-feature-card p {
            font-size: 12px;
            line-height: 1.65;
            color: #3e5877;
        }

        /* PURPOSE SECTION */
        .about-purpose {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            align-items: center;
            gap: 32px;
            margin-bottom: 20px;
        }

        .about-purpose-image {
            width: 100%;
            aspect-ratio: 2.65 / 1;
            min-height: 150px;
            border-radius: 9px;
            background-color: #d9edff;
            background-image: url('Images/about-purpose.png');
            background-repeat: no-repeat;
            background-position: center;
            background-size: cover;
            overflow: hidden;
        }

        .about-purpose-text {
            padding: 4px 0;
        }

        .about-purpose-text h2 {
            margin-bottom: 10px;
        }

        .about-purpose-text p {
            font-size: 13px;
            line-height: 1.75;
        }

        /* BENEFITS STRIP */
        .about-benefits {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            align-items: center;
            margin-bottom: 12px;
            padding: 16px 10px;
            background: linear-gradient(110deg, #f7fbff, #fff);
            border: 1px solid #e0eaf5;
            border-radius: 10px;
        }

        .about-benefit {
            display: flex;
            align-items: center;
            gap: 12px;
            min-width: 0;
            padding: 0 12px;
        }

        .about-benefit + .about-benefit {
            border-left: 1px solid #d7e3f0;
        }

        .about-benefit-icon {
            width: 46px;
            height: 46px;
        }

        .about-benefit-icon svg {
            width: 26px;
            height: 26px;
        }

        .about-benefit h3 {
            color: #123c70;
            font-size: 12px;
            font-weight: 750;
            line-height: 1.4;
            margin: 0 0 4px;
        }

        .about-benefit p {
            color: #49617e;
            font-size: 11px;
            line-height: 1.5;
        }

        /* START EXPLORING BANNER */
        .about-ending {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 132px;
            padding: 16px 20px;
            overflow: hidden;
            text-align: center;
            color: #fff;
            background-color: #07345f;
            background-image:
                linear-gradient(90deg, rgba(4, 43, 80, 0.18), rgba(4, 43, 80, 0.08)),
                url('Images/about-cta-bg.png');
            background-repeat: no-repeat;
            background-position: center;
            background-size: cover;
            border: 1px solid rgba(133, 192, 241, 0.35);
            border-radius: 10px;
        }

        .about-ending-content {
            position: relative;
            z-index: 1;
        }

        .about-ending h2 {
            color: #fff;
            font-size: 21px;
            margin-bottom: 5px;
        }

        .about-ending p {
            color: #fff;
            font-size: 12px;
            margin-bottom: 10px;
        }

        .about-cta-button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 145px;
            min-height: 34px;
            padding: 8px 20px;
            color: #123762 !important;
            background: #fff;
            border: 1px solid #d7e8fa;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 750;
            text-decoration: none !important;
            transition: background-color 0.2s ease, transform 0.2s ease;
        }

        .about-cta-button:hover {
            color: #0759a4 !important;
            background: #eaf5ff;
            transform: translateY(-1px);
        }

        /* TABLET */
        @media (max-width: 900px) {
            .about-feature-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .about-purpose {
                grid-template-columns: 1fr 1fr;
                gap: 22px;
            }

            .about-benefits {
                grid-template-columns: repeat(2, minmax(0, 1fr));
                row-gap: 18px;
            }

            .about-benefit:nth-child(3) {
                border-left: none;
            }
        }

        /* MOBILE */
        @media (max-width: 600px) {
            .about-page {
                width: calc(100% - 28px);
                margin-top: 14px;
                margin-bottom: 20px;
            }

            .about-hero {
                aspect-ratio: 2.2 / 1;
                min-height: 150px;
                margin-bottom: 24px;
                background-position: 57% center;
            }

            .about-page h2 {
                font-size: 21px;
            }

            .about-page p {
                font-size: 13px;
            }

            .about-intro {
                margin-bottom: 26px;
            }

            .about-features {
                margin-bottom: 26px;
            }

            .about-feature-grid {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .about-feature-card {
                min-height: 0;
                padding: 15px;
            }

            .about-purpose {
                grid-template-columns: 1fr;
                gap: 16px;
                margin-bottom: 20px;
            }

            .about-purpose-image {
                aspect-ratio: 2.3 / 1;
                min-height: 130px;
            }

            .about-benefits {
                grid-template-columns: 1fr;
                gap: 16px;
                padding: 16px;
            }

            .about-benefit {
                padding: 0;
                border-left: none !important;
            }

            .about-ending {
                min-height: 150px;
                padding: 20px 12px;
                background-position: center;
            }

            .about-ending h2 {
                font-size: 21px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .about-feature-card,
            .about-cta-button {
                transition: none;
            }
        }
    </style>

</asp:Content>