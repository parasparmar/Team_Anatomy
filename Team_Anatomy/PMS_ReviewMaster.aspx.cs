using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI.WebControls;

public partial class PMS_ReviewMaster : System.Web.UI.Page
{
    Helper PMS = new Helper();
    DataTable dt = new DataTable();
    string IsFormInUpdateOrCeateMode;
    string constr;
    protected void Page_Load(object sender, EventArgs e)
    {
        Page_Initialisation();
        if (!IsPostBack)
        {


        }
    }

    private void Page_Initialisation()
    {
        constr = ConfigurationManager.ConnectionStrings["constr"].ToString();
        // 1. Set Page Title
        Literal PageTitle = (Literal)Master.FindControl("ltlPageTitle");
        if (PageTitle != null)
        {
            PageTitle.Text = "Review Period Master";
        }
        IsFormInUpdateOrCeateMode = hdnIsFormInUpdateOrCeateMode.Value.ToString();
        // 2. Fill Gridview
        dt = getPeriodMST();
        gv_ReviewPeriods.DataSource = dt;
        gv_ReviewPeriods.DataBind();


    }

    private DataTable getPeriodMST()
    {
        StringBuilder strSQL = new StringBuilder("SELECT [PeriodId],Convert(varchar,[FromDate],106) as [FromDate]");
        strSQL.Append(",Convert(varchar,[ToDate],106) as [ToDate],[PMSPhase],[Active],[PCStart],[PCYear],[CanLock]");
        strSQL.Append(",[OverallGrace],[PDP],[PIP],[Poll],[TPF],[ShowAutoDisc],[allowsimulation],[StackPhaseId],[SlabType],[isStackJobRunning]");
        strSQL.Append(",[LastRatificationDate] FROM [CWFM_Umang].[PMS].[PeriodMst] where [Active]>0");
        DataTable dt = PMS.GetData(strSQL.ToString());
        return dt;
    }

    protected void ddl_Role_SelectedIndexChanged(object sender, EventArgs e)
    {

    }


    protected void btn_Submit_Click(object sender, EventArgs e)
    {
        StringBuilder strSQL = new StringBuilder();
        string myDate = "01-"+tb_FromDate.Text;
        DateTime FromDate = Convert.ToDateTime(myDate);
        // Convert a random date to the date of the first day of that month.
        FromDate = FromDate.AddDays(-1 * (FromDate.Day - 1));

        myDate = "01-" + tb_ToDate.Text;
        DateTime ToDate = Convert.ToDateTime(myDate);
        // Convert a random date to the date of the last day of that month.
        ToDate = ToDate.AddMonths(1).AddDays(-1);

        string PMSPhase = tb_PMSPhase.Text.ToUpper();
        bool Active = true;
        string PCStart = ddl_PCStart.SelectedValue.ToString();
        int PCYear = Convert.ToInt32(ddl_PCYear.SelectedValue);
        string CanLock = ddl_CanLock.SelectedValue == "1" ? "1" : "0";
        int OverallGrace = ddl_OverallGrace.SelectedValue == "1" ? 1 : 0;
        int PDP = ddl_PDP.SelectedValue == "1" ? 1 : 0;
        int PIP = ddl_PIP.SelectedValue == "1" ? 1 : 0;
        int Poll = ddl_Poll.SelectedValue == "1" ? 1 : 0;
        int TPF = ddl_TPF.SelectedValue == "1" ? 1 : 0;
        int ShowAutoDisc = ddl_ShowAutoDisc.SelectedValue == "1" ? 1 : 0;
        int allowsimulation = 0;
        int StackPhaseId = 0;
        string SlabType = ddl_SlabType.SelectedValue;
        int isStackJobRunning = 0;
        DateTime LastRatificationDate = DateTime.Now;

        string finalSQL = string.Empty;
        Helper h = new Helper();
        try
        {
            using (SqlConnection cn = new SqlConnection(constr))
            {
                cn.Open();
                using (SqlCommand d = new SqlCommand(strSQL.ToString(), cn))
                {
                    switch (IsFormInUpdateOrCeateMode.ToLower())
                    {
                        case "create":
                            d.CommandType = CommandType.Text;

                            strSQL.Clear();
                            strSQL.Append("INSERT INTO [PMS].[PeriodMst] ([FromDate],[ToDate],[PMSPhase],[Active],[PCStart],[PCYear],[CanLock]");
                            strSQL.Append(",[OverallGrace],[PDP],[PIP],[Poll],[TPF],[ShowAutoDisc],[allowsimulation]");
                            strSQL.Append(",[StackPhaseId],[SlabType],[isStackJobRunning],[LastRatificationDate])");
                            strSQL.Append(" VALUES(@FromDate,@ToDate,@PMSPhase,@Active,@PCStart,@PCYear,@CanLock");
                            strSQL.Append(" ,@OverallGrace,@PDP,@PIP,@Poll,@TPF,@ShowAutoDisc,@allowsimulation");
                            strSQL.Append(",@StackPhaseId,@SlabType,@isStackJobRunning,@LastRatificationDate)");



                            break;

                        case "update":
                            int PeriodID = Convert.ToInt32(hdnPeriodID.Value);
                            if (PeriodID > 0)
                            {
                                strSQL.Clear();
                                strSQL.Append("UPDATE [PMS].[PeriodMst] SET [FromDate] = @FromDate,[ToDate] = @ToDate,[PMSPhase] = @PMSPhase,[Active] = @Active");
                                strSQL.Append(",[PCStart] = @PCStart,[PCYear] = @PCYear,[CanLock] = @CanLock,[OverallGrace] = @OverallGrace,[PDP] = @PDP ");
                                strSQL.Append(",[PIP] = @PIP,[Poll] = @Poll,[TPF] = @TPF,[ShowAutoDisc] = @ShowAutoDisc,[allowsimulation] = @allowsimulation");
                                strSQL.Append(",[StackPhaseId] = @StackPhaseId,[SlabType] = @SlabType,[isStackJobRunning] = @isStackJobRunning");
                                strSQL.Append(",[LastRatificationDate] = @LastRatificationDate WHERE PeriodId = @PeriodId");
                                d.Parameters.AddWithValue("@PeriodId", PeriodID);
                            }
                            break;
                    }

                    d.Parameters.AddWithValue("@FromDate", FromDate);
                    d.Parameters.AddWithValue("@ToDate", ToDate);
                    d.Parameters.AddWithValue("@PMSPhase", PMSPhase);
                    d.Parameters.AddWithValue("@Active", Active);
                    d.Parameters.AddWithValue("@PCStart", PCStart);
                    d.Parameters.AddWithValue("@PCYear", PCYear);
                    d.Parameters.AddWithValue("@CanLock", CanLock);
                    d.Parameters.AddWithValue("@OverallGrace", OverallGrace);
                    d.Parameters.AddWithValue("@PDP", PDP);
                    d.Parameters.AddWithValue("@PIP", PIP);
                    d.Parameters.AddWithValue("@Poll", Poll);
                    d.Parameters.AddWithValue("@TPF", TPF);
                    d.Parameters.AddWithValue("@ShowAutoDisc", ShowAutoDisc);
                    d.Parameters.AddWithValue("@allowsimulation", allowsimulation);
                    d.Parameters.AddWithValue("@StackPhaseId", StackPhaseId);
                    d.Parameters.AddWithValue("@SlabType", SlabType);
                    d.Parameters.AddWithValue("@isStackJobRunning", isStackJobRunning);
                    d.Parameters.AddWithValue("@LastRatificationDate", LastRatificationDate);
                    // Just Checking...
                    finalSQL = strSQL.ToString();

                    d.CommandText = strSQL.ToString();

                    int rowsAffected = d.ExecuteNonQuery();
                    //lblResult.CssClass = "badge bg-green";
                    lblResult.Text = "The PMS Phase " + PMSPhase + " <br/>has been successfully added to <br/> PACMAN";
                    // Refresh the gridview with the inserted results
                    dt = getPeriodMST();
                    gv_ReviewPeriods.DataSource = dt;
                    gv_ReviewPeriods.DataBind();
                    pnlModal.CssClass = "modal modal-success fade";
                    pnlModal.Visible = true;
                    //string strCode = "0";
                   // ClientScript.RegisterStartupScript(this.GetType(), "SuccessModal", strCode);
                }

            }
        }
        catch (Exception ex)
        {

            lblResult.Text = ex.Message.ToString();
            pnlModal.CssClass = "modal modal-warning fade";
            pnlModal.Visible = true;
        }


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



    protected void gv_ReviewPeriods_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToLower() == "select")
        {
            hdnIsFormInUpdateOrCeateMode.Value = "update";
            ltlReviewButton.Text = "Modify Review Period";
            ltlClassForDefineHeader.Text = "<div class=\"box box-solid box-warning\">";
            int rowindex = Convert.ToInt32(e.CommandArgument);
            btn_Submit.CssClass = "btn btn-warning";

            GridView gv = (GridView)sender;
            // gv.Rows[rowindex].CssClass = "btn-warning";            
            int id = Convert.ToInt32(gv.Rows[rowindex].Cells[1].Text);
            hdnPeriodID.Value = id.ToString();
            gv_ReviewPeriods_FillWithSpecificPeriodID(id);
        }
    }

    protected void gv_ReviewPeriods_FillWithSpecificPeriodID(int PeriodId)
    {
        if (PeriodId >= 0 && PeriodId <= dt.Rows.Count)
        {
            DataRow[] Row = dt.Select("PeriodId = " + PeriodId);
            DataRow dr = Row[0];

            tb_FromDate.Text = Convert.ToDateTime(dr["FromDate"].ToString()).ToString("MMM-yyyy");
            tb_ToDate.Text = Convert.ToDateTime(dr["ToDate"].ToString()).ToString("MMM-yyyy");
            ltlDefineHeader.Text = "Editing Review Period with ID : " + PeriodId + " (From : " + tb_FromDate.Text.ToString() + " To : " + tb_ToDate.Text.ToString() + ")";
            tb_PMSPhase.Text = dr["PMSPhase"].ToString();

            string value = dr["PCStart"].ToString() == "1" ? "Yes" : "No";
            ddl_PCStart.ClearSelection();
            ddl_PCStart.Items.FindByText(value).Selected = true;


            value = dr["CanLock"].ToString() == "1" ? "Yes" : "No";
            ddl_CanLock.ClearSelection();
            ddl_CanLock.Items.FindByText(value).Selected = true;

            value = dr["OverallGrace"].ToString() == "1" ? "Yes" : "No";
            ddl_OverallGrace.ClearSelection();
            ddl_OverallGrace.Items.FindByText(value).Selected = true;

            value = dr["PDP"].ToString() == "1" ? "Yes" : "No";
            ddl_PDP.ClearSelection();
            ddl_PDP.Items.FindByText(value).Selected = true;

            value = dr["PIP"].ToString() == "1" ? "Yes" : "No";
            ddl_PIP.ClearSelection();
            ddl_PIP.Items.FindByText(value).Selected = true;

            value = dr["Poll"].ToString() == "1" ? "Yes" : "No";
            ddl_Poll.ClearSelection();
            ddl_Poll.Items.FindByText(value).Selected = true;

            value = dr["TPF"].ToString() == "1" ? "Yes" : "No";
            ddl_TPF.ClearSelection();
            ddl_TPF.Items.FindByText(value).Selected = true;

            value = dr["ShowAutoDisc"].ToString() == "1" ? "Yes" : "No";
            ddl_ShowAutoDisc.ClearSelection();
            ddl_ShowAutoDisc.Items.FindByText(value).Selected = true;

            ddl_SlabType.ClearSelection();
            value = dr["SlabType"].ToString().ToLower();
            ddl_SlabType.Items.FindByValue(value).Selected = true;
        }

    }
    protected void btnReset_Click(object sender, EventArgs e)
    {
        hdnIsFormInUpdateOrCeateMode.Value = "create";
        tb_FromDate.Text = string.Empty;
        tb_ToDate.Text = string.Empty;
        tb_PMSPhase.Text = string.Empty;
        ddl_PCStart.ClearSelection();
        ddl_CanLock.ClearSelection();
        ddl_OverallGrace.ClearSelection();
        ddl_PDP.ClearSelection();
        ddl_PIP.ClearSelection();
        ddl_Poll.ClearSelection();
        ddl_TPF.ClearSelection();
        ddl_ShowAutoDisc.ClearSelection();
        ddl_SlabType.ClearSelection();
        ltlDefineHeader.Text = "Create Review Period";
        ltlReviewButton.Text = "Create Review Period";
        ltlClassForDefineHeader.Text = "<div class=\"box box-solid box-primary\">";
        btn_Submit.CssClass = "btn btn-primary";
    }
}