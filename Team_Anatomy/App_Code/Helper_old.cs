using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


/// <summary>
/// Summary description for Helper
/// </summary>
public class Helper_old
{
    SqlCommand command;
    SqlDataReader sdr;
    SqlDataAdapter sda;
    SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["constr"].ConnectionString);

    private int _xCount_ID;
    private string _xMail_id;

    public int xCount_ID
    {
        get { return _xCount_ID; }
        set { _xCount_ID = value; }
    }

    public string xMail_ID
    {
        get { return _xMail_id; }
        set { _xMail_id = value; }
    }

	
    public DataTable GetData(string query)
    {
        string strConnString = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
        using (SqlConnection con = new SqlConnection(strConnString))
        {
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = query;
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    using (DataSet ds = new DataSet())
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        return dt;
                    }
                }
            }
        }
    }

    //Insert update query executor
    public void Query_executor_IU(string xQuery)
    {

        command = new SqlCommand(xQuery, con);
        command.CommandType = CommandType.Text;
        con.Open();
        command.ExecuteNonQuery();
        con.Close();

    }


    public void PWD_Count(string xQuery)
    {
        try
        {
            command = new SqlCommand(xQuery, con);
            con.Open();
            sdr = command.ExecuteReader();
            if (sdr.HasRows)
            {
                while (sdr.Read())
                {
                    xCount_ID = Convert.ToInt16(sdr.GetValue(0).ToString());
                    xMail_ID = sdr.GetValue(1).ToString();
                }
            }
            else
            {
                sdr.Close();
                con.Close();
                
            }
            sdr.Close();
            con.Close();
        }
        catch
        {
            sdr.Close();
            con.Close();
            throw;
        }

    }

    public void Send_Mail(string xReceipent, string xSubject, string xMessage)
    {
        //Application OutlookApplication = new Application();
        //MailItem email = (MailItem)OutlookApplication.CreateItem(OlItemType.olMailItem);
        //email.Recipients.Add(xReceipent);
        //email.Subject = xSubject;

        //email.HTMLBody = xMessage;
        //email.Send();

    }




   

}
