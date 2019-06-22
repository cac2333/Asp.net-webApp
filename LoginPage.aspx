<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="trial.LoginPage" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<%--    <div class="jumbotron">
       <h2> User Login </h2>
    </div>--%>
    <div class="group">
        <p />
    </div>

    <div class="group">
        <div class="w3l-login-form">
        <h2>User Login</h2>

        <asp:Login ID="Login1" runat="server" OnAuthenticate="Login1_Authenticate" CreateUserText="Register" PasswordRecoveryText="Forget your password?" class="table-style" DestinationPageUrl="~/Default.aspx">
            <LayoutTemplate>
                            <div class="txt-input">
                                        <asp:Label  ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label>
                                        <asp:TextBox  ID="UserName" runat="server" ></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                            </div>
                                    <div class="txt-input">
                                        <asp:Label  ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label>
                                        <asp:TextBox ID="Password" runat="server" TextMode="Password" ></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                                    </div>
                               
                                    <div>
                                        <asp:CheckBox class="txt-input" ID="RememberMe" runat="server" Text="Remember me next time." />
                                    </div>
                               
                                    <div style="color:lightpink;">
                                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                    </div>
                               
                                    <div class="forgot">
                                        <asp:HyperLink ID="PasswordRecoveryLink" runat="server" NavigateUrl="~/PasswordRecovery.aspx">Forget your password?</asp:HyperLink>
                                    </div>
                               
                                    <div class="forgot">
                                        <asp:HyperLink ID="CreateUserLink" runat="server" NavigateUrl="~/Register.aspx">Register</asp:HyperLink>
                                       <%-- <asp:Button ID="PasswordRecovery" runat="server" Text="Forget your password?" BorderWidth="0" Font-Italic="True" ForeColor="#990000" BorderColor="White" onclick="PasswordRecovery_Click" BackColor="Transparent" />--%>
                                    </div>

                                    <div >
                                       <p class="g-recaptcha" id="recaptcha" data-sitekey="6LcOdqUUAAAAABis3RSNmy1-6dbUKxXrzs3d3Vax"/>
                                    </div>
                              
                                    <div >
                                        <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log In" ValidationGroup="Login1" CssClass="button-style" />
                                    </div>
                              
                                
                            </div>
            </LayoutTemplate>
            <TitleTextStyle BackColor="#6B696B" Font-Bold="True" ForeColor="#FFFFFF" />
        </asp:Login>


            </div>
                            
        </div>

    </asp:Content>
