using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class ninebox : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }
    string myID;
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        try
        {
            dtEmp = (DataTable)Session["dtEmp"];
            if (dtEmp.Rows.Count <= 0)
            {
                Response.Redirect("index.aspx", false);
            }
            else
            {
                // In Production Use the below
                MyEmpID = dtEmp.Rows[0]["Employee_Id"].ToString().ToInt32();
            }
        }
        catch (Exception Ex)
        {
            Console.WriteLine(Ex.Message.ToString());
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        }
        Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
        title.Text = "Nine Box";

        if (!IsPostBack)
        {
            FillTeamList9box();
            FillSkillset9Box();
        }
    }
    private void FillTeamList9box()
    {
        int RepMgrCode = MyEmpID;
        SqlCommand cmd = new SqlCommand("FillTeamList9box");
        cmd.Parameters.AddWithValue("@RepMgrCode", RepMgrCode);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        lvMGR.DataSource = dt;
        lvMGR.DataBind();
    }
    private void FillSkillset9Box()
    {
        DataTable dt = my.GetData("select SkillsetID, Skillset from WFMP.tblSkillSet where SkillsetID < 5");
        lvSkill.DataSource = dt;
        lvSkill.DataBind();
    }
    [WebMethod]
    public static List<NineBubbleChart> GetBubbleChart(string EMPCODE)
    {
        Helper my = new Helper();
        string query = "FillChart9box";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@EMPCODE", EMPCODE);
        cmd.Parameters.AddWithValue("@Period", "H1 2018");
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<NineBubbleChart> objList = new List<NineBubbleChart>();
        objList = (from DataRow dr in dt.Rows
                   select new NineBubbleChart()
                   {
                       EmpCode = dr["EMPCODE"].ToString(),
                       Name = dr["NAME"].ToString(),
                       Performance = dr["PERFORMANCE"].ToString(),
                       Competency = dr["COMPETENCY"].ToString(),
                       Radius = dr["RADIUS"].ToString()

                   }).ToList();

        return objList;
    }

    [WebMethod]
    public static List<NineBubbleChart> GetSkillChart(string EMPCODE, string Skill)
    {
        Helper my = new Helper();
        string query = "skillbox9";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@EMPCODE", EMPCODE);
        cmd.Parameters.AddWithValue("@Skill", Skill);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<NineBubbleChart> objList = new List<NineBubbleChart>();
        objList = (from DataRow dr in dt.Rows
                   select new NineBubbleChart()
                   {
                       EmpCode = dr["EMPCODE"].ToString(),
                       Name = dr["NAME"].ToString(),
                       Designation = dr["DESIGNATION"].ToString(),
                       Performance = dr["PERFORMANCE"].ToString(),
                       Competency = dr["COMPETENCY"].ToString(),
                       Radius = dr["RADIUS"].ToString()

                   }).ToList();

        return objList;
    }

    public class NineBubbleChart
    {
        public string EmpCode { get; set; }
        public string Name { get; set; }
        public string Designation { get; set; }
        public string Performance { get; set; }
        public string Competency { get; set; }
        public string Radius { get; set; }
    }
    public class TypeList
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }
    public class DesignationList
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }
    public class LoginList
    {
        public string Value { get; set; }
        public string Text { get; set; }
    }
    protected void ddlMgr_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}