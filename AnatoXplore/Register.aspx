<%@ Page Title="Register | AnatoXplore" 

    Language="C#" 

    MasterPageFile="~/Site.Master" 

    AutoEventWireup="true" 

    CodeBehind="Register.aspx.cs" 

    Inherits="AnatoXplore.Register" %> 

 

<asp:Content ID="Content1" 

    ContentPlaceHolderID="MainContent" 

    runat="server"> 

 

    <style> 

        .register-page { 

            min-height: 75vh; 

            padding: 45px 20px; 

            display: flex; 

            align-items: center; 

            justify-content: center; 

            background: 

                linear-gradient( 

                    rgba(235, 245, 255, 0.22), 

                    rgba(235, 245, 255, 0.22) 

                ), 

                url('Images/anatomy-background.png') 

                center center / cover no-repeat; 

        } 

 

        .register-card { 

            width: 100%; 

            max-width: 450px; 

            padding: 34px; 

            background: rgba(255, 255, 255, 0.96); 

            border-radius: 12px; 

            box-shadow: 0 5px 25px rgba(25, 57, 90, 0.10); 

        } 

 

        .register-card h1 { 

            color: #142c4d; 

            font-size: 27px; 

            font-weight: 700; 

            margin: 0 0 8px; 

        } 

 

        .register-subtitle { 

            color: #65758b; 

            font-size: 15px; 

            line-height: 1.5; 

            margin: 0 0 25px; 

        } 

 

        .register-field { 

            margin-bottom: 18px; 

        } 

 

        .register-field label { 

            display: block; 

            margin-bottom: 8px; 

            color: #243b57; 

            font-size: 14px; 

            font-weight: bold; 

        } 

 

        .register-field input { 

            display: block; 

            width: 100%; 

            height: 44px; 

            padding: 0 13px; 

            border: 1px solid #d7e1ed; 

            border-radius: 7px; 

            background: #ffffff; 

            color: #243b57; 

            font-size: 14px; 

            box-sizing: border-box; 

        } 

 

        .register-field input::placeholder { 

            color: #9aa8b9; 

        } 

 

        .register-field input:focus { 

            outline: none; 

            border-color: #2580e8; 

            box-shadow: 0 0 0 2px rgba(37, 128, 232, 0.12); 

        } 

 

        .register-submit { 

            display: block; 

            width: 100%; 

            height: 46px; 

            margin-top: 5px; 

            border: none; 

            border-radius: 7px; 

            background: #1674df; 

            color: #ffffff; 

            font-size: 16px; 

            font-weight: bold; 

            cursor: pointer; 

        } 

 

        .register-submit:hover { 

            background: #0d60c2; 

        } 

 

        .register-message { 

            display: block; 

            margin-top: 14px; 

            font-size: 13px; 

            line-height: 1.5; 

            text-align: center; 

        } 

 

        .register-login { 

            margin: 23px 0 0; 

            text-align: center; 

            color: #566b83; 

            font-size: 14px; 

        } 

 

        .register-login a { 

            color: #1674df; 

            font-weight: bold; 

            text-decoration: none; 

        } 

 

        .register-login a:hover { 

            text-decoration: underline; 

        } 

 

        @media (max-width: 480px) { 

            .register-page { 

                min-height: 75vh; 

                padding: 28px 14px; 

            } 

 

            .register-card { 

                padding: 25px 22px; 

            } 

 

            .register-card h1 { 

                font-size: 24px; 

            } 

        } 

    </style> 

 

    <div class="register-page"> 

        <div class="register-card"> 

 

            <h1>Create an Account</h1> 

 

            <p class="register-subtitle"> 

                Join AnatoXplore and start learning! 

            </p> 

 

            <div class="register-field"> 

                <asp:Label 

                    ID="lblFullName" 

                    runat="server" 

                    AssociatedControlID="txtFullName" 

                    Text="Full Name" /> 

 

                <asp:TextBox 

                    ID="txtFullName" 

                    runat="server" 

                    MaxLength="100" 

                   placeholder="Enter your full name" />
                <asp:RequiredFieldValidator ID="rfvFullName" runat="server" ControlToValidate="txtFullName"
                    ErrorMessage="Full name is required." ForeColor="Red" Display="Dynamic" CssClass="small" /> 

            </div> 

 

            <div class="register-field"> 

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

 

            <div class="register-field"> 

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

                    placeholder="Enter a password" />
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword"
                    ErrorMessage="Password is required." ForeColor="Red" Display="Dynamic" CssClass="small" />
                <asp:RegularExpressionValidator ID="revPassword" runat="server" ControlToValidate="txtPassword"
                    ValidationExpression="^[\s\S]{8,128}$"
                    ErrorMessage="Password must be at least 8 characters." ForeColor="Red" Display="Dynamic" CssClass="small" /> 

            </div> 

 

            <div class="register-field"> 

                <asp:Label 

                    ID="lblConfirmPassword" 

                    runat="server" 

                    AssociatedControlID="txtConfirmPassword" 

                    Text="Confirm Password" /> 

 

                <asp:TextBox 

                    ID="txtConfirmPassword" 

                    runat="server" 

                    TextMode="Password" 

                    MaxLength="128" 

                    placeholder="Confirm your password" />
                <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                    ErrorMessage="Please confirm your password." ForeColor="Red" Display="Dynamic" CssClass="small" />
                <asp:CompareValidator ID="cvConfirmPassword" runat="server" ControlToValidate="txtConfirmPassword"
                    ControlToCompare="txtPassword" Operator="Equal" Type="String"
                    ErrorMessage="The passwords do not match." ForeColor="Red" Display="Dynamic" CssClass="small" /> 

            </div> 

 

            <asp:Button 

                ID="btnRegister" 

                runat="server" 

                Text="Register" 

                CssClass="register-submit" 

                OnClick="btnRegister_Click" /> 

 

            <asp:Label 

                ID="lblMessage" 

                runat="server" 

                CssClass="register-message" 

                EnableViewState="false" /> 

 

            <p class="register-login"> 

                Already have an account? 

                <a href="Login.aspx">Login</a> 

            </p> 

 

        </div> 

    </div> 

 

</asp:Content> 