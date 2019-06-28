<%@ Page Title="Create Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateContacts.aspx.cs" Inherits="trial.CreateContacts" %>

    <asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

        <div class="group">
            <p />
        </div>
        
        <div class="group">
             <h2> Add a New Contact</h2>
            <asp:Literal runat="server" ID="errorMsg" />
        </div>
        <div class="add-form">

            <div>
                <label>First Name: </label>
                <asp:TextBox runat="server" ID="txtFirstName"/>
            </div>

            <div>
                <label>Last Name: </label>
                <asp:TextBox runat="server" ID="txtLastName" />
            </div>

            <div>
                <label>Title: </label>
             <asp:DropDownList ID="ddlTitles" runat="server">
                            <asp:ListItem Text="Mr." Value="Mr." />
                            <asp:ListItem Text="Mrs." Value="Mrs." />
                            <asp:ListItem Text="Ms." Value="Ms." />
             </asp:DropDownList>
            </div>

            <div>
                <label>Phone number</label>
                <asp:TextBox runat="server" ID="txtPhone" />
                <asp:RegularExpressionValidator runat="server" ID="revPhone" ControlToValidate="txtPhone" ErrorMessage="*Please enter a valid phone number" ForeColor="Red" ValidationExpression="^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$" />
            </div>

            <div>
                <label>Email</label>
                <asp:TextBox runat="server" ID="txtEmail" />
                <asp:RegularExpressionValidator runat="server" ID="revEmail" ControlToValidate="txtEmail" ErrorMessage="*Please enter a valid email address" ForeColor="Red" ValidationExpression="[\w-]+@([\w-]+\.)+[\w-]+"/>
            </div>
            
            <div>
                <label> Choose a company: </label>
                <asp:DropDownList ID="ddlCompanies" runat="server">
                    <asp:ListItem Text="Please choose a company" Value="" />
                </asp:DropDownList>
            </div>


            <div>
                <label> Use default address </label>
                <asp:CheckBox ID="checkAddress" runat="server" AutoPostBack="true" Checked="true" OnCheckedChanged="checkAddress_CheckedChanged" />
                <asp:Panel ID="panelAddress" runat="server" Visible="false">

                    <h4> Add a new address </h4>

                    <div>
                    <label>Choose your country</label> 
                        <asp:DropDownList ID="ddlCountries" runat="server" OnSelectedIndexChanged="ddlCountries_SelectedIndexChanged" AutoPostBack="true">
                            <asp:ListItem Text="Country" Value="" />
                            <asp:ListItem Text="Canada" Value="Canada" />
                            <asp:ListItem Text="USA" Value="USA" />
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfv_ddlCountries" runat="server" ControlToValidate="ddlCountries" ErrorMessage="*Please choose a country" ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div>
                        <label>Addres Line 1</label>
                        <asp:TextBox ID="AddressLine1" runat="server" placeholder="Address Line 1" />
                        <asp:RequiredFieldValidator runat="server" ID="rfvAddress" ControlToValidate="AddressLine1" ErrorMessage="*This field is required" ForeColor="Red" Display="Dynamic" />
                    </div>

                    <div>
                        <label>Address Line2</label>
                        <asp:TextBox ID="AddressLine2" runat="server" placeholder="Address Line 2" />
                    </div>

                    <div>
                        <label>City</label> 
                        <asp:TextBox ID="city" runat="server" />
                    </div>

                    <div>
                    <label>State</label> 
                        <asp:DropDownList ID="ddlStates" runat="server"></asp:DropDownList>
                          <asp:RequiredFieldValidator ID="rfv_ddlStates" runat="server" ControlToValidate="ddlStates" ErrorMessage="Please choose a state" ForeColor="Red" Display="Dynamic" />
                    </div>
                    <label>Postal Code: </label>
                    <asp:TextBox ID="txtPost" runat="server" placeholder="Postal code" />
                    <asp:RegularExpressionValidator runat="server" ID="revPost" ControlToValidate="txtPost" ErrorMessage="*Please enter a valid postal code" ForeColor="Red" Display="Dynamic" />
                </asp:Panel>


            </div>

            <div>

            </div>
            <div>
                <asp:Button ID="submit_btn" runat="server" Text="Submit" OnClick="submit_btn_Click" CssClass="button-style"/>
            </div>
            <br/>
            <div class="message">
                <asp:Literal ID="Msg" runat="server" />
            </div>
        </div>
                   
    </asp:Content>