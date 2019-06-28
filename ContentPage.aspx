<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="ContentPage.aspx.cs" Inherits="trial.ContentPage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolKit" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

     <link href="css/tableStyle.css" rel="stylesheet" type="text/css" />
    <script>
            function expandcollapse(obj, row) {
                var div = document.getElementById(obj);
                var img = document.getElementById('img' + obj);

                if (div.style.display == "none") {
                    div.style.display = "block";
                    if (row == 'alt') {
                        img.src = "images/minus.png";
                    }
                    else {
                        img.src = "images/minus.png";
                    }
                    img.alt = "Close to view other contacts";
                }
                else {
                    div.style.display = "none";
                    if (row == 'alt') {
                        img.src = "images/plus.png";
                    }
                    else {
                        img.src = "images/plus.png";
                    }
                    img.alt = "Expand to show more details";
                }
        }

    </script>

    <script type="text/javascript">
        function showEditPanel() {
            var mpe = $find('mpeEdit');
            mpe.show();
        }
    </script>



    <div class="group">
    <p />
    </div>

 
    <div class="group">
          <asp:TextBox runat="server"/>
          <button type="submit" class="btn btn-default" style="width:20%">Submit</button>
    </div>

         
    <div class="container">

        <asp:GridView ID="GridView1" runat="server" DataKeyNames="contact_id"
            AutoGenerateColumns="False" OnRowDataBound="GridView1_RowDataBound" CssClass="mGrid" 
            OnRowDeleting="GridView1_RowDeleting" OnRowEditing="GridView1_RowEditing_temp" OnRowCancelingEdit="GridView1_RowCancelingEdit" OnRowUpdating="GridView1_RowUpdating" CellPadding="4" ForeColor="#333333" GridLines="None" >
            <AlternatingRowStyle BackColor="White" ForeColor="#284775" />
            <Columns>
                 <asp:TemplateField ItemStyle-Width="20px">
					<ItemTemplate>
						 <a href="javascript:expandcollapse('div<%# Eval("contact_id") %>', 'one');">
                            <img id="imgdiv<%# Eval("contact_id") %>" alt="Click to show/hide details <%# Eval("contact_id") %>"  src="images/plus.png"/>
                        </a>
                        </ItemTemplate >

<ItemStyle Width="20px"></ItemStyle>
                    </asp:TemplateField>
                <asp:BoundField DataField="company_name" HeaderText="Company" ReadOnly="True" SortExpression="company_name" />
                <asp:BoundField DataField="first_name" HeaderText="First Name" SortExpression="first_name"/>
                <asp:BoundField DataField="last_name" HeaderText="Last Name" SortExpression="last_name" />
                <asp:BoundField DataField="email" HeaderText="Email" />
                <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                 <asp:BoundField DataField="contact_id" HeaderText="contact_id" InsertVisible="False" ReadOnly="True" SortExpression="contact_id" Visible="False" />
                <asp:TemplateField ShowHeader="false">
                <ItemTemplate>
                      
                                  <%-- <asp:UpdatePanel ChildrenAsTriggers="false" id="UnpdatePanel" runat="server" UpdateMode="Conditional">

                                  <Triggers>
                                         <asp:AsyncPostBackTrigger ControlID="lbtnShowEdit" EventName="Click" />
                                  </Triggers>

                                   <ContentTemplate>--%>

                                  <asp:LinkButton runat="server" Text="Edit" ID="lbtnShowEdit" OnClick="btnShowEdit_Click"/>
    <%--                              
                                  </ContentTemplate>

                            </asp:UpdatePanel>--%>

                   </ItemTemplate>
               </asp:TemplateField>
                 <asp:CommandField ShowDeleteButton="true" />

                 <asp:TemplateField>
                    <ItemTemplate>
                        <tr>
                        <td colspan="100%">
						<div id="div<%# Eval("contact_id") %>" style="display: none;">
                            <div style="padding: 5px;">
							<asp:GridView ID="gvAddress" runat="server" AutoGenerateColumns="false"
								DataKeyNames="address_id" CssClass="rtable rtable--flip" ShowFooter="true" 
                                OnRowEditing="GvAddress_RowEditing" OnRowUpdating="GvAddress_RowUpdating" OnRowCancelingEdit="GvAddress_RowCancelingEdit"> 
								<Columns>
                                  <asp:BoundField DataField="Address1" Visible="false" />
                                  <asp:BoundField DataField="Address2" Visible="false" />
                                  <asp:BoundField DataField="City" Visible="false" />
                                  <asp:BoundField DataField="Province" Visible="false" />
                                  <asp:BoundField DataField="Contry" Visible="false" />
                                  <asp:BoundField DataField="PostalCode" Visible="false" />
                                    <asp:TemplateField HeaderText="Address Detail">
                                        <ItemTemplate>
                                            <asp:Label runat="server" Text=<%# Eval("Address1")+" "+Eval("Address2") %> />
                                            <br />
                                            <asp:Label runat="server" Text=<%# Eval("City")+" "+Eval("Province") %> />
                                        </ItemTemplate>
                                    </asp:TemplateField>
								</Columns>
							</asp:GridView>
                                </div>
                            <div style="padding: 5px;">
                                <asp:UpdatePanel runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                <asp:GridView ID="gvOthers" runat="server" AutoGenerateColumns="false"
								DataKeyNames="field_id" CssClass="rtable" ShowFooter="true"  ShowHeader="true"
                                    OnRowDataBound="gvOthers_RowDataBound" OnRowCommand="gvOthers_RowCommand" OnRowDeleting="gvOthers_RowDeleting">
                                    <columns> 
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:Label Text=<%# Eval("field_id") %> runat="server" Visible="false"/>
                                            </ItemTemplate>
                                             <FooterTemplate>
                                                <asp:Label runat="server" Visible="false" />
                                            </FooterTemplate>
                                        </asp:TemplateField>
                                        <asp:BoundField  />
                                        <asp:TemplateField HeaderText="Customized field">
                                           <ItemTemplate>
                                               <asp:label Text=<%# Eval("field_name") %> runat="server" />
                                           </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:TextBox ID="footerName" placeholder="New filed name" BackColor="White" ForeColor="Gray" runat="server" MaxLength="250" BorderWidth="1px"/>
                                            </FooterTemplate>
                                       </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="field value">
                                            <ItemTemplate>
                                               <asp:label Text=<%# Eval("field_value") %> runat="server" />
                                           </ItemTemplate>
    
                                            <FooterTemplate>
                                                <asp:TextBox ID="footerValue" placeholder="New field value" runat="server" MaxLength="250" BackColor="White" ForeColor="Gray" BorderWidth="1px"/>
                                            </FooterTemplate>
                                       </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="false">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="deleteBtn" CommandName="Delete" runat="server">Delete</asp:LinkButton>
                                        </ItemTemplate>
                                            <FooterTemplate>
                                                <asp:LinkButton ID="addBtn" CommandName="Add" runat="server">Add</asp:LinkButton>
                                            </FooterTemplate>
                                       </asp:TemplateField>
                                    <%--    <asp:CommandField ShowDeleteButton="true" />--%>
                                    </columns>
                                    
                                </asp:GridView>
                                        </ContentTemplate>
                             </asp:UpdatePanel>

                            </div>
						</div>
                          </td>
                            </tr>
					</ItemTemplate>
                     <ItemStyle Width="20px"></ItemStyle>
				</asp:TemplateField>   
            </Columns>
            <EditRowStyle BackColor="#999999" />
            <FooterStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#284775" ForeColor="White" HorizontalAlign="Center" />
            <RowStyle BackColor="#F7F6F3" ForeColor="#333333" />
            <SelectedRowStyle BackColor="#E2DED6" Font-Bold="True" ForeColor="#333333" />
            <SortedAscendingCellStyle BackColor="#E9E7E2" />
            <SortedAscendingHeaderStyle BackColor="#506C8C" />
            <SortedDescendingCellStyle BackColor="#FFFDF8" />
            <SortedDescendingHeaderStyle BackColor="#6F8DAE" />
        </asp:GridView>

     
        </div>

    <asp:Button ID="btnFake" runat="server" style="display:none;"/>

    <asp:Panel ID="EditPanel" runat="server" CssClass="form-style-9" style="display:none;">
               <h2>Edit Contact</h2>
           <div>
           <ul>
               <li>
                <asp:HiddenField  runat="server" ID="hiddenContactID"/>
                 <label class="field-style field-full">Company
                 <asp:DropDownList id="ddlCompany" runat="server" /> </label>
               </li>
          
               <li>  <label class="field-style field-split align-left">
                   <span>First name: </span>
                 <asp:TextBox ID="txtEditFN" runat="server"  />
                   </label>
                   <label class="field-style field-split align-right">Last name: 
                 <asp:TextBox ID="txtEditLN" runat="server"/>
                     </label>
               </li> 

               <li>  <label class="field-style field-split align-left">Phone:
                 <asp:TextBox ID="txtEditPhone" runat="server" />
                    </label>
                    <asp:RegularExpressionValidator display="Dynamic" runat="server" ID="revPhone" ControlToValidate="txtEditPhone" ErrorMessage="*" ForeColor="Red" ValidationExpression="^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$" />
            
               <label class="field-style field-split align-right">Email:
                 <asp:TextBox ID="txtEditEmail" runat="server" />
                    </label>
                   <asp:RegularExpressionValidator display="Dynamic" id="revEmail" runat="server" ControlToValidate="txtEditEmail"  ErrorMessage="*" ForeColor="Red" ValidationExpression="^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$"/>    
               </li>
        </ul>
    </div>
    <div>
        
   <asp:updatepanel runat="server" id="UpdatePanel" UpdateMode="Conditional" >
          <ContentTemplate>
            <h3>Shipping address</h3>
           <asp:CheckBox ID="cbAddress" runat="server" Text="Using company default address" Checked="true" OnCheckedChanged="cbAddress_CheckedChanged" AutoPostBack="true"/>

            <asp:Panel runat="server" ID="AddressPanel" Visible="false">
         
            <ul>
                <asp:HiddenField id="hiddenAddressID" runat="server" />
               <li>
                     <label class="field-style field-split align-left">Line 1
                 <asp:TextBox ID="txtEditLine1" runat="server" /> </label>

                    <label class="field-style field-split align-right">Line 2
                 <asp:TextBox ID="txtEditLine2" runat="server" /> </label>
               </li>  

               <li>
                     <label class="field-style field-split align-left">City
                 <asp:TextBox ID="txtEditCity" runat="server"  /> </label>

                    <label class="field-style field-split align-right">Postal Code
                           <asp:TextBox runat="server" ID="txtEditPost" />
                       </label>
               </li>  

               <li>
                  
                         <label class="field-style field-split align-left">Country
                         <asp:DropDownList runat="server" ID="ddlCountry" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged" AutoPostBack="true">
                          <asp:ListItem Text="Canada" Value="Canada" />
                          <asp:ListItem Text="USA" Value="USA" />
                          </asp:DropDownList></label>

                      <label class="field-style field-split align-right">Province
                      <asp:DropDownList runat="server" ID="ddlProvince" /> </label>
               </li>  
 
            </ul>
        </asp:Panel>
              
           </ContentTemplate>        
           </asp:updatepanel>


          </div>       
        <div class="right-bottom">
                   <asp:LinkButton Font-Size="Large" ForeColor="Gray" ID="btnOkay" runat="server" Text="Okay" OnClick="btnOkay_Click" />
                   <asp:LinkButton ID="btnCancel" runat="server" class="btn-link" Text="Cancel" Font-Size="Large" ForeColor="Gray"/>
		</div>
    </asp:Panel>

     <ajaxToolKit:ModalPopupExtender runat="server" ID="mpe"
        cancelcontrolid="btnCancel" targetcontrolid="btnFake" popupcontrolid="EditPanel"
        BackgroundCssClass="ModalPopupBG">
    </ajaxToolKit:ModalPopupExtender>

    <div class="right-bottom">
            <p>
               <asp:Button CssClass="btn-link" Text="Add a New Contact" runat="server" ID="btnAdd" OnClick="btnAdd_Click"/>
            </p>
        </div>

    <div class="group"/>
    <asp:SqlDataSource ID="CompanyDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MyDBConnectionString %>" SelectCommand="SELECT [Company_ID], [Company_Name] FROM [Company]"></asp:SqlDataSource>
   
</asp:Content>
