using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace trial
{
    public partial class CompanyList : System.Web.UI.Page
    {

        static int page = 0;
        const int num = 6;
        static string connString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["LocalSqlServer"].ConnectionString;
        static SqlConnection conn = new SqlConnection(connString);
        static DataTable companyTable;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.User.Identity.IsAuthenticated)
                Response.Redirect("LoginPage.aspx");
            Session["Username"] = Page.User.Identity.Name;

            if (!IsPostBack)
            {
                page = 0;
                companyTable = new DataTable("Company");
                int id;
                if (Request.QueryString["id"] != null && Request.QueryString["id"] != "")
                {
                    LoadCompanies(Convert.ToInt32(Request.QueryString["id"]));
                }
                else
                {
                    LoadCompanies();
                }
                
                ShowCompany(page);
            }
            else {
                string postbackControlID = Page.Request.Params["__EVENTTARGET"];
                if (postbackControlID != "" && postbackControlID != null)
                {
                    LinkButton postbackControl = (LinkButton)Page.FindControl(postbackControlID);
                    if (postbackControl == btn_next)
                        ShowCompany(++page);
                    if (postbackControl == btn_prev)
                        ShowCompany(--page);
                }
            }
           
        }

        protected void ShowCompany(int page)
        {
            companyBlock.Controls.Clear();

            for(int i=0;i<num&&page*num+i<companyTable.Rows.Count; i++)
            {
                Panel panel = new Panel();
                panel.CssClass = "company-box text-center";

                HtmlGenericControl p1 = new HtmlGenericControl("h3");
                p1.InnerText = companyTable.Rows[page+i].ItemArray[0].ToString();
                panel.Controls.Add(p1);

                HtmlGenericControl p2 = new HtmlGenericControl("p");
                p2.InnerText = companyTable.Rows[page + i].ItemArray[1].ToString()+"  "+ companyTable.Rows[page + i].ItemArray[3];
                panel.Controls.Add(p2);

                HiddenField cid = new HiddenField();
                cid.Value = companyTable.Rows[page + i].ItemArray[4].ToString();
                panel.Controls.Add(cid);

                LinkButton btn = new LinkButton();
                btn.Text = "View";
                btn.PostBackUrl = "CompanyPage.aspx?id=" + cid.Value;
                btn.Click += new EventHandler(Redirect);
                panel.Controls.Add(btn);
                companyBlock.Controls.Add(panel);
            }

            if (companyTable.Rows.Count < (page + 1) * num)
            {
                btn_next.Enabled = false;
            }
            else
            {
                btn_next.Enabled = true;
            }
            if (page <= 0)
            {
                btn_prev.Enabled = false;
            }
            else
            {
                btn_prev.Enabled = true;
            }

        }

        protected void Redirect(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            HiddenField hf = (HiddenField)((Panel)btn.Parent).Controls[2];
            Response.Redirect("CompanyPage.aspx?id=" + hf.Value);
        }


        #region Load from database

        protected void LoadCompanies(int id=-1) {
            String procedure = "dbo.ShowCompanies";
            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = CommandType.StoredProcedure
            };
            cmd.Parameters.Add(new SqlParameter("@company_id", id));

            try
            {
                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(companyTable);
            }
            catch (Exception e)
            {

            }
            finally
            {
                cmd.Dispose();
                conn.Close();
            }
        }

        [WebMethod]
        public static string[] GetCompanies(string prefix)
        {
            List<string> companies = new List<string>();
            String fetchCompany = "SELECT Company_Name, Company_ID FROM Company WHERE Company_Name LIKE @SearchText +'%'";
            SqlCommand cmd = new SqlCommand(fetchCompany, conn);
            cmd.Parameters.Add(new SqlParameter("@SearchText", prefix));

            try
            {
                conn.Open();
                SqlDataReader rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    companies.Add(string.Format("{0}-{1}", rdr["Company_Name"], rdr["Company_ID"]));

                }
            }
            catch (Exception e)
            {
               
            }
            finally
            {
                cmd.Dispose();
                conn.Close();
            }
            return companies.ToArray();
        }

        #endregion


        #region event handler

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            Response.Redirect("CompanyList.aspx?id=" + hfCompanyID.Value);
        }

        protected void Company_Click(object sender, EventArgs e)
        {
            Response.Redirect("ContentPage.aspx?id=" + hfCompanyID.Value);
        }

        protected void btn_next_Click(object sender, EventArgs e)
        {

        }

        protected void btn_prev_Click(object sender, EventArgs e)
        {
          
        }
        #endregion
    }
}