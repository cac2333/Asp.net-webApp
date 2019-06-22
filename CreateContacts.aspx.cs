using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;

namespace trial
{
    public partial class CreateContacts : System.Web.UI.Page
    {

        static string connString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString;
        SqlConnection conn = new SqlConnection(connString);


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.User.Identity.IsAuthenticated)
                Response.Redirect("LoginPage.aspx");

            if (!IsPostBack)
            {
                Company_DataBind();
            }

        }

        protected void submit_btn_Click(object sender, EventArgs e)
        {
            string message = string.Format("{0} have chosen {1}.", Page.User.Identity.Name, ddlCompanies.SelectedValue);
            Msg.Text = message;
            string procedure = "dbo.Add_Contact";

            //if user choose to use the default value, query the address id from the database
            //else add a new address and return its id

            int address_id = checkAddress.Checked ? 0 : InsertAddress();

            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new SqlParameter("@company_id", ddlCompanies.SelectedValue));
            cmd.Parameters.Add(new SqlParameter("@username", Page.User.Identity.Name));
            cmd.Parameters.Add(new SqlParameter("@address", address_id));
            cmd.Parameters.Add(new SqlParameter("@phone", txtPhone.Text));
            cmd.Parameters.Add(new SqlParameter("@first_name", txtFirstName.Text));
            cmd.Parameters.Add(new SqlParameter("@last_name", txtLastName.Text));
            cmd.Parameters.Add(new SqlParameter("@title", ddlTitles.SelectedValue));
            cmd.Parameters.Add(new SqlParameter("@ip", Request.UserHostAddress));
            cmd.Parameters.Add(new SqlParameter("@email", txtEmail.Text));

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
                PopupScript("This contact has been added successfully. You will now be redirected to home page.", "Default.aspx");
                
            }
            catch (Exception ex)
            {
                errorMsg.Text = ex.Message;
            }
            finally
            {
                conn.Close();
            }
        }

        protected void btnEvent_Click(object sender, EventArgs e)
        {

        }

        protected void checkAddress_CheckedChanged(object sender, EventArgs e)
        {
            if (checkAddress.Checked == true)
                panelAddress.Visible = false;
            else
                panelAddress.Visible = true;
        }

        protected void ddlCountries_SelectedIndexChanged(object sender, EventArgs e)
        {
            string country = ddlCountries.SelectedValue;
            State_DataBind(country);

            if (country == "Canada")
            {
                //not in xml so use \\
                revPost.ValidationExpression = "[ABCEGHJKLMNPRSTVXY]\\d[ABCEGHJ-NPRSTV-Z][ ]?\\d[ABCEGHJ-NPRSTV-Z]\\d";
            }
            else if (country == "USA")
            {
                revPost.ValidationExpression = "\\d{5}([ \\-]\\d{4})?";
            }

        }


        protected void Company_DataBind()
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
                errorMsg.Text = "Something went wrong. Please try again.";
            }
            finally
            {
                conn.Close();
            }
        }


        protected void State_DataBind(string country)
        {
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
                errorMsg.Text = "Something went wrong. Please try again.";
            }
            finally
            {
                conn.Close();
            }
        }


        private int InsertAddress()
        {
            string procedure = "dbo.Add_Address";
            SqlDataReader rdr= null;

            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new SqlParameter("@line1", AddressLine1.Text));
            cmd.Parameters.Add(new SqlParameter("@line2", AddressLine2.Text));
            cmd.Parameters.Add(new SqlParameter("@city", city.Text));
            cmd.Parameters.Add(new SqlParameter("@state", ddlStates.SelectedValue));
            cmd.Parameters.Add(new SqlParameter("@country", ddlCountries.SelectedValue));
            cmd.Parameters.Add(new SqlParameter("@postalCode", txtPost.Text));
            cmd.Parameters.Add(new SqlParameter("@username", Page.User.Identity.Name));

            try
            {
                conn.Open();
                rdr= cmd.ExecuteReader();

                if (rdr.Read())
                {
                  //  id = (int)rdr.GetInt32(0);
                    var id = rdr.GetValue(0);
                    return Convert.ToInt32(id);
                }
            }
            catch (Exception e)
            {
                errorMsg.Text = e.Message;
            }
            finally
            {
                conn.Close();
            }

            return 0;
        }

        private void PopupScript(string msg, string url)
        {
            string script = "window.onload = function(){ alert('";
            script += msg;
            script += "');";
            script += "window.location = '";
            script += url;
            script += "'; }";
            // string script = string.Format("window.onload=function(){ alter(\' {0} \'); window.location=\'{1}\';}", msg, url);
            ClientScript.RegisterStartupScript(this.GetType(), "Redirect", script, true);
        }

    }
}