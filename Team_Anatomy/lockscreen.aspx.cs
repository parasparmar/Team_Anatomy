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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            string UserText = Session["myID"].ToString();
            UserText +=", <br /><br />The application could not find you in our employee database.<br />You can however, request it to be updated by filling in the details below.";
            ltlUserID.Text = UserText;
            currentYear.Text = DateTime.Today.Year.ToString();

        }
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {

        string strEmpID = tbEmpID.Value;
        string ntName = PageExtensionMethods.getMyWindowsID();
        int EmpID = 0;
        if (Int32.TryParse(strEmpID, out EmpID))
        {
            int rowcount = Convert.ToInt32(P.getSingleton("Select count(*) from [CWFM_Umang].[WFMP].[tblMaster] where [Employee_ID] = " + EmpID));
            if (rowcount == 0)
            {
                string strSQL = "INSERT INTO [CWFM_Umang].[WFMP].[tblMaster] ([Employee_ID],[ntName],EmpStatus, TrngStatus) VALUES (@Employee_ID, @ntName,@EmpStatus, @TrngStatus)";
                SqlCommand c = new SqlCommand(strSQL);
                c.Parameters.AddWithValue("@Employee_ID", EmpID);
                c.Parameters.AddWithValue("@ntName", ntName);
                c.Parameters.AddWithValue("@EmpStatus", 0);
                c.Parameters.AddWithValue("@TrngStatus", 0);
                int rowsAffected = P.ExecuteDMLCommand(ref c, strSQL, "E");
                btnSubmit.Enabled = false;
                string UserText = ntName;
                UserText += ", <br /><br />Your Employee Code has been added to the employee database.<br />To access this application your reporting managers would need to update a few more details.";
                UserText += "";

            }
            else
            {
                btnSubmit.Enabled = false;
            }

        }
    }
}