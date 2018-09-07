using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;
using System.Globalization;

public partial class movement : System.Web.UI.Page
{
    private DataTable dtEmp { get; set; }
    private Helper my { get; set; }
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    private TransferMode EmpTransferMode { get; set; }

    private EmailSender Email = new EmailSender();

    protected void Page_Load(object sender, EventArgs e)
    {
        EmpTransferMode = TransferMode.NotSpecified;
        my = new Helper();
        try
        {
            dtEmp = Session["dtEmp"] as DataTable;
            if (dtEmp == null)
            {
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
                enableMovements(MyEmpID);
            }

        }
        catch (Exception Ex)
        {
            Console.WriteLine(Ex.Message.ToString());
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
        //fillTeamList();
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Team Movement";


    }

    protected void enableMovements(int EmpID)
    {
        Boolean isReportingManager = false;
        string strSQL = "SELECT IsReportingManager FROM WFMP.tblMaster where Employee_ID = " + EmpID;
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                isReportingManager = Convert.ToBoolean(cmd.ExecuteScalar());
            }
        }
        if (isReportingManager)
        {
            pnlEnableMovements.Visible = true;
        }

    }

    public enum TransferMode : int
    {
        NotSpecified = 0,
        ManagerTransferOut = 1,
        ManagerTransferIn = 2,
        DepartmentTransferOut = 3,
        DepartmentTransferIn = 4,
    }

    protected void btnMgrMovement_Click(object sender, EventArgs e)
    {
        MovementHandler(MovementType.Manager);
    }
    protected void btnDeptMovement_Click(object sender, EventArgs e)
    {
        MovementHandler(MovementType.Department);


        ddlDepartmentManager.Items.Insert(0, new ListItem("---", "0"));
        ddlDepartmentManager.SelectedIndex = 0;

        ddlFunctionId.Items.Insert(0, new ListItem("---", String.Empty));
        ddlFunctionId.SelectedIndex = 0;

        ddlDepartmentID.Items.Insert(0, new ListItem("---", String.Empty));
        ddlDepartmentID.SelectedIndex = 0;

        ddlLOBID.Items.Insert(0, new ListItem("---", String.Empty));
        ddlLOBID.SelectedIndex = 0;

        ddlSkillSet.Items.Insert(0, new ListItem("---", String.Empty));
        ddlSkillSet.SelectedIndex = 0;

        ddlSubSkillSet.Items.Insert(0, new ListItem("---", String.Empty));
        ddlSubSkillSet.SelectedIndex = 0;
    }
    protected void rdoMgrMovement_CheckedChanged(object sender, EventArgs e)
    {
        MovementHandler(MovementType.Manager);
    }
    protected void rdoDeptMovement_CheckedChanged(object sender, EventArgs e)
    {
        MovementHandler(MovementType.Department);
    }
    private void MovementHandler(string M)
    {
        if (typeof(MovementType).HasProperty(M))
        {

            switch (M.ToString())
            {
                //Employee is transferred across Reporting Managers
                case "Manager":
                    ltlMovementTypeHeading.Text = "Reporting Manager Movement";
                    pnlDeptMovement.Visible = false;
                    pnlMgrMovement.Visible = true;
                    pnlMgrActions.Visible = true;
                    pnlEffectiveDate.Visible = true;
                    rdoDeptMovement.Checked = false;
                    rdoMgrMovement.Checked = true;

                    break;


                //Employee is transferred across Departments
                case "Department":
                    ltlMovementTypeHeading.Text = "Department Movement";
                    pnlDeptMovement.Visible = true;
                    pnlMgrMovement.Visible = false;
                    pnlMgrActions.Visible = false;
                    pnlEffectiveDate.Visible = true;
                    rdoDeptMovement.Checked = true;
                    rdoMgrMovement.Checked = false;

                    // Fill the dropdowns ddlFromDept and ddlToDept, ddlFromDeptMgr and ddlToDeptMgr
                    string depmgrvalue = ddlDepartmentManager.SelectedValue.ToString();
                    if (depmgrvalue == "0" || depmgrvalue == null || string.IsNullOrEmpty(depmgrvalue))
                    {
                        // MyEmpID = 923563;
                    }
                    else
                    {
                        MyEmpID = Convert.ToInt32(depmgrvalue);
                    }

                    strSQL = "SELECT Employee_ID, dbo.toProperCase(First_Name)+' '+ dbo.toProperCase(Middle_Name)+' '+dbo.toProperCase(Last_Name) as Name";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] where RepMgrCode = " + MyEmpID;
                    strSQL += " and IsReportingManager = 1 union ";
                    strSQL += " SELECT Employee_ID, dbo.toProperCase(First_Name)+' '+ dbo.toProperCase(Middle_Name)+' '+dbo.toProperCase(Last_Name) as Name";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] where Employee_ID = " + MyEmpID;
                    strSQL += " and IsReportingManager = 1 ";

                    ddlDepartmentManager.DataSource = my.GetData(strSQL);
                    ddlDepartmentManager.DataTextField = "Name";
                    ddlDepartmentManager.DataValueField = "Employee_ID";
                    ddlDepartmentManager.DataBind();

                    strSQL = "Exec CWFM_UMANG.WFMP.GetDeptValues";
                    ddlFunctionId.DataSource = my.GetData(strSQL);
                    ddlFunctionId.DataTextField = "Function";
                    ddlFunctionId.DataValueField = "TransID";
                    ddlFunctionId.DataBind();

                    break;


                case "TransferOut":

                    // Fill From Mgr Dropdown.
                    strSQL = "SELECT Distinct A.[Employee_ID] ";
                    strSQL += " ,REPLACE(dbo.ToProperCase(A.First_Name) + ' ' + dbo.ToProperCase(A.Middle_Name) + ' ' +dbo.ToProperCase(A.Last_Name),' ',' ') as Name   ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A  ";
                    strSQL += " where A.isReportingManager > 0 and A.Employee_ID = " + MyEmpID;
                    strSQL += " order by REPLACE(dbo.ToProperCase(A.First_Name) + ' ' + dbo.ToProperCase(A.Middle_Name) + ' ' +dbo.ToProperCase(A.Last_Name),' ',' ') ASC ";


                    ddlFromMgr.DataSource = my.GetData(strSQL);
                    ddlFromMgr.DataTextField = "Name";
                    ddlFromMgr.DataValueField = "Employee_ID";
                    ddlFromMgr.DataBind();

                    // Fill To Mgr Dropdown.
                    strSQL = "SELECT Distinct A.[Employee_ID],REPLACE(dbo.ToProperCase(A.First_Name) + ' ' + dbo.ToProperCase(A.Middle_Name) + ' ' +dbo.ToProperCase(A.Last_Name),' ',' ') as Name ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
                    strSQL += " where A.isReportingManager > 0 and A.Employee_ID <> " + MyEmpID;
                    strSQL += " order by REPLACE(dbo.ToProperCase(A.First_Name) + ' ' + dbo.ToProperCase(A.Middle_Name) + ' ' +dbo.ToProperCase(A.Last_Name),' ',' ') ASC";

                    ddlToMgr.DataSource = my.GetData(strSQL);
                    ddlToMgr.DataTextField = "Name";
                    ddlToMgr.DataValueField = "Employee_ID";
                    ListItem LI = new ListItem("Please Select", "0");
                    ddlToMgr.Items.Insert(0, LI);
                    ddlToMgr.DataBind();

                    //  divDepMovement.Visible = false;

                    btnSubmit.Visible = true;

                    rdobtnMgrPush.Checked = true;
                    rdobtnMgrPull.Checked = false;

                    ltlMovementTypeHeading.Text = "Reporting Manager Movement : Initiate Transfer Out";
                    //ltlDirection.Text = "<i class=\"fa fa-arrow-circle-right\"></i>";


                    // The Left Side Gridview 
                    fillTeamList(MyEmpID, ref gv_LeftHandSideTeamList);
                    gv_RightHandSideTeamList.DataSource = null;
                    gv_RightHandSideTeamList.DataBind();
                    //HideColumn(gv_RightHandSideTeamList, "Selection");
                    //UnHideColumn(gv_LeftHandSideTeamList, "Selection");

                    if (ddlFromMgr.Items.Count > 1)
                    {
                        ddlToMgr.Items.Insert(0, new ListItem("---", "9999999999"));
                        ddlToMgr.SelectedIndex = 0;
                    }

                    break;

                case "TransferIn":
                    strSQL = "SELECT Distinct A.[Employee_ID],REPLACE(dbo.ToProperCase(A.First_Name) + ' ' + dbo.ToProperCase(A.Middle_Name) + ' ' +dbo.ToProperCase(A.Last_Name),' ',' ') as Name  ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A where A.isReportingManager > 0 and A.Employee_ID = ";
                    strSQL += MyEmpID;

                    ddlToMgr.DataSource = my.GetData(strSQL);
                    ddlToMgr.DataTextField = "Name";
                    ddlToMgr.DataValueField = "Employee_ID";
                    ddlToMgr.DataBind();

                    strSQL = "SELECT 0 as 'Employee_ID','Un-Mapped Employees' as Name union SELECT Distinct B.[Employee_ID] ";
                    strSQL += "  ,REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),'  ',' ') as Name  ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A  ";
                    strSQL += " inner join [CWFM_Umang].[WFMP].[tblMaster] B on B.Employee_ID = A.RepMgrCode ";
                    strSQL += " where B.isReportingManager > 0 and B.Employee_ID <> " + MyEmpID;

                    ddlFromMgr.DataSource = my.GetData(strSQL);
                    ddlFromMgr.DataTextField = "Name";
                    ddlFromMgr.DataValueField = "Employee_ID";
                    ddlFromMgr.DataBind();

                    rdobtnMgrPush.Checked = false;
                    rdobtnMgrPull.Checked = true;
                    ltlMovementTypeHeading.Text = "Reporting Manager Movement : Request Transfer In";
                    fillTeamList(MyEmpID, ref gv_RightHandSideTeamList);
                    gv_LeftHandSideTeamList.DataSource = null;
                    gv_LeftHandSideTeamList.DataBind();

                    ddlFromMgr.Items.Insert(0, new ListItem("---", "1"));
                    ddlFromMgr.SelectedIndex = 0;

                    break;

                default:

                    break;
            }
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void HideColumn(GridView sender, string ColumnToHide)
    {
        // Hides a column given its header text
        GridView ThisGrid = (GridView)sender;
        ((DataControlField)ThisGrid.Columns
                .Cast<DataControlField>()
                .Where(fld => fld.HeaderText == ColumnToHide)
                .SingleOrDefault()).Visible = false;
    }
    protected void UnHideColumn(GridView sender, string ColumnToUnHide)
    {
        // Ensures visibility of a column given its header text.
        GridView ThisGrid = (GridView)sender;
        ((DataControlField)ThisGrid.Columns
                .Cast<DataControlField>()
                .Where(fld => fld.HeaderText == ColumnToUnHide)
                .SingleOrDefault()).Visible = true;
    }
    private void fillTeamList(int EmpCode, string gvTeamList)
    {
        if (dtEmp != null && dtEmp.Rows.Count > 0)
        {
            GridView v = (GridView)Page.FindControlRecursive(gvTeamList);
            v.DataSource = my.GetData("Exec WFMP.Transfer_TeamList " + EmpCode);
            v.DataBind();
        }
        else
        {

        }
    }
    private void fillTeamList(int EmpCode, ref GridView gvTeamList)
    {
        if (dtEmp != null && dtEmp.Rows.Count > 0)
        {
            gvTeamList.DataSource = my.GetData("Exec WFMP.Transfer_TeamList " + EmpCode);
            gvTeamList.DataBind();
        }
        else
        {

        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }

    private void fillDepartmentTransferList(int EmpCode, ref GridView gvTeamList)
    {
        if (dtEmp.Rows.Count > 0)
        {
            gvTeamList.DataSource = my.GetData("Exec WFMP.Transfer_DepartmentList " + EmpCode);
            gvTeamList.DataBind();
        }
        else
        {

        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void btnMgrPush_Click(object sender, EventArgs e)
    {
        MovementHandler(MovementType.TransferOut);

    }
    protected void btnMgrPull_Click(object sender, EventArgs e)
    {
        MovementHandler(MovementType.TransferIn);
    }
    protected void ddlToMgr_SelectedIndexChanged(object sender, EventArgs e)
    {
        int EmpCode = Convert.ToInt32(ddlToMgr.SelectedValue.ToString());
        fillTeamList(EmpCode, ref gv_RightHandSideTeamList);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void ddlToDept_SelectedIndexChanged(object sender, EventArgs e)
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
    private bool isValidDateOfGivenFormat(string dateString, string format)
    {
        DateTime dateTime;
        if (DateTime.TryParseExact(dateString, format, CultureInfo.InvariantCulture, DateTimeStyles.None, out dateTime))
        {
            return true;
        }
        else
        {
            return false;
        }

    }
    /// <summary>
    /// gv_LeftHandSideTeamList_RowDataBound
    /// This method disables the ability of the user in selecting employees who are already under transfers.
    /// It does this by disabling the checkboxes that allow selection of the relevant rows in the table.
    /// </summary>
    /// <remarks>no parameters needed</remarks>
    protected void gv_LeftHandSideTeamList_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow gRow = e.Row;
        if (gRow.RowIndex >= 0)
        {
            string status = gRow.Cells[3].Text.ToString();
            CheckBox cbTeamListID = (CheckBox)gRow.FindControl("cbMyTeamListID");
            if (status.Length > 7)
            {
                string MyState = status.Substring(0, 7).ToLower();
                if (MyState == "pending")
                {
                    cbTeamListID.Enabled = false;
                }
            }
        }

    }
    protected void ddlDepartmentManager_SelectedIndexChanged(object sender, EventArgs e)
    {
        MyEmpID = Convert.ToInt32(ddlDepartmentManager.SelectedValue.ToString());
        fillDepartmentTransferList(MyEmpID, ref gv_DepMgrTeamList);
        btnDepSubmit_enabler();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void ddlFunctionId_SelectedIndexChanged(object sender, EventArgs e)
    {

        strSQL = "CWFM_UMANG.WFMP.GetDeptValues";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@FunctionID", Convert.ToInt32(ddlFunctionId.SelectedValue.ToString()));
        //cmd.CommandType = CommandType.StoredProcedure;
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        ddlDepartmentID.DataSource = dt;
        ddlDepartmentID.DataTextField = dt.Columns[1].ColumnName;
        ddlDepartmentID.DataValueField = dt.Columns[0].ColumnName;
        ddlDepartmentID.DataBind();
        ddlDepartmentID.Items.Insert(0, new ListItem("---", String.Empty));
        ddlDepartmentID.SelectedIndex = 0;
        ddlLOBID.SelectedIndex = 0;
        ddlSkillSet.SelectedIndex = 0;
        ddlSubSkillSet.SelectedIndex = 0;
        btnDepSubmit_enabler();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void ddlDepartmentID_SelectedIndexChanged(object sender, EventArgs e)
    {
        strSQL = "CWFM_UMANG.WFMP.GetDeptValues";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@FunctionID", ddlFunctionId.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@DepartmentID", ddlDepartmentID.SelectedValue.ToString());
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        ddlLOBID.DataSource = dt;
        ddlLOBID.DataTextField = dt.Columns[1].ColumnName;
        ddlLOBID.DataValueField = dt.Columns[0].ColumnName;
        ddlLOBID.DataBind();
        ddlLOBID.Items.Insert(0, new ListItem("---", String.Empty));
        ddlLOBID.SelectedIndex = 0;
        btnDepSubmit_enabler();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void ddlLOBID_SelectedIndexChanged(object sender, EventArgs e)
    {
        strSQL = "CWFM_UMANG.WFMP.GetDeptValues";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@FunctionID", ddlFunctionId.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@DepartmentID", ddlDepartmentID.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@LOBID", ddlLOBID.SelectedValue.ToString());

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        ddlSkillSet.DataSource = dt;
        ddlSkillSet.DataTextField = dt.Columns[1].ColumnName;
        ddlSkillSet.DataValueField = dt.Columns[0].ColumnName;
        ddlSkillSet.DataBind();
        ddlSkillSet.Items.Insert(0, new ListItem("---", String.Empty));
        ddlSkillSet.SelectedIndex = 0;
        btnDepSubmit_enabler();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void ddlSkillSet_SelectedIndexChanged(object sender, EventArgs e)
    {
        strSQL = "CWFM_UMANG.WFMP.GetDeptValues";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@FunctionID", ddlFunctionId.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@DepartmentID", ddlDepartmentID.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@LOBID", ddlLOBID.SelectedValue.ToString());
        cmd.Parameters.AddWithValue("@SkillSetID", ddlSkillSet.SelectedValue.ToString());

        DataTable dt = my.GetDataTableViaProcedure(ref cmd);

        ddlSubSkillSet.DataSource = dt;
        ddlSubSkillSet.DataTextField = dt.Columns[1].ColumnName;
        ddlSubSkillSet.DataValueField = dt.Columns[0].ColumnName;
        ddlSubSkillSet.DataBind();
        ddlSubSkillSet.Items.Insert(0, new ListItem("---", String.Empty));
        ddlSubSkillSet.SelectedIndex = 0;
        btnDepSubmit_enabler();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void ddlSubSkillSet_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnDepSubmit_enabler();
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void ddlFromMgr_SelectedIndexChanged(object sender, EventArgs e)
    {
        int EmpCode = Convert.ToInt32(ddlFromMgr.SelectedValue.ToString());
        fillTeamList(EmpCode, ref gv_LeftHandSideTeamList);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (rdobtnMgrPull.Checked) { EmpTransferMode = TransferMode.ManagerTransferIn; }
        if (rdobtnMgrPush.Checked) { EmpTransferMode = TransferMode.ManagerTransferOut; }


        DropDownList ddlFromManager = ddlFromMgr;
        DropDownList ddlToManager = ddlToMgr;
        int TypeOfMovement = 0;
        int rowsAffected = 0;
        switch (EmpTransferMode)
        {
            case TransferMode.ManagerTransferIn:
                TypeOfMovement = (int)TransferMode.ManagerTransferIn;
                break;
            case TransferMode.ManagerTransferOut:
                TypeOfMovement = (int)TransferMode.ManagerTransferOut;
                break;
        }

        Transferee M = new Transferee();

        string ntID = dtEmp.Rows[0]["ntName"].ToString();
        int Employee_Id = Convert.ToInt32(dtEmp.Rows[0]["Employee_ID"].ToString());
        DateTime D = Convert.ToDateTime(tbEffectiveDate.Text.ToString());
        int FromDptLinkMstId = Convert.ToInt32(dtEmp.Rows[0]["DeptLinkId"].ToString());
        int ToDptLinkMstId = FromDptLinkMstId;

        foreach (GridViewRow gvrow in gv_LeftHandSideTeamList.Rows)
        {
            CheckBox checkbox = gvrow.FindControl("cbMyTeamListID") as CheckBox;
            if (checkbox.Checked)
            {
                M.FromDptLinkMstId = FromDptLinkMstId;
                M.ToDptLinkMstId = ToDptLinkMstId;
                M.EmpId = Convert.ToInt32(gv_LeftHandSideTeamList.DataKeys[gvrow.RowIndex].Value.ToString());
                M.FromMgr = Convert.ToInt32(ddlFromManager.SelectedValue.ToString());
                M.ToMgr = Convert.ToInt32(ddlToMgr.SelectedValue.ToString());
                M.Types = TypeOfMovement;
                M.State = 0;
                M.InitBy = Employee_Id;
                M.InitOn = DateTime.Now;
                M.EffectiveDate = D;
                M.UpdaterID = Employee_Id;
                M.UpdatedOn = DateTime.Now;

                //Transfers.Add(M);
                // Go...

                rowsAffected = M.InitiateTransfer();
            }

        }
        int RMEmpCode = Convert.ToInt32(ddlFromMgr.SelectedValue.ToString());
        fillTeamList(RMEmpCode, ref gv_LeftHandSideTeamList);
        Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message5", "toastr.success('The Transfer has been successfully initiated. For more details please visit the Movement Transfer Actions Page.','Transfer Initiated');", true);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);

    }

    protected void btnDepSubmit_enabler()
    {
        if (ddlDepartmentManager.SelectedValue.Length > 0
             && ddlFunctionId.SelectedValue.Length > 0
            && ddlDepartmentID.SelectedValue.Length > 0
            && ddlLOBID.SelectedValue.Length > 0
            && ddlSkillSet.SelectedValue.Length > 0
            && ddlSubSkillSet.SelectedValue.Length > 0)
        {
            btnDepSubmit.Enabled = true;
        }
        else
        {
            btnDepSubmit.Enabled = false;
        }
    }

    protected void btnDepSubmit_Click(object sender, EventArgs e)
    {
        Transferee M = new Transferee();

        if (rdoDeptMovement.Checked && rdobtnMgrPull.Checked) { EmpTransferMode = TransferMode.DepartmentTransferIn; }
        if (rdoDeptMovement.Checked && rdobtnMgrPush.Checked) { EmpTransferMode = TransferMode.DepartmentTransferOut; }
        int TypeOfMovement = (int)TransferMode.DepartmentTransferOut;


        // string ntID = dtEmp.Rows[0]["ntName"].ToString();
        int Employee_Id = Convert.ToInt32(dtEmp.Rows[0]["Employee_ID"].ToString());
        DateTime EffectiveDate = Convert.ToDateTime(tbEffectiveDate.Text.ToString());
        int FromDptLinkMstId = Convert.ToInt32(dtEmp.Rows[0]["DeptLinkId"].ToString());
        int ToDptLinkMstId = 0;

        // Locate the ToDptLinkMstId
        string mstQuery = "[WFMP].[GetDeptValues]";
        SqlCommand mstCmd = new SqlCommand();
        mstCmd.CommandText = mstQuery;

        mstCmd.Parameters.AddWithValue("@FunctionID", ddlFunctionId.SelectedValue.ToString());
        mstCmd.Parameters.AddWithValue("@DepartmentID", ddlDepartmentID.SelectedValue.ToString());
        mstCmd.Parameters.AddWithValue("@LOBID", ddlLOBID.SelectedValue.ToString());
        mstCmd.Parameters.AddWithValue("@SkillSetID", ddlSkillSet.SelectedValue.ToString());
        mstCmd.Parameters.AddWithValue("@SubSkillSetID", ddlSubSkillSet.SelectedValue.ToString());
        ToDptLinkMstId = Convert.ToInt32(my.GetDataTableViaProcedure(ref mstCmd).Rows[0]["TransId"].ToString());


        List<Transferee> TransferList = new List<Transferee>();
        int rowsAffected = 0;
        foreach (GridViewRow gvrow in gv_DepMgrTeamList.Rows)
        {
            CheckBox checkbox = gvrow.FindControl("cbMyTeamListID") as CheckBox;
            if (checkbox.Checked)
            {
                M.FromDptLinkMstId = FromDptLinkMstId;
                M.ToDptLinkMstId = ToDptLinkMstId;
                M.FunctionID = Convert.ToInt32(ddlFunctionId.SelectedValue.ToString());
                M.DepartmentID = Convert.ToInt32(ddlDepartmentID.SelectedValue.ToString());
                M.LOBID = Convert.ToInt32(ddlLOBID.SelectedValue.ToString());
                M.SkillSetID = Convert.ToInt32(ddlSkillSet.SelectedValue.ToString());
                M.SubSkillSetID = Convert.ToInt32(ddlSubSkillSet.SelectedValue.ToString());
                M.FromMgr = Convert.ToInt32(ddlDepartmentManager.SelectedValue.ToString());
                M.ToMgr = M.FromMgr; //  Since this is not a mgr movement.
                M.EmpId = Convert.ToInt32(gv_DepMgrTeamList.DataKeys[gvrow.RowIndex].Value.ToString());
                M.Types = TypeOfMovement;
                M.State = 2; //2 is approved
                M.InitBy = Employee_Id;
                M.InitOn = DateTime.Now;
                M.EffectiveDate = EffectiveDate;
                M.UpdaterID = Employee_Id;
                M.UpdatedOn = DateTime.Now;

                // Collect Together all transferees...
                TransferList.Add(M);
            }
        }
        rowsAffected = 0;
        foreach (Transferee N in TransferList)
        {
            rowsAffected += N.InitiateDepartmentTransfer();
        }
        if (TypeOfMovement == (int)TransferMode.DepartmentTransferOut)
        {
            fillDepartmentTransferList(Employee_Id, ref gv_DepMgrTeamList);
        }
        else
        {
            fillTeamList(Employee_Id, ref gv_DepMgrTeamList);
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer();", true);
    }
    protected void gv_DepMgrTeamList_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        GridViewRow gRow = e.Row;
        if (gRow.RowIndex > 0)
        {
            string status = gRow.Cells[3].Text.ToString();
            CheckBox cbTeamListID = (CheckBox)gRow.FindControl("cbMyTeamListID");
            if (status.Length > 7)
            {
                string MyState = status.Substring(0, 7).ToLower();
                if (MyState == "pending")
                {
                    cbTeamListID.Enabled = false;
                }
            }
        }
    }
}