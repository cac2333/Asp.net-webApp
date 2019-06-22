using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using trial.Models;
using System.Web.Security;

namespace trial
{
    public partial class LoginPage : System.Web.UI.Page
    {

        SqlConnection conn = new SqlConnection();

        protected void Page_Load(object sender, EventArgs e)
        {
            var i = 0;

        }


        void ConnectionString()
        {
            conn.ConnectionString = "Data Source=DESKTOP-59T15BS\\SQLEXPRESS;Database=MyDB;Integrated Security=SSPI";
        }


        void SaveToLog(string uname)
        {
            ConnectionString();
            string procedure = "dbo.newLog";

            SqlCommand cmd = new SqlCommand(procedure, conn)
            {
                CommandType = System.Data.CommandType.StoredProcedure
            };

            cmd.Parameters.Add(new SqlParameter("@uname", uname));
            cmd.Parameters.Add(new SqlParameter("@login_time", DateTime.Now));
            cmd.Parameters.Add(new SqlParameter("@ip", Request.UserHostAddress));
            cmd.Parameters.Add(new SqlParameter("@browser", Request.Headers["User-Agent"].ToString()));

            try
            {
                conn.Open();
                cmd.ExecuteNonQuery();
            }
            finally
            {
                if (conn != null)
                    conn.Close();
            }

        }



        protected void Login1_Authenticate(object sender, AuthenticateEventArgs e)
        {
            //reCaptcha validation
            string EncodedResponse = Request.Form["g-Recaptcha-Response"];
            // bool IsValid = ReCaptchaResponse.Validate(EncodedResponse) == "true" ? true : false;
            bool IsValid = true;

            if(IsValid&&Membership.ValidateUser(Login1.UserName, Login1.Password))
            {

                e.Authenticated = true;
                SaveToLog(Login1.UserName);
                FormsAuthentication.SetAuthCookie(Login1.UserName, false);
                FormsAuthentication.RedirectFromLoginPage(Login1.UserName, true); 
            }
            else
            {
                e.Authenticated = false;
            }

            
        }

    }
}