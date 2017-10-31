using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;

public partial class lockscreen : System.Web.UI.Page
{
    Helper P = new Helper();
    string myid = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            myid = Session["myid"].ToString();
            string UserText = myid;
            UserText += ", <br /><br />The application could not find you in our employee database.<br />You can however, request it to be updated by filling in the details below.";
            ltlUserID.Text = UserText;
            currentYear.Text = DateTime.Today.Year.ToString();
        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        string strSQL;
        string strEmpID = tbEmpID.Value;
        string ntName = Session["myid"].ToString();
        int EmpID = 0;
        if (Int32.TryParse(strEmpID, out EmpID))
        {
            int rowcount = Convert.ToInt32(P.getSingleton("Select count(*) from [CWFM_Umang].[WFMP].[tblMaster] where [Employee_ID] = " + EmpID));
            if (rowcount == 0)
            {
                strSQL = "INSERT INTO [CWFM_Umang].[WFMP].[tblMaster] ([Employee_ID],[ntName],EmpStatus, TrngStatus) VALUES (@Employee_ID, @ntName,@EmpStatus, @TrngStatus)";
                btnSubmit.Enabled = false;
                string UserText = ntName;
                UserText += ", <br /><br />Your Employee Code has been added to the employee database.<br />To access this application your reporting managers would need to update a few more details.";
                UserText += "";
            }
            else
            {
                // This is dangerous code as it may lead to an escalation of privilege attack.
                // Management has been advised 31/10/2017 12.25 AM, **however** clear 
                // and specific directions were given for this requirement to be implemented as per the below.
                strSQL = "Update [CWFM_Umang].[WFMP].[tblMaster] ";
                strSQL += " Set [ntName] = @ntName,EmpStatus=0,TrngStatus=0";
                strSQL += " Where [Employee_ID] = @Employee_ID";
                string UserText = ntName;
                UserText += ", <br /><br />Your Employee Code has been updated.<br />To access this application your reporting managers would need to update a few more details.";
                UserText += "";

            }

            using (SqlConnection q = new SqlConnection(P.getConnectionString()))
            {
                q.Open();
                using (SqlCommand c = new SqlCommand(strSQL, q))
                {

                    c.Parameters.AddWithValue("@Employee_ID", EmpID);
                    c.Parameters.AddWithValue("@ntName", ntName);
                    c.Parameters.AddWithValue("@EmpStatus", 0);
                    c.Parameters.AddWithValue("@TrngStatus", 0);
                    int rowsAffected = c.ExecuteNonQuery();
                }
            }
            btnSubmit.Enabled = false;

            Response.Redirect("index.aspx", false);
        }
    }
}