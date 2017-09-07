using System;
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
    public System.Data.SqlClient.SqlConnection mcon;

    public string getConnectionString()
    {
        EDCryptor xEDCryptor = new EDCryptor();
        string xString = ConfigurationManager.ConnectionStrings["constr"].ToString();
        xString = xEDCryptor.DeCrypt(xString);
        return xString;
    }

    // ------------------------- Open Database Connection -------------------------
    public void open_db()
    {
        mcon = new SqlConnection(getConnectionString());
        try
        {
            mcon.Open();
        }
        catch (Exception e)
        {
            Console.WriteLine("{0} Exception Caught", e);
            Log.thisException(e);
        }
    }

    // ------------------------- Close  Database Connection -------------------------
    public void close_conn()
    {
        if (mcon.State == ConnectionState.Open)
        {
            mcon.Close();
            mcon.Dispose();
        }
    }


    // ------------------------- Procedure for Execute Sql Query/Stored Procedure -------------------------
    public int ExecuteDMLCommand(ref SqlCommand cmd, string sql_string, string operation)
    {
        open_db();
        int returnValue = 0;
        try
        {
            //cmd = new SqlCommand(sql_string, mcon);
            cmd.Connection = mcon;
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
            //close_conn();

        }
        return returnValue;
    }


    // ------------------------- Function for return datatable -------------------------
    public DataTable GetData(string sql)
    {
        using (SqlConnection mcon = new SqlConnection(getConnectionString()))
        {
            DataTable worktable = new DataTable();
            SqlDataAdapter dap = new System.Data.SqlClient.SqlDataAdapter(new System.Data.SqlClient.SqlCommand(sql, mcon));
            DataSet ds = new DataSet();
            dap.Fill(ds);
            worktable = ds.Tables[0];
            //close_conn();
            return worktable;
        }

    }

    // ------------------------- Function for return datatable -------------------------
    public DataSet return_dataset(string sql)
    {
        open_db();
        DataTable worktable = new DataTable();
        SqlDataAdapter dap = new System.Data.SqlClient.SqlDataAdapter(new System.Data.SqlClient.SqlCommand(sql, mcon));
        DataSet ds = new DataSet();
        dap.Fill(ds);
        //close_conn();
        return ds;
    }

    // ------------------------- Procedure For fill ListBox with default item -------------------------
    public void fill_listbox(ref ListBox list_name, string sp_name, string datatextfeild, string datavaluefeild, string defaultitem, string parameters)
    {
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter dap = new SqlDataAdapter();
        DataSet ds = new DataSet();

        try
        {
            ExecuteDMLCommand(ref cmd, sp_name, "S");
            //----------------------- Addning Muiltipal Parameters with there values by split using '#'.
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
            list_name.DataTextField = datatextfeild;
            list_name.DataValueField = datavaluefeild;
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
            dap.Dispose();
            ds.Dispose();
            close_conn();
        }
        
    }


    // ------------------------- Procedure For fill dropdownlist with default item -------------------------
    public void fill_dropdown(ref DropDownList drp_name, string sp_name, string datatextfeild, string datavaluefeild, string defaultitem, string parameters, string tran_type)
    {
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter dap = new SqlDataAdapter();
        DataSet ds = new DataSet();
        try
        {
            ExecuteDMLCommand(ref cmd, sp_name, tran_type);
            //----------------------- Addning Muiltipal Parameters with there values by split using '#' only if it is stored procedure.
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

            dap.SelectCommand = cmd;
            dap.Fill(ds);

            if (defaultitem != "")
            {
                DataRow dr = ds.Tables[0].NewRow();
                dr[0] = 0;
                dr[1] = defaultitem;
                ds.Tables[0].Rows.Add(dr);
            }
            drp_name.DataSource = ds.Tables[0];
            drp_name.DataTextField = datatextfeild;
            drp_name.DataValueField = datavaluefeild;
            drp_name.DataBind();


            //--------------------------------------------
            if (defaultitem != "")
            {
                drp_name.SelectedValue = "0";
            }
        }
        catch (Exception e)
        {
            Log.thisException(e);
        }
        finally
        {
            dap.Dispose();
            ds.Dispose();
            close_conn();
        }

    }


    // ------------------------- Procedure For fill Gridview with Blank row -------------------------
    public void fill_gridview(ref GridView gridname, string sql_string)
    {
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


    // ------------------------- Display Page heading Name -------------------------
    public void set_pageheading(string heading, Page pagename)
    {
        Label lblheading = (Label)pagename.Master.FindControl("lblheading");
        if (lblheading != null)
        {
            lblheading.Visible = true;
            lblheading.Text = heading;
        }
    }



}
