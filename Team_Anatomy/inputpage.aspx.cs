using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using OfficeOpenXml;

public partial class inputpage : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    //private int[] AuthorizedIDs = new int[6] { 755882, 931040, 923563, 918031, 1092308, 798904 };
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        //try
        //{
        //    dtEmp = (DataTable)Session["dtEmp"];
        //    if (dtEmp.Rows.Count <= 0)
        //    {
        //        Response.Redirect("index.aspx", false);
        //    }
        //    else
        //    {
        //        // In Production Use the below
        //        MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
        //    }
        //}
        //catch (Exception Ex)
        //{
        //    Console.WriteLine(Ex.Message.ToString());
        //    Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        //}
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Kronos";
        hfNTID.Value = PageExtensionMethods.getMyWindowsID();
        if (!IsPostBack)
        {
            fillddlMonth();
        }
    }
    private void fillddlMonth()
    {
        SqlCommand cmd = new SqlCommand("GetMonthProdHrsChk");
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlMonth.DataSource = dt;

        ddlMonth.DataTextField = "Month";
        ddlMonth.DataValueField = "Month";
        ddlMonth.DataBind();
        //ddlMonth.Items.Insert(0, new ListItem("All", "0"));
        ddlMonth_SelectedIndexChanged(this, new EventArgs());

    }
    private void FillGvInputPage()
    {
        //SqlCommand cmd = new SqlCommand("Exec [ProdHrsChkComparison] '20180701','ALL','ALL','ALL'");
        //DataTable dt = my.GetData(ref cmd);
        //gvInputGrid.DataSource = dt;
        //gvInputGrid.DataBind();
    }

    private void fillTabOverall()
    {
        SqlCommand cmd = new SqlCommand("ProdHrsChk");
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@XMONTH", ddlMonth.SelectedValue.ToDateTime());
        cmd.Parameters.AddWithValue("@MARKET", ddlMarket.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@FACILITY", ddlFacility.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@ACCOUNT", ddlAccount.SelectedValue.ToString());
        cmd.Connection = my.open_db();
        SqlDataAdapter da = new SqlDataAdapter(cmd);

        DataSet ds = new DataSet();
        da.Fill(ds);
        string tableID = "gvOverall";
        int i = 1;
        foreach (DataTable dt in ds.Tables)
        {
            tableID = "gvOverall" + i;
            GridView gv = tabOverall.FindControlRecursive(tableID) as GridView;
            gv.DataSource = dt;
            gv.DataBind();
            i++;
        }
        my.close_conn();
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

    protected void gvInputGrid_RowEditing(object sender, GridViewEditEventArgs e)
    {
        GridView gvInput = sender as GridView;
        gvInput.Rows[e.NewEditIndex].RowState = DataControlRowState.Edit;


    }

    protected void gvInputGrid_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Update")
        {
            GridView gv = sender as GridView;
            gv.SelectedIndex = Convert.ToInt32(e.CommandArgument);
            LinkButton lb = gv.Rows[gv.SelectedIndex].FindControlRecursive("lnkSaveComments") as LinkButton;
            lnkSaveComments_Click(lb, e);
        }
    }

    protected void lnkSaveComments_Click(object sender, EventArgs e)
    {
        LinkButton lb = sender as LinkButton;
        GridViewRow gvr = lb.Parent.Parent as GridViewRow;

        int index = gvr.RowIndex;

        TextBox tComments = gvr.FindControlRecursive("lblComments") as TextBox;
        string Comments = tComments.Text.ToString();
        int EmpCode = gvr.Cells[gvr.GetGVCellUsingFieldName("EmpCode")].Text.ToInt32();
        string UpdatedBy = PageExtensionMethods.getMyWindowsID();
        DateTime myMonth = ddlMonth.SelectedValue.ToDateTime();
        //int UpdatedBy = MyEmpID;
        string strSQL = "[UpdateProdHrsChk]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", EmpCode);
        cmd.Parameters.AddWithValue("@Month", myMonth);
        cmd.Parameters.AddWithValue("@Comments", Comments);
        cmd.Parameters.AddWithValue("@UpdatedBy", UpdatedBy);
        int rowsAffected = my.ExecuteDMLCommand(ref cmd, "", "S");
        string message = "toastr['success']('The Row has been successfuly saved.', 'Success')";
        Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", message, true);
        //FillGvInputPage();
    }

    protected void gvInputGrid_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        //FillGvInputPage();
    }

    protected void ddlMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlMonth.SelectedIndex > -1)
        {
            DateTime myMonth = ddlMonth.SelectedValue.ToDateTime();
            SqlCommand cmd = new SqlCommand("GetMarketProdHrsChk");
            cmd.Parameters.AddWithValue("@Month", myMonth);
            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            ddlMarket.DataSource = dt;
            ddlMarket.DataTextField = "Market";
            ddlMarket.DataValueField = "Market";
            ddlMarket.DataBind();
            ddlMarket.SelectedIndex = 0;
            ddlMarket_SelectedIndexChanged(this, new EventArgs());
        }

    }

    [WebMethod]

    public static string SaveComments(string empcode, string month, string comments)
    {
        Helper my = new Helper();
        string UpdatedBy = PageExtensionMethods.getMyWindowsID();

        string strSQL = "[UpdateProdHrsChk]";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@EmpCode", empcode);
        cmd.Parameters.AddWithValue("@Month", month);
        cmd.Parameters.AddWithValue("@Comments", comments);
        cmd.Parameters.AddWithValue("@UpdatedBy", UpdatedBy);
        cmd.Parameters.Add("@UpdatedOn", SqlDbType.DateTime);
        cmd.Parameters["@UpdatedOn"].Direction = ParameterDirection.Output;
        int rowsAffected = my.ExecuteDMLCommand(ref cmd, "", "S");
        return cmd.Parameters["@UpdatedOn"].Value.ToDateTime().ToString("dd-MMM-yyyy hh:mm:ss");
        //string message = "toastr['success']('The Row has been successfuly saved.', 'Success')";
        //Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", message, true);
    }

    [WebMethod]
    public static string GetData(string xMonth, string xMarket, string xFacility, string xAccount)
    {
        Helper my = new Helper();
        string query = "[ProdHrsChkComparison]";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@Month", xMonth);
        cmd.Parameters.AddWithValue("@Market", xMarket);
        cmd.Parameters.AddWithValue("@Facility", xFacility);
        cmd.Parameters.AddWithValue("@Account", xAccount);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        //return dt.Rows[0][0].ToString();
        string xTable = "";
        if (dt.Rows.Count > 0)
        {
            xTable = "<table id='MyDataTable' class='table table-bordered table-hover table-responsive'><thead><tr>";

            foreach (DataColumn column in dt.Columns)
            {
                xTable += "<th>" + column.ToString() + "</th>";
            }

            xTable += "</tr></thead><tbody class='tbody'>";

            foreach (DataRow row in dt.Rows)
            {
                xTable += "<tr>";
                for (int i = 0; i < dt.Columns.Count; i++)
                {
                    string xBadgeS = "";
                    string xBadgeE = "";

                    if ((dt.Columns[i].ColumnName == "KRONOS HRS" || dt.Columns[i].ColumnName == "OVERTIME HRS") && row["IN KRONOS"].ToString() == "Yes")
                    {
                        xBadgeS = "<small class='badge pull-right bg-green'>";
                        xBadgeE = "</small>";
                    }

                    if ((dt.Columns[i].ColumnName == "KRONOS HRS" || dt.Columns[i].ColumnName == "OVERTIME HRS") && row["IN KRONOS"].ToString() == "No")
                    {
                        xBadgeS = "<small class='badge pull-right bg-red'>";
                        xBadgeE = "</small>";
                    }

                    if (dt.Columns[i].ColumnName == "BO HRS" && row["IN KRONOS"].ToString() == "Yes")
                    {
                        xBadgeS = "<small class='badge pull-right bg-green'>";
                        xBadgeE = "</small>";
                    }

                    if (dt.Columns[i].ColumnName == "BO HRS" && row["IN BO"].ToString() == "No")
                    {
                        xBadgeS = "<small class='badge pull-right bg-red'>";
                        xBadgeE = "</small>";
                    }

                    if (dt.Columns[i].ColumnName == "IN BOOST" && row["IN BOOST"].ToString() == "Yes")
                    {
                        xBadgeS = "<small class='badge pull-right bg-green'>";
                        xBadgeE = "</small>";
                    }

                    if (dt.Columns[i].ColumnName == "IN BOOST" && row["IN BOOST"].ToString() == "No")
                    {
                        xBadgeS = "<small class='badge pull-right bg-red'>";
                        xBadgeE = "</small>";
                    }

                    string xDiv = "";

                    if (dt.Columns[i].ColumnName == "COMMENTS")
                    {
                        xDiv = "<DIV style='color:#fff;'>" + row[i].ToString().Replace(" ", " ");
                        xDiv += "</DIV>";
                    }
                    else
                    {
                        xDiv = row[i].ToString().Replace(" ", " ");
                    }

                    xTable += "<td >" + xBadgeS + xDiv + xBadgeE + "</td>";
                }
                xTable += "</tr>";
            }
            xTable += "<tbody></table>";
        }

        else
        {
            xTable = "<div style='display:table;width:100%;'><div style='display:table-cell;vertical-align:middle;text-align:center;'>No Record(s) Found</div></div>";
        }
        return xTable;


    }


    public class classparam
    {
        public string xMonth { get; set; }
        public string xMarket { get; set; }
        public string xFacility { get; set; }
        public string xAccount { get; set; }

    }



    protected void btnFetch_Click(object sender, EventArgs e)
    {
        if (ddlMonth.SelectedIndex > -1)
        {
            fillTabOverall();
            //        DateTime myMonth = ddlMonth.SelectedValue.ToDateTime();
            //        string myMarket = ddlMarket.SelectedValue.ToString();
            //        string myFacility = ddlFacility.SelectedValue.ToString();
            //        string myAccount = ddlAccount.SelectedValue.ToString();
            //        SqlCommand cmd = new SqlCommand("ProdHrsChkComparison");
            //        cmd.Parameters.AddWithValue("@MONTH", myMonth);
            //        cmd.Parameters.AddWithValue("@Market", myMarket);
            //        cmd.Parameters.AddWithValue("@Facility", myFacility);
            //        cmd.Parameters.AddWithValue("@Account", myAccount);
            //        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            //        gvInputGrid.DataSource = dt;
            //        gvInputGrid.DataBind();
        }
    }

    protected void ddlMarket_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlMonth.SelectedIndex > -1)
        {
            DateTime myMonth = ddlMonth.SelectedValue.ToDateTime();
            string myMarket = ddlMarket.SelectedValue.ToString();
            SqlCommand cmd = new SqlCommand("GetFacilityProdHrsChk");
            cmd.Parameters.AddWithValue("@Month", myMonth);
            cmd.Parameters.AddWithValue("@Market", myMarket);
            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            ddlFacility.DataSource = dt;
            ddlFacility.DataTextField = "Facility";
            ddlFacility.DataValueField = "Facility";
            ddlFacility.DataBind();
            ddlFacility.SelectedIndex = 0;
            ddlFacility_SelectedIndexChanged(this, new EventArgs());
        }


    }

    protected void ddlFacility_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlMonth.SelectedIndex > -1)
        {
            DateTime myMonth = ddlMonth.SelectedValue.ToDateTime();
            string myMarket = ddlMarket.SelectedValue.ToString();
            string myFacility = ddlFacility.SelectedValue.ToString();
            SqlCommand cmd = new SqlCommand("GetAccountProdHrsChk");
            cmd.Parameters.AddWithValue("@MONTH", myMonth);
            cmd.Parameters.AddWithValue("@Market", myMarket);
            cmd.Parameters.AddWithValue("@Facility", myFacility);
            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            ddlAccount.DataSource = dt;
            ddlAccount.DataTextField = "Account";
            ddlAccount.DataValueField = "Account";
            ddlAccount.DataBind();
        }
    }

    protected void ddlAccount_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

    protected void rpOverall_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {

    }


    protected void btnExport_Click(object sender, EventArgs e)
    {
        string strSQL = "ProdHrsChkComparison";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@Month", ddlMonth.SelectedValue.ToDateTime());
        cmd.Parameters.AddWithValue("@Market", ddlMarket.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@Facility", ddlFacility.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@Account", ddlAccount.SelectedValue.ToString());        
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Connection = my.open_db();
        
        SqlDataAdapter da = new SqlDataAdapter(cmd);

        DataSet ds = new DataSet();
        da.Fill(ds);
        string FileName = ddlAccount.SelectedValue.ToString().Trim() + " Account Comparison for " + ddlMonth.SelectedValue.ToDateTime().ToString("MMM yyyy") + " downloaded " + DateTime.Now.ToString("dd-MMM-yyyy HH-mm-ss") + ".xlsx";
        string FilePath = Server.MapPath("Sitel//metric_downloads//" + FileName);
        using (ExcelPackage pck = new ExcelPackage())
        {
            pck.Workbook.Properties.Author = "iaccess_support@sitel.com";
            pck.Workbook.Properties.Title = FileName;
            int validSheetCount = 0;
            foreach (DataTable d in ds.Tables)
            {

                if (d != null && d.Rows.Count > 0)
                {
                    int recordCount = d.Rows.Count;
                    int columnCount = d.Columns.Count;
                    string currentSheet = "Comparison_Sheet";
                    
                    //Get the physical path to the file.
                    ExcelWorksheet ws = pck.Workbook.Worksheets.Add(currentSheet);
                    validSheetCount++;
                    ws.Cells["A1"].LoadFromDataTable(d, true);
                    //ws.Cells[2, 12, recordCount + 1, 17].Style.Numberformat.Format = "dd-mmm-yyyy HH:mm:ss";
                    //ws.Cells[2, 18, recordCount + 1, 18].Style.Numberformat.Format = "dd-mmm-yyyy";
                    //ws.Cells[2, 19, recordCount + 1, 19].Style.Numberformat.Format = "HH:mm:ss";
                    ws.Cells[1, 1, recordCount, columnCount].AutoFitColumns(15);

                    pck.Save();
                    //var shape = ws.Drawings.AddShape("Comparison", eShapeStyle.Rect);
                    //shape.SetPosition(50, 200);
                    //shape.SetSize(200, 100);
                    //shape.Text = FileName;
                    //Send the CSV file as a Download.
                    //Response.Buffer = true;
                    //Response.AddHeader("content-disposition", "attachment;filename=" + FileName);
                    //Response.Charset = "";
                    //Response.ContentType = "application/text";
                    //Response.Output.Write(File.ReadAllText(FilePath));

                }
            }
            if (validSheetCount > 0)
            {
                pck.SaveAs(Response.OutputStream);
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;  filename=" + FileName);
                File.Delete(FilePath);
            }
        }
    }
}