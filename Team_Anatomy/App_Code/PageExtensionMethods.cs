using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;


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
        string myID = System.Security.Principal.WindowsIdentity.GetCurrent().Name;
        string[] stringSeparators = new string[] { "\\" };
        string[] result = myID.Split(stringSeparators, StringSplitOptions.RemoveEmptyEntries);
        return result[1];
    }

    
}