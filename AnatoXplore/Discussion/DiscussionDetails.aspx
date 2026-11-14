<%@ Page Title="Discussion | AnatoXplore"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="DiscussionDetails.aspx.cs"
    Inherits="AnatoXplore.DiscussionDetails"
    UnobtrusiveValidationMode="None" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

    <style>
        /* PAGE */
        .dd-page {
            min-height: 100vh;
            padding: 40px 20px 20px;
            box-sizing: border-box;
            background-image: url('/Images/anatomy-background.png');
            background-position: center center;
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .dd-wrap {
            max-width: 860px;
            margin: 0 auto;
        }

        .dd-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 14px;
            color: #35506e;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
        }

        .dd-back:hover {
            color: #1674df;
        }

        .dd-card {
            margin-bottom: 20px;
            padding: 30px 32px;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 5px 25px rgba(25, 57, 90, 0.10);
        }

        /* MESSAGES */
        .dd-alert {
            display: block;
            margin-bottom: 16px;
            padding: 12px 16px;
            border-radius: 8px;
            background: #e9f8ef;
            color: #1e7a45;
            font-size: 14px;
        }

        .dd-alert.error {
            background: #fdecec;
            color: #a12b2b;
        }

        /* POST */
        .dd-post-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            margin-bottom: 14px;
        }

        .dd-topic {
            display: inline-block;
            margin-left: 6px;
            padding: 3px 11px;
            border-radius: 20px;
            background: #142c4d;
            color: #ffffff;
            font-size: 12px;
            font-weight: 700;
        }

        .dd-topic i {
            display: none;
        }

        .dd-owner-actions {
            display: flex;
            gap: 8px;
            margin-left: auto;
        }

        .dd-action {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 13px;
            border: 1px solid #d7e1ed;
            border-radius: 8px;
            background: #ffffff;
            color: #35506e;
            font-size: 13px;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
        }

        .dd-action:hover {
            border-color: #1674df;
            color: #1674df;
        }

        .dd-action.danger:hover {
            border-color: #d64545;
            color: #c03535;
        }

        .dd-title {
            margin: 0 0 14px;
            color: #142c4d;
            font-size: 26px;
            font-weight: 700;
            line-height: 1.3;
            overflow-wrap: anywhere;
        }

        .dd-author {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
        }

        .dd-avatar {
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

        .dd-avatar.small {
            width: 36px;
            height: 36px;
            font-size: 12px;
        }

        .dd-name {
            display: block;
            color: #142c4d;
            font-size: 15px;
            font-weight: 600;
        }

        .dd-meta {
            color: #687c91;
            font-size: 13px;
        }

        .dd-edited {
            font-style: italic;
        }

        .dd-content {
            color: #2b3f57;
            font-size: 16px;
            line-height: 1.75;
            overflow-wrap: anywhere;
        }

        /* REPLIES */
        .dd-section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 6px;
            color: #142c4d;
            font-size: 19px;
            font-weight: 700;
        }

        .dd-count {
            padding: 0;
            border-radius: 0;
            background: transparent;
            color: #1674df;
            font-size: 14px;
            font-weight: 600;
        }

        .dd-reply {
            display: flex;
            gap: 14px;
            padding: 18px 0;
            border-bottom: 1px solid #edf1f5;
        }

        .dd-reply:last-child {
            border-bottom: none;
        }

        .dd-reply-body {
            flex: 1;
            min-width: 0;
        }

        .dd-reply-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 6px;
        }

        .dd-reply-head .dd-name {
            display: inline;
            margin-right: 6px;
            font-size: 14px;
        }

        .dd-reply-text {
            color: #2b3f57;
            font-size: 15px;
            line-height: 1.65;
            overflow-wrap: anywhere;
        }

        .dd-delete-reply {
            color: #8a9bb0;
            font-size: 13px;
            text-decoration: none;
        }

        .dd-delete-reply:hover {
            color: #c03535;
        }

        .dd-no-replies {
            padding: 24px 0 8px;
            color: #687c91;
            text-align: center;
        }

        /* REPLY FORM */
        .dd-form-label {
            display: block;
            margin: 6px 0 8px;
            color: #243b57;
            font-size: 14px;
            font-weight: 600;
        }

        .dd-textarea {
            width: 100%;
            max-width: none;
            min-height: 120px;
            padding: 12px 14px;
            border: 1px solid #d7e1ed;
            border-radius: 10px;
            background: #f8fbff;
            color: #183153;
            font-size: 15px;
            font-family: inherit;
            line-height: 1.6;
            box-sizing: border-box;
            resize: vertical;
        }

        .dd-textarea:focus {
            outline: none;
            border-color: #1674df;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(22, 116, 223, 0.15);
        }

        .dd-form-footer {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 12px;
            margin-top: 8px;
        }

        .dd-error {
            display: block;
            color: #c0392b;
            font-size: 13px;
        }

        .dd-counter {
            display: block;
            color: #8a9bb0;
            font-size: 12px;
        }

        .dd-counter.too-short {
            color: #b45309;
        }

        .dd-counter.ok {
            color: #1e7a45;
        }

        .dd-btn {
            height: 44px;
            padding: 0 24px;
            border: none;
            border-radius: 10px;
            background: #1674df;
            color: #ffffff;
            font-size: 15px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            white-space: nowrap;
        }

        .dd-btn:hover {
            background: #0d60c2;
        }

        .dd-login-note {
            padding: 16px;
            border-radius: 10px;
            background: #f3f8ff;
            color: #35506e;
            font-size: 14px;
            text-align: center;
        }

        .dd-login-note a {
            color: #1674df;
            font-weight: 600;
        }

        .dd-not-found {
            padding: 50px 20px;
            color: #687c91;
            text-align: center;
        }

        .dd-not-found i {
            display: block;
            margin-bottom: 12px;
            color: #b9cce0;
            font-size: 40px;
        }

        /* RESPONSIVE (phones) */
        @media (max-width: 650px) {
            .dd-card {
                padding: 22px 18px;
            }

            .dd-title {
                font-size: 22px;
            }

            .dd-post-top {
                flex-wrap: wrap;
            }

            .dd-form-footer {
                flex-direction: column;
            }

            .dd-btn {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">

    <div class="dd-page">
        <div class="dd-wrap">

            <a class="dd-back" href="<%= ResolveUrl("~/Discussion/Discussions.aspx") %>">
                <i class="fa-solid fa-arrow-left"></i> Back to discussions
            </a>

            <!-- MESSAGE AFTER EDIT / REPLY / DELETE -->
            <asp:Label ID="lblStatus" runat="server"
                CssClass="dd-alert" Visible="false" />

            <!-- SHOWN WHEN THE POST DOES NOT EXIST -->
            <asp:Panel ID="pnlNotFound" runat="server"
                CssClass="dd-card dd-not-found" Visible="false">
                <i class="fa-regular fa-face-frown"></i>
                This discussion could not be found. It may have been deleted.
            </asp:Panel>

            <asp:Panel ID="pnlDiscussion" runat="server">

                <!-- THE POST -->
                <article class="dd-card">

                    <div class="dd-post-top">
                        <asp:Literal ID="litTopic" runat="server" />

                        <!-- Only the author or an admin sees these buttons -->
                        <asp:Panel ID="pnlOwnerActions" runat="server"
                            CssClass="dd-owner-actions" Visible="false">

                            <asp:HyperLink ID="lnkEdit" runat="server" CssClass="dd-action">
                                <i class="fa-regular fa-pen-to-square"></i> Edit
                            </asp:HyperLink>

                            <asp:LinkButton ID="btnDeletePost" runat="server"
                                CssClass="dd-action danger"
                                CausesValidation="false"
                                OnClick="btnDeletePost_Click"
                                OnClientClick="return confirm('Delete this post and all of its replies?');">
                                <i class="fa-regular fa-trash-can"></i> Delete
                            </asp:LinkButton>
                        </asp:Panel>
                    </div>

                    <h1 class="dd-title">
                        <asp:Literal ID="litTitle" runat="server" />
                    </h1>

                    <div class="dd-author">
                        <asp:Literal ID="litAvatar" runat="server" />
                        <div>
                            <span class="dd-name">
                                <asp:Literal ID="litAuthor" runat="server" />
                            </span>
                            <span class="dd-meta">
                                <asp:Literal ID="litPostMeta" runat="server" />
                            </span>
                        </div>
                    </div>

                    <div class="dd-content">
                        <asp:Literal ID="litContent" runat="server" />
                    </div>
                </article>

                <!-- REPLIES -->
                <section class="dd-card" id="replies">

                    <h2 class="dd-section-title">
                        Replies
                        <span class="dd-count">
                            <asp:Literal ID="litReplyCount" runat="server" />
                        </span>
                    </h2>

                    <asp:Repeater ID="rptReplies" runat="server"
                        OnItemCommand="rptReplies_ItemCommand">
                        <ItemTemplate>
                            <div class="dd-reply">
                                <%# AnatoXplore.ProfileBadgeRenderer.Render(Eval("ProfilePhotoPath"), Eval("ProfileFrameKey"), Eval("AuthorName"), "dd-avatar small") %>

                                <div class="dd-reply-body">
                                    <div class="dd-reply-head">
                                        <div>
                                            <span class="dd-name"><%#: Eval("AuthorName") %></span>
                                            <span class="dd-meta"><%# GetTimeAgo(Eval("CreatedAt")) %></span>
                                        </div>

                                        <asp:LinkButton ID="btnDeleteReply" runat="server"
                                            CssClass="dd-delete-reply"
                                            CommandName="DeleteReply"
                                            CommandArgument='<%# Eval("DiscussionID") %>'
                                            CausesValidation="false"
                                            Visible='<%# CanManage(Eval("UserID")) %>'
                                            OnClientClick="return confirm('Delete this reply?');">
                                            <i class="fa-regular fa-trash-can"></i> Delete
                                        </asp:LinkButton>
                                    </div>

                                    <div class="dd-reply-text">
                                        <%# FormatContent(Eval("PostContent")) %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Panel ID="pnlNoReplies" runat="server"
                        CssClass="dd-no-replies" Visible="false">
                        No replies yet. Be the first to help!
                    </asp:Panel>
                </section>

                <!-- WRITE A REPLY (logged-in users) -->
                <asp:Panel ID="pnlReplyForm" runat="server"
                    CssClass="dd-card" DefaultButton="btnReply">

                    <asp:Label runat="server" AssociatedControlID="txtReply"
                        CssClass="dd-form-label" Text="Write a reply" />

                    <asp:TextBox ID="txtReply" runat="server"
                        CssClass="dd-textarea" TextMode="MultiLine" Rows="5"
                        ValidateRequestMode="Disabled"
                        placeholder="Share your answer or ideas..." />

                    <div class="dd-form-footer">
                        <div>
                            <asp:RequiredFieldValidator ID="rfvReply" runat="server"
                                ControlToValidate="txtReply"
                                ValidationGroup="Reply"
                                ErrorMessage="Write a reply before sending."
                                CssClass="dd-error" Display="Dynamic" />

                            <asp:RegularExpressionValidator ID="revReply" runat="server"
                                ControlToValidate="txtReply"
                                ValidationGroup="Reply"
                                ValidationExpression="^[\s\S]{2,2000}$"
                                ErrorMessage="Your reply must be between 2 and 2000 characters."
                                CssClass="dd-error" Display="Dynamic" />

                            <span class="dd-counter" id="replyCounter">0 / 2000</span>
                        </div>

                        <asp:Button ID="btnReply" runat="server"
                            CssClass="dd-btn" Text="Reply"
                            ValidationGroup="Reply"
                            OnClick="btnReply_Click" />
                    </div>
                </asp:Panel>

                <!-- NOTE FOR GUESTS -->
                <asp:Panel ID="pnlLoginToReply" runat="server"
                    CssClass="dd-card" Visible="false">
                    <div class="dd-login-note">
                        <a href="<%= ResolveUrl("~/Login.aspx") %>">Log in</a> or
                        <a href="<%= ResolveUrl("~/Register.aspx") %>">register</a>
                        to reply to this discussion.
                    </div>
                </asp:Panel>

            </asp:Panel>
        </div>
    </div>

    <!-- LIVE CHARACTER COUNTER FOR THE REPLY BOX -->
    <script>
        (function () {
    var input = document.getElementById("<%= txtReply.ClientID %>");
    var counter = document.getElementById("replyCounter");
    if (!input || !counter) return;

    function update() {
        var length = input.value.length;
        counter.textContent = length + " / 2000";
        counter.className = "dd-counter";
        if (length > 0 && length < 2) counter.className += " too-short";
        else if (length >= 2) counter.className += " ok";
    }

    input.addEventListener("input", update);
    update();
})();
document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".dd-topic").forEach(function (topic) {
        topic.innerHTML = topic.innerHTML
            .replace(/\bSystem\b/g, "")
            .replace(/\s{2,}/g, " ")
            .trim();
    });
});
</script>
</asp:Content>