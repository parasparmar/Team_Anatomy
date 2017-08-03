<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <!-- Select2 -->
    <link rel="stylesheet" href="/AdminLTE/bower_components/select2/dist/css/select2.min.css">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="headmenu" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="leftmenu" runat="Server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <h1>Profile Information
    <small>View/ Edit and Save profile Information</small>
    </h1>
    <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i>Home</a></li>
        <li class="active"><a href="#">Profile Information</a></li>
    </ol>
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row">
        <div class="col-md-3">
            <!-- Profile Image -->
            <div class="box box-primary">
                <div class="box-body box-profile">
                    <asp:Image ID="imgbtnProfilePhoto" CssClass="profile-user-img img-responsive img-circle" runat="server" />
                    <h3 class="profile-username text-center">
                        <asp:Label ID="lblName" runat="server"></asp:Label>
                    </h3>
                    <p class="text-muted text-center">
                        Employee :
                    <b><a class="pull-none">
                        <asp:Label ID="lblEmployee_ID" runat="server"></asp:Label></a></b>
                    </p>
                    <p class="text-muted text-center">
                        Windows ID :
                    <b><a class="pull-none">
                        <asp:Label ID="lblNTID" runat="server"></asp:Label></a></b>
                    </p>
                    <ul class="list-group list-group-unbordered">
                        <li class="list-group-item">
                            <b>Designation</b><a class="pull-right"><asp:Label ID="lblDesignation" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Department</b><a class="pull-right"><asp:Label ID="lblDepartment" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Date of Joining</b><a class="pull-right"><asp:Label ID="lblDOJ" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Email id</b> <a class="pull-right">
                                <asp:Label ID="lblEmailID" runat="server"></asp:Label></a>
                        </li>
                        <li class="list-group-item">
                            <b>Contact Number</b> <a class="pull-right">
                                <asp:Label ID="lblContactNumber" runat="server"></asp:Label></a>
                        </li>
                    </ul>

                    <a href="#" class="btn btn-primary btn-block"><b>Edit Information</b></a>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
            <!-- Employee Information Box -->
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Employee Information</h3>
                </div>
                <!-- /.box-header -->
                <div class="box-body">
                    <strong><i class="fa fa-book margin-r-5"></i>Reporting Manager</strong>
                    <p class="text-muted">
                        <asp:Label ID="lblSupervisor" runat="server"></asp:Label>
                        <a class="pull-right"></a>
                    </p>

                    <hr>
                    <strong><i class="fa fa-book margin-r-5"></i>Employee Role</strong>
                    <p class="text-muted">
                        <asp:Label ID="lblEmployee_Role" runat="server"></asp:Label>
                    </p>
                    <hr>
                    <strong><i class="fa fa-book margin-r-5"></i>Employee_Type</strong>
                    <p class="text-muted">
                        <asp:Label ID="lblEmployee_Type" runat="server"></asp:Label>
                    </p>
                    <hr>
                    <strong><i class="fa fa-map-marker margin-r-5"></i>Employee_Status</strong>
                    <p class="text-muted">
                        <asp:Label ID="lblEmployee_Status" runat="server"></asp:Label>
                    </p>
                    <hr>
                    <strong><i class="fa fa-map-marker margin-r-5"></i>Updated by</strong>
                    <p class="text-muted">
                        <asp:Label ID="lblUpdated_by" runat="server"></asp:Label>
                    </p>
                    <hr>
                    <strong><i class="fa fa-map-marker margin-r-5"></i>Update_Date</strong>
                    <p class="text-muted">
                        <asp:Label ID="lblUpdate_Date" runat="server"></asp:Label>
                    </p>
                    <hr>
                    <strong><i class="fa fa-map-marker margin-r-5"></i>Site</strong>
                    <p class="text-muted">
                        <asp:Label ID="lblSite" runat="server"></asp:Label>
                    </p>
                    <hr>
                    <strong><i class="fa fa-pencil margin-r-5"></i>Skills</strong>
                    <p>
                        <span class="label label-danger">UI Design</span>
                        <span class="label label-success">Coding</span>
                        <span class="label label-info">Javascript</span>
                        <span class="label label-warning">PHP</span>
                        <span class="label label-primary">Node.js</span>
                    </p>
                    <hr>
                    <strong><i class="fa fa-file-text-o margin-r-5"></i>Notes</strong>
                    <p></p>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
        </div>
        <div class="col-md-9">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#personal" data-toggle="tab">Personal</a></li>
                    <li><a href="#transport" data-toggle="tab">Transport</a></li>
                    <li><a href="#work_experience" data-toggle="tab">Work Experience</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="personal">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbGender" class="col-sm-2 control-label">Gender</label>
                                <div class="col-sm-10">
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="tbGender" runat="server">
                                        <asp:ListItem Text="Male"></asp:ListItem>
                                        <asp:ListItem Text="Female"></asp:ListItem>
                                        <asp:ListItem Text="Not Specified" Value=""></asp:ListItem>
                                    </asp:DropDownList>

                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbDate_of_Birth" class="col-sm-2 control-label">Date of Birth</label>
                                <div class="col-sm-10">
                                    <asp:TextBox ID="tbDate_of_Birth" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbHighest_Qualification" class="col-sm-2 control-label">Highest Qualification</label>
                                <div class="col-sm-10">
                                    <asp:DropDownList ItemType="text" CssClass="form-control  select2" ID="tbHighest_Qualification" runat="server">
                                        <asp:ListItem Value="" Text="select your education level"></asp:ListItem>
                                        <asp:ListItem Value="NONE" Text="Some High School"></asp:ListItem>
                                        <asp:ListItem Value="HS" Text="High School Diploma / GED"></asp:ListItem>
                                        <asp:ListItem Value="SOME_COLLEGE" Text="Some College"></asp:ListItem>
                                        <asp:ListItem Value="ASSOCIATE" Text="Associate's Degree"></asp:ListItem>
                                        <asp:ListItem Value="BACHELOR" Text="Bachelor's Degree"></asp:ListItem>
                                        <asp:ListItem Value="MASTER" Text="Master's Degree"></asp:ListItem>
                                        <asp:ListItem Value="DOCTOR" Text="Doctorate Degree"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbMarital_Status" class="col-sm-2 control-label">Marital Status</label>

                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbMarital_Status" placeholder="Marital Status" runat="server">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="inputSkills" class="col-sm-2 control-label">Anniversary</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbAnniversary_Date" placeholder="Date of Anniversary" runat="server">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbContact_Number" class="col-sm-2 control-label">Contact Number</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbContact_Number" placeholder="The primary mobile number" runat="server">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAlternate_Contact" class="col-sm-2 control-label">Alternate Number</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbAlternate_Contact" placeholder="The secondary/standby mobile number" runat="server">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbEmail_id" class="col-sm-2 control-label">Email id</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbEmail_id" placeholder="Non-Official Email ID" runat="server">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="submit" class="btn btn-danger">Submit</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane Edit Personal Data-->
                    <div class="tab-pane" id="transport">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbTransport_User" class="col-sm-2 control-label">Transport User</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbTransport_User" placeholder="Transport User (Yes / No)">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Line_1" class="col-sm-2 control-label">Address Line 1</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbAddress_Line_1" placeholder="Address Line 1">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Line_2" class="col-sm-2 control-label">Address Line 2</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbAddress_Line_2" placeholder="Address Line 2">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Landmark" class="col-sm-2 control-label">Address Landmark</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbAddress_Landmark" placeholder="Address Landmark">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_City" class="col-sm-2 control-label">Address City</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbAddress_City" placeholder="Address City">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Country" class="col-sm-2 control-label">Address Country</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbAddress_Country" placeholder="Address Country">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Country" class="col-sm-2 control-label">Address Country</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="Text1" placeholder="Address Country">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbPermanent_Address_City" class="col-sm-2 control-label">Permanent Address City</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbPermanent_Address_City" placeholder="Permanent Address City">
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-10">
                                    <button type="submit" class="btn btn-danger">Submit</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane -->
                    <div class="tab-pane" id="work_experience">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbTotal_Work_Experience" class="col-sm-2 control-label">Total Work Experience</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbTotal_Work_Experience" placeholder="Total Work Experience">
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_1" class="col-sm-2 control-label">Skill Set 1</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="tbSkill_Set_1" placeholder="Skill Set 1">
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_2" class="col-sm-2 control-label">Skill Set 2</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="Text2" placeholder="Skill Set 2">
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_3" class="col-sm-2 control-label">Skill Set 3</label>
                                <div class="col-sm-10">
                                    <input type="text" class="form-control" id="Text3" placeholder="Skill Set 3">
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane -->
                </div>
                <!-- /.tab-content -->
            </div>
            <!-- /.nav-tabs-custom -->
        </div>
        <!-- /.box -->
    </div>
    <!-- /.col -->

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="/AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script>
        $(function () {
            //Date picker
            $("[class*='datepicker']").datepicker({
                autoclose: true
            })
            //Initialize Select2 Elements
            $("[class*='select2']").select2();
        });
    </script>

</asp:Content>

