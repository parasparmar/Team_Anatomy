﻿using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using context = System.Web.HttpContext;
using System.Web;
using CD;

public class Helper
{
    public Helper() { }
    private SqlConnection cn { get; set; }
    public string getConnectionString()
    {
        EDCryptor xEDCryptor = new EDCryptor();
        string xString = ConfigurationManager.ConnectionStrings["constr"].ToString();
        xString = xEDCryptor.DeCrypt(xString);
        return xString;
    }
    public SqlConnection open_db()
    {

        cn = new SqlConnection(getConnectionString());
        try
        {
            if (cn.State == ConnectionState.Closed || cn.State == ConnectionState.Broken)
            {
                cn.Open();
                return cn;
            }
        }
        catch (Exception e)
        {

            Console.WriteLine("{0} Exception Caught", e);
            Log.thisException(e);
        }
        return null;
    }
    public void close_conn()
    {
        if (cn.State == ConnectionState.Open)
        {
            cn.Close();
            cn.Dispose();
        }
    }
    public int ExecuteDMLCommand(ref SqlCommand cmd, string sql_string, string operation)
    {
        open_db();
        int returnValue = 0;
        try
        {
            cmd.Connection = cn;
            if (operation == "E")
            {
                returnValue = cmd.ExecuteNonQuery();
            }
            else if (operation == "S")
            {

                cmd.CommandType = CommandType.StoredProcedure;
                returnValue = cmd.ExecuteNonQuery();
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);

        }
        finally
        {

            // Paras 29-03-2017 : Don't close the connection here.
            close_conn();

        }
        return returnValue;
    }
    public DataTable GetDataTableViaProcedure(ref SqlCommand cmd)
    {
        open_db();
        DataTable dt = new DataTable();
        using (cmd)
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cn;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.SelectCommand.CommandTimeout = 60;
            da.Fill(dt);
        }
        close_conn();
        return dt;
    }
    public DataTable GetData(string sql)
    {
        
        DataTable dt = new DataTable();
        using (SqlCommand cmd = new SqlCommand(sql))
        {
            cmd.Connection = open_db();
            var r = cmd.ExecuteReader();
            dt.Load(r);
        }
        close_conn();
        return dt;
    }

    public DataTable GetData(ref SqlCommand cmd)
    {
        cmd.Connection = open_db();
        DataTable dt = new DataTable();
        using (cmd)
        {
            var r = cmd.ExecuteReader();
            dt.Load(r);
        }
        close_conn();
        return dt;
    }
    public DataSet return_dataset(string sql)
    {
        open_db();
        DataTable worktable = new DataTable();
        SqlDataAdapter dap = new System.Data.SqlClient.SqlDataAdapter(new System.Data.SqlClient.SqlCommand(sql, cn));
        DataSet ds = new DataSet();
        dap.Fill(ds);
        close_conn();
        return ds;
    }
    public void fill_listbox(ref ListBox list_name, string sp_name, string dataTextField, string dataValueField, string defaultitem, string parameters)
    {
        open_db();
        SqlCommand cmd = new SqlCommand();
        cmd.CommandText = sp_name;
        cmd.Connection = cn;



        try
        {
            //ExecuteDMLCommand(ref cmd, sp_name, "S");
            //----------------------- Adding multiple Parameters with there values by split using '#'.
            if (parameters.Trim() != "")
            {
                string[] multiple_parameter = parameters.Split(',');
                foreach (string p_value in multiple_parameter)
                {
                    string para_name = p_value.Split('#')[0];
                    string para_value = p_value.Split('#')[1];
                    cmd.Parameters.AddWithValue("@" + para_name, para_value);
                }
            }
            SqlDataAdapter dap = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();
            dap.SelectCommand = cmd;
            dap.Fill(ds);

            if (defaultitem != "")
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr[0] = 0;
                dr[1] = defaultitem;
                ds.Tables[0].Rows.Add(dr);
            }
            list_name.DataSource = ds.Tables[0];
            list_name.DataTextField = dataTextField;
            list_name.DataValueField = dataValueField;
            list_name.DataBind();


            //--------------------------------------------
            if (defaultitem != "")
            {
                list_name.SelectedValue = "0";
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            close_conn();
        }

    }
    public void fill_gridview(ref GridView gridname, string sql_string)
    {
        open_db();
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter dap = new SqlDataAdapter();
        DataSet ds = new DataSet();
        try
        {
            ExecuteDMLCommand(ref cmd, sql_string, "E");
            dap.SelectCommand = cmd;
            dap.Fill(ds);
            //------------------------  Add blank row in gridview if no record found ---- else bind gridview
            if (ds.Tables[0].Rows.Count == 0)
            {
                ds.Tables[0].Rows.Add(ds.Tables[0].NewRow());
                gridname.DataSource = ds.Tables[0];
                gridname.DataBind();

                int columncount = gridname.Rows[0].Cells.Count;
                gridname.Rows[0].Cells.Clear();
                gridname.Rows[0].Cells.Add(new TableCell());
                gridname.Rows[0].Cells[0].ColumnSpan = columncount;
                gridname.Rows[0].Cells[0].Text = "No Items in List";
                gridname.Rows[0].Cells[0].HorizontalAlign = HorizontalAlign.Center;
                gridname.Rows[0].Cells[0].Font.Bold = true;
                gridname.Rows[0].Cells[0].Font.Size = 8;
            }
            else
            {
                gridname.DataSource = ds.Tables[0];
                gridname.DataBind();
            }

        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            cmd.Dispose();
            dap.Dispose();
            close_conn();
        }
    }
    public void set_pageheading(string heading, Page pagename)
    {
        Label lblheading = (Label)pagename.Master.FindControl("lblheading");
        if (lblheading != null)
        {
            lblheading.Visible = true;
            lblheading.Text = heading;
        }
    }
    public int getSingleton(string strSQL)
    {
        open_db();
        SqlCommand cmd = new SqlCommand(strSQL, cn);
        var the_result = cmd.ExecuteScalar();
        int result = 0;
        close_conn();

        if (Int32.TryParse(the_result.ToString(), out result))
        {
            return result;
        }
        else
        {
            return 0;
        };

    }

    public string getFirstResult(string strSQL)
    {
        open_db();
        SqlCommand cmd = new SqlCommand(strSQL, cn);
        var the_result = Convert.ToString(cmd.ExecuteScalar());
        close_conn();
        return the_result;
    }
    public void fill_dropdown(Control drp_name, string sp_name, string datatextfield, string datavaluefield, string defaultitem, string parameters, string tran_type)
    {
        open_db();
        SqlCommand cmd = new SqlCommand(sp_name, cn);
        cmd.CommandType = CommandType.StoredProcedure;


        try
        {
            DropDownList v = (DropDownList)drp_name;


            //----------------------- Adding multiple Parameters with there values by split using '#' only if it is stored procedure.
            if (tran_type == "S")
            {
                if (parameters.Trim() != "")
                {
                    string[] multiple_parameter = parameters.Split(',');
                    foreach (string p_value in multiple_parameter)
                    {
                        string para_name = p_value.Split('#')[0];
                        string para_value = p_value.Split('#')[1];
                        cmd.Parameters.AddWithValue("@" + para_name, para_value);
                    }
                }
            }
            SqlDataAdapter dap = new SqlDataAdapter(cmd);
            dap.SelectCommand = cmd;
            DataSet ds = new DataSet();
            dap.Fill(ds);




            if (defaultitem != "")
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr[0] = 0;
                dr[1] = defaultitem;
                ds.Tables[0].Rows.Add(dr);
            }
            v.DataSource = ds.Tables[0];
            v.DataTextField = datatextfield;
            v.DataValueField = datavaluefield;
            v.DataBind();


            //--------------------------------------------
            if (defaultitem != "")
            {
                v.SelectedValue = "0";
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            close_conn();
        }
    }
    public void append_dropdown(ref DropDownList drp_name, string sp_name, int TextPosition, int ValuePosition)
    {
        open_db();

        using (SqlCommand cmd = new SqlCommand(sp_name, cn))
        {
            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                try
                {
                    DropDownList dp = (DropDownList)drp_name;

                    while (dr.Read())
                    {
                        dp.Items.Add(new ListItem(dr.GetValue(TextPosition).ToString(), dr.GetValue(ValuePosition).ToString()));
                    }

                }
                catch (Exception Ex)
                {
                    Console.Write(Ex.Message.ToString());
                }
                finally
                {
                    close_conn();
                }
            }
        }


    }



}

public class EmailSender
{
    private string _initiatorEmail;
    private string[] _recipientsEmailAddresses { get; set; }
    public int InitiatorEmpId { get; set; }
    public string RecipientsEmpId { get; set; }
    public string CCsEmpId { get; set; }
    public string BCCsEmpId { get; set; }
    public string Subject { get; set; }
    public string Body { get; set; }
    private string MailFormat = "html";
    private string From { get; set; }
    public int EmailType { get; set; }
    Helper my = new Helper();
    public EmailSender()
    {
        if (_initiatorEmail != null && _initiatorEmail != string.Empty) { From = _initiatorEmail.ToString(); }

    }

    public string getFullNameFromEmpID(int EmpID)
    {
        string myName = string.Empty;
        string strSQL = "Select A.First_Name+' '+A.Middle_Name+' '+A.Last_Name as Name from WFMP.tblMaster A where A.Employee_ID = " + EmpID;

        myName = my.getFirstResult(strSQL);
        if (myName.Length > 0)
        {
            myName = myName.Replace("  ", " ");
            return myName;
        }
        else
        {
            return string.Empty;
        }
    }

    public string EmailFromEmpID(int EmpID)
    {
        string emailID = string.Empty;
        string strSQL = "Select A.Email_Office from WFMP.tblmaster A where A.Employee_ID = " + EmpID;

        emailID = my.getFirstResult(strSQL);
        if ((emailID.Contains("@") && emailID.Contains(".")))
        {
            return emailID;
        }
        else
        {
            return string.Empty;
        }


    }

    private string convertAndReplaceDelimitedEmpIDs2EmailIds(string semicolonseperatedempids)
    {
        string[] _recipients = semicolonseperatedempids.Split(';');
        string emailIDsToBereturned = string.Empty;
        if (semicolonseperatedempids != null && semicolonseperatedempids.Length > 0)
        {
            for (int i = 0; i < _recipients.Length; i++)
            {
                emailIDsToBereturned += ";" + EmailFromEmpID(Convert.ToInt32(_recipients[i]));

            }
        }
        if (emailIDsToBereturned.IndexOf(";") == 0)
        {
            return emailIDsToBereturned.Remove(0, 1);
        }
        else
        {
            return emailIDsToBereturned;
        }


    }

    public int Send()
    {
        int sentId = 0;
        string errorMessage = string.Empty;
        if (InitiatorEmpId != 0 && RecipientsEmpId != null && Subject != null & Body != null)
        {
            RecipientsEmpId = convertAndReplaceDelimitedEmpIDs2EmailIds(RecipientsEmpId);
            string InitiatorEmailID = EmailFromEmpID(InitiatorEmpId);
            if (CCsEmpId != null && CCsEmpId.Length > 0) { CCsEmpId = convertAndReplaceDelimitedEmpIDs2EmailIds(CCsEmpId); }
            if (BCCsEmpId != null && BCCsEmpId.Length > 0) { BCCsEmpId = convertAndReplaceDelimitedEmpIDs2EmailIds(BCCsEmpId); }
            try
            {
                using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
                {
                    cn.Open();
                    using (SqlCommand cmd = new SqlCommand("Master.dbo.SendEMailDB", cn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;

                        cmd.Parameters.AddWithValue("@xrecipients", RecipientsEmpId);
                        cmd.Parameters.AddWithValue("@xcopy_recipients", CCsEmpId);
                        cmd.Parameters.AddWithValue("@xblind_copy_recipients", BCCsEmpId);
                        cmd.Parameters.AddWithValue("@xsubject", Subject);
                        cmd.Parameters.AddWithValue("@xbody", Body);
                        cmd.Parameters.AddWithValue("@xbody_format", MailFormat);
                        cmd.Parameters.AddWithValue("@xfrom_address", InitiatorEmailID);
                        if (EmailType == 0) { EmailType = (int)emailtype.Development; }
                        cmd.Parameters.AddWithValue("@xEmailType", EmailType);
                        sentId = cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                sentId = 0;
                return sentId;
            }
        }
        return sentId;
    }

    public enum emailtype
    {
        Production = 1,
        UAT = 2,
        Development = 3
    }
}
