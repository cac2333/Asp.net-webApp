<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="CompanyList.aspx.cs" Inherits="trial.CompanyList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
                                
    <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.10.0.min.js" type="text/javascript"></script>
    <script src="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.2/jquery-ui.min.js" type="text/javascript"></script>
    <link href="http://ajax.aspnetcdn.com/ajax/jquery.ui/1.9.2/themes/blitzer/jquery-ui.css"
    rel="Stylesheet" type="text/css" />

<script type="text/javascript">
    $(function () {
        $("#<%=searchBox.ClientID%>").autocomplete({
            source: function (request, response) {
                $.ajax({
                    url: '<%=ResolveUrl("~/CompanyList.aspx/GetCompanies") %>',
                    data: "{ 'prefix': '" + request.term + "'}",
                    dataType: "json",
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (data) {
                        response($.map(data.d, function (item) {
                            return {
                                label: item.split('-')[0],
                                val: item.split('-')[1]
                            }
                        }))
                    },
                    error: function (response) {
                        var r = jQuery.parseJSON(response.responseText);
                        alert("Message: " + r.Message);
                        alert("StackTrace: " + r.StackTrace);
                        alert("ExceptionType: " + r.ExceptionType);
                    },
                    failure: function (response) {
                        var r = jQuery.parseJSON(response.responseText);
                        alert("Message: " + r.Message);
                        alert("StackTrace: " + r.StackTrace);
                        alert("ExceptionType: " + r.ExceptionType);
                    }
                });
            },
            select: function (e, i) {
                $("[id$=hfCompanyID]").val(i.item.val);
            },
            minLength: 1
        });
    });  
</script>



    <div class="group">
 
    </div>

    <div class="group">

  <nav class="floating-menu float-left-20" >
    <h3>Contacts</h3>
    <a href="ContentPage.aspx/">View Your Contact</a>
    <a href="CreateContact">Add a new Contact</a>
    <p class="menu-active">Explore More</p>
  </nav>

    <div class="right-80">


    <div style="div-head"><h3>Expore more companies</h3></div>
    <div class="div-search">
        <asp:TextBox runat="server" ID="searchBox" placeholder="Search Company" />
        <asp:HiddenField runat="server" ID="hfCompanyID" />
        <asp:Button runat="server" ID="btnSearch" Text="Search" OnClick="btnSearch_Click" class="btn-style"/>
    </div>

       <asp:UpdatePanel runat="server">
           <ContentTemplate>
               <div class="company-box-container">
                    <asp:PlaceHolder ID="companyBlock" runat="server"></asp:PlaceHolder>
               </div>
               <div>
               <asp:LinkButton ID="btn_prev" Text="Previous Page" runat="server" CssClass="btn-default" OnClick="btn_prev_Click" />
               <asp:LinkButton ID="btn_next" OnClick="btn_next_Click" Text="Next Page" runat="server" CssClass="btn-default" />
               </div>
           </ContentTemplate>
       </asp:UpdatePanel>

   </div>
       
 </div>

   
</asp:Content>

