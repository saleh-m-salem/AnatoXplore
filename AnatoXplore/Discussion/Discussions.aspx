<%@ Page Title="Discussions | AnatoXplore"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="Discussions.aspx.cs"
    Inherits="AnatoXplore.Discussions" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

    <style>
        /* PAGE */
        .disc-page {
            min-height: 100vh;
            width: 100%;
            padding: 40px 20px 20px;
            box-sizing: border-box;
            background-image: url('/Images/anatomy-background.png');
            background-position: center center;
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .disc-card {
            max-width: 960px;
            margin: 0 auto;
            padding: 32px;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 5px 25px rgba(25, 57, 90, 0.10);
        }

        /* HEADER */
        .disc-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 22px;
        }

        .disc-header h1 {
            margin: 0 0 6px;
            color: #142c4d;
            font-size: 28px;
            font-weight: 700;
        }

        .disc-subtitle {
            margin: 0;
            color: #65758b;
            font-size: 15px;
        }

        .disc-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 11px 20px;
            border: none;
            border-radius: 8px;
            background: #1674df;
            color: #ffffff;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            white-space: nowrap;
            cursor: pointer;
        }

        .disc-btn:hover {
            background: #0d60c2;
            color: #ffffff;
        }

        /* MESSAGES */
        .disc-alert {
            display: block;
            margin-bottom: 18px;
            padding: 12px 16px;
            border-radius: 8px;
            background: #e9f8ef;
            color: #1e7a45;
            font-size: 14px;
        }

        .disc-note {
            margin-bottom: 18px;
            padding: 12px 16px;
            border-radius: 8px;
            background: #f3f8ff;
            color: #35506e;
            font-size: 14px;
        }

        .disc-note a {
            color: #1674df;
            font-weight: 600;
        }

        /* SEARCH BOX */
        .disc-tools {
            display: flex;
            gap: 10px;
            margin-bottom: 16px;
        }

        .disc-search {
            position: relative;
            flex: 1;
            min-width: 0;
        }

        .disc-search i {
            position: absolute;
            top: 50%;
            left: 15px;
            transform: translateY(-50%);
            color: #8a9bb0;
            font-size: 15px;
        }

        .disc-input {
            width: 100%;
            max-width: none;
            height: 44px;
            padding: 0 14px 0 42px;
            border: 1px solid #d7e1ed;
            border-radius: 10px;
            background: #f8fbff;
            color: #183153;
            font-size: 14px;
            font-family: inherit;
            box-sizing: border-box;
        }

        .disc-input:focus {
            outline: none;
            border-color: #1674df;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(22, 116, 223, 0.15);
        }

        .disc-btn-outline {
            height: 44px;
            padding: 0 20px;
            border: 1px solid #1674df;
            border-radius: 10px;
            background: #ffffff;
            color: #1674df;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .disc-btn-outline:hover {
            background: #eaf4ff;
        }

        /* TOPIC CHIPS */
        .disc-topics {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 8px;
            margin-bottom: 18px;
        }

        .disc-topics-label {
            margin-right: 4px;
            color: #687c91;
            font-size: 13px;
            font-weight: 600;
        }

        .disc-chip {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 14px;
            border: 1px solid #d7e1ed;
            border-radius: 20px;
            background: #ffffff;
            color: #142c4d;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
            transition: all 0.15s;
        }

        .disc-chip:hover {
            border-color: #142c4d;
            color: #142c4d;
        }

        .disc-chip.active {
            border-color: #142c4d;
            background: #142c4d;
            color: #ffffff;
        }

        .disc-chip.active i {
            color: #ffffff !important;
        }

        /* RESULT COUNT + SORT TABS */
        .disc-toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 12px;
            padding-top: 16px;
            margin-bottom: 12px;
            border-top: 1px solid #edf1f5;
        }

        .disc-count-text {
            margin: 0;
            color: #687c91;
            font-size: 13px;
        }

        .disc-clear {
            margin-left: 10px;
            color: #1674df;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
        }

        .disc-clear:hover {
            text-decoration: underline;
        }

        .disc-sort {
            display: inline-flex;
            flex-wrap: wrap;
            gap: 2px;
            padding: 4px;
            border-radius: 10px;
            background: #f1f5fa;
        }

        .disc-sort-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 13px;
            border-radius: 8px;
            color: #4a5f78;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.15s;
        }

        .disc-sort-btn:hover {
            color: #1674df;
        }

        .disc-sort-btn.active {
            background: #ffffff;
            color: #1674df;
            box-shadow: 0 1px 4px rgba(25, 57, 90, 0.15);
        }

        /* DISCUSSION LIST (scrolls inside the card) */
        .disc-list {
            max-height: 520px;
            overflow-y: auto;
            border-top: 1px solid #edf1f5;
            border-bottom: 1px solid #edf1f5;
        }

        .disc-list::-webkit-scrollbar {
            width: 8px;
        }

        .disc-list::-webkit-scrollbar-thumb {
            background: #c9d8e8;
            border-radius: 10px;
        }

        .disc-list::-webkit-scrollbar-thumb:hover {
            background: #9fb8d2;
        }

        .disc-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 10px;
            border-bottom: 1px solid #edf1f5;
            color: inherit;
            text-decoration: none;
        }

        .disc-item:last-child {
            border-bottom: none;
        }

        .disc-item:hover {
            background: #f7fbff;
        }

        .disc-avatar {
            flex-shrink: 0;
            overflow: hidden;
            width: 42px;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            font-size: 14px;
            font-weight: 700;
        }

        .disc-body {
            flex: 1;
            min-width: 0;
        }

        .disc-title {
            display: block;
            margin-bottom: 5px;
            color: #142c4d;
            font-size: 16px;
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .disc-item:hover .disc-title {
            color: #1674df;
        }

        .disc-meta {
            color: #687c91;
            font-size: 13px;
        }

        .disc-topic {
            display: inline-block;
            margin-left: 6px;
            padding: 2px 9px;
            border-radius: 20px;
            background: #142c4d;
            color: #ffffff;
            font-size: 12px;
            font-weight: 700;
        }

        .disc-topic i {
            display: none;
        }

        .disc-replies {
            flex-shrink: 0;
            color: #1674df;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
        }

        .disc-noreply {
            flex-shrink: 0;
            color: #1674df;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
        }

        .disc-empty {
            padding: 45px 20px;
            text-align: center;
            color: #687c91;
        }

        .disc-empty i {
            display: block;
            margin-bottom: 12px;
            color: #b9cce0;
            font-size: 38px;
        }

        /* RESPONSIVE (phones) */
        @media (max-width: 650px) {
            .disc-card {
                padding: 22px 18px;
            }

            .disc-header {
                flex-direction: column;
            }

            .disc-toolbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .disc-item {
                gap: 12px;
                padding: 15px 4px;
            }

            .disc-avatar {
                width: 36px;
                height: 36px;
                font-size: 12px;
            }

            .disc-list {
                max-height: none;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">

    <div class="disc-page">
        <section class="disc-card">

            <!-- PAGE HEADER -->
            <div class="disc-header">
                <div>
                    <h1>Discussions</h1>
                    <p class="disc-subtitle">
                        Ask anatomy questions and learn together with other students.
                    </p>
                </div>

                <asp:HyperLink ID="lnkNewPost" runat="server" CssClass="disc-btn">
                    <i class="fa-solid fa-plus"></i> New Post
                </asp:HyperLink>
            </div>

            <!-- SUCCESS MESSAGE (after create / update / delete) -->
            <asp:Label ID="lblStatus" runat="server"
                CssClass="disc-alert" Visible="false" />

            <!-- NOTE FOR GUESTS -->
            <asp:Panel ID="pnlGuestNote" runat="server"
                CssClass="disc-note" Visible="false">
                You are browsing as a guest.
                <a href="<%= ResolveUrl("~/Login.aspx") %>">Log in</a> or
                <a href="<%= ResolveUrl("~/Register.aspx") %>">register</a>
                to create posts and reply to other students.
            </asp:Panel>

            <!-- SEARCH BOX (Enter key runs the search) -->
            <asp:Panel ID="pnlSearch" runat="server"
                CssClass="disc-tools" DefaultButton="btnSearch">

                <div class="disc-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <asp:TextBox ID="txtSearch" runat="server"
                        CssClass="disc-input" MaxLength="100"
                        placeholder="Search discussions..." />
                </div>

                <asp:Button ID="btnSearch" runat="server"
                    Text="Search" CssClass="disc-btn-outline"
                    CausesValidation="false" OnClick="btnSearch_Click" />
            </asp:Panel>

            <!-- TOPIC CHIPS (click again to remove the topic filter) -->
            <div class="disc-topics">
                <span class="disc-topics-label">Topics:</span>

                <asp:Repeater ID="rptTopics" runat="server">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnTopic" runat="server"
                            CssClass='<%# GetTopicChipClass(Eval("SystemID")) %>'
                            CommandArgument='<%# Eval("SystemID") %>'
                            OnCommand="Topic_Command"
                            CausesValidation="false">
                            <%#: GetShortTopicName(Eval("SystemName")) %>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- RESULT COUNT, CLEAR LINK AND SORT TABS -->
            <div class="disc-toolbar">
                <div>
                    <span class="disc-count-text">
                        <asp:Literal ID="litResultCount" runat="server" />
                    </span>

                    <asp:LinkButton ID="btnClear" runat="server"
                        CssClass="disc-clear" Visible="false"
                        CausesValidation="false" OnClick="btnClear_Click">
                        <i class="fa-solid fa-xmark"></i> Clear filters
                    </asp:LinkButton>
                </div>

                <!-- Click a tab again to turn it off -->
                <div class="disc-sort">
                    <asp:LinkButton ID="btnNewest" runat="server"
                        CommandArgument="newest" OnCommand="Filter_Command"
                        CausesValidation="false">
                        <i class="fa-regular fa-clock"></i> Newest
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnMostReplies" runat="server"
                        CommandArgument="replies" OnCommand="Filter_Command"
                        CausesValidation="false">
                        <i class="fa-solid fa-fire"></i> Most replies
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnUnanswered" runat="server"
                        CommandArgument="unanswered" OnCommand="Filter_Command"
                        CausesValidation="false">
                        <i class="fa-regular fa-circle-question"></i> Unanswered
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnMyPosts" runat="server"
                        CommandArgument="mine" OnCommand="Filter_Command"
                        CausesValidation="false">
                        <i class="fa-regular fa-user"></i> My posts
                    </asp:LinkButton>
                </div>
            </div>

            <!-- LIST OF DISCUSSIONS -->
            <div class="disc-list">
                <asp:Repeater ID="rptDiscussions" runat="server">
                    <ItemTemplate>
                        <a class="disc-item"
                           href='<%# ResolveUrl("~/Discussion/DiscussionDetails.aspx?id=" + Eval("DiscussionID")) %>'>

                            <%# AnatoXplore.ProfileBadgeRenderer.Render(Eval("AuthorPhotoPath"), Eval("AuthorFrameKey"), Eval("AuthorName"), "disc-avatar") %>

                            <span class="disc-body">
                                <span class="disc-title"><%#: Eval("Title") %></span>
                                <span class="disc-meta">
                                    <%#: Eval("AuthorName") %>
                                    &bull; <%# GetTimeAgo(Eval("CreatedAt")) %>
                                    <%# GetTopicBadge(Eval("SystemName")) %>
                                </span>
                            </span>

                            <%# GetRepliesBadge(Eval("ReplyCount")) %>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- SHOWN WHEN THERE ARE NO POSTS -->
                <asp:Panel ID="pnlEmpty" runat="server"
                    CssClass="disc-empty" Visible="false">
                    <i class="fa-regular fa-comments"></i>
                    <asp:Literal ID="litEmpty" runat="server" />
                </asp:Panel>
            </div>

        </section>
    </div>
</asp:Content>