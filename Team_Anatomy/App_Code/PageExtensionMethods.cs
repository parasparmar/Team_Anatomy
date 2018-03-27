using System;
using System.Data;
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
        string[] allowedNTIDs = { "pparm001", "ktriv003" };
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


}


