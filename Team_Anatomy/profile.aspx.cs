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
    string myid;
    Helper my;
    DataTable dtEmp;
    protected void Page_Load(object sender, EventArgs e)
    {
        my = new Helper();
        if (!IsPostBack)
        {
            Literal title = (Literal)PageExtensionMethods.FindControlRecursive(Master, "ltlPageTitle");
            title.Text = "Profile";

            fillOptionLists();
            intialize_me();
        }
    }



    protected void intialize_me()
    {
        //try
        //{
        dtEmp = Session["dtEmp"] as DataTable;
        if (dtEmp != null && dtEmp.Rows.Count > 0)
        {
            //Critical** This line refreshes the data received from the session.
            dtEmp = my.GetData("WFMP.getEmployeeData '" + dtEmp.Rows[0]["ntName"] + "'");
            Session["dtEmp"] = dtEmp;
            DataRow dr = dtEmp.Rows[0];
            lblNTID.Text = dr["ntName"].ToString();
            lblEmployee_ID.Text = dr["Employee_ID"].ToString();
            lblName.Text = dr["First_Name"].ToString() + " " + dr["Middle_Name"].ToString() + " " + dr["Last_Name"].ToString();
            lblDesignation.Text = dr["DesignationID"].ToString();
            lblDepartment.Text = dr["SkillSet"].ToString() + "-" + dr["SubSkillSet"].ToString();
            lblDOJ.Text = Convert.ToDateTime(dr["DOJ"]).ToString("dd-MMM-yyyy");
            lblEmailID.Text = dr["Email_Office"].ToString();
            lblContactNumber.Text = dr["Contact_Number"].ToString();
            if (dr["UserImage"].ToString().Length > 0)
            {
                imgbtnUserImage.ImageUrl = "sitel/user_images/" + dr["UserImage"].ToString();

            }
            lblSupervisor.Text = dr["RepMgrName"].ToString();
            lblEmployee_Role.Text = dr["Job_Type"].ToString();
            lblEmployee_Type.Text = dr["FunctionId"].ToString();
            lblEmployee_Status.Text = dr["EmpStatus"].ToString();
            lblUpdate_Date.Text = dr["Update_Date"].ToString().Length == 0 ? string.Empty : Convert.ToDateTime(dr["Update_Date"].ToString()).ToString("dd-MMM-yyyy HH:mm"); //dr["Update_Date"].ToString();

            lblSite.Text = dr["SiteID"].ToString();
            /////---------------Personal Section 
            if (dr["Gender"] != null && dr["Gender"].ToString().Length > 0) { tbGender.Items.FindByText(dr["Gender"].ToString()).Selected = true; }


            tbDate_of_Birth.Text = dr["Date_of_Birth"].ToString().Length == 0 ? string.Empty : Convert.ToDateTime(dr["Date_of_Birth"].ToString()).ToString("dd-MMM-yyyy");

            if (dr["Qualification"] != null && dr["Qualification"].ToString().Length > 0)
            {
                tbQualification.Items.FindByText(dr["Qualification"].ToString()).Selected = true;
            }


            if (dr["MaritalStatus"] != null && dr["MaritalStatus"].ToString().Length > 0)
            {
                tbMaritalStatus.Items.FindByText(dr["MaritalStatus"].ToString()).Selected = true;
            }

            tbAnniversaryDate.Text = dr["AnniversaryDate"].ToString().Length == 0 ? string.Empty : Convert.ToDateTime(dr["AnniversaryDate"].ToString()).ToString("dd-MMM-yyyy");
            tbContact_Number.Text = dr["Contact_Number"].ToString();
            tbAlternate_Contact.Text = dr["Alternate_Contact"].ToString();

            if (dr["EmergencyContactNo"].ToString() != "0") { tbEmergencyContactNo.Text = dr["EmergencyContactNo"].ToString(); }

            tbEmergencyContactPerson.Text = dr["EmergencyContactPerson"].ToString();
            tbEmail_id.Text = dr["Email_Personal"].ToString();
            /////---------------Transport Section 
            tbTransport_User.Text = dr["Transport"].ToString();
            tbAddress_Line_1.Text = dr["Address1"].ToString();
            tbAddress_Line_2.Text = dr["Address2"].ToString();
            tbAddress_Landmark.Text = dr["Landmark"].ToString();
            tbAddress_City.Text = dr["City"].ToString();

            /////---------------Work Experience
            tbTotal_Work_Experience.Text = dr["Total_Work_Experience"].ToString();

            string strSQL = "SELECT [Id],[Skill] FROM [CWFM_Umang].[WFMP].[tblSkills]";
            DataTable dtSkills = my.GetData(strSQL);

            tbSkill_Set_1.DataSource = dtSkills;
            tbSkill_Set_1.DataValueField = "Id";
            tbSkill_Set_1.DataTextField = "Skill";
            tbSkill_Set_1.DataBind();


            tbSkill_Set_2.DataSource = dtSkills;
            tbSkill_Set_2.DataValueField = "Id";
            tbSkill_Set_2.DataTextField = "Skill";
            tbSkill_Set_2.DataBind();

            tbSkill_Set_3.DataSource = dtSkills;
            tbSkill_Set_3.DataValueField = "Id";
            tbSkill_Set_3.DataTextField = "Skill";
            tbSkill_Set_3.DataBind();

            StringBuilder j = new StringBuilder(dr["Skill1"].ToString());
            string[] tbSkill_Set_1Items = j.ToString().Split(Convert.ToChar(","));

            for (int i = 0; i < tbSkill_Set_1Items.Length; i++)
            {
                ListItem skill = new ListItem(tbSkill_Set_1Items[i]);
                tbSkill_Set_1.Items.Add(skill);
                tbSkill_Set_1.Items.FindByText(skill.Text.ToString()).Selected = true;
            }
            j.Clear();


            j.Append(dr["Skill2"].ToString());

            string[] tbSkill_Set_2Items = j.ToString().Split(Convert.ToChar(","));
            for (int i = 0; i < tbSkill_Set_2Items.Length; i++)
            {
                ListItem skill = new ListItem(tbSkill_Set_2Items[i]);
                tbSkill_Set_2.Items.Add(skill);
                tbSkill_Set_2.Items.FindByText(skill.Text.ToString()).Selected = true;

            }
            j.Clear();


            j.Append(dr["Skill3"].ToString());
            string[] tbSkill_Set_3Items = j.ToString().Split(Convert.ToChar(","));

            for (int i = 0; i < tbSkill_Set_3Items.Length; i++)
            {
                ListItem skill = new ListItem(tbSkill_Set_3Items[i]);
                tbSkill_Set_3.Items.Add(skill);
                tbSkill_Set_3.Items.FindByText(skill.Text.ToString()).Selected = true;
            }

            //{
            //    tbSkill_Set_1.Items.Add(i);
            //    tbSkill_Set_2.Items.Add(i);
            //    tbSkill_Set_3.Items.Add(i);

            //}
        }
        else
        {
            Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "SomeOtherPage.aspx");
        }



        //}
        //catch (Exception Ex)
        //{
        //    Response.Write(Ex.Message);
        //    Response.Redirect(ViewState["PreviousPageUrl"] != null ? ViewState["PreviousPageUrl"].ToString() : "index.aspx", false);
        //}



    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        dtEmp = (DataTable)Session["dtEmp"];
        DataRow dr = dtEmp.Rows[0];

        myid = dr["ntName"].ToString();
        int Employee_ID = Convert.ToInt32(lblEmployee_ID.Text);
        int Gender = Convert.ToInt32(tbGender.SelectedValue.ToString());
        int MaritalStatus = Convert.ToInt32(tbMaritalStatus.SelectedValue.ToString());
        string Address_Country = tbAddress_Country.Text;
        string Address_City = tbAddress_City.Text;
        string Address1 = tbAddress_Line_1.Text;
        string Address2 = tbAddress_Line_2.Text;
        string Landmark = tbAddress_Landmark.Text;
        string Permanent_Address_City = tbPermanent_Address_City.Text;
        string EmergencyContactPerson = tbEmergencyContactPerson.Text;
        string EmergencyContactNo = tbEmergencyContactNo.Text;
        string Email_Personal = tbEmail_id.Text;
        bool Transport = tbTransport_User.SelectedItem.ToString() == "Yes" ? true : false;
        string Country = tbAddress_Country.Text;
        string City = tbAddress_City.Text;
        int Qualification = Convert.ToInt32(tbQualification.SelectedValue.ToString());


        DateTime Date_of_Birth;
        if (!DateTime.TryParse(tbDate_of_Birth.Text.ToString(), out Date_of_Birth)) { tbDate_of_Birth.Text = "Not a Date"; }
        DateTime Anniversary_Date;
        if (!DateTime.TryParse(tbAnniversaryDate.Text.ToString(), out Anniversary_Date)) { tbAnniversaryDate.Text = "Not a Date"; }
        Decimal Contact_Number;
        if (!Decimal.TryParse(tbContact_Number.Text.ToString(), out Contact_Number)) { tbContact_Number.Text = "Not a valid Number"; }
        Decimal Alternate_Contact;
        if (!Decimal.TryParse(tbAlternate_Contact.Text.ToString(), out Alternate_Contact)) { tbAlternate_Contact.Text = "Not a valid Number"; }
        Decimal Total_Work_Experience;
        if (!Decimal.TryParse(tbTotal_Work_Experience.Text.ToString(), out Total_Work_Experience)) { tbTotal_Work_Experience.Text = "Not a valid Number"; }




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

        for (int i = 0; i < tbSkill_Set_2.Items.Count - 1; i++)
        {
            if (tbSkill_Set_2.Items[i].Selected) j.Append("," + tbSkill_Set_2.Items[i].Text);
        }
        string Skill2 = j.ToString().Substring(1);
        j.Clear();

        for (int i = 0; i < tbSkill_Set_3.Items.Count - 1; i++)
        {
            if (tbSkill_Set_3.Items[i].Selected) j.Append("," + tbSkill_Set_3.Items[i].Text);
        }
        string Skill3 = j.ToString().Substring(1);

        string Updated_by = myid;
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


                    cmd.Parameters.AddWithValue("@MaritalStatus", MaritalStatus);
                    cmd.Parameters.AddWithValue("@Qualification", Qualification);
                    cmd.Parameters.AddWithValue("@Transport", Transport);
                    cmd.Parameters.AddWithValue("@Address1", Address1);
                    cmd.Parameters.AddWithValue("@Address2", Address2);
                    cmd.Parameters.AddWithValue("@Landmark", Landmark);
                    cmd.Parameters.AddWithValue("@City", City);

                    cmd.Parameters.AddWithValue("@Skill1", Skill1);
                    cmd.Parameters.AddWithValue("@Skill2", Skill2);
                    cmd.Parameters.AddWithValue("@Skill3", Skill3);

                    cmd.Parameters.AddWithValue("@EmergencyContactPerson", EmergencyContactPerson);
                    cmd.Parameters.AddWithValue("@EmergencyContactNo", EmergencyContactNo);
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

        Page.ClientScript.RegisterStartupScript(this.GetType(), "toastr_message", "toastr.success('Data uploaded successfull.')", true);

    }
    protected void fillOptionLists()
    {
        string strSQL = string.Empty;
        //Fill tbGender
        strSQL = "SELECT [Id],[Gender] FROM [CWFM_Umang].[WFMP].[tblGender]";
        my.append_dropdown(ref tbGender, strSQL, 1, 0);

        //Fill tbQualification
        strSQL = "SELECT [Id], [Qualification] FROM [CWFM_Umang].[WFMP].[tblQualification]";
        tbQualification.Items.Insert(0, new ListItem("Please select your highest (pursued/pursuing) education level"));
        my.append_dropdown(ref tbQualification, strSQL, 1, 0);

        //Fill tbMaritalStatus
        strSQL = "SELECT [Id],[MaritalStatus] FROM [CWFM_Umang].[WFMP].[tblMaritalStatus]";
        my.append_dropdown(ref tbMaritalStatus, strSQL, 1, 0);

    }

}