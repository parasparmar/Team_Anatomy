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
    DataTable dt;
    Helper my = new Helper();
    string strSQL = string.Empty;
    int MyEmpID = 0;
    TransferMode EmpTransferMode = TransferMode.NotSpecified;

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            dt = (DataTable)Session["dtEmp"];
            if (dt.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx");
            }
            else
            {
                MyEmpID = Convert.ToInt32(dt.Rows[0]["Employee_Id"].ToString());
            }

        }
        catch (Exception Ex)
        {
            Response.Redirect("index.aspx");
        }
        //fillTeamList();
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Team Movement";


    }
    public enum TransferMode : int
    {
        NotSpecified = 0,
        ManagerTransferOut = 1,
        ManagerTransferIn = 2,
        DepartmentTransferOut = 3,
        DepartmentTransferIn = 4,
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {

    }
    protected void btnMgrMovement_Click(object sender, EventArgs e)
    {
        MovementHandler(MovementType.Manager);
    }
    protected void btnDeptMovement_Click(object sender, EventArgs e)
    {
        MovementHandler(MovementType.Department);

        //ddlDepartmentManager.SelectedIndex = 0;
        //if (ddlDepartmentManager.Items.Count > 1)
        //{
        ddlDepartmentManager.Items.Insert(0, new ListItem("---", "0"));
        ddlDepartmentManager.SelectedIndex = 0;
        //}

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
                        MyEmpID = 923563;
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

                    //fillTeamList(MyEmpID, ref gv_DepMgrTeamList);

                    break;


                case "TransferOut":

                    // Fill From Mgr Dropdown.
                    strSQL = "SELECT Distinct B.[Employee_ID],REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') as Name ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A inner join [CWFM_Umang].[WFMP].[tblMaster] B on B.Employee_ID = A.RepMgrCode";
                    strSQL += " where B.Employee_ID = " + MyEmpID;
                    strSQL += " order by REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') ASC";

                    ddlFromMgr.DataSource = my.GetData(strSQL);
                    ddlFromMgr.DataTextField = "Name";
                    ddlFromMgr.DataValueField = "Employee_ID";
                    ddlFromMgr.DataBind();

                    // Fill To Mgr Dropdown.
                    strSQL = "SELECT Distinct B.[Employee_ID],REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') as Name ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A inner join [CWFM_Umang].[WFMP].[tblMaster] B on B.Employee_ID = A.RepMgrCode ";
                    strSQL += " where B.isReportingManager > 0 and B.Employee_ID <> " + MyEmpID;
                    strSQL += " order by REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') ASC";

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
                        ddlToMgr.Items.Insert(0, new ListItem("---", "0"));
                        ddlToMgr.SelectedIndex = 0;
                    }

                    break;

                case "TransferIn":
                    strSQL = "SELECT Distinct B.[Employee_ID],REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') as Name ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A inner join [CWFM_Umang].[WFMP].[tblMaster] B on B.Employee_ID = A.RepMgrCode";
                    strSQL += " where B.Employee_ID = " + MyEmpID;

                    ddlToMgr.DataSource = my.GetData(strSQL);
                    ddlToMgr.DataTextField = "Name";
                    ddlToMgr.DataValueField = "Employee_ID";
                    ddlToMgr.DataBind();



                    // Fill From Mgr Dropdown.
                    strSQL = "SELECT Distinct B.[Employee_ID],REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') as Name ";
                    strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A inner join [CWFM_Umang].[WFMP].[tblMaster] B on B.Employee_ID = A.RepMgrCode";
                    strSQL += " where B.isReportingManager > 0 and B.Employee_ID <> " + MyEmpID;
                    strSQL += " order by REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') ASC";

                    ddlFromMgr.DataSource = my.GetData(strSQL);
                    ddlFromMgr.DataTextField = "Name";
                    ddlFromMgr.DataValueField = "Employee_ID";
                    ListItem LI2 = new ListItem("Please Select", "0");
                    ddlFromMgr.Items.Insert(0, LI2);
                    ddlFromMgr.DataBind();



                    // divDepMovement.Visible = false;



                    rdobtnMgrPush.Checked = false;
                    rdobtnMgrPull.Checked = true;
                    ltlMovementTypeHeading.Text = "Reporting Manager Movement : Request Transfer In";
                    //ltlDirection.Text = "<i class=\"content-header pageicon fa fa-arrow-circle-left\" style=\"padding-top:10%\"></i>";
                    //ltlDirection.Text = "<i class=\"content-header pageicon fa fa-arrow-circle-right\" style=\"padding-top:10%\"></i>";
                    //ltlDirection.Text = "<i class=\"fa fa-arrow-circle-right\"></i>";
                    fillTeamList(MyEmpID, ref gv_RightHandSideTeamList);
                    gv_LeftHandSideTeamList.DataSource = null;
                    gv_LeftHandSideTeamList.DataBind();
                    //HideColumn(gv_RightHandSideTeamList, "Selection");
                    //UnHideColumn(gv_LeftHandSideTeamList, "Selection");

                    ddlFromMgr.Items.Insert(0, new ListItem("---", "0"));
                    ddlFromMgr.SelectedIndex = 0;

                    break;

                default:

                    break;
            }
        }
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
        if (dt.Rows.Count > 0)
        {
            GridView v = (GridView)Page.FindControlRecursive(gvTeamList);
            v.DataSource = my.GetData("Exec [WFMP].[Transfer_TeamList] " + EmpCode);
            v.DataBind();
        }
        else
        {

        }
    }
    private void fillTeamList(int EmpCode, ref GridView gvTeamList)
    {
        if (dt.Rows.Count > 0)
        {
            gvTeamList.DataSource = my.GetData("Exec [WFMP].[Transfer_TeamList] " + EmpCode);
            gvTeamList.DataBind();
        }
        else
        {

        }
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
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key", "pluginsInitializer()", true);

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
    protected void gv_LeftHandSideTeamList_RowDataBound(object sender, GridViewRowEventArgs e)
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
    protected void ddlDepartmentManager_SelectedIndexChanged(object sender, EventArgs e)
    {
        MyEmpID = Convert.ToInt32(ddlDepartmentManager.SelectedValue.ToString());
        fillTeamList(MyEmpID, ref gv_DepMgrTeamList);
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
    }
    protected void ddlSubSkillSet_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddlFromMgr_SelectedIndexChanged(object sender, EventArgs e)
    {
        int EmpCode = Convert.ToInt32(ddlFromMgr.SelectedValue.ToString());
        fillTeamList(EmpCode, ref gv_LeftHandSideTeamList);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "pluginsInitializer()", true);
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
        string ntID = PageExtensionMethods.getMyWindowsID();
        string strSQL = "Select top 1 [Employee_ID] from [CWFM_Umang].[WFMP].[tblMaster] where [ntName] = '" + ntID + "'";
        int Employee_Id = Convert.ToInt32(my.GetData(strSQL).Rows[0]["Employee_ID"].ToString());
        DateTime D = Convert.ToDateTime(tbEffectiveDate.Text.ToString());

        foreach (GridViewRow gvrow in gv_LeftHandSideTeamList.Rows)
        {
            CheckBox checkbox = gvrow.FindControl("cbMyTeamListID") as CheckBox;
            if (checkbox.Checked)
            {
                M.EmpId = Convert.ToInt32(gv_LeftHandSideTeamList.DataKeys[gvrow.RowIndex].Value.ToString());
                M.FromMgr = Convert.ToInt32(ddlFromManager.SelectedValue.ToString());
                M.ToMgr = Convert.ToInt32(ddlToMgr.SelectedValue.ToString());
                M.Types = TypeOfMovement;
                M.State = 0;
                M.InitBy = Employee_Id;
                M.EffectiveDate = D;
                M.UpdaterID = Employee_Id;
                M.UpdatedOn = DateTime.Now;
                // Go...
                rowsAffected = M.InitiateTransfer();
            }

        }
        int EmpCode = Convert.ToInt32(ddlFromMgr.SelectedValue.ToString());
        fillTeamList(EmpCode, ref gv_LeftHandSideTeamList);

    }




    class Transferee
    {
        public int FromDptLinkMstId { get; set; }
        public int ToDptLinkMstId { get; set; }
        public int FromMgr { get; set; }
        public int ToMgr { get; set; }
        public int EmpId { get; set; }
        public int Types { get; set; }
        public int State { get; set; }
        public int InitBy { get; set; }
        public DateTime EffectiveDate { get; set; }
        public int UpdaterID { get; set; }
        public DateTime UpdatedOn { get; set; }


        private Helper my = new Helper();

        public Transferee() { }
        public int InitiateTransfer()
        {
            //Check if Employee Movement exists in the table, if it does not, Insert to DB directly with State = 1

            DataTable dt;
            int rowcount = 0;
            string strSQL = "select * from CWFM_Umang.WFMP.tbltrans_Movement A";
            strSQL += " where A.EmpId = " + EmpId + " and state=0";
            dt = my.GetData(strSQL);
            rowcount = dt.Rows.Count;
            if (rowcount == 0)
            {
                // For this EmpID, Unfinished movements (not approved or not declined ones) donot exist.
                rowcount = InsertToDB();
            }
            else if (rowcount > 0)
            {
                // Unfinished movements exist for this empID
                // Check if the From and To Mgrs for the movement are the same as the ones in the row above.

                bool SameFromMgr = false;
                bool SameToMgr = false;
                SameFromMgr = (FromMgr.ToString() == dt.Rows[0]["FromMgr"].ToString()) ? true : false;
                SameToMgr = (ToMgr.ToString() == dt.Rows[0]["ToMgr"].ToString()) ? true : false;
                if (SameFromMgr && SameToMgr)
                {
                    rowcount = UpdateToDB();
                }
            }
            return rowcount;
        }
        public int ApproveTransfer() { return 0; }
        private int InsertToDB()
        {
            string strSQL = "INSERT INTO [CWFM_Umang].[WFMP].[tbltrans_Movement]([FromMgr],[ToMgr],[EmpId],[Type] ";
            strSQL += " ,[State],[InitBy],[EffectiveDate],[UpdaterID],[UpdatedOn]) ";
            strSQL += " VALUES (@FromMgr,@ToMgr,@EmpId,@Type,@State,@InitBy,@EffectiveDate,@UpdaterID,@UpdatedOn)";

            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.Parameters.AddWithValue("@FromMgr", FromMgr);
            cmd.Parameters.AddWithValue("@ToMgr", ToMgr);
            cmd.Parameters.AddWithValue("@EmpId", EmpId);
            cmd.Parameters.AddWithValue("@Type", Types);
            cmd.Parameters.AddWithValue("@State", State);
            cmd.Parameters.AddWithValue("@InitBy", InitBy);
            cmd.Parameters.AddWithValue("@EffectiveDate", EffectiveDate);
            cmd.Parameters.AddWithValue("@UpdaterID", UpdaterID);
            cmd.Parameters.AddWithValue("@UpdatedOn", UpdatedOn);

            return my.ExecuteDMLCommand(ref cmd, strSQL, "E");
        }
        private int UpdateToDB()
        {
            string strSQL = "UPDATE [CWFM_Umang].[WFMP].[tbltrans_Movement]";
            strSQL += " SET  [State] = @State, [UpdaterID] = @UpdaterID ";
            strSQL += " , [UpdatedOn] = @UpdatedOn";
            strSQL += " WHERE [EmpId] = @EmpId and [FromMgr] = @FromMgr and [ToMgr] = @ToMgr and [Type] = @Type and [EffectiveDate] = @EffectiveDate";

            SqlCommand cmd = new SqlCommand(strSQL);
            cmd.Parameters.AddWithValue("@FromMgr", FromMgr);
            cmd.Parameters.AddWithValue("@ToMgr", ToMgr);
            cmd.Parameters.AddWithValue("@EmpId", EmpId);
            cmd.Parameters.AddWithValue("@Type", Types);
            cmd.Parameters.AddWithValue("@State", State);
            cmd.Parameters.AddWithValue("@EffectiveDate", EffectiveDate);
            cmd.Parameters.AddWithValue("@UpdaterID", UpdaterID);
            cmd.Parameters.AddWithValue("@UpdatedOn", UpdatedOn);

            return my.ExecuteDMLCommand(ref cmd, strSQL, "E");
        }

    }


    protected void btnDepSubmit_Click(object sender, EventArgs e)
    {
        if (rdoDeptMovement.Checked && rdobtnMgrPull.Checked) { EmpTransferMode = TransferMode.DepartmentTransferIn; }
        if (rdoDeptMovement.Checked && rdobtnMgrPush.Checked) { EmpTransferMode = TransferMode.DepartmentTransferOut; }
        int TypeOfMovement = 0;
        int rowsAffected = 0;
        switch (EmpTransferMode)
        {
            case TransferMode.DepartmentTransferIn:
                TypeOfMovement = (int)TransferMode.DepartmentTransferOut;
                break;

            case TransferMode.DepartmentTransferOut:
                TypeOfMovement = (int)TransferMode.DepartmentTransferOut;
                break;
        }

        Transferee M = new Transferee();
        string ntID = PageExtensionMethods.getMyWindowsID();
        string strSQL = "Select top 1 [Employee_ID],[DPT] from [CWFM_Umang].[WFMP].[tblMaster] where [ntName] = '" + ntID + "'";
        DataTable dt = my.GetData(strSQL);
        int Employee_Id = Convert.ToInt32(dt.Rows[0]["Employee_ID"].ToString());
        DateTime D = Convert.ToDateTime(tbEffectiveDate.Text.ToString());
        int FromDptLinkMstId = Convert.ToInt32(dt.Rows[0]["DPT"].ToString());
        int ToDptLinkMstId = 0;

        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            string mstQuery = "SELECT TransID FROM CWFM_Umang.WFMP.tblDepartmentLinkMst";
            mstQuery += " where  FunctionID = @FunctionID  and DepartmentID = @DepartmentID and ";
            mstQuery += " LOBID = @LOBID and SkillSetID = @SkillSetID and SubSkillSetID = @SubSkillSetID  and Active = 1";
            cn.Open();
            using (SqlCommand mstCmd = new SqlCommand(mstQuery, cn))
            {
                mstCmd.Parameters.AddWithValue("@FunctionID", ddlFunctionId.SelectedValue.ToString());
                mstCmd.Parameters.AddWithValue("@DepartmentID", ddlDepartmentID.SelectedValue.ToString());
                mstCmd.Parameters.AddWithValue("@LOBID", ddlLOBID.SelectedValue.ToString());
                mstCmd.Parameters.AddWithValue("@SkillSetID", ddlSkillSet.SelectedValue.ToString());
                mstCmd.Parameters.AddWithValue("@SubSkillSetID", ddlSubSkillSet.SelectedValue.ToString());
                ToDptLinkMstId = Convert.ToInt32(mstCmd.ExecuteScalar());
            }
        }

        foreach (GridViewRow gvrow in gv_DepMgrTeamList.Rows)
        {
            CheckBox checkbox = gvrow.FindControl("cbMyTeamListID") as CheckBox;
            if (checkbox.Checked)
            {
                M.EmpId = Convert.ToInt32(gv_DepMgrTeamList.DataKeys[gvrow.RowIndex].Value.ToString());
                M.FromMgr = Convert.ToInt32(ddlDepartmentManager.SelectedValue.ToString());
                
                M.Types = TypeOfMovement;
                M.State = 0;
                M.InitBy = Employee_Id;
                M.EffectiveDate = D;
                M.UpdaterID = Employee_Id;
                M.UpdatedOn = DateTime.Now;
                // Go...
                rowsAffected = M.InitiateTransfer();
            }

        }

        fillTeamList(Employee_Id, ref gv_DepMgrTeamList);

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