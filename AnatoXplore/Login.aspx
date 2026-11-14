<%@ Page Title="Login | AnatoXplore" 

    Language="C#" 

    MasterPageFile="~/Site.Master" 

    AutoEventWireup="true" 

    CodeBehind="Login.aspx.cs" 

    Inherits="AnatoXplore.Login" %> 

 

<asp:Content ID="Content1" 

    ContentPlaceHolderID="MainContent" 

    runat="server"> 

 

    <style> 

        .login-page { 

            min-height: 75vh; 

            padding: 45px 20px; 

            display: flex; 

            align-items: center; 

            justify-content: center; 

            background: 

                linear-gradient( 

                    rgba(235, 245, 255, 0.25), 

                    rgba(235, 245, 255, 0.25) 

                ), 

                url('Images/anatomy-background.png') 

                center center / cover no-repeat; 

        } 

 

        .login-card { 

            width: 100%; 

            max-width: 430px; 

            padding: 35px; 

            background: rgba(255, 255, 255, 0.97); 

            border-radius: 12px; 

            box-shadow: 0 5px 25px rgba(25, 57, 90, 0.12); 

            box-sizing: border-box; 

        } 

 

        .login-card h1 { 

            color: #142c4d; 

            font-size: 28px; 

            margin: 0 0 8px; 

        } 

 

        .login-subtitle { 

            color: #65758b; 

            font-size: 15px; 

            line-height: 1.5; 

            margin-bottom: 26px; 

        } 

 

        .login-field { 

            margin-bottom: 20px; 

        } 

 

        .login-field label { 

            display: block; 

            margin-bottom: 8px; 

            color: #243b57; 

            font-size: 14px; 

            font-weight: bold; 

        } 

 

        .login-field input { 

            width: 100%; 

            height: 44px; 

            padding: 0 13px; 

            border: 1px solid #d7e1ed; 

            border-radius: 7px; 

            box-sizing: border-box; 

            font-size: 14px; 

        } 

 

        .login-submit { 

            width: 100%; 

            height: 46px; 

            border: none; 

            border-radius: 7px; 

            background: #1674df; 

            color: white; 

            font-size: 16px; 

            font-weight: bold; 

            cursor: pointer; 

        } 

 

        .login-submit:hover { 

            background: #0d60c2; 

        } 

 

        .login-message { 

            display: block; 

            margin-top: 15px; 

            text-align: center; 

            font-size: 14px; 

        } 

 

        .login-register { 

            margin-top: 24px; 

            text-align: center; 

            color: #566b83; 

            font-size: 14px; 

        } 

 

        .login-register a { 

            color: #1674df; 

            font-weight: bold; 

            text-decoration: none; 

        } 

 

        @media (max-width: 480px) { 

            .login-card { 

                padding: 25px 22px; 

            } 

        } 

    </style> 

 

    <div class="login-page"> 

        <div class="login-card"> 

 

            <h1>Welcome Back</h1> 

 

            <p class="login-subtitle"> 

                Log in to continue your anatomy learning journey. 

            </p> 

 

            <div class="login-field"> 

                <asp:Label 

                    ID="lblEmail" 

                    runat="server" 

                    AssociatedControlID="txtEmail" 

                    Text="Email Address" /> 

 

                <asp:TextBox 

                    ID="txtEmail" 

                    runat="server" 

                    TextMode="Email" 

                    MaxLength="255" 

                   placeholder="Enter your email" />
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Email is required." ForeColor="Red" Display="Dynamic" CssClass="small" />
                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Please enter a valid email address." ForeColor="Red" Display="Dynamic" CssClass="small" /> 

            </div> 

 

            <div class="login-field"> 

                <asp:Label 

                    ID="lblPassword" 

                    runat="server" 

                    AssociatedControlID="txtPassword" 

                    Text="Password" /> 

 

                <asp:TextBox 

                    ID="txtPassword" 

                    runat="server" 

                    TextMode="Password" 

                    MaxLength="128" 

                    placeholder="Enter your password" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required." ForeColor="Red" Display="Dynamic" CssClass="small" /> 

            </div> 

 

            <asp:Button 

                ID="btnLogin" 

                runat="server" 

                Text="Login" 

                CssClass="login-submit" 

                OnClick="btnLogin_Click" /> 

 

            <asp:Label 

                ID="lblMessage" 

                runat="server" 

                CssClass="login-message" 

                EnableViewState="false" /> 

 

            <p class="login-register"> 

                Don't have an account? 

                <a href="<%= ResolveUrl("~/Register.aspx") %>"> 

                    Register 

                </a> 

            </p> 

 

        </div> 

    </div> 

 

</asp:Content> 