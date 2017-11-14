using System;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Transferee
/// </summary>
public class Transferee
{
    public Transferee() { }
    public int FromDptLinkMstId { get; set; }
    public int ToDptLinkMstId { get; set; }
    public int FunctionID { get; set; }
    public int DepartmentID { get; set; }
    public int LOBID { get; set; }
    public int SkillSetID { get; set; }
    public int SubSkillSetID { get; set; }
    public int FromMgr { get; set; }
    public int ToMgr { get; set; }
    public int EmpId { get; set; }
    public int Types { get; set; }
    public int State { get; set; }
    public int InitBy { get; set; }
    public DateTime InitOn { get; set; }
    public DateTime EffectiveDate { get; set; }
    public int UpdaterID { get; set; }
    public DateTime UpdatedOn { get; set; }
    private int rowsAffected = 0;
    private Helper my = new Helper();
    //Check if Employee Movement exists in the table, if it does not, Insert to DB directly with State = 1

    private bool _hasUnActionedTransfers()
    {
        DataTable dt;
        rowsAffected = 0;
        string strSQL = "select * from CWFM_Umang.WFMP.tbltrans_Movement A";
        strSQL += " where A.EmpId = " + EmpId + " and state=0";
        dt = my.GetData(strSQL);
        rowsAffected = dt.Rows.Count;
        if (rowsAffected <= 0)
        {
            return false;
        }
        else if (rowsAffected > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    public int InitiateTransfer()
    {
        DataTable dt;
        rowsAffected = 0;
        string strSQL = "select * from CWFM_Umang.WFMP.tbltrans_Movement A";
        strSQL += " where A.EmpId = " + EmpId + " and state=0";
        dt = my.GetData(strSQL);
        rowsAffected = dt.Rows.Count;

        if (rowsAffected == 0)
        {
            // For this EmpID, Unfinished movements (not approved or not declined ones) donot exist.
            rowsAffected = InsertToDB();
        }
        else
        {
            // Unfinished movements exist for this empID
            // Check if the From and To Mgrs for the movement are the same as the ones in the row above.

            bool SameFromMgr = false;
            bool SameToMgr = false;
            if (Types < 3)
            {
                ToDptLinkMstId = FromDptLinkMstId;
            }

            if (!string.IsNullOrEmpty(dt.Rows[0]["FromMgr"].ToString()) || string.IsNullOrEmpty(dt.Rows[0]["ToMgr"].ToString()))
            {
                SameFromMgr = (FromMgr.ToString() == dt.Rows[0]["FromMgr"].ToString()) ? true : false;
                SameToMgr = (ToMgr.ToString() == dt.Rows[0]["ToMgr"].ToString()) ? true : false;
                if (SameFromMgr && SameToMgr)
                {
                    rowsAffected = UpdateToDB();
                }
            }
        }
        return rowsAffected;
    }
    public int InitiateDepartmentTransfer()
    {
        // Check for unactioned previous department / manager movements.
        DataTable dt;
        rowsAffected = 0;
        string strSQL = "select * from CWFM_Umang.WFMP.tbltrans_Movement A";
        strSQL += " where A.EmpId = " + EmpId + " and state=0";
        dt = my.GetData(strSQL);
        rowsAffected = dt.Rows.Count;
        if (rowsAffected == 0)
        {
            // For this EmpID, Unfinished movements (not approved or not declined ones) donot exist.
            rowsAffected = InsertToDB();
        }
        else
        {
            // Unfinished movements exist for this empID. The Department movement cannot proceed.
            rowsAffected = 0;
        }
        //rowsAffected = InsertToDB();
        return rowsAffected;
    }
    public int ApproveTransfer()
    {

        return 0;
    }
    private int InsertToDB()
    {
        string strSQL = "INSERT INTO [CWFM_Umang].[WFMP].[tbltrans_Movement]([FromDptLinkMstId],[ToDptLinkMstId],[FromMgr],[ToMgr],[EmpId],[Type] ";
        strSQL += " ,[State],[InitBy],[EffectiveDate],[UpdaterID],[UpdatedOn]) ";
        strSQL += " VALUES (@FromDptLinkMstId,@ToDptLinkMstId, @FromMgr,@ToMgr,@EmpId,@Type,@State,@InitBy,@EffectiveDate,@UpdaterID,@UpdatedOn)";
        // We are initiating a transfer. The direction and type of transfer is already specified.
        // However the state is supposed to be "Initiated" ie:0
        // this.State = 0;

        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.Parameters.AddWithValue("@FromDptLinkMstId", FromDptLinkMstId);
        cmd.Parameters.AddWithValue("@ToDptLinkMstId", ToDptLinkMstId);
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

        //TODO: Now that we have updated the Transfer Log : tbltrans_Movement
        //We need to update the tblMaster with the new repmgrcode

    }
    private int UpdateToDB()
    {
        string strSQL = "UPDATE [CWFM_Umang].[WFMP].[tbltrans_Movement]";
        strSQL += " SET [FromDptLinkMstId] = @FromDptLinkMstId,[ToDptLinkMstId]=@ToDptLinkMstId, [State] = @State, [UpdaterID] = @UpdaterID ";
        strSQL += " , [UpdatedOn] = @UpdatedOn";
        strSQL += " WHERE [EmpId] = @EmpId and [FromMgr] = @FromMgr and [ToMgr] = @ToMgr and [Type] = @Type and [EffectiveDate] = @EffectiveDate";

        SqlCommand cmd = new SqlCommand(strSQL);

        cmd.Parameters.AddWithValue("@FromDptLinkMstId", FromDptLinkMstId);
        cmd.Parameters.AddWithValue("@ToDptLinkMstId", ToDptLinkMstId);
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


