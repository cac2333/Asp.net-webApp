<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="ContentPage.aspx.cs" Inherits="trial.ContentPage" %>




<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

     <link href="css/tableStyle.css" rel="stylesheet" type="text/css" />
    <script language="javascript" type="text/javascript">
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
        $(function () {
            //Getting values from session and saving in javascript variable.
            // But this will be executed only at document.ready.
            var ddl = document.getElementById("ddlCompanies");
            var value = ddl.options[ddl.selectedIndex].value;

        $("#SelectedCompany").val(value);

        $('ddlCompanies').onchange(function () {
            //Posting values to save in session
            $.post(document.URL + '?mode=ajax',
                {
                    'SelectedCompany': $("#SelectedCompany").val(),
                });
        });

        });
        </script>


    <div class="group">
    <p />
    </div>
         
    <div class="group">
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
                <asp:BoundField DataField="contact_id" HeaderText="contact_id" InsertVisible="False" ReadOnly="True" SortExpression="contact_id" Visible="False" />
                <asp:BoundField DataField="first_name" HeaderText="First Name" SortExpression="first_name" />
                <asp:BoundField DataField="last_name" HeaderText="Last Name" SortExpression="last_name" />
                 <asp:TemplateField HeaderText="Email" SortExpression="email">
                     <EditItemTemplate>
                         <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("email") %>'></asp:TextBox>
                     </EditItemTemplate>
                     <ItemTemplate>
                         <asp:Label ID="Label1" runat="server" Text='<%# Bind("email") %>'></asp:Label>
                     </ItemTemplate>
                 </asp:TemplateField>
                <asp:BoundField DataField="phone" HeaderText="Phone" SortExpression="phone" />
                <asp:TemplateField HeaderText="Company Name">
                    <ItemTemplate><%# Eval("company_name") %></ItemTemplate>
                        <EditItemTemplate>
                                        <asp:DropDownList ID="ddlCompanies" runat="server" DataSourceID="CompanyDataSource" SelectedValue='<%# Bind ("Company_ID") %>' DataTextField="Company_Name" DataValueField="Company_Id">
                                        </asp:DropDownList>
                        </EditItemTemplate>
                </asp:TemplateField>
              <%--  <asp:BoundField DataField="company_name" HeaderText="Company" ReadOnly="True" SortExpression="company_name" />--%>
                 <asp:CommandField ShowEditButton="True"/>
                 <asp:CommandField ShowDeleteButton="true" />

                 <asp:TemplateField>
                    <ItemTemplate>
                        <tr>
                        <td colspan="100%">
						<div id="div<%# Eval("contact_id") %>" style="display: none;">
                            <div>
							<asp:GridView ID="gvAddress" runat="server" AutoGenerateColumns="false"
								DataKeyNames="address_id" CssClass="rtable rtable--flip" ShowFooter="true" 
                                OnRowEditing="GvAddress_RowEditing" OnRowUpdating="GvAddress_RowUpdating" OnRowCancelingEdit="GvAddress_RowCancelingEdit">
								<Columns>
                                  <asp:TemplateField SortExpression="address1">
                                                <ItemTemplate><%# Eval("address1")%></ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtAddress1" Text='<%# Eval("address1")%>' runat="server"></asp:TextBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                  <asp:TemplateField SortExpression="address2">
                                                <ItemTemplate><%# Eval("address2")%></ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtAddress2" Text='<%# Eval("address2")%>' runat="server"></asp:TextBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                  <asp:TemplateField >
                                                <ItemTemplate><%# Eval("City")%></ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtCity" Text='<%# Eval("City")%>' runat="server"></asp:TextBox>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                <asp:TemplateField >
                                    <ItemTemplate><%# Eval("Country")%></ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:DropDownList ID="ddlCountry" Text='<%# Eval("Country")%>' runat="server" OnDataBound="ddlCountry_DataBound" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged">
                                                        <asp:ListItem Text="Canada" Value="Canada"></asp:ListItem>
                                                        <asp:ListItem Text="USA" Value="USA" />
                                                    </asp:DropDownList>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                    <asp:TemplateField >
                                                <ItemTemplate><%# Eval("Province")%></ItemTemplate>
                                                <EditItemTemplate>
                   <%--                                 <asp:DropDownList ID="ddlProvince" SelectedValue='<%# Bind ("Province") %>' runat="server" DataSourceID="StateDataSource" DataTextField="name" DataValueField="name">
                                                        <asp:ListItem Text="" Value=""></asp:ListItem>
                                                    </asp:DropDownList>--%>
                                                     <asp:TextBox ID="txtProvince" Text='<%# Eval("Province")%>' runat="server"></asp:TextBox>
                                                </EditItemTemplate>
                                     </asp:TemplateField>
    
                                    <asp:TemplateField >
                                                <ItemTemplate><%# Eval("PostalCode")%></ItemTemplate>
                                                <EditItemTemplate>
                                                    <asp:TextBox ID="txtPostalCode" Text='<%# Eval("PostalCode")%>' runat="server"></asp:TextBox>
                                               <%--    <asp:RegularExpressionValidator id="revPost" runat="server" ControlToValidate="txtPostalCode"  ErrorMessage="*Need to be a valid postal code"/>--%>
                                                </EditItemTemplate>
                                            </asp:TemplateField>
                                 
                                     <asp:CommandField ShowEditButton="True"/>
								</Columns>
							</asp:GridView>
                                </div>
                            <div>
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

    <asp:SqlDataSource ID="CompanyDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:MyDBConnectionString %>" SelectCommand="SELECT [Company_ID], [Company_Name] FROM [Company]"></asp:SqlDataSource>
   
</asp:Content>
