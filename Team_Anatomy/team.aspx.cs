using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class team : System.Web.UI.Page
{
    public DataTable dtMyTeam;
    public IEnumerable<DataRow> eTeam { get; set; }
    public int[] distinctRMs { get; set; }
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
            if (dt != null && dt.Rows.Count > 0)
            {
                Helper my = new Helper();
                DataRow dr = dt.Rows[0];
                int EmpCode = Convert.ToInt32(dr["Employee_Id"].ToString());
                SqlCommand cmd = new SqlCommand("[WFMP].[TeamList]");
                cmd.Parameters.AddWithValue("@RepMgrCode", EmpCode);
                dtMyTeam = my.GetDataTableViaProcedure(ref cmd);
                eTeam = dtMyTeam.AsEnumerable();
                List<DistinctReportingManagers> DRMList = new List<DistinctReportingManagers>();
                DRMList.AddRange(
                    eTeam.Where(m => m["ReporteeLevel"].ToString() == "1")
                    .Select(t => new DistinctReportingManagers(
                    t["Name"].ToString(),
                    t["Employee_ID"].ToInt32(),
                    t["userimage"].ToString(),
                    t["Designation"].ToString(),
                    t["ReporteeLevel"].ToInt32()
                )).Distinct());

                rptrL1TabHeaders.DataSource = DRMList;
                rptrL1TabContents.DataSource = DRMList;
                rptrL1TabHeaders.DataBind();
                rptrL1TabContents.DataBind();
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
            {
                next = next.AddYears(1);
            }
            else
            {
                next = new DateTime(next.Year + 1, birthday.Month, birthday.Day);
            }
        }

        int numDays = (next - today).Days;
        return numDays;
    }



    protected void rptrL1TabContents_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        //if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        if (e.Item.ItemType == ListItemType.Item)
        {
            DistinctReportingManagers rm = e.Item.DataItem as DistinctReportingManagers;
            int empCode = rm.Employee_ID;

            GridView v = e.Item.Controls[1] as GridView;
            if (v != null)
            {
                //DataRow[] drows = dtMyTeam.AsEnumerable().Where(t => t["RepMgrCode"].ToString() == empCode.ToString()).Distinct().ToArray();
                DataView dv = new DataView(dtMyTeam, "RepMgrCode = " + empCode, "Name Asc", DataViewRowState.CurrentRows);
                v.DataSource = dv;
                v.DataBind();
            }
        }
    }
}


class DistinctReportingManagers
{


    public DistinctReportingManagers(string name, int employee_id, string Userimage, string designation, int reporteelevel)
    {
        this.Name = name;
        this.Employee_ID = employee_id;
        this.userimage = Userimage;
        this.Designation = designation;
        this.ReporteeLevel = reporteelevel;
    }

    public string Name { get; set; }
    public int Employee_ID { get; set; }
    public string userimage { get; set; }
    public string Designation { get; set; }
    public int ReporteeLevel { get; set; }
}