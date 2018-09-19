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

    private int[] AuthorizedIDs = new int[6] { 755882, 931040, 923563, 918031, 1092308, 798904 };
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
            FillddlPeriod();
            ddlPeriod.SelectedIndex = 1;
            FillTeamList9box(MyEmpID);
            if (AuthorizedIDs.Contains<int>(MyEmpID))
            {
                FillddlMgr(MyEmpID);
                FillSkillset9Box();
            }
        }
    }
    private void FillTeamList9box(int RepMgrCode)
    {
        if (RepMgrCode > 0)
        {
            SqlCommand cmd = new SqlCommand("FillTeamList9box");
            cmd.Parameters.AddWithValue("@EmpCode", RepMgrCode);
            cmd.Parameters.AddWithValue("@Period", ddlPeriod.SelectedValue);
            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            lvMGR.DataSource = dt;
            lvMGR.DataBind();
        }
        else
        {
            clearAllBoxes();
        }

    }
    private void FillddlPeriod()
    {
        SqlCommand cmd = new SqlCommand("NINEBOXfillDdlPeriod");
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        ddlPeriod.DataSource = dt;
        ddlPeriod.DataValueField = "Period";
        ddlPeriod.DataTextField = "Period";
        ddlPeriod.DataBind();
        ddlPeriod.Items.Insert(0, new ListItem("0", "Please Select"));
    }
    private void FillddlMgr(int RepMgrCode)
    {
        if (RepMgrCode > 0)
        {
            SqlCommand cmd = new SqlCommand("FillTeamList9box");
            cmd.Parameters.AddWithValue("@EmpCode", RepMgrCode);
            cmd.Parameters.AddWithValue("@Period", ddlPeriod.SelectedValue);
            DataTable dt = my.GetDataTableViaProcedure(ref cmd);
            ddlMgr.DataSource = dt;
            ddlMgr.DataValueField = "EmpCode";
            ddlMgr.DataTextField = "Name";
            ddlMgr.DataBind();
        }
        else
        {
            clearAllBoxes();
        }
    }
    private void FillSkillset9Box()
    {
        DataTable dt = my.GetData("select SkillsetID, Skillset from WFMP.tblSkillSet where SkillsetID < 5");
        lvSkill.DataSource = dt;
        lvSkill.DataBind();
    }
    private void clearAllBoxes()
    {
        lvMGR.Items.Clear();
        ddlMgr.Items.Clear();
        lvSkill.Items.Clear();
    }
    [WebMethod]
    public static List<NineBubbleChart> GetBubbleChart(string EMPCODE, string Period)
    {
        Helper my = new Helper();
        string query = "FillChart9box";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@EMPCODE", EMPCODE);
        cmd.Parameters.AddWithValue("@Period", Period);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<NineBubbleChart> myJSON = new List<NineBubbleChart>();
        myJSON = (from DataRow dr in dt.Rows
                  select new NineBubbleChart()
                  {
                      EmpCode = dr["EMPCODE"].ToString(),
                      Name = dr["NAME"].ToString(),
                      ReportingManager = dr["repmgr"].ToString(),
                      Period = dr["Period"].ToString(),
                      Performance = dr["PERFORMANCE"].ToString(),
                      Competency = dr["COMPETENCY"].ToString(),
                      Radius = dr["RADIUS"].ToString(),
                      SPI = dr["SPI"].ToString()
                  }).ToList();

        return myJSON;
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
        List<NineBubbleChart> myJSON = new List<NineBubbleChart>();
        myJSON = (from DataRow dr in dt.Rows
                  select new NineBubbleChart()
                  {
                      EmpCode = dr["EMPCODE"].ToString(),
                      Name = dr["NAME"].ToString(),
                      Designation = dr["DESIGNATION"].ToString(),
                      Period = dr["Period"].ToString(),
                      Performance = dr["PERFORMANCE"].ToString(),
                      Competency = dr["COMPETENCY"].ToString(),
                      Radius = dr["RADIUS"].ToString(),
                      SPI = dr["SPI"].ToString()
                  }).ToList();

        return myJSON;
    }
    public class NineBubbleChart
    {
        public string EmpCode { get; set; }
        public string Name { get; set; }
        public string ReportingManager { get; set; }
        public string Period { get; set; }
        public string Designation { get; set; }
        public string Performance { get; set; }
        public string Competency { get; set; }
        public string Radius { get; set; }
        public string SPI { get; set; }
    }
    protected void ddlMgr_SelectedIndexChanged(object sender, EventArgs e)
    {
        int RepMgr = ddlMgr.SelectedValue.ToInt32();
        clearAllBoxes();
        FillTeamList9box(RepMgr);
        FillSkillset9Box();
    }
    [WebMethod]
    public static List<NineBoxEmpStats> getEmpStatsFromDB(string empcode, string period)
    {
        Helper my = new Helper();
        string query = "NINEBOXgetEmpStats";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@EmpCode", empcode);
        cmd.Parameters.AddWithValue("@Period", period);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<NineBoxEmpStats> myJSON = new List<NineBoxEmpStats>();
        myJSON = (from DataRow dr in dt.Rows
                  select new NineBoxEmpStats()
                  {
                      EmpCode = dr["EmpCode"].ToString(),
                      Name = dr["Name"].ToString(),
                      RepMgrCode = dr["RepMgrCode"].ToString(),
                      RepMgr = dr["RepMgr"].ToString(),
                      Period = dr["Period"].ToString(),
                      SPI = dr["SPI"].ToString(),
                      PacManRating = dr["PacManRating"].ToString(),
                      TestScore = dr["TestScore"].ToString(),
                      CompetencyRating = dr["CompetencyRating"].ToString(),
                      Analytics = dr["Analytics"].ToString(),
                      Aptitude = dr["Aptitude"].ToString(),
                      Planning = dr["Planning"].ToString(),
                      RTA = dr["RTA"].ToString(),
                      Scheduling = dr["Scheduling"].ToString(),
                      WFC = dr["WFC"].ToString(),
                      Total = dr["Total"].ToString(),
                      UserImage = dr["UserImage"].ToString(),
                  }).ToList();
        return myJSON;
    }
    [WebMethod]
    public static List<NineBoxCompetency> getEmpCompetencyFromDB(string empcode, string period)
    {
        Helper my = new Helper();
        string query = "NINEBOXgetCompetency";
        SqlCommand cmd = new SqlCommand(query);
        cmd.Parameters.AddWithValue("@EmpCode", empcode);
        cmd.Parameters.AddWithValue("@Period", period);
        cmd.Parameters.AddWithValue("@Type", 1);
        DataTable dt = my.GetDataTableViaProcedure(ref cmd);
        List<NineBoxCompetency> myJSON = new List<NineBoxCompetency>();
        myJSON = (from DataRow dr in dt.Rows
                  select new NineBoxCompetency()
                  {
                      COMPETENCY = dr["COMPETENCY"].ToString(),
                      DESCRIPTION = dr["DESCRIPTION"].ToString(),
                      COMMENTS = dr["COMMENTS"].ToString(),
                      RATING = dr["RATING"].ToString(),
                      RATINGSCALE = dr["RATING_SCALE"].ToString()
                  }).ToList();
        return myJSON;
    }
    public class NineBoxEmpStats
    {
        public string EmpCode { get; set; }
        public string Name { get; set; }
        public string RepMgrCode { get; set; }
        public string RepMgr { get; set; }
        public string Period { get; set; }
        public string SPI { get; set; }
        public string PacManRating { get; set; }
        public string TestScore { get; set; }
        public string CompetencyRating { get; set; }
        public string UserImage { get; set; }
        public string Analytics { get; set; }
        public string Aptitude { get; set; }
        public string Planning { get; set; }
        public string RTA { get; set; }
        public string Scheduling { get; set; }
        public string WFC { get; set; }

        public string Total { get; set; }
    }
    public class NineBoxCompetency
    {
        public string COMPETENCY { get; set; }
        public string DESCRIPTION { get; set; }
        public string COMMENTS { get; set; }
        public string RATING { get; set; }
        public string RATINGSCALE { get; set; }

    }
}