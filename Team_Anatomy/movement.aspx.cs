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

    protected void btn_Submit_Click(object sender, EventArgs e)
    {

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
                    strSQL = "select C.Id, C.Department  FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
                    strSQL += " inner join CWFM_Umang..WFM_Employee_List B on A.Employee_ID=B.Employee_ID ";
                    strSQL += " Left join [CWFM_Umang].[WFMP].tblDepartment C on C.Department = B.Department ";
                    strSQL += " where A.Employee_ID = " + MyEmpID;


                    ddlFromDept.DataSource = my.GetData(strSQL);
                    ddlFromDept.DataTextField = "Department";
                    ddlFromDept.DataValueField = "Id";
                    ddlFromDept.DataBind();

                    strSQL = "SELECT Distinct [Id],[Department] FROM [CWFM_Umang].[WFMP].[tblDepartment]";
                    DataTable dtDestinationDept = my.GetData(strSQL);
                    ddlToDept.DataSource = dtDestinationDept;
                    ddlToDept.DataTextField = "Department";
                    ddlToDept.DataValueField = "Id";
                    ddlToDept.DataBind();
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
        // In both Push and Pull scenarios the Gridview from where the selection is initiated is placed on the LEFT.
        // Hence, we need to ensure that the LEFT side always has a selection capability enabled.
        // Correspondingly, the RIGHT side will have the selection capability disabled.

        //HideColumn(gv_RightHandSideTeamList, "Selection");
        //UnHideColumn(gv_LeftHandSideTeamList, "Selection");

    }
    protected void ddlFromMgr_SelectedIndexChanged(object sender, EventArgs e)
    {
        int EmpCode = Convert.ToInt32(ddlFromMgr.SelectedValue.ToString());
        fillTeamList(EmpCode, ref gv_LeftHandSideTeamList);


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
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (rdobtnMgrPull.Checked) { EmpTransferMode = TransferMode.ManagerTransferIn; }
        if (rdobtnMgrPush.Checked) { EmpTransferMode = TransferMode.ManagerTransferIn; }
        if (rdoDeptMovement.Checked && rdobtnMgrPull.Checked) { EmpTransferMode = TransferMode.DepartmentTransferIn; }
        if (rdoDeptMovement.Checked && rdobtnMgrPush.Checked) { EmpTransferMode = TransferMode.DepartmentTransferOut; }
        GridView gv = new GridView();
        DropDownList ddlFromManager = new DropDownList();
        DropDownList ddlToManager = new DropDownList();
        int TypeOfMovement = 0;


        switch (EmpTransferMode)
        {
            case TransferMode.ManagerTransferIn:
                gv = gv_LeftHandSideTeamList;
                ddlFromManager = ddlFromMgr;
                ddlToManager = ddlToMgr;
                TypeOfMovement = (int)TransferMode.ManagerTransferIn;

                break;
            case TransferMode.ManagerTransferOut:
                gv = gv_LeftHandSideTeamList;
                ddlFromManager = ddlFromMgr;
                ddlToManager = ddlToMgr;
                TypeOfMovement = (int)TransferMode.ManagerTransferOut;

                break;

            case TransferMode.DepartmentTransferIn:
                break;
            case TransferMode.DepartmentTransferOut:
                break;
        }

        Transferee M = new Transferee();
        int Employee_Id = Convert.ToInt32(my.GetData("Select top 1 [Employee_ID] from [CWFM_Umang].[WFMP].[tblMaster] where [ntName] = '" + M.UpdatedBy + "'").Rows[0]["Employee_ID"].ToString());
        string ntID = PageExtensionMethods.getMyWindowsID();
        DateTime D = Convert.ToDateTime(tbEffectiveDate.Text.ToString());

        foreach (GridViewRow gvrow in gv.Rows)
        {
            CheckBox checkbox = gvrow.FindControl("cbMyTeamListID") as CheckBox;
            if (checkbox.Checked)
            {

                M.EmpId = Convert.ToInt32(gv.DataKeys[gvrow.RowIndex].Value.ToString());
                M.FromMgr = Convert.ToInt32(ddlFromManager.SelectedValue.ToString());
                M.ToMgr = Convert.ToInt32(ddlToMgr.SelectedValue.ToString());
                M.Types = TypeOfMovement;
                M.State = 1;
                M.Comments = String.Empty;
                M.EffectiveDate = D;
                M.UpdatedBy = ntID;
                M.UpdaterID = Employee_Id;
                M.UpdatedOn = DateTime.Now;
                M.IsValid = true;
                switch (TypeOfMovement)
                {
                    case 1:
                        M.InitiateTransferIn();
                        break;
                    case 2:
                        M.InitiateTransferOut();
                        break;

                }
            }

        }
    }


}

class Transferee
{


    public int FromMgr { get; set; }
    public int ToMgr { get; set; }
    public int EmpId { get; set; }
    public int Types { get; set; }
    public int State { get; set; }
    public string Comments { get; set; }
    public DateTime EffectiveDate { get; set; }
    public int UpdaterID { get; set; }
    public string UpdatedBy { get; set; }
    public DateTime UpdatedOn { get; set; }
    public bool IsValid { get; set; }
    private Helper my = new Helper();

    public Transferee() { }

    //public enum State
    //{
    //   string strSQL = "SELECT * FROM [CWFM_Umang].[WFMP].[tblMovementTypes]";

    //}

    public bool IsEligibleForTransfer(Transferee M)
    {

        return false;
    }

    public int InitiateTransferOut()
    {
        // 1. Check if Employee Movement exists in the table
        string strSQL = "select * from [CWFM_Umang].[WFMP].[tbltrans_Movement] A where EmpId =" + EmpId;
        DataTable dt = my.GetData(strSQL);
        int rowcount = dt.Rows.Count;
        // Movement record Does not exist
        if (rowcount == 0)
        {
            //If EmpID does not exist in [tbltrans_Movement], InsertToDB.
            rowcount = InsertToDB();
            return rowcount;
        }
        else if (rowcount > 0)
        {
            // Prior movement exists for this employee.
            // Check if the state is approved (4) or declined (3) or pending (2) or initiated (1) or null(0)
           




        }




        //3. If EmpID exists in [tbltrans_Movement] with State = 4 ("Approved")  for that EmpID. Then UpdateToDB.
        // Also deactivate all prior rows.
        //4. An Employee cannot be transferred out or in if the State field is anything other than null or "Approved"
        // Hence only if the selected EmpID exists in [tbltrans_Movement] with State = "Approved" and date = max date for EmpID. Then UpdateToDB
        // -- Find Latest valid Movement entry for this employee id

        strSQL = "SELECT * FROM [CWFM_Umang].[WFMP].[tbltrans_Movement] A where EmpId = " + EmpId;
        strSQL += " and IsValid=1 or (EmpId = " + EmpId + " and state like '%Approved%' and IsValid=1)";
        strSQL += " order by A.EffectiveDate desc";
        dt = my.GetData(strSQL);
        if (dt.Rows.Count == 0)
        {
            InsertToDB();
        }
        else if (dt.Rows.Count > 0)
        {
            UpdateToDB();
        }

        return 0;
    }

    public int InitiateTransferIn()
    {

        // If EmpID does not exist in [tbltrans_Movement], InsertToDB.



        return 0;
    }




    private int InsertToDB()
    {
        string strSQL = "INSERT INTO [CWFM_Umang].[WFMP].[tbltrans_Movement]([FromMgr],[ToMgr],[EmpId],[Type] ";
        strSQL += " ,[State],[Comments],[EffectiveDate],[UpdaterID],[UpdatedBy],[UpdatedOn],[IsValid]) ";
        strSQL += " VALUES (@FromMgr,@ToMgr,@EmpId,@Type,@State,@Comments,@EffectiveDate,@UpdaterID,@UpdatedBy,@UpdatedOn,@IsValid)";


        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@FromMgr", FromMgr);
        cmd.Parameters.AddWithValue("@ToMgr", ToMgr);
        cmd.Parameters.AddWithValue("@EmpId", EmpId);
        cmd.Parameters.AddWithValue("@Type", Types);
        cmd.Parameters.AddWithValue("@State", State);
        cmd.Parameters.AddWithValue("@Comments", Comments);
        cmd.Parameters.AddWithValue("@EffectiveDate", EffectiveDate);
        cmd.Parameters.AddWithValue("@UpdatedBy", UpdatedBy);
        cmd.Parameters.AddWithValue("@UpdatedOn", UpdatedOn);
        cmd.Parameters.AddWithValue("@IsValid", IsValid);
        return my.ExecuteDMLCommand(ref cmd, strSQL, "E");


    }

    private int UpdateToDB()
    {
        string strSQL = "UPDATE [CWFM_Umang].[WFMP].[tbltrans_Movement]";
        strSQL += " SET  [State] = @State, [Comments] = @Comments, [UpdaterID] = @UpdaterID , [UpdatedBy] = @UpdatedBy ";
        strSQL += " , [UpdatedOn] = @UpdatedOn ,[IsValid] = @IsValid ";
        strSQL += " WHERE [EmpId] = @EmpId and [FromMgr] = @FromMgr and [ToMgr] = @ToMgr and [Type] = @Type and [EffectiveDate] = @EffectiveDate";

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@FromMgr", FromMgr);
        cmd.Parameters.AddWithValue("@ToMgr", ToMgr);
        cmd.Parameters.AddWithValue("@EmpId", EmpId);
        cmd.Parameters.AddWithValue("@Type", Types);
        cmd.Parameters.AddWithValue("@State", State);
        cmd.Parameters.AddWithValue("@Comments", Comments);
        cmd.Parameters.AddWithValue("@EffectiveDate", EffectiveDate);
        cmd.Parameters.AddWithValue("@UpdaterID", UpdaterID);
        cmd.Parameters.AddWithValue("@UpdatedBy", UpdatedBy);
        cmd.Parameters.AddWithValue("@UpdatedOn", UpdatedOn);
        cmd.Parameters.AddWithValue("@IsValid", IsValid);
        return my.ExecuteDMLCommand(ref cmd, strSQL, "E");

    }

}