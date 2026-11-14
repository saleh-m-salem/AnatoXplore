<%@ Page Title="Home | AnatoXplore" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AnatoXplore._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
    .anato-home {
        color: #183153;
        font-family: "Segoe UI", Arial, sans-serif;
    }

    /* HERO BANNER */
    .anato-hero {
        position: relative;
        min-height: 440px;
        border-radius: 24px;
        margin: 25px 0 45px;
        padding: 45px;
        display: flex;
        align-items: center;
        overflow: hidden;
        background:
            linear-gradient(90deg, rgba(3, 29, 62, .96) 0%,
            rgba(5, 47, 88, .88) 42%,
            rgba(5, 47, 88, .08) 100%),
            url('Images/hero-anatomy.png') center center / cover no-repeat;
    }

    .anato-hero-text {
        position: relative;
        z-index: 1;
        width: 58%;
        max-width: 650px;
        color: white;
    }

    .anato-hero .anato-eyebrow {
        color: #d8eaff;
        font-size: 15px;
        font-weight: 700;
        letter-spacing: 1px;
        margin-bottom: 18px;
    }

    .anato-hero h1 {
        color: white;
        font-size: clamp(34px, 4vw, 52px);
        font-weight: 750;
        line-height: 1.13;
        margin: 0 0 20px;
    }

    .anato-hero p {
        color: #e0ebf8;
        font-size: 17px;
        line-height: 1.75;
    }

    .anato-btn {
        display: inline-block;
        background: #079ee8;
        color: white !important;
        padding: 13px 22px;
        border-radius: 8px;
        text-decoration: none !important;
        font-weight: 650;
        margin: 8px 8px 0 0;
        text-align: center;
        transition: background .2s, transform .2s;
    }

    .anato-btn:hover {
        background: #087dc0;
        transform: translateY(-2px);
    }

    .anato-btn-secondary {
        background: white;
        color: #15558d !important;
        border: 1px solid white;
    }

    .anato-btn-secondary:hover {
        background: #eaf4ff;
    }

    /* SECTIONS */
    .anato-section {
        margin: 45px 0;
    }

    .anato-section h2,
    .anato-ready h2 {
        font-size: 30px;
        font-weight: 700;
        color: #17385e;
        margin-bottom: 10px;
    }

    .anato-subtitle {
        color: #718198;
        margin-bottom: 25px;
        line-height: 1.7;
    }

    /* SEARCH AND FILTER */
    .anato-topic-tools {
        display: flex;
        gap: 15px;
        margin-bottom: 25px;
        flex-wrap: wrap;
    }

    .anato-search,
    .anato-filter {
        padding: 13px 16px;
        border: 1px solid #dce7f2;
        border-radius: 9px;
        background: white;
        color: #183153;
        font-family: inherit;
        font-size: 15px;
        box-sizing: border-box;
    }

    .anato-search {
        flex: 1 1 300px;
        min-width: 0;
    }

    .anato-filter {
        flex: 0 1 230px;
        cursor: pointer;
    }

    .anato-search:focus,
    .anato-filter:focus {
        outline: none;
        border-color: #1769aa;
        box-shadow: 0 0 0 3px rgba(23, 105, 170, .1);
    }

    /* TOPIC CARDS */
    .anato-topic-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 22px;
        align-items: stretch;
    }

    .anato-card {
        background: white;
        border: 1px solid #e0eaf3;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 5px 18px rgba(27, 68, 105, .06);
        transition: transform .2s, box-shadow .2s;
        min-width: 0;
        display: flex;
        flex-direction: column;
    }

    .anato-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 25px rgba(27, 68, 105, .12);
    }

    .anato-card img {
        display: block;
        width: 100%;
        height: 190px;
        object-fit: contain;
        object-position: center;
        background: #fff;
        padding: 8px;
        box-sizing: border-box;
    }

    .anato-card-content {
        padding: 16px;
        display: flex;
        flex-direction: column;
        flex: 1;
    }

    .anato-card h3 {
        color: #17385e;
        font-size: 19px;
        font-weight: 700;
        margin: 0 0 7px;
    }

    .anato-card p {
        color: #687c91;
        line-height: 1.55;
        margin: 0 0 15px;
        flex: 1;
    }

    /* BLUE TOPIC BUTTONS */
    .anato-topic-button {
        display: block;
        width: 100%;
        box-sizing: border-box;
        background: #dceeff;
        color: #0875d1 !important;
        border: none;
        border-radius: 7px;
        padding: 11px 12px;
        text-align: center;
        text-decoration: none !important;
        font-size: 14px;
        font-weight: 650;
        margin-top: auto;
        transition: background .2s;
    }

    .anato-topic-button:hover {
        background: #c7e3ff;
    }

    .anato-topic-button.locked {
        background: #edf1f5;
        color: #60748b !important;
    }

    .anato-topic-button.locked:hover {
        background: #e0e8f0;
    }

    /* ACCESS LABELS */
    .anato-access-label {
        display: inline-flex;
        align-items: center;
        align-self: flex-start;
        gap: 6px;
        border-radius: 5px;
        padding: 5px 9px;
        margin-top: 7px;
        font-size: 12px;
        line-height: 1.2;
    }

    .anato-access-label.free {
        background: #dff8e9;
        color: #16834a;
    }

    .anato-access-label.locked-label {
        background: #ffebeb;
        color: #d51e1e;
    }

    .anato-access-label i {
        font-size: 11px;
    }

    .anato-no-results {
        display: none;
        background: #f4f9ff;
        padding: 25px;
        border-radius: 12px;
        text-align: center;
        color: #526981;
        margin-top: 15px;
    }

    /* LEARNING FEATURES */
    .anato-features {
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 20px;
    }

    .anato-feature {
        padding: 25px;
        background: #f3f8ff;
        border-radius: 18px;
        border: 1px solid #e1edfb;
    }

    .anato-feature .feature-icon {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: #dceeff;
        color: #0875e1;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 21px;
        margin-bottom: 16px;
    }

    .anato-feature h3 {
        font-size: 19px;
        font-weight: 700;
        color: #17385e;
        margin-bottom: 10px;
    }

    .anato-feature p {
        color: #687c91;
        line-height: 1.6;
        margin-bottom: 0;
    }

    /* READY TO EXPLORE */
    .anato-ready {
        text-align: center;
        background: #edf6ff;
        padding: 40px 20px;
        border-radius: 20px;
        margin: 45px 0;
    }

    .anato-ready .anato-subtitle {
        margin-bottom: 18px;
    }

    @media (max-width: 900px) {
        .anato-hero {
            padding: 35px 28px;
        }

        .anato-hero-text {
            width: 75%;
        }

        .anato-topic-grid {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }

        .anato-features {
            grid-template-columns: repeat(2, minmax(0, 1fr));
        }
    }

    @media (max-width: 550px) {
        .anato-hero {
            padding: 28px 20px;
            border-radius: 18px;
            min-height: 400px;
            background-position: 65% center;
        }

        .anato-hero-text {
            width: 100%;
        }

        .anato-hero h1 {
            font-size: 34px;
        }

        .anato-hero p {
            font-size: 15px;
        }

        .anato-topic-grid,
        .anato-features {
            grid-template-columns: 1fr;
        }

        .anato-filter {
            flex: 1 1 100%;
        }

        .anato-section h2,
        .anato-ready h2 {
            font-size: 26px;
        }
    }
</style>

<!-- Font Awesome icons for the learning feature tiles -->
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

<div class="anato-home">

    <!-- HERO BANNER -->
    <section class="anato-hero">

        <div class="anato-hero-text">
            <p class="anato-eyebrow">YOUR INTERACTIVE ANATOMY LEARNING PLATFORM</p>

            <h1>
                Explore the Human Body.<br />
                Learn. Practice. Achieve.
            </h1>

            <p>
                Discover human anatomy through visual learning, interactive
                flashcards, educational videos and quizzes designed to help
                medical students understand and revise each body system.
            </p>

            <a href="#topics" class="anato-btn">Explore Topics &#8594;</a>

            <a href="<%= ResolveUrl("~/Learning/Skeletal.aspx") %>"
               class="anato-btn anato-btn-secondary">Try Demo</a>
        </div>

    </section>

    <!-- ANATOMY TOPICS -->
    <section class="anato-section" id="topics">

        <h2>Explore Body Systems</h2>

        <p class="anato-subtitle">
            Choose a body system and start exploring its structures and functions.
        </p>

        <!-- SEARCH AND FILTER -->
        <div class="anato-topic-tools">

            <input type="search"
                   id="anatoSearch"
                   class="anato-search"
                   placeholder="Search topics..."
                   aria-label="Search anatomy topics" />

            <select id="anatoFilter"
                    class="anato-filter"
                    aria-label="Filter by body system">
                <option value="all">All Systems</option>
                <option value="skeletal">Skeletal System</option>
                <option value="cardiovascular">Cardiovascular System</option>
                <option value="nervous">Nervous System</option>
                <option value="muscular">Muscular System</option>
            </select>

        </div>

        <div class="anato-topic-grid" id="anatoTopicGrid">

            <!-- SKELETAL SYSTEM: FREE DEMO -->
            <article class="anato-card"
                     data-system="skeletal"
                     data-title="skeletal system bones joints skeleton">

                <img src="Images/skeletal-system.png"
                     alt="Human skeletal system" />

                <div class="anato-card-content">
                    <h3>Skeletal System</h3>

                    <p>Learn about bones and structure.</p>

                    <a class="anato-topic-button"
                       href="<%= ResolveUrl("~/Learning/Skeletal.aspx") %>">
                        View Topic
                    </a>

                    <span class="anato-access-label free">
                        <i class="fa-solid fa-lock-open"></i>
                        Free Access
                    </span>
                </div>
            </article>

            <!-- CARDIOVASCULAR SYSTEM: LOGIN REQUIRED -->
            <article class="anato-card"
                     data-system="cardiovascular"
                     data-title="cardiovascular system heart blood vessels circulation">

                <img src="Images/heart.png"
                     alt="Human heart and blood vessels" />

                <div class="anato-card-content">
                    <h3>Cardiovascular System</h3>

                    <p>Explore the heart and blood vessels.</p>

                    <a class="anato-topic-button <%= Session["UserID"] == null ? "locked" : "" %>"
                       href="<%= Session["UserID"] == null ? ResolveUrl("~/Login.aspx") + "?returnUrl=" + Server.UrlEncode(ResolveUrl("~/Learning/Cardiovascular.aspx")) : ResolveUrl("~/Learning/Cardiovascular.aspx") %>">
                        <%= Session["UserID"] == null ? "View Topic" : "Open Lesson" %>
                    </a>

                    <span class="anato-access-label <%= Session["UserID"] == null ? "locked-label" : "free" %>">
                        <i class="fa-solid <%= Session["UserID"] == null ? "fa-lock" : "fa-lock-open" %>"></i>
                        <%= Session["UserID"] == null ? "Login Required" : "Available" %>
                    </span>
                </div>
            </article>

            <!-- NERVOUS SYSTEM: LOGIN REQUIRED -->
            <article class="anato-card"
                     data-system="nervous"
                     data-title="nervous system brain spinal cord nerves">

                <img src="Images/brain.png"
                     alt="Human brain and nervous system" />

                <div class="anato-card-content">
                    <h3>Nervous System</h3>

                    <p>Learn about the brain and nervous system.</p>

                    <a class="anato-topic-button <%= Session["UserID"] == null ? "locked" : "" %>"
                       href="<%= Session["UserID"] == null ? ResolveUrl("~/Login.aspx") + "?returnUrl=" + Server.UrlEncode(ResolveUrl("~/Learning/Nervous.aspx")) : ResolveUrl("~/Learning/Nervous.aspx") %>">
                        <%= Session["UserID"] == null ? "View Topic" : "Open Lesson" %>
                    </a>

                    <span class="anato-access-label <%= Session["UserID"] == null ? "locked-label" : "free" %>">
                        <i class="fa-solid <%= Session["UserID"] == null ? "fa-lock" : "fa-lock-open" %>"></i>
                        <%= Session["UserID"] == null ? "Login Required" : "Available" %>
                    </span>
                </div>
            </article>

            <!-- MUSCULAR SYSTEM: LOGIN REQUIRED -->
            <article class="anato-card"
                     data-system="muscular"
                     data-title="muscular system muscles movement">

                <img src="Images/muscular-system.png"
                     alt="Human muscular system" />

                <div class="anato-card-content">
                    <h3>Muscular System</h3>

                    <p>Discover muscles and body movement.</p>

                    <a class="anato-topic-button <%= Session["UserID"] == null ? "locked" : "" %>"
                       href="<%= Session["UserID"] == null ? ResolveUrl("~/Login.aspx") + "?returnUrl=" + Server.UrlEncode(ResolveUrl("~/Learning/Muscular.aspx")) : ResolveUrl("~/Learning/Muscular.aspx") %>">
                        <%= Session["UserID"] == null ? "View Topic" : "Open Lesson" %>
                    </a>

                    <span class="anato-access-label <%= Session["UserID"] == null ? "locked-label" : "free" %>">
                        <i class="fa-solid <%= Session["UserID"] == null ? "fa-lock" : "fa-lock-open" %>"></i>
                        <%= Session["UserID"] == null ? "Login Required" : "Available" %>
                    </span>
                </div>
            </article>

        </div>

        <div class="anato-no-results" id="anatoNoResults">
            No anatomy topics match your search. Try another keyword or system.
        </div>

    </section>

    <!-- LEARNING FEATURES -->
    <section class="anato-section">

        <h2>Learn in Your Own Way</h2>

        <p class="anato-subtitle">
            Build your understanding with different learning activities.
        </p>

        <div class="anato-features">

            <div class="anato-feature">
                <div class="feature-icon">
                    <i class="fa-regular fa-image" aria-hidden="true"></i>
                </div>
                <h3>Visual Learning</h3>
                <p>Study anatomy illustrations, structures and explanations.</p>
            </div>

            <div class="anato-feature">
                <div class="feature-icon">
                    <i class="fa-regular fa-rectangle-list" aria-hidden="true"></i>
                </div>
                <h3>Practice Quizzes</h3>
                <p>Test your knowledge and identify topics to revise.</p>
            </div>

            <div class="anato-feature">
                <div class="feature-icon">
                    <i class="fa-solid fa-chart-line" aria-hidden="true"></i>
                </div>
                <h3>Track Progress</h3>
                <p>Monitor completed topics and follow your learning progress.</p>
            </div>

            <div class="anato-feature">
                <div class="feature-icon">
                    <i class="fa-solid fa-users" aria-hidden="true"></i>
                </div>
                <h3>Student Community</h3>
                <p>Share questions, discuss anatomy and learn with other students.</p>
            </div>

        </div>

    </section>

    <!-- READY TO EXPLORE -->
    <section class="anato-ready">

        <h2>Ready to Explore Anatomy?</h2>

        <p class="anato-subtitle">
            Start learning, practise your knowledge and track your progress.
        </p>

        <a href="<%= ResolveUrl("~/Register.aspx") %>" class="anato-btn">
    Start Learning &#8594;
        </a>

    </section>

</div>

<!-- SEARCH AND FILTER FUNCTIONALITY -->
<script>
// @ts-nocheck
(function () {
    var searchBox = document.getElementById("anatoSearch");
    var filterBox = document.getElementById("anatoFilter");
    var cards = document.querySelectorAll("#anatoTopicGrid .anato-card");
    var noResults = document.getElementById("anatoNoResults");

    function filterTopics() {
        var searchText = searchBox.value.toLowerCase().trim();
        var selectedSystem = filterBox.value;
        var visibleCount = 0;

        cards.forEach(function (card) {
            var title = card.getAttribute("data-title").toLowerCase();
            var system = card.getAttribute("data-system").toLowerCase();

            var matchesSearch = title.indexOf(searchText) !== -1;
            var matchesSystem =
                selectedSystem === "all" || system === selectedSystem;

            if (matchesSearch && matchesSystem) {
                card.style.display = "";
                visibleCount++;
            } else {
                card.style.display = "none";
            }
        });

        noResults.style.display = visibleCount === 0 ? "block" : "none";
    }

    searchBox.addEventListener("input", filterTopics);
    filterBox.addEventListener("change", filterTopics);
})();
</script>

</asp:Content>