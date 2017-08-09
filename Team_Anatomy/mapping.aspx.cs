using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class mapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string SQL = "Select Distinct employee_id as Name from WFM_Employee_List where Designation in ('Director','Lead Scheduler','Manager 1','Manager 2','Senior Analyst','Senior Manager','Senior Workforce Coordinator','Sr. RTA Coor')";
    }
}