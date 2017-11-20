using System;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Transferee
/// </summary>
public class Transferee
{
    public Transferee() { }

    public int MovementId { get; set; }
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
            int LocalMovementID = InsertToDB();

            // When there is no From Mgr, the employees fall in the unaligned case. There is no second level approval process to be followed. 
            if (this.FromMgr == 0 || string.IsNullOrEmpty(this.FromMgr.ToString()))
            {
                MovementId = LocalMovementID;
                FromMgr = ToMgr;
                State = 2;
                ActionTransfer(this);
            }
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
            else if (string.IsNullOrEmpty(dt.Rows[0]["FromMgr"].ToString()))
            {
                // Employees with 0 or Null RepMGR codes are unaligned employees. The can be new or have missing alignment data.
                // As a process they need to be aligned to the initiating reporting manager directly without second level approval.

                rowsAffected = UpdateToDB();
            }
        }
        return rowsAffected;
    }

    public int ActionTransfer(Transferee T)
    {

        string strSQL = "[WFMP].[Transfer_ApproveAndCommitToMaster]";
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MovementId", MovementId);
                cmd.Parameters.AddWithValue("@State", State);
                cmd.Parameters.AddWithValue("@UpdaterID", UpdaterID);
                cmd.Parameters.AddWithValue("@EffectiveDate", EffectiveDate);

                cmd.ExecuteNonQuery();
            }
        }
        return 1;
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
        int MovementId = 0;
        string strSQL = "INSERT INTO [WFMP].[tbltrans_Movement] ";
        strSQL += " ([FromDptLinkMstId],[ToDptLinkMstId],[FromMgr],[ToMgr],[EmpId],[Type],[State],[InitBy],[InitOn]";
        strSQL += " ,[EffectiveDate],[UpdaterID],[UpdatedOn])";
        strSQL += " VALUES (@FromDptLinkMstId,@ToDptLinkMstId,@FromMgr,@ToMgr,@EmpId,@Type,@State,@InitBy";
        strSQL += " ,@InitOn,@EffectiveDate,@UpdaterID,@UpdatedOn); Select @MovementId = SCOPE_IDENTITY();";

        // We are initiating a transfer. The direction and type of transfer is already specified.
        // However the state is supposed to be "Initiated" ie:0
        // this.State = 0;
        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {
                SqlParameter MovId = new SqlParameter("@MovementId", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                cmd.Parameters.Add(MovId);
                cmd.Parameters.AddWithValue("@FromDptLinkMstId", FromDptLinkMstId);
                cmd.Parameters.AddWithValue("@ToDptLinkMstId", ToDptLinkMstId);
                cmd.Parameters.AddWithValue("@FromMgr", FromMgr);
                cmd.Parameters.AddWithValue("@ToMgr", ToMgr);
                cmd.Parameters.AddWithValue("@EmpId", EmpId);
                cmd.Parameters.AddWithValue("@Type", Types);
                cmd.Parameters.AddWithValue("@State", State);
                cmd.Parameters.AddWithValue("@InitBy", InitBy);
                cmd.Parameters.AddWithValue("@InitOn", InitOn);
                cmd.Parameters.AddWithValue("@EffectiveDate", EffectiveDate);
                cmd.Parameters.AddWithValue("@UpdaterID", UpdaterID);
                cmd.Parameters.AddWithValue("@UpdatedOn", UpdatedOn);
                cmd.ExecuteNonQuery();
                // idAsNullableInt remains null
                MovementId = MovId.Value as int? ?? default(int);



            }
        }
        //TODO: Now that we have updated the Transfer Log : tbltrans_Movement
        //We need to update the tblMaster with the new repmgrcode
        return MovementId;
    }
    private int UpdateToDB()
    {
        string strSQL = "UPDATE [CWFM_Umang].[WFMP].[tbltrans_Movement]";
        strSQL += " SET [FromDptLinkMstId] = @FromDptLinkMstId,[ToDptLinkMstId]=@ToDptLinkMstId, [State] = @State, [UpdaterID] = @UpdaterID ";
        strSQL += " , [UpdatedOn] = @UpdatedOn";
        strSQL += " WHERE [Id] = @MovementId";

        using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd = new SqlCommand(strSQL, cn))
            {

                cmd.Parameters.AddWithValue("@FromDptLinkMstId", FromDptLinkMstId);
                cmd.Parameters.AddWithValue("@ToDptLinkMstId", ToDptLinkMstId);
                cmd.Parameters.AddWithValue("@State", State);
                cmd.Parameters.AddWithValue("@UpdaterID", UpdaterID);
                cmd.Parameters.AddWithValue("@UpdatedOn", UpdatedOn);
                cmd.Parameters.AddWithValue("@MovementId", MovementId);

                return cmd.ExecuteNonQuery();
            }
        }
    }
    public Transferee(int MovementID)
    {

        string StrSQL = "[WFMP].[Transfer_getTransfereeUsingMovementID]";
        SqlCommand cmd = new SqlCommand(StrSQL);
        cmd.Parameters.AddWithValue("@Id", MovementID);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        if (dt.Rows.Count == 1)
        {

            DataRow d = dt.Rows[0];
            this.MovementId = Convert.ToInt32(d["Id"].ToString());
            this.FromDptLinkMstId = d["FromDptLinkMstId"].ToString() == string.Empty ? 0 : Convert.ToInt32(d["FromDptLinkMstId"].ToString());
            this.ToDptLinkMstId = d["ToDptLinkMstId"].ToString() == string.Empty ? 0 : Convert.ToInt32(d["ToDptLinkMstId"].ToString());
            this.FromMgr = Convert.ToInt32(d["FromMgr"].ToString());
            this.ToMgr = Convert.ToInt32(d["ToMgr"].ToString());
            this.EmpId = Convert.ToInt32(d["EmpId"].ToString());
            this.Types = Convert.ToInt32(d["Type"].ToString());
            this.State = Convert.ToInt32(d["State"].ToString());
            this.InitBy = Convert.ToInt32(d["InitBy"].ToString());
            this.InitOn = Convert.ToDateTime(d["InitOn"].ToString());
            this.EffectiveDate = d["EffectiveDate"].ToString() == string.Empty ? DateTime.Now : Convert.ToDateTime(d["EffectiveDate"].ToString());
            this.UpdaterID = Convert.ToInt32(d["UpdaterID"].ToString());
            this.UpdatedOn = d["UpdatedOn"].ToString() == string.Empty ? DateTime.Now : Convert.ToDateTime(d["UpdatedOn"].ToString());
        }
    }
}
public static class MovementType
{
    public static String Manager { get { return "Manager"; } }
    public static String Department { get { return "Department"; } }
    public static String TransferOut { get { return "TransferOut"; } }
    public static String TransferIn { get { return "TransferIn"; } }

    public static bool HasProperty(this Type obj, string propertyName)
    {
        return obj.GetProperty(propertyName) != null;
    }
}


