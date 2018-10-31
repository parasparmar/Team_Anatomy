using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;

public partial class team : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        fillTeamList();
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Team List";

    }

    private void fillTeamList()
    {
        try
        {
            DataTable dt = Session["dtEmp"] as DataTable;
            if (dt.Rows.Count > 0)
            {
                Helper my = new Helper();
                DataRow dr = dt.Rows[0];
                int EmpCode = Convert.ToInt32(dr["Employee_Id"].ToString());

                DataTable dtMyTeam = my.GetData("Exec [WFMP].[TeamList] " + EmpCode);
                gv_TeamList.DataSource = dtMyTeam;
                gv_TeamList.DataBind();
            }
            else
            {
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
        }
        catch (Exception Ex)
        {
            string Message = Ex.Message;
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
    }

    protected void btn_Submit_Click(object sender, EventArgs e)
    {

    }
    protected void btnReset_Click(object sender, EventArgs e)
    {

    }

    protected void gv_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;
        if (gv.Rows.Count > 0)
        {
            gv.UseAccessibleHeader = true;
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;

            gv.HeaderStyle.BorderStyle = BorderStyle.None;

            gv.BorderStyle = BorderStyle.None;
            gv.BorderWidth = Unit.Pixel(1);
        }
    }
    protected void gv_TeamList_RowCommand(object sender, GridViewCommandEventArgs e)
    {

    }

    private static int GetDaysUntilBirthday(DateTime birthday)
    {
        DateTime today = DateTime.Today;
        DateTime next = birthday.AddYears(today.Year - birthday.Year);

        if (next < today)
        {
            if (!DateTime.IsLeapYear(next.Year + 1))
                next = next.AddYears(1);
            else
                next = new DateTime(next.Year + 1, birthday.Month, birthday.Day);
        }

        int numDays = (next - today).Days;
        return numDays;
    }
}