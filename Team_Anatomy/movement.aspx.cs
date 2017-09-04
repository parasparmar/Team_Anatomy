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
            v.DataSource = my.GetData("Exec [WFMP].[TeamList] " + EmpCode);
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

            gvTeamList.DataSource = my.GetData("Exec [WFMP].[TeamList] " + EmpCode);
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

    }
}