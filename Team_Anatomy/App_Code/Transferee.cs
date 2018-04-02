using System;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Transferee
/// </summary>
public class Transferee
{

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
    private EmailSender Email = new EmailSender();
    // Constructors.
    public Transferee() { }
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

    //private bool _hasUnActionedTransfers()
    //{
    //    DataTable dt;
    //    rowsAffected = 0;
    //    string strSQL = "select * from CWFM_Umang.WFMP.tbltrans_Movement A";
    //    strSQL += " where A.EmpId = " + EmpId + " and state=0";
    //    dt = my.GetData(strSQL);
    //    rowsAffected = dt.Rows.Count;
    //    if (rowsAffected <= 0)
    //    {
    //        return false;
    //    }
    //    else if (rowsAffected > 0)
    //    {
    //        return true;
    //    }
    //    else
    //    {
    //        return false;
    //    }
    //}

    public int InitiateTransfer()
    {
        DataTable dt;
        rowsAffected = 0;
        string strSQL = "select * from CWFM_Umang.WFMP.tbltrans_Movement A";
        strSQL += " where A.EmpId = " + EmpId + " and state=0";
        dt = my.GetData(strSQL);
        rowsAffected = dt.Rows.Count;
        // Do Unfinished Movements exist?
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
                ActionTransfer();

            }
            sendEmail();
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
            else
            {
                rowsAffected = ActionTransfer();
                sendEmail();
            }

            if (!string.IsNullOrEmpty(dt.Rows[0]["FromMgr"].ToString()) || string.IsNullOrEmpty(dt.Rows[0]["ToMgr"].ToString()))
            {
                SameFromMgr = (FromMgr.ToString() == dt.Rows[0]["FromMgr"].ToString()) ? true : false;
                SameToMgr = (ToMgr.ToString() == dt.Rows[0]["ToMgr"].ToString()) ? true : false;
                if (SameFromMgr && SameToMgr)
                {
                    rowsAffected = UpdateToDB();
                    sendEmail();
                }
            }
            else if (string.IsNullOrEmpty(dt.Rows[0]["FromMgr"].ToString()))
            {
                // Employees with 0 or Null RepMGR codes are unaligned employees. The can be new or have missing alignment data.
                // As a process they need to be aligned to the initiating reporting manager directly without second level approval.

                rowsAffected = UpdateToDB();
                sendEmail();
            }
        }
        return rowsAffected;
    }
    public int InitiateDepartmentTransfer()
    {
        DataTable dt;
        rowsAffected = 0;
        string strSQL = "select * from CWFM_Umang.WFMP.tbltrans_Movement A ";
        strSQL += " where A.EmpId = " + EmpId + " and state <3 and EffectiveDate <=GETDATE()";
        dt = my.GetData(strSQL);
        rowsAffected = dt.Rows.Count;
        if (rowsAffected > 0)
        {
            for (int i = 0; i < rowsAffected; i++)
            {
                MovementId = Convert.ToInt32(dt.Rows[i]["Id"].ToString());
                State = 3;
                ActionTransfer();
            }
        }
        else
        {
            MovementId = InsertToDB();
            State = 3;
            ActionTransfer();
        }
        sendEmail();
        return 0;
    }
    public int ActionTransfer()
    {
        int rowsAffected = 0;
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

                rowsAffected = cmd.ExecuteNonQuery();
            }
        }
        sendEmail();
        return rowsAffected;
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

    private void sendEmail()
    {

        string InitiatorName = Email.getFullNameFromEmpID(InitBy);
        string FromMgrName = Email.getFullNameFromEmpID(FromMgr);
        string ToMgrName = Email.getFullNameFromEmpID(ToMgr);
        string EmpName = Email.getFullNameFromEmpID(EmpId);
        string UpdaterName = Email.getFullNameFromEmpID(UpdaterID);

        switch (Types)
        {
            case 1:
                // Manager Transfers Out
                if (State == (int)state.Approved)
                {
                    Email.Subject = EmpName + "'s outward movement has been approved by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has been approved by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(FromMgr);
                    Email.CCsEmpId = ToMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Declined)
                {
                    Email.Subject = EmpName + "'s outward movement has not been accepted by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has not been accepted by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(FromMgr);
                    Email.CCsEmpId = ToMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Initiated)
                {
                    Email.Subject = EmpName + "'s outward movement has been initiated by " + InitiatorName;
                    Email.Body = "<strong>Hi </strong>" + ToMgrName + ", ";
                    Email.Body += "<p>The inward movement of " + EmpName + " has been initiated by </p>" + FromMgrName;
                    Email.Body += "<p>Please click the approve/decline buttons at the  <a href='http://iaccess/TA/TransferActions.aspx'>Transfer Actions page</a>  to move the process forward.";

                    Email.RecipientsEmpId = Convert.ToString(ToMgr);
                    Email.CCsEmpId = FromMgr.ToString();
                    Email.Send();
                }
                break;
            case 2:
                // Manager Transfer In
                if (State == (int)state.Approved)
                {
                    Email.Subject = EmpName + "'s inward movement has been approved by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has been approved by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(ToMgr);
                    Email.CCsEmpId = FromMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Declined)
                {
                    Email.Subject = EmpName + "'s outward movement has not been accepted by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has not been accepted by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(ToMgr);
                    Email.CCsEmpId = FromMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Initiated)
                {
                    Email.Subject = EmpName + "'s inward movement has been initiated by " + InitiatorName;
                    Email.Body = "<strong>Hi </strong>" + ToMgrName + ", ";
                    Email.Body += "<p>The outward movement of " + EmpName + " has been initiated by </p>" + FromMgrName;
                    Email.Body += "<p>Please click the approve/decline buttons at the  <a href='http://iaccess/TA/TransferActions.aspx'>Transfer Actions page</a>  to move the process forward.";

                    Email.RecipientsEmpId = Convert.ToString(FromMgr);
                    Email.CCsEmpId = ToMgr.ToString();
                    Email.Send();
                }
                break;
            case 3:
                // Dept Transfer Out
                if (State == (int)state.Approved)
                {
                    Email.Subject = EmpName + "'s outward movement has been approved by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has been approved by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(FromMgr);
                    Email.CCsEmpId = ToMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Declined)
                {
                    Email.Subject = EmpName + "'s outward movement has not been accepted by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has not been accepted by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(FromMgr);
                    Email.CCsEmpId = ToMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Initiated)
                {
                    Email.Subject = EmpName + "'s outward movement has been initiated by " + InitiatorName;
                    Email.Body = "<strong>Hi </strong>" + ToMgrName + ", ";
                    Email.Body += "<p>The inward movement of " + EmpName + " has been initiated by </p>" + FromMgrName;
                    Email.Body += "<p>Please click the approve/decline buttons at the  <a href='http://iaccess/TA/TransferActions.aspx'>Transfer Actions page</a>  to move the process forward.";

                    Email.RecipientsEmpId = Convert.ToString(ToMgr);
                    Email.CCsEmpId = FromMgr.ToString();
                    Email.Send();
                }
                break;
            case 4:
                // Dept Transfer In 
                if (State == (int)state.Approved)
                {
                    Email.Subject = EmpName + "'s inward movement has been approved by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has been approved by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(ToMgr);
                    Email.CCsEmpId = FromMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Declined)
                {
                    Email.Subject = EmpName + "'s outward movement has not been accepted by " + UpdaterName;
                    Email.Body = "<strong>Hi </strong>" + InitiatorName + ", ";
                    Email.Body += "<p>The movement of " + EmpName + " initiated by you has not been accepted by " + UpdaterName + ".</p>";
                    Email.Body += "<p>To verify this, please check your team dashboard.</p>";

                    Email.RecipientsEmpId = Convert.ToString(ToMgr);
                    Email.CCsEmpId = FromMgr.ToString();
                    Email.Send();
                }
                else if (State == (int)state.Initiated)
                {
                    Email.Subject = EmpName + "'s inward movement has been initiated by " + InitiatorName;
                    Email.Body = "<strong>Hi </strong>" + ToMgrName + ", ";
                    Email.Body += "<p>The outward movement of " + EmpName + " has been initiated by </p>" + FromMgrName;
                    Email.Body += "<p>Please click the approve/decline buttons at the  <a href='http://iaccess/TA/TransferActions.aspx'>Transfer Actions page</a>  to move the process forward.";

                    Email.RecipientsEmpId = Convert.ToString(FromMgr);
                    Email.CCsEmpId = FromMgr.ToString();
                    Email.Send();
                }
                break;
        }



    }
    protected enum state : int
    {
        Initiated = 0,
        Declined = 1,
        Approved = 2
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


