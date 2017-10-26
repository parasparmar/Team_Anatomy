using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;
using System.Text;
using System.Web.Services;
using System.Configuration;


public partial class profile : System.Web.UI.Page
{
    string myID;
    Helper my = new Helper();
    DataTable dtEmp;
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!Page.IsPostBack)
        {
            intialize_me();
        }
    }

    protected bool my_permissions()
    {
        return true;
    }

    protected void intialize_me()
    {
        try
        {
            dtEmp = Session["dtEmp"] as DataTable;
            //Critical** This line refreshes the data received from the session.
            dtEmp = my.GetData("WFMP.getEmployeeData '" + dtEmp.Rows[0]["ntName"] + "'");

            if (dtEmp.Rows.Count > 0)
            {
                DataRow dr = dtEmp.Rows[0];
                lblNTID.Text = dr["ntName"].ToString();
                lblEmployee_ID.Text = dr["Employee_ID"].ToString();
                lblName.Text = dr["First_Name"].ToString() + " " + dr["Middle_Name"].ToString() + " " + dr["Last_Name"].ToString();
                lblDesignation.Text = dr["DesignationID"].ToString();
                lblDepartment.Text = dr["SkillSet"].ToString() + "-" + dr["SubSkillSet"].ToString();
                lblDOJ.Text = Convert.ToDateTime(dr["DOJ"]).ToString("dd-MMMM-yyyy");
                lblEmailID.Text = dr["Email_Office"].ToString();
                lblContactNumber.Text = dr["Contact_Number"].ToString();
                if (dr["UserImage"].ToString().Length > 0)
                {
                    imgbtnUserImage.ImageUrl = "sitel/user_images/" + dr["UserImage"].ToString();

                }
                lblSupervisor.Text = dr["RepMgrCode"].ToString();
                lblEmployee_Role.Text = dr["Job_Type"].ToString();
                lblEmployee_Type.Text = dr["FunctionId"].ToString();
                lblEmployee_Status.Text = dr["EmpStatus"].ToString();
                lblUpdate_Date.Text = dr["Update_Date"].ToString().Length == 0 ? string.Empty : Convert.ToDateTime(dr["Update_Date"].ToString()).ToString("dd-MMMM-yyyy HH:mm"); //dr["Update_Date"].ToString();
                lblUpdated_by.Text = dr["Updated_by"].ToString();
                lblSite.Text = dr["SiteID"].ToString();
                /////---------------Personal Section 
                tbGender.SelectedValue = dr["Gender"].ToString();
                tbDate_of_Birth.Text = dr["Date_of_Birth"].ToString().Length == 0 ? string.Empty : Convert.ToDateTime(dr["Date_of_Birth"].ToString()).ToString("dd-MMMM-yyyy");
                tbHighest_Qualification.Text = dr["HighestQualification"].ToString();
                //tbMarital_Status.Text = dr["Marital_Status"].ToString();
                tbAnniversaryDate.Text = dr["AnniversaryDate"].ToString().Length == 0 ? string.Empty : Convert.ToDateTime(dr["AnniversaryDate"].ToString()).ToString("dd-MMM-yyyy");
                tbContact_Number.Text = dr["Contact_Number"].ToString();
                tbAlternate_Contact.Text = dr["Alternate_Contact"].ToString();
                tbEmergencyContactPerson.Text = dr["EmergencyContactPerson"].ToString();
                tbEmail_id.Text = dr["Email_Personal"].ToString();
                /////---------------Transport Section 
                tbTransport_User.Text = dr["Transport"].ToString();
                tbAddress_Line_1.Text = dr["Address1"].ToString();
                tbAddress_Line_2.Text = dr["Address2"].ToString();
                tbAddress_Landmark.Text = dr["Landmark"].ToString();
                tbAddress_City.Text = dr["City"].ToString();
                //tbAddress_Country.Text = dr["Address_Country"].ToString();
                // tbPermanent_Address_City.Text = dr["Permanent_Address_City"].ToString();
                /////---------------Work Experience
                tbTotal_Work_Experience.Text = dr["Total_Work_Experience"].ToString();

                StringBuilder j = new StringBuilder(dr["Skill1"].ToString());
                string[] tbSkill_Set_1Items = j.ToString().Split(Convert.ToChar(","));

                for (int i = 0; i < tbSkill_Set_1Items.Length; i++)
                {
                    tbSkill_Set_1.Items.Add(new ListItem(tbSkill_Set_1Items[i]));
                    tbSkill_Set_1.Items[i].Selected = true;
                }
                j.Clear();


                j.Append(dr["Skill2"].ToString());

                string[] tbSkill_Set_2Items = j.ToString().Split(Convert.ToChar(","));
                for (int i = 0; i < tbSkill_Set_2Items.Length; i++)
                {
                    tbSkill_Set_2.Items.Add(new ListItem(tbSkill_Set_2Items[i]));
                    tbSkill_Set_2.Items[i].Selected = true;
                }
                j.Clear();


                j.Append(dr["Skill3"].ToString());
                string[] tbSkill_Set_3Items = j.ToString().Split(Convert.ToChar(","));

                for (int i = 0; i < tbSkill_Set_3Items.Length; i++)
                {
                    tbSkill_Set_3.Items.Add(new ListItem(tbSkill_Set_3Items[i]));
                    tbSkill_Set_3.Items[i].Selected = true;
                }

                string[] arrSkills = { "Access", "Accounting", "Administration", "Analysis", "Analytics", "ASP", "Aspect", "Automation", "Avaya CMS", "Back Office", "Basic German Language", "Blue Pumkin", "BO", "BP", "BTP", "Budget", "Business Analytics", "C", "C++", "Call Centre", "Capacity Planning", "Capman", "Client management", "CMS", "Communication", "Computer", "Cooking", "Coordination", "CRA", "Customer Service", "Development", "Dialler", "DotNet", "End to End Forecast", "Excel", "EXCEL Advanced", "EXCEL Basic", "EXCEL VBA", "External Clients Management", "Extra Innovation Activities for User Friendly Data Efficiency", "Finance", "Finance(Essbase)", "Financial", "Financial Reporting", "Forecast", "Forecasting", "Forecasting & Planning", "Formation", "GCC", "GCC & Analytics", "Genesys Platform", "German Language", "Hands On Expertise In Analytics", "Hardware", "IEX", "Internal and external clients management", "Invoices", "JAVASCRIPT", "JQUERY", "Kronos", "Language", "Languages", "Layout", "Leadership", "LINUX", "Logical Reasoning", "Macros & Formula", "Management", "Manpower Planning", "MCSC", "MIS", "MIS - Analyst", "MIS - Operations", "MIS - Reporting", "MIS & Reporting", "MIS Excel", "MIS Reporting", "MS Access", "MS Excel", "MS Office", "MS SQL", "MSCS", "NA", "networking", "Office", "Operations", "Ops Team Lead", "Oracle", "People Management", "Planning", "Programming Languages", "Project Management", "Projects Management", "Real Time", "Real Time Management", "Real time Reports", "Recording Macro", "Reporting", "Reports", "Resource Planning", "Rostering", "RTA", "RTA Analyst", "RTA)", "Sales", "SAP Knowlegde for Analysys", "Scheduling", "Scheduling & Rostering", "Scheduling in Excel", "Scheduling WFM Support", "Seat Utilization", "Sizing", "Skill Development", "Spanish", "Spanish Language Expert", "SQL", "Staffing", "Stakeholder Management", "Strategy", "Team Management", "Technical Support", "VB", "VBA", "VBA Automation", "Visual Basic", "WFC", "WFM", "Writing" };
                foreach (string i in arrSkills)
                {
                    tbSkill_Set_1.Items.Add(i);
                    tbSkill_Set_2.Items.Add(i);
                    tbSkill_Set_3.Items.Add(i);

                }
            }
            else
            {
                //Response.Write(Session["dtEmp"].ToString() + "----------------" + Ex.Message);
                //Response.Redirect("index.aspx");
            }



        }
        catch (Exception Ex)
        {
            //Response.Write(Session["dtEmp"].ToString() + "----------------" + Ex.Message);
            Response.Redirect("index.aspx");
        }



    }
    protected void btnPersonalSubmit_Click(object sender, EventArgs e)
    {
        dtEmp = (DataTable)Session["dtEmp"];
        DataRow dr = dtEmp.Rows[0];

        myID = dr["ntName"].ToString();
        int Employee_ID = Convert.ToInt32(lblEmployee_ID.Text);
        string Gender = tbGender.SelectedItem.ToString();
        string Marital_Status = tbMarital_Status.SelectedItem.ToString();
        string Address_Country = tbAddress_Country.Text;
        string Address_City = tbAddress_City.Text;
        string Address1 = tbAddress_Line_1.Text;
        string Address2 = tbAddress_Line_2.Text;
        string Landmark = tbAddress_Landmark.Text;
        string Permanent_Address_City = tbPermanent_Address_City.Text;
        string EmergencyContactPerson = tbEmergencyContactPerson.Text;
        string Email_Personal = tbEmail_id.Text;
        bool Transport = tbTransport_User.SelectedItem.ToString() == "Yes" ? true : false;
        string Country = tbAddress_Country.Text;
        string City = tbAddress_City.Text;
        string HighestQualification = tbHighest_Qualification.Text;

        DateTime Date_of_Birth;
        DateTime Anniversary_Date;
        Decimal Contact_Number;
        Decimal Alternate_Contact;
        Decimal Total_Work_Experience;




        StringBuilder j = new StringBuilder();
        string first = string.Empty;
        j.Append(first);

        // GET SELECTED ITEMS
        for (int i = 0; i < tbSkill_Set_1.Items.Count - 1; i++)
        {
            if (tbSkill_Set_1.Items[i].Selected) j.Append("," + tbSkill_Set_1.Items[i].Text);
        }
        string Skill1 = j.ToString().Substring(1);

        j.Clear();
        for (int i = 0; i < tbSkill_Set_1.Items.Count - 1; i++)
        {
            if (tbSkill_Set_2.Items[i].Selected) j.Append("," + tbSkill_Set_2.Items[i].Text);
        }
        string Skill2 = j.ToString().Substring(1);

        j.Clear();
        for (int i = 0; i < tbSkill_Set_1.Items.Count - 1; i++)
        {
            if (tbSkill_Set_3.Items[i].Selected) j.Append("," + tbSkill_Set_3.Items[i].Text);
        }
        string Skill3 = j.ToString().Substring(1);

        string Updated_by = myID;
        DateTime Update_Date = DateTime.Now;
        string the_Procedure = "WFMP.updateEmployeeProfileData";

        try
        {
            using (SqlConnection cn = new SqlConnection(my.getConnectionString()))
            {
                cn.Open();
                using (SqlCommand cmd = new SqlCommand(the_Procedure, cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@Gender", Gender);
                    cmd.Parameters.AddWithValue("@Email_Personal", Email_Personal);


                    cmd.Parameters.AddWithValue("@HighestQualification", HighestQualification);
                    cmd.Parameters.AddWithValue("@Transport", Transport);
                    cmd.Parameters.AddWithValue("@Address1", Address1);
                    cmd.Parameters.AddWithValue("@Address2", Address2);
                    cmd.Parameters.AddWithValue("@Landmark", Landmark);
                    cmd.Parameters.AddWithValue("@City", City);

                    cmd.Parameters.AddWithValue("@Skill1", Skill1);
                    cmd.Parameters.AddWithValue("@Skill2", Skill2);
                    cmd.Parameters.AddWithValue("@Skill3", Skill3);

                    cmd.Parameters.AddWithValue("@EmergencyContactPerson", EmergencyContactPerson);
                    cmd.Parameters.AddWithValue("@Updated_by", Updated_by);
                    cmd.Parameters.AddWithValue("@Update_Date", Update_Date);
                    cmd.Parameters.AddWithValue("@Employee_ID", Employee_ID);


                    if (DateTime.TryParse(tbDate_of_Birth.Text, out Date_of_Birth))
                    {
                        cmd.Parameters.AddWithValue("@Date_of_Birth", Date_of_Birth);
                    }

                    if (DateTime.TryParse(tbAnniversaryDate.Text, out Anniversary_Date))
                    {
                        cmd.Parameters.AddWithValue("@AnniversaryDate", Anniversary_Date);
                    }
                    if (Decimal.TryParse(tbContact_Number.Text, out Contact_Number))
                    {
                        cmd.Parameters.AddWithValue("@Contact_Number", Contact_Number);
                    }
                    if (Decimal.TryParse(tbAlternate_Contact.Text, out Alternate_Contact))
                    {
                        cmd.Parameters.AddWithValue("@Alternate_Contact", Alternate_Contact);
                    }
                    if (Decimal.TryParse(tbTotal_Work_Experience.Text, out Total_Work_Experience))
                    {
                        cmd.Parameters.AddWithValue("@Total_Work_Experience", Total_Work_Experience);
                    }
                    //Procedure or function 'updateEmployeeProfileData' expects parameter '@Employee_ID', which was not supplied.            
                    int rowsAffected = cmd.ExecuteNonQuery();

                    this.intialize_me();
                }
            }
        }
        catch (Exception Ex)
        {
            Response.Write(Ex.Message);
        }

    }




}