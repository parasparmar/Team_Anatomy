using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using CsvHelper;
using System.Globalization;
using System.IO;
using System.Text;

public partial class myroster : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    // string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private DateTime toDate { get; set; }
    private DateTime fromDate { get; set; }
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

        if (!IsPostBack)
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp == null)
                {
                    Response.Redirect("index.aspx", false);
                }
                else
                {
                    // In Production Use the below
                    MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());

                }
            }
            catch (Exception Ex)
            {
                Console.WriteLine(Ex.Message.ToString());
                Response.Redirect("index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Site Rosters";

            fillddlCountry();
            fillddlSite();
            fillddlLocation();
            fillddlWeekSelection();

        }
    }
    private void fillddlCountry()
    {
        string strSQL = "SELECT A.CountryID,B.Country,A.MarketID,B.Market,A.SiteID,C.Location,C.Site ";
        strSQL += " FROM [CWFM_Umang].[WFMP].[tblMappingMst] A ";
        strSQL += " Left Join [CWFM_Umang].[WFMP].[tblCountry] B on B.TransID = A.CountryID ";
        strSQL += " Left Join [CWFM_Umang].[WFMP].[tblSite] C on C.TransID = A.SiteID ";
        DataTable dt = new DataTable();
        dt = my.GetData(strSQL);
        ddlCountry.DataSource = dt;
        ddlCountry.DataTextField = "Country";
        ddlCountry.DataValueField = "CountryID";
        ddlCountry.SelectedValue = "77";
        ddlCountry.DataBind();
    }
    private void fillddlSite()
    {
        string strSQL = "SELECT A.CountryID,B.Country,A.MarketID,B.Market,A.SiteID,C.Location,C.Site ";
        strSQL += " FROM [CWFM_Umang].[WFMP].[tblMappingMst] A ";
        strSQL += " Inner Join [CWFM_Umang].[WFMP].[tblCountry] B on B.TransID = A.CountryID ";
        strSQL += " Inner Join [CWFM_Umang].[WFMP].[tblSite] C on C.TransID = A.SiteID ";
        strSQL += " where  A.CountryID  = '" + ddlCountry.SelectedValue.ToString() + "'";

        DataTable dt = my.GetData(strSQL);
        ddlSite.DataSource = dt;
        ddlSite.DataTextField = "Site";
        ddlSite.DataValueField = "SiteID";
        ddlSite.SelectedValue = "1";
        ddlSite.DataBind();

    }
    protected void ddlCountry_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlSite();
        ddlSite_SelectedIndexChanged(ddlCountry, new EventArgs());
    }
    private void fillddlLocation()
    {
        string strSQL = "SELECT A.CountryID,B.Country,A.MarketID,B.Market,A.SiteID,C.Location,C.Site ";
        strSQL += " FROM [CWFM_Umang].[WFMP].[tblMappingMst] A ";
        strSQL += " Inner Join [CWFM_Umang].[WFMP].[tblCountry] B on B.TransID = A.CountryID ";
        strSQL += " Inner Join [CWFM_Umang].[WFMP].[tblSite] C on C.TransID = A.SiteID ";
        strSQL += " where  A.SiteID =  '" + ddlSite.SelectedValue.ToString() + "'";

        DataTable dt = my.GetData(strSQL);
        ddlLocation.DataSource = dt;
        ddlLocation.DataTextField = "Location";
        ddlLocation.DataValueField = "SiteID";
        ddlLocation.SelectedValue = "1";
        ddlLocation.DataBind();
    }
    protected void ddlSite_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlLocation();
        ddlLocation_SelectedIndexChanged(ddlSite, new EventArgs());
    }
    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        fillddlWeekSelection();
    }
    private void fillddlWeekSelection()
    {
        string strSQL = "[WFMP].[GetWeeks]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Year", 0);
        ddlWeekSelection.DataSource = my.GetDataTableViaProcedure(ref cmd);
        ddlWeekSelection.DataTextField = "Dates";
        ddlWeekSelection.DataValueField = "Id";
        ddlWeekSelection.DataBind();
        cmd = null;
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
    protected void ddlFromDate_TextChanged(object sender, EventArgs e)
    {
        getFromAndToDates();
        btnDownloadRoster.Enabled = true;
    }
    private void getFromAndToDates()
    {
        rdoCustomDateSelection.Checked = true;
        rdoWeekSelection.Checked = false;
        if (ddlFromDate.Text.Length > 0 && ddlToDate.Text.Length > 0)
        {
            DateTime fromDate = Convert.ToDateTime(ddlFromDate.Text);
            DateTime toDate = Convert.ToDateTime(ddlToDate.Text);
            if (fromDate > toDate)
            {
                ddlFromDate.Text = toDate.ToString();
                ddlToDate.Text = fromDate.ToString();
                fromDate = toDate;
                toDate = Convert.ToDateTime(ddlFromDate.Text);
            }
            btnDownloadRoster.Text = "Download: " + fromDate.ToString("dd-MMM") + " to " + toDate.ToString("dd-MMM");
        }

    }
    protected void ddlToDate_TextChanged(object sender, EventArgs e)
    {
        getFromAndToDates();
        btnDownloadRoster.Enabled = true;
    }
    protected void ddlWeekSelection_SelectedIndexChanged(object sender, EventArgs e)
    {
        rdoWeekSelection.Checked = true;
        btnDownloadRoster.Enabled = true;
        //int WeekID = Convert.ToInt32(ddlWeekSelection.SelectedValue.ToString());

        //btnDownloadRoster.Text = "Download: " + fromDate.ToString("dd-MMM") + " to " + toDate.ToString("dd-MMM");
    }
    protected void btnDownloadRoster_Click(object sender, EventArgs e)
    {
        my = new Helper();
        string FileName = "Sitel " + ddlSite.SelectedItem.ToString() + " Roster ";

        string strSQL;
        if (rdoCustomDateSelection.Checked)
        {
            if (ddlFromDate.Text.Length > 0 && ddlToDate.Text.Length > 0)
            {
                fromDate = Convert.ToDateTime(ddlFromDate.Text);
                toDate = Convert.ToDateTime(ddlToDate.Text);
                // Swap dates if From is After To date.
                if (fromDate > toDate)
                {
                    ddlFromDate.Text = toDate.ToString();
                    ddlToDate.Text = fromDate.ToString();
                    fromDate = toDate;
                    toDate = Convert.ToDateTime(ddlFromDate.Text);
                }
            }
        }
        else if (rdoWeekSelection.Checked)
        {
            strSQL = "SELECT [WeekId],[FrDate],[ToDate] FROM [CWFM_Umang].[WFMP].[tblRstWeeks] ";
            strSQL += " where [WeekId] = " + ddlWeekSelection.SelectedValue;
            DataTable dt = my.GetData(strSQL);
            fromDate = Convert.ToDateTime(dt.Rows[0]["FrDate"].ToString());
            toDate = Convert.ToDateTime(dt.Rows[0]["ToDate"].ToString());
            dt.Dispose();
        }
        else
        {

        }

        if (fromDate <= toDate)
        {
            strSQL = "[WFMP].[Roster_GetAdminFormatRoster]";
            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@FromDate", fromDate);
            cmd.Parameters.AddWithValue("@ToDate", toDate);
            DataTable d = my.GetDataTableViaProcedure(ref cmd);
            d.Columns.Remove("ShiftID");
            d.Columns.Remove("CountryID");
            d.Columns.Remove("SiteID");
            d.Columns.Remove("LOBID");
            d.Columns.Remove("ResType");

            string[] rowFields = { "ECN", "NAME", "PROCESS", "TL_ECN", "TEAM_LEADER" };
            string[] columnFields = { "ShiftDate" };
            Pivot pvt = new Pivot(d);
            d = pvt.PivotData("ShiftCode", AggregateFunction.First, rowFields, columnFields);
            DateTime myDate;
            foreach (DataColumn dc in d.Columns)
            {
                if (DateTime.TryParse(dc.ColumnName, out myDate))
                {
                    dc.ColumnName = myDate.ToString("ddd dd-MMM-yyyy");
                    //dc.ColumnName = myDate.ToString("(ddd) dd-MMM-yyyy");
                    //dc.ColumnName = myDate.ToString("ddd(dd)");
                }
            }


            //// Use only if you wish to see what's getting sent to the csv download.
            //gvRoster.DataSource = d;
            //gvRoster.DataBind();

            FileName += fromDate.ToString("dd-MMM-yyyy") + " to " + toDate.ToString("dd-MMM-yyyy") + ".csv";
            //Get the physical path to the file.
            string FilePath = Server.MapPath("Sitel//roster_downloads//" + FileName);
            using (var textWriter = File.CreateText(FilePath))
            {
                using (var csv = new CsvWriter(textWriter))
                {
                    // Write columns
                    foreach (DataColumn column in d.Columns)
                    {
                        csv.WriteField(column.ColumnName);
                    }
                    csv.NextRecord();

                    // Write row values
                    foreach (DataRow row in d.Rows)
                    {
                        for (var i = 0; i < d.Columns.Count; i++)
                        {
                            csv.WriteField(row[i]);
                        }
                        csv.NextRecord();
                    }
                }
            }

            //Send the CSV file as a Download.
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=" + FileName);
            Response.Charset = "";
            Response.ContentType = "application/text";
            Response.Output.Write(File.ReadAllText(FilePath));
            Response.Flush();
            Response.End();
        }
    }
}