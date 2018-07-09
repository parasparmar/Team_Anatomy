using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Summary description for PageExtensionMethods
/// Source: https://docs.microsoft.com/en-us/aspnet/web-forms/overview/older-versions-getting-started/master-pages/control-id-naming-in-content-pages-cs
/// Objective : Illustrates how ContentPlaceHolder controls serve as a naming container 
/// and therefore make programmatically working with a control difficult (via FindConrol). 
/// Looks at this issue and workarounds. 
/// Also discusses how to programmatically access the resulting ClientID value.
/// </summary>
public static class PageExtensionMethods
{
    public static Control FindControlRecursive(this Control ctrl, string controlID)
    {
        if (string.Compare(ctrl.ID, controlID, true) == 0)
        {
            // We found the control!
            return ctrl;
        }
        else
        {
            // Recurse through ctrl's Controls collections
            foreach (Control child in ctrl.Controls)
            {
                Control lookFor = FindControlRecursive(child, controlID);

                if (lookFor != null)
                    return lookFor;  // We found the control
            }

            // If we reach here, control was not found
            return null;
        }
    }
    public static Int32 ToInt32(this object ctrl)
    {
        int returnInt = 0;
        string ConvertMeToInt32 = ctrl.ToString();
        if (Int32.TryParse(ConvertMeToInt32, out returnInt)){
            return returnInt;
        }
        else
        {
            throw new InvalidCastException("The given String " + ConvertMeToInt32 + " cannot be parsed to an Int32 Value.");
        }
    }
    public static DateTime ToDateTime(this object ctrl)
    {
        DateTime returnDateTime;
        string ConvertMeToDateTime = ctrl.ToString();
        if (DateTime.TryParse(ConvertMeToDateTime, out returnDateTime))
        {
            return returnDateTime;
        }
        else
        {
            throw new InvalidCastException("The given String " + ConvertMeToDateTime + " cannot be parsed to a DateTime Value.");
        }
    }
    public static Decimal ToDecimal(this object ctrl)
    {
        Decimal returnDecimal;
        string ConvertMeToDecimal = ctrl.ToString();
        if (Decimal.TryParse(ConvertMeToDecimal, out returnDecimal))
        {
            return returnDecimal;
        }
        else
        {
            throw new InvalidCastException("The given String " + ConvertMeToDecimal + " cannot be parsed to a Decimal Value.");
        }
    }

    public static Boolean ToBool(this object ctrl)
    {
        Boolean returnBoolean;
        string ConvertMeToBoolean = ctrl.ToString();
        if (Boolean.TryParse(ConvertMeToBoolean, out returnBoolean))
        {
            return returnBoolean;
        }
        else
        {
            throw new InvalidCastException("The given String "+ ConvertMeToBoolean + " cannot be parsed to a Boolean Value.");
        }
    }

    public static string DataTableToCSV(this DataTable datatable, char seperator)
    {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < datatable.Columns.Count; i++)
        {
            sb.Append(datatable.Columns[i]);
            if (i < datatable.Columns.Count - 1)
                sb.Append(seperator);
        }
        sb.AppendLine();
        foreach (DataRow dr in datatable.Rows)
        {
            for (int i = 0; i < datatable.Columns.Count; i++)
            {
                sb.Append(dr[i].ToString());

                if (i < datatable.Columns.Count - 1)
                    sb.Append(seperator);
            }
            sb.AppendLine();
        }
        return sb.ToString();
    }

    public static string getMyWindowsID()
    {
        string myid = HttpContext.Current.User.Identity.Name;
        string[] stringSeparators = new string[] { "\\" };
        string[] result = myid.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);
        if (result.Length > 1)
        {
            return result[1];
        }
        else { return "IDNotFound"; }        
    }

    public static int getMyEmployeeID()
    {
        string myid = HttpContext.Current.User.Identity.Name;
        string[] stringSeparators = new string[] { "\\" };
        string[] result = myid.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);
        if (result.Length > 1)
        {
            string ntName = result[1];
            Helper my = new Helper();
            int empcode = my.getSingleton("select Employee_Id as EmpCode from WFMP.tblMaster where ntname = '" + result[1] + "'");
            return Convert.ToInt32(empcode);
        }
        else { return 0; }
    }

    public static string[] AllowedIds()
    {
        string[] allowedNTIDs = { "pparm001", "ktriv003", "gsing017" };
        return allowedNTIDs;
    }

    /// <summary>
    /// Gets the ordinal index of a TableCell in a rendered GridViewRow, using a text fieldHandle (e.g. the corresponding column's DataFieldName/SortExpression/HeaderText)
    /// </summary>
    public static int GetGVCellUsingFieldName(this GridView grid, string fieldHandle)
    {
        int iCellIndex = -1;

        for (int iColIndex = 0; iColIndex < grid.Columns.Count; iColIndex++)
        {
            if (grid.Columns[iColIndex] is DataControlField)
            {
                DataControlField col = (DataControlField)grid.Columns[iColIndex];
                if ((col is BoundField && string.Compare(((BoundField)col).DataField, fieldHandle, true) == 0)
                    || string.Compare(col.SortExpression, fieldHandle, true) == 0
                    || col.HeaderText.Contains(fieldHandle))
                {
                    iCellIndex = iColIndex;
                    break;
                }
            }
        }
        return iCellIndex;
    }

    /// <summary>
    /// Gets the ordinal index of a TableCell in a rendered GridViewRow, using a text fieldHandle (e.g. the corresponding column's DataFieldName/SortExpression/HeaderText)
    /// </summary>
    public static int GetGVCellUsingFieldName(this GridViewRow row, string fieldHandle)
    {
        return GetGVCellUsingFieldName((GridView)row.Parent.Parent, fieldHandle);
    }
    public static bool AmIAllowedThisPage(int myEmpID, string orginalUrl)
    {

        var oURL = orginalUrl.Split('/');
        orginalUrl = oURL[oURL.Length - 1].ToString();

        bool Allowed = false;
        string strSQL = "PMS.AmIAllowedThisPage";
        SqlCommand cmd = new SqlCommand(strSQL);
        cmd.CommandType = CommandType.StoredProcedure;
        cmd.Parameters.AddWithValue("@EmpCode", myEmpID);
        cmd.Parameters.AddWithValue("@URL", orginalUrl);
        Helper my = new Helper();
        int allowedInt = my.getSingleton(ref cmd);
        if (allowedInt == 1)
        {
            Allowed = true;
        }       
        
        return Allowed;
    }
}


