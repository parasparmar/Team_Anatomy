using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;

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
    protected void btnMgrMovement_Click(object sender, EventArgs e)
    {
        MovementHandler("mgr");
    }
    protected void btnDeptMovement_Click(object sender, EventArgs e)
    {
        MovementHandler("dep");
    }
    protected void rdoMgrMovement_CheckedChanged(object sender, EventArgs e)
    {
        MovementHandler("mgr");
    }
    protected void rdoDeptMovement_CheckedChanged(object sender, EventArgs e)
    {
        MovementHandler("dep");
    }
    private void MovementHandler(string MovementType)
    {
        switch (MovementType)
        {
            //Employee is transferred across Reporting Managers
            case "mgr":
                ltlMovementTypeHeading.Text = "Reporting Manager Movement";
                pnlDeptMovement.Visible = false;
                pnlMgrMovement.Visible = true;
                pnlMgrActions.Visible = true;
                rdoDeptMovement.Checked = false;
                rdoMgrMovement.Checked = true;
                //fillTeamList(MyEmpID);
                fillTeamList(923563);

                break;


            //Employee is transferred across Departments
            case "dep":
                ltlMovementTypeHeading.Text = "Department Movement";
                pnlDeptMovement.Visible = true;
                pnlMgrMovement.Visible = false;
                pnlMgrActions.Visible = false;
                rdoDeptMovement.Checked = true;
                rdoMgrMovement.Checked = false;

                // Fill the dropdowns ddlFromDept and ddlToDept, ddlFromDeptMgr and ddlToDeptMgr

                strSQL = "select C.Id, C.Department  FROM [CWFM_Umang].[WFMP].[tblMaster] A ";
                strSQL += " inner join CWFM_Umang..WFM_Employee_List B on A.Employee_ID=B.Employee_ID ";
                strSQL += " Left join [CWFM_Umang].[WFMP].tblDepartment C on C.Department = B.Department ";
                strSQL += " where A.Employee_ID = " + MyEmpID;


                DataTable dtMyDept = my.GetData(strSQL);
                ddlFromDept.DataSource = dtMyDept;
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

            case "Push":
                strSQL = "SELECT Distinct B.[Employee_ID],REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') as Name ";
                strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A inner join [CWFM_Umang].[WFMP].[tblMaster] B on B.Employee_ID = A.RepMgrCode";
                strSQL += " where B.Employee_ID = " + MyEmpID;
                DataTable dtPushingMgr = my.GetData(strSQL);
                ddlFromMgr.DataSource = dtPushingMgr;
                ddlFromMgr.DataTextField = "Name";
                ddlFromMgr.DataValueField = "Employee_ID";
                ddlFromMgr.DataBind();

                strSQL = "SELECT Distinct B.[Employee_ID],REPLACE(dbo.ToProperCase(B.First_Name) + ' ' + dbo.ToProperCase(B.Middle_Name) + ' ' +dbo.ToProperCase(B.Last_Name),' ',' ') as Name ";
                strSQL += " FROM [CWFM_Umang].[WFMP].[tblMaster] A inner join [CWFM_Umang].[WFMP].[tblMaster] B on B.Employee_ID = A.RepMgrCode";
                DataTable dtReceivingMgr = my.GetData(strSQL);
                ddlToMgr.DataSource = dtReceivingMgr;
                ddlToMgr.DataTextField = "Name";
                ddlToMgr.DataValueField = "Employee_ID";
                ddlToMgr.DataBind();

                break;

            case "Pull":


                break;

            default:
                break;
        }
    }
    private void fillTeamList(int EmpCode)
    {
        if (dt.Rows.Count > 0)
        {
            Helper my = new Helper();
            DataRow dr = dt.Rows[0];
            //Convert.ToInt32(dr["Employee_Id"].ToString());
            //923563;
            DataTable dtMyTeam = my.GetData("Exec [WFMP].[TeamList] " + EmpCode);
            gv_TeamList.DataSource = dtMyTeam;
            gv_TeamList.DataBind();
        }
        else
        {

        }
    }
    protected void btnMgrPush_Click(object sender, EventArgs e)
    {
        MovementHandler("Push");
    }
    protected void btnMgrPull_Click(object sender, EventArgs e)
    {
        MovementHandler("Pull");
    }
}