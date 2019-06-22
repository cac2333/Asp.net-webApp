﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Web.Security;

namespace trial
{
    public partial class ContentPage : System.Web.UI.Page
    {

        #region Global arributes

        string gvAddressUniqueID=string.Empty;
        int gvAddressEditIndex = -1;
        string gvOthersUniqueID = string.Empty;
        int gvOthersEditIndex = -1;
        string selectedCountry;
        int id;
        static string connString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);

        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.User.Identity.IsAuthenticated)
                Response.Redirect("LoginPage.aspx");

            Session["Username"] = Page.User.Identity.Name;
            Session["SelectedCompany"] = null;
            Session["SelectedCountry"] = null;;

            if (!IsPostBack)
            {
                GridView1.DataSource = GetTable("dbo.DisplayContacts");
                GridView1.DataBind();
            }

        }

        protected void LoginStatus1_LoggingOut(object sender, LoginCancelEventArgs e)
        {
            Session.Abandon();
            Session.Clear();
        }


        #region Helper functions for databind

        private DataTable GetTable(string procedure, int key = 0)
        {
            DataTable dt = new DataTable("Default_Contacts");
            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            if (procedure == "dbo.DisplayContacts")
                cmd.Parameters.Add(new SqlParameter("@username", Session["Username"]));
            else
            {
                cmd.Parameters.Add(new SqlParameter("@contact_id", key));
            }

            SqlDataAdapter da = new SqlDataAdapter();

            try
            {
                conn.Open();
                da.SelectCommand = cmd;
                da.Fill(dt);
            }
            catch (Exception ex)
            {
                var msg = ex.Message;
            }
            finally
            {
                cmd.Dispose();
                conn.Close();
            }

            return dt;
        }



        private void Update(SqlCommand cmd)
        {
            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                var err = ex.Message;
            }
            finally
            {
                cmd.Dispose();
                conn.Close();
            }
        }


        protected void Company_DataBind(DropDownList ddlCompanies)
        {
            SqlCommand cmd = new SqlCommand("SELECT Company_ID, Company_Name From Company ORDER BY Company_Name", conn);

            try
            {
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataSet dataset = new DataSet();
                adapter.Fill(dataset);
                if (dataset.Tables[0].Rows.Count > 0)
                {
                    ddlCompanies.DataSource = dataset.Tables[0];
                    ddlCompanies.DataTextField = "Company_Name";
                    ddlCompanies.DataValueField = "Company_ID";
                    ddlCompanies.DataBind();
                }
            }
            catch (Exception e)
            {
            }
            finally
            {
                conn.Close();
            }
        }
        #endregion

        #region databind

        //date bound

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
               
                int contact_id = Convert.ToInt32(GridView1.DataKeys[e.Row.RowIndex].Value);
                DropDownList ddlCompanies = (DropDownList)e.Row.FindControl("ddlCompanies");

                GridView gvAddress = (GridView)e.Row.FindControl("gvAddress");
                GridView gvOthers = (GridView)e.Row.FindControl("gvOthers");

                if (gvAddress.UniqueID == gvAddressUniqueID ||gvOthers.UniqueID==gvOthersUniqueID)
                {
                    gvAddress.EditIndex = gvAddressEditIndex;
                    gvOthers.EditIndex = gvOthersEditIndex;
                    //expand the child grid
                    ClientScript.RegisterStartupScript(GetType(), "Expand", "<SCRIPT LANGUAGE='javascript'>expandcollapse('div" + ((DataRowView)e.Row.DataItem)["contact_id"].ToString() + "');</script>");
                }

                    gvAddress.DataSource = GetTable("dbo.DisplayContactAddress", contact_id);
                    gvAddress.DataBind();

                    gvOthers.DataSource = GetTable("dbo.Display_Customized_Contact", contact_id);
                    gvOthers.DataBind();
            }
        }


        protected void gvOthers_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            e.Row.Cells[0].Visible = false;
            if (e.Row.RowIndex==0 )
            {
                e.Row.Visible = false;
            }
  
        }
        #endregion

        #region Row edit
        //edit functions


        protected void GridView1_RowEditing_temp(object sender, GridViewEditEventArgs e)
        {
            GridView1.EditIndex = e.NewEditIndex;

            id = Convert.ToInt32(GridView1.DataKeys[e.NewEditIndex].Value);

            //GridView gv_address = (GridView)GridView1.Rows[e.NewEditIndex].FindControl("gvAddress");
            //GridView gv_others = (GridView)GridView1.Rows[e.NewEditIndex].FindControl("gvOthers");

            //GvAddress_RowEditing(gv_address, e);
            //GvOthers_RowEditing(gv_others, e);

            GridView1.DataSource = GetTable("dbo.DisplayContacts");
            GridView1.DataBind();

            //DropDownList ddlCompanies = (DropDownList)GridView1.Rows[e.NewEditIndex].FindControl("ddlCompanies");
            //Company_DataBind(ddlCompanies);
        }


        protected void GvAddress_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GridView gvTemp = (GridView)sender;
            gvAddressUniqueID = gvTemp.UniqueID;
            gvAddressEditIndex = e.NewEditIndex;
            GridView1.DataSource = GetTable("dbo.DisplayContacts");
            GridView1.DataBind();
            //GridView gvAddress = ((System.Web.UI.WebControls.GridView)sender);
            //gvAddress.EditIndex = e.NewEditIndex;
            //int index = ((GridViewRow)gvAddress.Parent.Parent).RowIndex;
            //int id = Convert.ToInt32(GridView1.DataKeys[index].Value);

            //string[] field = { "address1", "address2", "City" };
            //int size = field.Length;
            //Panel[] panels = new Panel[size];
            //Label[] labels = new Label[size];
            //TextBox[] txt = new TextBox[size];

            //for (int j = 0; j < size; j++)
            //{
            //    int temp = j + 1;
            //    DataTable dt = GetTable("dbo.DisplayContactAddress", id);
            //    panels[j] = (Panel)gvAddress.Rows[0].FindControl("Panel" + temp);
            //    labels[j] = (Label)gvAddress.Rows[0].FindControl("Label" + temp);
            //    txt[j] = (TextBox)gvAddress.Rows[0].FindControl("txtAddr" + temp);
            //    labels[j].Visible = false;
            //    txt[j].Text = dt.Rows[0][field[j]].ToString();
            //    panels[j].Visible = true;
            //    panels[j].Controls.Add(txt[j]);
            //    txt[j].Visible = true;
            //}
            //gvAddress.DataSource = GetTable("dbo.DisplayContactAddress", id);
            //gvAddress.DataBind();
        }

        #endregion


        #region Row Updating

        protected void GvOthers_RowEditing(object sender, GridViewEditEventArgs e)
        {

        }


        //update functions

        protected void GridView1_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

            int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
            string company = ((DropDownList)GridView1.Rows[e.RowIndex].FindControl("ddlCompanies")).SelectedValue;
            string first_name = e.NewValues["first_name"].ToString();
            string last_name = e.NewValues["last_name"].ToString();
            string phone = e.NewValues["phone"].ToString();
            string email = e.NewValues["email"].ToString();

            if (!ValidateEmail(email))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Invalid email');", true);
                return;
            }

            string procedure = "dbo.UpdateContact";
            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.Add(new SqlParameter("@contact_id", id));
            cmd.Parameters.Add(new SqlParameter("@company", company));
            cmd.Parameters.Add(new SqlParameter("@user", Page.User.Identity.Name));
            cmd.Parameters.Add(new SqlParameter("@phone", phone));
            cmd.Parameters.Add(new SqlParameter("@first_name", first_name));
            cmd.Parameters.Add(new SqlParameter("@last_name", last_name));
            cmd.Parameters.Add(new SqlParameter("@ip", Request.UserHostAddress));
            cmd.Parameters.Add(new SqlParameter("@email", email));
            Update(cmd);

            GridView1.EditIndex = -1;
            Session["SelectedCompany"] = null;
            GridView1.DataSource = GetTable("dbo.DisplayContacts");
            GridView1.DataBind();
        }


        protected void GvAddress_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridView gvAddress = ((System.Web.UI.WebControls.GridView)sender);
            int index = ((GridViewRow)gvAddress.Parent.Parent).RowIndex;
            int id = Convert.ToInt32(GridView1.DataKeys[index].Value);

            string address1 = ((TextBox)gvAddress.Rows[e.RowIndex].FindControl("txtAddress1")).Text;
            string address2 = ((TextBox)gvAddress.Rows[e.RowIndex].FindControl("txtAddress2")).Text;
            string city = ((TextBox)gvAddress.Rows[e.RowIndex].FindControl("txtCity")).Text;
            //string province = ((DropDownList)gvAddress.Rows[e.RowIndex].FindControl("ddlProvince")).SelectedValue;
            string province = ((TextBox)gvAddress.Rows[e.RowIndex].FindControl("txtProvince")).Text;
            string country = ((DropDownList)gvAddress.Rows[e.RowIndex].FindControl("ddlCountry")).SelectedValue;
            string postalCode = ((TextBox)gvAddress.Rows[e.RowIndex].FindControl("txtPostalCode")).Text;


            string procedure = "dbo.UpdateAddress";
            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new SqlParameter("@contact_id", id));
            cmd.Parameters.Add(new SqlParameter("@address_id", gvAddress.DataKeys[e.RowIndex].Value));
            cmd.Parameters.Add(new SqlParameter("@address1", address1));
            cmd.Parameters.Add(new SqlParameter("@address2", address2));
            cmd.Parameters.Add(new SqlParameter("@city", city));
            cmd.Parameters.Add(new SqlParameter("@province", province));
            cmd.Parameters.Add(new SqlParameter("@country",country));
            cmd.Parameters.Add(new SqlParameter("@postal", postalCode));
            cmd.Parameters.Add(new SqlParameter("@update_by", Session["Username"]));
            cmd.Parameters.Add(new SqlParameter("@update_ip", Request.UserHostAddress));
            Update(cmd);

            //for (int j = 0; j <= g.Rows.Count - 1; j++)
            //{
            //    txt[j] = (TextBox)g.Rows[0].FindControl("txtAddr"+j+1);
            //    cm.update("update state set statename='" +
            //    txt.Text + "' where stateid=" + sid + "");
            //}

            gvAddress.EditIndex = -1;
            gvAddress.DataSource = GetTable("dbo.DisplayContactAddress", id);
            gvAddress.DataBind();

        }
        #endregion


        #region Deleting

        protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {

            int id = Convert.ToInt32(GridView1.DataKeys[e.RowIndex].Value);
            string procedure = "dbo.DeleteContact";
            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new SqlParameter("@contact_id", id));

            Update(cmd);
            GridView1.DataSource = GetTable("dbo.DisplayContacts");
            GridView1.DataBind();
        }

        protected void gvOthers_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            GridView gvOthers = (GridView)sender;
            int field_id = Convert.ToInt32(gvOthers.DataKeys[e.RowIndex].Value);
            string procedure = "dbo.DeleteCustomizedContact";

            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = CommandType.StoredProcedure
            };

            cmd.Parameters.Add(new SqlParameter("@field_id", field_id));
            Update(cmd);

            GridView1.DataSource = GetTable("dbo.DisplayContacts");
            GridView1.DataBind();
        }

        #endregion



        #region Cancel Editing
        protected void GridView1_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView1.EditIndex = -1;
            Session["SelectedCompany"] = null;
            GridView1.DataSource = GetTable("dbo.DisplayContacts");
            GridView1.DataBind();
        }


    

        protected void GvAddress_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            GridView gvAddress = (GridView)sender;
            gvAddress.EditIndex = -1;
            GridView1.DataSource = GetTable("dbo.DisplayContacts");
            GridView1.DataBind();

        }

        #endregion


        #region Handle dropDownLists inside the gridview

        protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
        {

            DropDownList ddlCountry = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddlCountry.Parent.Parent;
            GridView gvAddress = (GridView)row.Parent.Parent;
            gvAddressUniqueID = gvAddress.UniqueID;
            gvAddressEditIndex = row.RowIndex;
            //RegularExpressionValidator revPost = (RegularExpressionValidator)row.FindControl("revPost");
            selectedCountry = ddlCountry.SelectedValue;
                //GridView1.DataSource = GetTable("dbo.DisplayContacts");
                //GridView1.DataBind();
                //State_DataBind(country, row);

            //if (country == "Canada")
            //{
            //    //not in xml so use \\
            //    revPost.ValidationExpression = "[ABCEGHJKLMNPRSTVXY]\\d[ABCEGHJ-NPRSTV-Z][ ]?\\d[ABCEGHJ-NPRSTV-Z]\\d";
            //}
            //else if (country == "USA")
            //{
            //    revPost.ValidationExpression = "\\d{5}([ \\-]\\d{4})?";
            //}
        }

        protected void State_DataBind(string country, GridViewRow row)
        {
            DropDownList ddlStates = (DropDownList)row.FindControl("ddlProvince");
            string procedure = "dbo.Display_States";

            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new SqlParameter("@Country", country));

            try
            {
                conn.Open();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataSet dataset = new DataSet();
                adapter.Fill(dataset);
                if (dataset.Tables[0].Rows.Count > 0)
                {
                    ddlStates.DataSource = dataset.Tables[0];
                    ddlStates.DataTextField = "name";
                    ddlStates.DataValueField = "name";
                    ddlStates.DataBind();
                }
            }
            catch (Exception e)
            {
            }
            finally
            {
                conn.Close();
            }
        }

        protected void ddlCountry_DataBound(object sender, EventArgs e)
        {
            DropDownList ddlCountry = (DropDownList)sender;
            GridViewRow row = (GridViewRow)ddlCountry.Parent.Parent;
            string country = ddlCountry.SelectedValue;
           // State_DataBind(country, row);
        }




        #endregion



        #region other commands

        protected void gvOthers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            GridView gvOthers = ((System.Web.UI.WebControls.GridView)sender);
            int index = ((GridViewRow)gvOthers.Parent.Parent).RowIndex;
            int id = Convert.ToInt32(GridView1.DataKeys[index].Value);
            string procedure = "dbo.AddCustomizedInfo";

            if (e.CommandName == "Add")
            {

                TextBox txtName = (TextBox)gvOthers.FooterRow.FindControl("footerName");
                TextBox txtValue = (TextBox)gvOthers.FooterRow.FindControl("footerValue");
                SqlCommand cmd = new SqlCommand(procedure, conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.Add(new SqlParameter("@contact_id", id));
                cmd.Parameters.Add(new SqlParameter("field_name", txtName.Text));
                cmd.Parameters.Add(new SqlParameter("field_value", txtValue.Text));
                Update(cmd);

                //gvOthers.DataSource = GetTable("dbo.Display_Customized_Info", id);
                //gvOthers.DataBind();
                GridView1.DataSource = GetTable("dbo.DisplayContacts", id);
                GridView1.DataBind();

            }

            //if (e.CommandName == "Delete")
            //{
            //    GridViewRow gvr = (GridViewRow)(((LinkButton)e.CommandSource).NamingContainer);
            //    gvOthers_RowDeleting(sender, gvr.RowIndex);
            //}
        }

        #endregion


        private bool ValidateEmail(string email)
        {
            
                try
                {
                    var addr = new System.Net.Mail.MailAddress(email);
                    return addr.Address == email;
                }
                catch
                {
                    return false;
                }
            
        }
    }
}