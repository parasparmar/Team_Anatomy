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
    public void open_db()
    {

        cn = new SqlConnection(getConnectionString());
        try
        {
            if (cn.State == ConnectionState.Closed || cn.State == ConnectionState.Broken)
            {
                cn.Open();
            }
        }
        catch (Exception e)
        {
            Console.WriteLine("{0} Exception Caught", e);
            Log.thisException(e);
        }
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
        open_db();
        DataTable dt = new DataTable();
        using (SqlDataAdapter da = new SqlDataAdapter(new SqlCommand(sql, cn)))
        {
            da.SelectCommand.CommandTimeout = 60;
            DataSet ds = new DataSet();
            da.Fill(ds);
            dt = ds.Tables[0];
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
