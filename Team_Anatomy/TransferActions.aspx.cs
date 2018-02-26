using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.Sql;
using System.Data.SqlClient;


public partial class TransferActions : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    protected string strSQL { get; set; }
    protected int MyEmpID { get; set; }

    protected DataTable dtAllMyTransferees;
    protected enum State : int
    {
        Initiated = 0,
        Declined = 1,
        Approved = 2
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();

        if (!IsPostBack)
        {
            try
            {
                dtEmp = (DataTable)Session["dtEmp"];
                if (dtEmp.Rows.Count <= 0)
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
                Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
            }
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Transfer Actions";
            fillDtAllMyTransferees();            
            fillGvPendingTransfers();
            fillGvCompletedTransfers();
        }
    }

    private void fillDtAllMyTransferees()
    {
        SqlCommand cmd = new SqlCommand("[WFMP].[Transfer_ActionsList]");
        cmd.Parameters.AddWithValue("@RepMgrCode", MyEmpID);
        this.dtAllMyTransferees = my.GetDataTableViaProcedure(ref cmd);
    }
    protected void fillGvPendingTransfers()
    {
        try
        {
        DataTable dtPendingTransfers = dtAllMyTransferees.Select("State=0").CopyToDataTable();
        if (dtPendingTransfers.Rows.Count > 0)
        {
            gvPendingTransfers.DataSource = dtPendingTransfers;
            gvPendingTransfers.DataBind();
        }

        DataRow[] myPendingMovements = dtPendingTransfers.Select("PendingAt=" + MyEmpID + "");
        if (myPendingMovements.GetLength(0) > 0)
        {
            foreach (GridViewRow gr in gvPendingTransfers.Rows)
            {

                foreach (DataRow r in myPendingMovements)
                {
                    if (r["Id"].ToString() == gr.Cells[9].Text)
                    {
                        gr.FindControl("pnlPendingAction").Visible = true;
                    }
                    else
                    {
                        gr.FindControl("pnlPendingAtOtherRepMgr").Visible = true;
                        Label lblPendingAtOtherRepMgr = gr.FindControl("lblPendingAtOtherRepMgr") as Label;
                        //string movementId = dtPendingTransfers.Select("PendingAt="+gr.Cells[9].Text)
                        DataRow[] drPendingAtOtherRepMgr = dtPendingTransfers.Select("Id=" + gr.Cells[9].Text);
                        if (drPendingAtOtherRepMgr.GetLength(0) > 0)
                        {
                            lblPendingAtOtherRepMgr.Text = drPendingAtOtherRepMgr[0]["PendingBy"].ToString();
                        }
                    }
                }
            }
        }
        else
        {
            foreach (GridViewRow gr in gvPendingTransfers.Rows)
            {
                gr.FindControl("pnlPendingAtOtherRepMgr").Visible = true;
                Label lblPendingAtOtherRepMgr = gr.FindControl("lblPendingAtOtherRepMgr") as Label;
                // Cells 9 is the movement ID
                DataRow[] drPendingAtOtherRepMgr = dtPendingTransfers.Select("Id=" + gr.Cells[9].Text);
                if (drPendingAtOtherRepMgr.GetLength(0) > 0)
                {
                    lblPendingAtOtherRepMgr.Text = drPendingAtOtherRepMgr[0]["PendingBy"].ToString();
                }


            }

        }

        }
        catch
        {
            gvPendingTransfers.EmptyDataText = "No Data Found for Pending Transfers";
        }
    }
    protected void fillGvCompletedTransfers()
    {
        // Not Pending with Me. Eiether Approved or Declined with Me.
        // Not Pending with Others. Eiether Approved or Declined by them.
        try
        {
            DataTable dtCompletedTransfers = dtAllMyTransferees.Select("State>0").CopyToDataTable();
            DataView dv = dtCompletedTransfers.DefaultView;
            dv.Sort = "UpdatedOn desc";
            DataTable sortedDT = dv.ToTable();

            if (dtCompletedTransfers.Rows.Count > 0)
            {
                gvCompletedTransfers.DataSource = sortedDT;
                gvCompletedTransfers.DataBind();
            }
        }
        catch
        {
            gvCompletedTransfers.EmptyDataText = "No Data Found for Completed Transfers";
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
    protected void HideColumn(GridView sender, string ColumnToHide)
    {
        // Hides a column given its header text
        GridView ThisGrid = (GridView)sender;
        ((DataControlField)ThisGrid.Columns
                .Cast<DataControlField>()
                .Where(fld => fld.HeaderText == ColumnToHide)
                .SingleOrDefault()).Visible = false;
    }
    protected void gvPendingTransfers_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        try
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                MyEmpID = Convert.ToInt32(dtEmp.Rows[0]["Employee_Id"].ToString());
            }
        }
        catch (Exception Ex)
        {
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }


        // Get index of row passed as command argument
        int index = Convert.ToInt32(e.CommandArgument.ToString());
        int movementID = Convert.ToInt32(gvPendingTransfers.Rows[index].Cells[9].Text.ToString());
        Transferee A = new Transferee(movementID);
        A.UpdaterID = MyEmpID;
        A.UpdatedOn = DateTime.Now;

        int rowsAffected = 0;
        if (e.CommandName == "Approve")
        {
            A.State = (int)State.Approved;
        }
        else if (e.CommandName == "Decline")
        {
            A.State = (int)State.Declined;
        }
        rowsAffected = A.ActionTransfer();
        fillGvPendingTransfers();
        fillGvCompletedTransfers();
        Page.Response.Redirect(Page.Request.Url.ToString(), true);
    }
}