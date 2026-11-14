<%@ Page Title="New Post | AnatoXplore"
    Language="C#"
    MasterPageFile="~/Site.Master"
    AutoEventWireup="true"
    CodeBehind="CreateDiscussion.aspx.cs"
    Inherits="AnatoXplore.CreateDiscussion"
    UnobtrusiveValidationMode="None" %>

<asp:Content ID="HeadArea" ContentPlaceHolderID="HeadContent" runat="server">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />

    <style>
        /* PAGE */
        .cd-page {
            min-height: 100vh;
            padding: 40px 20px 20px;
            box-sizing: border-box;
            background-image: url('/Images/anatomy-background.png');
            background-position: center center;
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .cd-wrap {
            max-width: 960px;
            margin: 0 auto;
        }

        .cd-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 14px;
            color: #35506e;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
        }

        .cd-back:hover {
            color: #1674df;
        }

        .cd-card {
            display: grid;
            grid-template-columns: minmax(0, 1fr);
            padding: 32px;
            background: #ffffff;
            border-radius: 14px;
            box-shadow: 0 5px 25px rgba(25, 57, 90, 0.10);
        }

        /* HEADER */
        .cd-card h1 {
            margin: 0 0 6px;
            color: #142c4d;
            font-size: 26px;
            font-weight: 700;
        }

        .cd-subtitle {
            margin: 0 0 24px;
            color: #65758b;
            font-size: 15px;
        }

        /* FORM FIELDS */
        .cd-field {
            margin-bottom: 22px;
        }

        .cd-field-title {
            width: 100%;
            margin-left: 0;
            margin-right: 0;
        }

        .cd-field-title .cd-label {
            text-align: left;
            font-size: 18px;
        }

        .cd-label {
            display: block;
            margin-bottom: 8px;
            color: #243b57;
            font-size: 14px;
            font-weight: 600;
        }

        .cd-optional {
            color: #8a9bb0;
            font-weight: 400;
        }

        .cd-input,
        .cd-textarea {
            width: 100%;
            max-width: none;
            padding: 11px 14px;
            border: 1px solid #d7e1ed;
            border-radius: 10px;
            background: #f8fbff;
            color: #183153;
            font-size: 15px;
            font-family: inherit;
            box-sizing: border-box;
        }

        .cd-input {
            height: 46px;
        }

        .cd-textarea {
            display: block;
            width: 100%;
            min-height: 180px;
            line-height: 1.6;
            resize: vertical;
        }

        .cd-input:focus,
        .cd-textarea:focus {
            outline: none;
            border-color: #1674df;
            background: #ffffff;
            box-shadow: 0 0 0 3px rgba(22, 116, 223, 0.15);
        }

        .cd-field-footer {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-top: 6px;
            min-height: 18px;
        }

        .cd-error {
            color: #c0392b;
            font-size: 13px;
        }

        .cd-counter {
            margin-left: auto;
            color: #8a9bb0;
            font-size: 12px;
            white-space: nowrap;
        }

        .cd-counter.too-short {
            color: #b45309;
        }

        .cd-counter.ok {
            color: #1e7a45;
        }

        /* TOPIC CHOICE (radio buttons styled as chips) */
        .cd-topics {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .cd-topics input {
            position: absolute;
            opacity: 0;
            pointer-events: none;
        }

        .cd-topics label {
            display: inline-block;
            padding: 8px 15px;
            border: 1px solid #d7e1ed;
            border-radius: 20px;
            background: #ffffff;
            color: #35506e;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.15s;
        }

        .cd-topics label:hover {
            border-color: #1674df;
            color: #1674df;
        }

        .cd-topics input:checked + label {
            border-color: #1674df;
            background: #1674df;
            color: #ffffff;
        }

        .cd-topics input:focus-visible + label {
            box-shadow: 0 0 0 3px rgba(22, 116, 223, 0.25);
        }

        /* MESSAGES */
        .cd-alert {
            display: block;
            margin-bottom: 18px;
            padding: 12px 16px;
            border-radius: 8px;
            background: #fdecec;
            color: #a12b2b;
            font-size: 14px;
        }

        /* BUTTONS */
        .cd-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding-top: 6px;
        }

        .cd-btn {
            height: 46px;
            padding: 0 26px;
            border: none;
            border-radius: 10px;
            background: #1674df;
            color: #ffffff;
            font-size: 15px;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
        }

        .cd-btn:hover {
            background: #0d60c2;
        }

        .cd-btn-light {
            display: inline-flex;
            align-items: center;
            height: 46px;
            padding: 0 22px;
            border: 1px solid #d7e1ed;
            border-radius: 10px;
            background: #ffffff;
            color: #35506e;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            box-sizing: border-box;
        }

        .cd-btn-light:hover {
            border-color: #9fb8d2;
        }

        /* RESPONSIVE (tablets and phones) */
        @media (max-width: 800px) {
            .cd-card {
                grid-template-columns: 1fr;
                padding: 24px 18px;
            }

            .cd-actions {
                flex-direction: column-reverse;
            }

            .cd-btn,
            .cd-btn-light {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainArea" ContentPlaceHolderID="MainContent" runat="server">

    <div class="cd-page">
        <div class="cd-wrap">

            <asp:HyperLink ID="lnkBack" runat="server"
                CssClass="cd-back" NavigateUrl="~/Discussion/Discussions.aspx">
                <i class="fa-solid fa-arrow-left"></i>
                <asp:Literal ID="litBack" runat="server" Text="Back to discussions" />
            </asp:HyperLink>

            <section class="cd-card">

                <!-- FORM -->
                <div>
                    <h1><asp:Literal ID="litHeading" runat="server" Text="New discussion post" /></h1>
                    <p class="cd-subtitle">
                        <asp:Literal ID="litSubtitle" runat="server"
                            Text="Ask a question or start a discussion with other students." />
                    </p>

                    <!-- ERROR MESSAGE FROM THE SERVER -->
                    <asp:Label ID="lblError" runat="server"
                        CssClass="cd-alert" Visible="false" />

                    <!-- TITLE -->
                    <div class="cd-field cd-field-title">
                        <asp:Label runat="server" AssociatedControlID="txtTitle"
                            CssClass="cd-label" Text="Title" />

                        <asp:TextBox ID="txtTitle" runat="server"
                            CssClass="cd-input" MaxLength="200"
                            ValidateRequestMode="Disabled"
                            placeholder="Write a clear, descriptive title" />

                        <div class="cd-field-footer">
                            <div>
                                <asp:RequiredFieldValidator ID="rfvTitle" runat="server"
                                    ControlToValidate="txtTitle"
                                    ErrorMessage="Enter a title for your post."
                                    CssClass="cd-error" Display="Dynamic"
                                    SetFocusOnError="true" />

                                <asp:RegularExpressionValidator ID="revTitle" runat="server"
                                    ControlToValidate="txtTitle"
                                    ValidationExpression="^[\s\S]{5,200}$"
                                    ErrorMessage="The title must be between 5 and 200 characters."
                                    
                                    CssClass="cd-error" Display="Dynamic"
                                    SetFocusOnError="true" />
                            </div>

                            <span class="cd-counter" id="titleCounter">0 / 200</span>
                        </div>
                    </div>

                    <!-- TOPIC (OPTIONAL) -->
                    <div class="cd-field">
                        <span class="cd-label">
                            Topic <span class="cd-optional">(optional)</span>
                        </span>

                        <asp:RadioButtonList ID="rblTopic" runat="server"
                            CssClass="cd-topics"
                            RepeatDirection="Horizontal"
                            RepeatLayout="Flow" />
                    </div>

                    <!-- MESSAGE -->
                    <div class="cd-field">
                        <asp:Label runat="server" AssociatedControlID="txtMessage"
                            CssClass="cd-label" Text="Message" />

                        <asp:TextBox ID="txtMessage" runat="server"
                            CssClass="cd-textarea" TextMode="MultiLine" Rows="8"
                            ValidateRequestMode="Disabled"
                            placeholder="Write your question or discussion here..." />

                        <div class="cd-field-footer">
                            <div>
                                <asp:RequiredFieldValidator ID="rfvMessage" runat="server"
                                    ControlToValidate="txtMessage"
                                    ErrorMessage="Enter a message for your post."
                                    CssClass="cd-error" Display="Dynamic"
                                    SetFocusOnError="true" />

                                <asp:RegularExpressionValidator ID="revMessage" runat="server"
                                    ControlToValidate="txtMessage"
                                    ValidationExpression="^[\s\S]{20,4000}$"
                                    ErrorMessage="The message must be between 20 and 4000 characters."
                                    CssClass="cd-error" Display="Dynamic"
                                    SetFocusOnError="true" />
                            </div>

                            <span class="cd-counter" id="messageCounter">0 / 4000</span>
                        </div>
                    </div>

                    <!-- BUTTONS -->
                    <div class="cd-actions">
                        <asp:HyperLink ID="lnkCancel" runat="server"
                            CssClass="cd-btn-light" NavigateUrl="~/Discussion/Discussions.aspx"
                            Text="Cancel" />

                        <asp:Button ID="btnPost" runat="server"
                            CssClass="cd-btn" Text="Post"
                            OnClick="btnPost_Click" />
                    </div>
                </div>

            </section>
        </div>
    </div>

    <!-- LIVE CHARACTER COUNTERS (client-side JavaScript) -->
    <script>
        function setupCounter(inputId, counterId, min, max) {
            var input = document.getElementById(inputId);
            var counter = document.getElementById(counterId);

            function update() {
                var length = input.value.length;
                counter.textContent = length + " / " + max;

                counter.className = "cd-counter";
                if (length > 0 && length < min) {
                    counter.className += " too-short";
                } else if (length >= min) {
                    counter.className += " ok";
                }
            }

            input.addEventListener("input", update);
            update();
        }

        setupCounter("<%= txtTitle.ClientID %>", "titleCounter", 5, 200);
setupCounter("<%= txtMessage.ClientID %>", "messageCounter", 20, 4000);
</script>
</asp:Content>