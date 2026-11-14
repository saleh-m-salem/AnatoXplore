<%@ Page Title="Send Feedback - AnatoXplore" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="AnatoXplore.Feedback" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" />
    
    <style>
        .page-container {
            background: linear-gradient(135deg, rgba(241,248,255,.80), rgba(227,240,252,.76)), url('<%= ResolveUrl("~/Images/anatomy-background.png") %>') center / cover fixed;
        }

        body {
            background-image: url('/Images/anatomy-background.png');
            background-position: center center;
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        .feedback-container {
            max-width: 700px;
            margin: 40px auto 60px;
            padding: 0 20px;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .feedback-card {
            background: white;
            border: 1px solid #e0eaf3;
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 5px 18px rgba(27, 68, 105, 0.06);
        }

        .feedback-card h2 {
            color: #17385e;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .feedback-subtitle {
            color: #687c91;
            font-size: 15px;
            margin-bottom: 25px;
            line-height: 1.6;
        }

        .form-label {
            color: #183153;
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 6px;
        }

        .form-control, .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #dce7f2;
            border-radius: 9px;
            font-size: 15px;
            color: #183153;
            box-sizing: border-box;
            transition: border-color .2s, box-shadow .2s;
        }

        .form-control:focus, .form-select:focus {
            outline: none;
            border-color: #1769aa;
            box-shadow: 0 0 0 3px rgba(23, 105, 170, .1);
        }

        .feedback-btn {
            background: #079ee8;
            color: white;
            border: none;
            border-radius: 8px;
            padding: 13px 22px;
            font-size: 16px;
            font-weight: 650;
            width: 100%;
            cursor: pointer;
            transition: background .2s, transform .2s;
        }

        .feedback-btn:hover {
            background: #087dc0;
            transform: translateY(-1px);
        }

        .alert-success-custom {
            background: #dff8e9;
            color: #16834a;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .alert-danger-custom {
            background: #ffebeb;
            color: #d51e1e;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
            font-weight: 600;
        }
    </style>

    <div class="feedback-container">
        <div class="feedback-card">
            <h2>Send Feedback</h2>
            <p class="feedback-subtitle">
                Have a suggestion, found an issue with an anatomy model, or need technical help? Let us know below.
            </p>

            <!-- Success Message Panel -->
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert-success-custom">
                <i class="fa-solid fa-circle-check"></i> Thank you! Your feedback has been submitted successfully.
            </asp:Panel>

            <!-- Error Message Panel -->
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-danger-custom">
                <i class="fa-solid fa-triangle-exclamation"></i> An error occurred while submitting your feedback. Please try again.
            </asp:Panel>

            <div class="mb-3">
                <label class="form-label">Feedback Type</label>
                <asp:DropDownList ID="ddlFeedbackType" runat="server" CssClass="form-select">
                    <asp:ListItem Text="General Feedback" Value="General Feedback" />
                    <asp:ListItem Text="Report a Problem" Value="Report a Problem" />
                    <asp:ListItem Text="Incorrect Anatomy Content" Value="Incorrect Content" />
                </asp:DropDownList>
            </div>

            <div class="mb-3">
                <label class="form-label">Subject</label>
                <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Write the subject here..." />
                <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject" 
                    ForeColor="Red" ErrorMessage="Subject is required." Display="Dynamic" CssClass="small mt-1" />
            </div>

            <div class="mb-4">
                <label class="form-label">Message</label>
                <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Describe in detail..." />
                <asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage" 
                    ForeColor="Red" ErrorMessage="Message cannot be empty." Display="Dynamic" CssClass="small mt-1" />
            </div>

            <div>
                <asp:Button ID="btnSubmitFeedback" runat="server" Text="Submit Feedback" CssClass="feedback-btn" OnClick="btnSubmitFeedback_Click" />
            </div>
        </div>
    </div>

</asp:Content>
