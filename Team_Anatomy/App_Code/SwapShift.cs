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
using System.Text;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for SwapShift
/// </summary>
public class SwapShift
{
    public int ID { get; private set; }
    public DateTime Date { get; set; }
    public int WeekID { get; set; }
    public int EmpCode1 { get; set; }
    public int ShiftID1 { get; set; }
    public string ShiftCode1 { get; set; }
    public int isWorkingShift1 { get; set; }
    public int NewShiftID1 { get; set; }
    public string NewShiftCode1 { get; set; }
    public int isNewWorkingShift1 { get; set; }
    public int EmpCode2 { get; set; }
    public int ShiftID2 { get; set; }
    public string ShiftCode2 { get; set; }
    public int isWorkingShift2 { get; set; }
    public int NewShiftID2 { get; set; }
    public string NewShiftCode2 { get; set; }
    public int isNewWorkingShift2 { get; set; }
    public DateTime InitiatedOn { get; set; }
    public int ActionByEmpCode2 { get; set; }
    public DateTime? ActionByEmpCode2On { get; set; }
    public int RepMgrCode { get; set; }
    public int ActionByRepMgr { get; set; }
    public DateTime? ActionByRepMgrOn { get; set; }
    public int Active { get; set; }

    public SwapShift() { }
    public SwapShift(int ID)
    {
        string strSQL = "select * from WFMP.vwSwap A where id=@Id";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@Id", ID);
        Helper my = new Helper();
        DataTable dt = my.GetData(ref cmd);
        if (dt != null && dt.Rows.Count > 0)
        {
            this.ID = ID;
            this.Date = Convert.ToDateTime(dt.Rows[0]["Date"].ToString());
            this.EmpCode1 = Convert.ToInt32(dt.Rows[0]["EmpCode1"].ToString());
            this.ShiftID1 = Convert.ToInt32(dt.Rows[0]["ShiftID1"].ToString());
            this.isWorkingShift1 = Convert.ToInt32(dt.Rows[0]["isWorkingShift1"].ToString());
            this.NewShiftID1 = Convert.ToInt32(dt.Rows[0]["NewShiftID1"].ToString());
            this.isNewWorkingShift1 = Convert.ToInt32(dt.Rows[0]["isNewWorkingShift1"].ToString());
            this.EmpCode2 = Convert.ToInt32(dt.Rows[0]["EmpCode2"].ToString());
            this.ShiftID2 = Convert.ToInt32(dt.Rows[0]["ShiftID2"].ToString());
            this.isWorkingShift2 = Convert.ToInt32(dt.Rows[0]["isWorkingShift2"].ToString());
            this.NewShiftID2 = Convert.ToInt32(dt.Rows[0]["NewShiftID2"].ToString());
            this.isNewWorkingShift2 = Convert.ToInt32(dt.Rows[0]["isNewWorkingShift2"].ToString());
            this.InitiatedOn = Convert.ToDateTime(dt.Rows[0]["InitiatedOn"].ToString());
            this.ActionByEmpCode2 = Convert.ToInt32(dt.Rows[0]["ActionByEmpCode2"].ToString());
            if (dt.Rows[0]["ActionByEmpCode2On"].ToString().Length > 0) { this.ActionByEmpCode2On = Convert.ToDateTime(dt.Rows[0]["ActionByEmpCode2On"].ToString()); }
            this.RepMgrCode = Convert.ToInt32(dt.Rows[0]["RepMgrCode"].ToString());
            if (dt.Rows[0]["ActionByRepMgrOn"].ToString().Length > 0) { this.ActionByRepMgrOn = Convert.ToDateTime(dt.Rows[0]["ActionByRepMgrOn"].ToString()); }
            //this.Active = Convert.ToInt32(dt.Rows[0]["Active"].ToString());
        }

    }
    public bool ApproveSwap(int SenderEmpCode)
    {
        if (SenderEmpCode == this.EmpCode1) { return false; }
        else if (SenderEmpCode == this.EmpCode2)
        {
            this.ActionByEmpCode2 = 1;
            this.ActionByEmpCode2On = DateTime.Now;
            Update(this);
            return true;
        }
        else if (SenderEmpCode == this.RepMgrCode)
        {
            this.ActionByRepMgr = 1;
            this.ActionByRepMgrOn = DateTime.Now;
            Update(this);
            return true;
        }
        else
        {
            return false;
        }
    }
    public bool DeclineSwap(int SenderEmpCode)
    {
        if (SenderEmpCode == this.EmpCode1)
        {
            return false;
        }
        else if (SenderEmpCode == this.EmpCode2)
        {
            this.ActionByEmpCode2 = 2;
            this.ActionByEmpCode2On = DateTime.Now;
            Update(this);
            return true;
        }
        else if (SenderEmpCode == this.RepMgrCode)
        {
            this.ActionByRepMgr = 2;
            this.ActionByRepMgrOn = DateTime.Now;
            Update(this);
            return true;
        }
        else
        {
            return false;
        }

    }
    public static int Save(SwapShift Me)
    {
        int rowsAffected = 0;
        int originalHeadCount = Me.isWorkingShift1 + Me.isWorkingShift2;
        int postSwapHeadCount = Me.isNewWorkingShift1 + Me.isNewWorkingShift2;
        if (originalHeadCount == postSwapHeadCount && Me.NewShiftID1 == Me.ShiftID2 && Me.NewShiftID2 == Me.ShiftID1)
        {
            rowsAffected += Insert(Me);
        }
        return rowsAffected;
    }
    public static int Save(List<SwapShift> Entries)
    {
        int rowsAffected = 0;
        foreach (SwapShift Me in Entries)
        {
            int originalHeadCount = Me.isWorkingShift1 + Me.isWorkingShift2;
            int postSwapHeadCount = Me.isNewWorkingShift1 + Me.isNewWorkingShift2;
            if (originalHeadCount == postSwapHeadCount && Me.ShiftID1 != Me.ShiftID2 && Me.NewShiftID1 == Me.ShiftID2 && Me.NewShiftID2 == Me.ShiftID1)
            {
                rowsAffected += Insert(Me);
            }
        }
        return rowsAffected;
    }
    private static int Insert(SwapShift s)
    {
        int rowsAffected = 0;
        Helper my = new Helper();
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            SqlCommand cmd = new SqlCommand("WFMP.Swap_Insert2DB", cn);
            cmd.CommandType = CommandType.StoredProcedure;            
            cmd.Parameters.AddWithValue("@Date", s.Date);
            cmd.Parameters.AddWithValue("@WeekID", s.WeekID);
            cmd.Parameters.AddWithValue("@EmpCode1", s.EmpCode1);
            cmd.Parameters.AddWithValue("@ShiftID1", s.ShiftID1);
            cmd.Parameters.AddWithValue("@NewShiftID1", s.NewShiftID1);
            cmd.Parameters.AddWithValue("@EmpCode2", s.EmpCode2);
            cmd.Parameters.AddWithValue("@ShiftID2", s.ShiftID2);
            cmd.Parameters.AddWithValue("@NewShiftID2", s.NewShiftID2);
            cmd.Parameters.AddWithValue("@ActionByEmpCode2", s.ActionByEmpCode2);
            cmd.Parameters.AddWithValue("@ActionByEmpCode2On", s.ActionByEmpCode2On);
            cmd.Parameters.AddWithValue("@RepMgrCode", s.RepMgrCode);
            cmd.Parameters.AddWithValue("@ActionByRepMgr", s.ActionByRepMgr);
            cmd.Parameters.AddWithValue("@ActionByRepMgrOn", s.ActionByRepMgrOn);
            
            rowsAffected = cmd.ExecuteNonQuery();
        }
        return rowsAffected;
    }
    private static int Update(SwapShift s)
    {
        Helper my = new Helper();
        int rowsAffected = 0;
        SqlCommand cmd = new SqlCommand("WFMP.Swap_Update2DB");
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@SwapID", s.ID);        
        cmd.Parameters.AddWithValue("@ActionByEmpCode2", s.ActionByEmpCode2);
        cmd.Parameters.AddWithValue("@ActionByEmpCode2On", s.ActionByEmpCode2On);        
        cmd.Parameters.AddWithValue("@ActionByRepMgr", s.ActionByRepMgr);
        cmd.Parameters.AddWithValue("@ActionByRepMgrOn", s.ActionByRepMgrOn);    
        
        rowsAffected = my.ExecuteDMLCommand(ref cmd, cmd.CommandText, "S");
        // This will actually commit all approved swaps to the roster.
        Commit2Roster();
        return rowsAffected;

    }
    private static int Commit2Roster()
    {
        Helper my = new Helper();
        SqlCommand cmd = new SqlCommand("WFMP.Swap_Commit2Roster");
        my.ExecuteDMLCommand(ref cmd, "WFMP.Swap_Commit2Roster", "S");
        return 0;
    }
}