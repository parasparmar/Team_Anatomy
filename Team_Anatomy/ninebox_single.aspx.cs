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


public partial class ninebox_single : System.Web.UI.Page
{
    DataTable dtEmp;
    Helper my;
    private string strSQL { get; set; }
    private int MyEmpID { get; set; }

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
                MyEmpID = 798904;
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
                     
        }
    }
    private void FillTeamList9box(int RepMgrCode)
    {
        if (RepMgrCode > 0)
        {
            SqlCommand cmd = new SqlCommand("select Distinct Department, DepOrder from WFMP.tblDsgn2DeptGroup4NineBox_ByDesignation where Active = 1 order by DepOrder Asc");                        
            DataTable dt = my.GetData(ref cmd);
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
    
    private void clearAllBoxes()
    {
        lvMGR.Items.Clear();         
    }

    [WebMethod]
    public static List<NineBubbleChart> GetBubbleChart_ByDesignation(string Dept, string Period)
    {
        Helper my = new Helper();
        string query = "FillChart9box_byDesignation";
        SqlCommand cmd = new SqlCommand(query);        
        cmd.Parameters.AddWithValue("@Period", Period);
        cmd.Parameters.AddWithValue("@Dept", Dept);
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
                      SPI = dr["SPI"].ToString(),
                      DesignationGroup = dr["DesignationGroup"].ToString(),
                      Department = dr["Department"].ToString(),
                  }).ToList();

        return myJSON;
    }

   
    public class NineBubbleChart
    {
        public string EmpCode { get; set; }
        public string Name { get; set; }
        public int RepMgrCode { get; set; }
        public string ReportingManager { get; set; }
        public string Period { get; set; }
        public string Designation { get; set; }
        public string Performance { get; set; }
        public string Competency { get; set; }
        public string Radius { get; set; }
        public string SPI { get; set; }
        public string DesignationGroup { get; set; }
        public string Department { get; set; }

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