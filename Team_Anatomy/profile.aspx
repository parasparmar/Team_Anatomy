<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="profile.aspx.cs" Inherits="profile" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <style>
        .cursor {
            cursor: pointer;
        }
    </style>
</asp:Content>
<%--<asp:Content ID="Content2" ContentPlaceHolderID="headmenu" runat="Server">
</asp:Content>--%>
<%--<asp:Content ID="Content3" ContentPlaceHolderID="leftmenu" runat="Server">
</asp:Content>--%>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="profile.aspx"><i class="fa fa-user-plus"></i>Profile Information</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-user-plus"></span></div>
        <div class="pagetitle">
            <h5>View / Edit and Save Profile Information</h5>
            <h1>My Profile</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row">
        <div class="col-md-4">
            <!-- Profile Image -->
            <div class="box box-primary">
                <div class="box-body box-profile">
                    <asp:Image ID="imgbtnUserImage" CssClass="profile-user-img img-responsive img-circle cursor" runat="server" />
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
                        <li class="list-group-item">
                            <b>Site</b>
                            <a class="pull-right">
                                <asp:Label ID="lblSite" runat="server"></asp:Label>
                            </a>

                        </li>
                    </ul>

                    <%--<a href="#" class="btn btn-primary btn-block"><b>Request Rectification</b></a>--%>
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
                    <ul class="list-group list-group-unbordered">
                        <li class="list-group-item">
                            <strong>Reporting Manager</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblSupervisor" runat="server"></asp:Label>
                            </a>
                        </li>

                        <li class="list-group-item">
                            <strong>Employee Role</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblEmployee_Role" runat="server"></asp:Label>
                            </a>

                        </li>
                        <li class="list-group-item">
                            <strong>Employee Type</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblEmployee_Type" runat="server"></asp:Label>
                            </a>

                        </li>
                        <li class="list-group-item">
                            <strong>Employee Status</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblEmployee_Status" runat="server"></asp:Label>
                            </a>

                        </li>
                        <%--<li class="list-group-item">
                            <strong>Updated by</strong>
                            <a class="pull-right">
                                <asp:Label ID="lblUpdated_by" runat="server"></asp:Label>
                            </a>

                        </li>--%>
                    </ul>
                    <%-- <a href="#" class="btn btn-primary btn-block"><b>Request Rectification</b></a>--%>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->


        </div>
        <div class="col-md-8">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#personal" data-toggle="tab">Personal</a></li>
                    <li><a href="#transport" data-toggle="tab">Transport</a></li>
                    <li><a href="#work_experience" data-toggle="tab">Work Experience</a></li>
                    <li><a href="#profile_image" data-toggle="tab">Profile Image</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="personal">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbGender" class="col-sm-2 control-label">Gender</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-genderless"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="tbGender" runat="server" placeholder="Gender" type="text">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbDate_of_Birth" class="col-sm-2 control-label">Date of Birth</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-birthday-cake"></i></span>
                                        <asp:TextBox ID="tbDate_of_Birth" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbQualification" class="col-sm-2 control-label">Highest Qualification</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-university"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control  select2" ID="tbQualification" Style="width: 100%" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbMarital_Status" class="col-sm-2 control-label">Marital Status</label>
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-user-plus"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="tbMaritalStatus" runat="server">
                                        </asp:DropDownList>
                                    </div>
                                </div>

                                <label for="inputSkills" class="col-sm-2 control-label">Anniversary Date</label>
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                                        <asp:TextBox ID="tbAnniversaryDate" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                    </div>

                                </div>
                            </div>
                            <br>
                            <div class="form-group">
                                <label for="tbContact_Number" class="col-sm-2 control-label">Contact Number</label>
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-mobile"></i></span>
                                        <asp:TextBox ID="tbContact_Number" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="tbContact_Number" ErrorMessage="Invalid Number Format" ForeColor="Red" ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>

                                </div>

                                <label for="tbAlternate_Contact" class="col-sm-2 control-label">Alternate Number</label>
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-phone-square"></i></span>
                                        <asp:TextBox ID="tbAlternate_Contact" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="tbAlternate_Contact" ErrorMessage="Invalid Number Format" ForeColor="Red" ValidationExpression="[0-9]{10}"></asp:RegularExpressionValidator>
                                </div>
                            </div>

                            <%--<label>Emergency Contact Person Details</label>--%>

                            <div class="form-group">
                                <label for="tbEmergencyContactPerson" class="col-sm-2 control-label">Emergency Contact Name</label>
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                        <asp:TextBox ID="tbEmergencyContactPerson" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="tbEmergencyContactPerson" ErrorMessage="Only alphabets are allowed" ForeColor="Red" ValidationExpression="^[a-zA-Z ]+$"></asp:RegularExpressionValidator>

                                </div>

                                <label for="tbEmergencyContactNumber" class="col-sm-2 control-label">Emergency Contact Number</label>
                                <div class="col-sm-4">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-phone"></i></span>
                                        <asp:TextBox ID="tbEmergencyContactNo" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="tbEmergencyContactNo" ErrorMessage="Invalid Number Format" ForeColor="Red" ValidationExpression="[0-9]{10}|0"></asp:RegularExpressionValidator>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="tbEmail_id" class="col-sm-2 control-label">Email id (Personal)</label>
                                <div class="col-sm-10">

                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-envelope"></i></span>
                                        <asp:TextBox ID="tbEmail_id" CssClass="form-control" type="email" runat="server" placeholder="Email"></asp:TextBox>
                                    </div>
                                    <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ForeColor="Red" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="tbEmail_id" ErrorMessage="Invalid Email Format"></asp:RegularExpressionValidator>
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
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-automobile"></i></span>
                                        <asp:DropDownList ItemType="text" CssClass="form-control select" ID="tbTransport_User" runat="server">
                                            <asp:ListItem Text="Yes"></asp:ListItem>
                                            <asp:ListItem Text="No"></asp:ListItem>
                                            <asp:ListItem Text="Not Specified"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Line_1" class="col-sm-2 control-label">Address Line 1</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Line_1" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Line_2" class="col-sm-2 control-label">Address Line 2</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Line_2" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Landmark" class="col-sm-2 control-label">Address Landmark</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Landmark" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_City" class="col-sm-2 control-label">Address City</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_City" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbAddress_Country" class="col-sm-2 control-label">Address Country</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-hotel"></i></span>
                                        <asp:TextBox ID="tbAddress_Country" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="tbPermanent_Address_City" class="col-sm-2 control-label">Permanent Address City</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-home"></i></span>
                                        <asp:TextBox ID="tbPermanent_Address_City" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                    <!-- /.tab-pane Transport -->
                    <div class="tab-pane" id="work_experience">
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbTotal_Work_Experience" class="col-sm-2 control-label">Total Work Experience</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-briefcase"></i></span>

                                        <asp:TextBox ID="tbTotal_Work_Experience" CssClass="form-control" runat="server"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_1" class="col-sm-2 control-label">Primary Skill Set</label>
                                <div class="col-sm-10">

                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-rocket"></i></span>
                                        <select id="tbSkill_Set_1" class="form-control select2" selectionmode="multiple" multiple="true" style="width: 100%" runat="server">
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_2" class="col-sm-2 control-label">Secondary Skill Set</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-fighter-jet"></i></span>
                                        <select id="tbSkill_Set_2" class="form-control select2" selectionmode="multiple" multiple="true" style="width: 100%" runat="server"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_3" class="col-sm-2 control-label">Tertiary Skill Set</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-bicycle"></i></span>
                                        <select id="tbSkill_Set_3" class="form-control select2" selectionmode="multiple" multiple="true" style="width: 100%" runat="server"></select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane -->
                    <div class="tab-pane" id="profile_image">

                        <div class="form-horizontal">
                            <div class="form-group">
                                <label for="tbSkill_Set_3" class="col-sm-2 control-label">Change Profile Image</label>
                                <div class="col-sm-10">
                                    <div class="input-group">
                                        <asp:FileUpload ID="fileUploadNewProfileImage" runat="server" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- /.tab-pane Edit Profile Image-->
                </div>
                <!-- /.tab-content -->
                <div class="box-footer">
                    <div class="form-group">
                        <div class="col-sm-offset-2 col-sm-10">
                            <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-danger" Text="Submit" OnClick="btnSubmit_Click" />
                            <label class=" control-label pull-right">
                                last updated on &nbsp
                                        <a class="pull-right">
                                            <asp:Label ID="lblUpdate_Date" runat="server"></asp:Label>
                                        </a>
                            </label>

                        </div>
                    </div>
                    <!--Submit Button-->
                </div>
            </div>
            <!-- /.nav-tabs-custom -->
        </div>
        <!-- /.box -->

    </div>
    <!-- /.col -->

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script>
        if ($("#tbMaritalStatus option:selected").val() == 'Not Married' || $("#tbMaritalStatus option:selected").val() == 'Not Specified') {
            $("#tbAnniversaryDate").prop('disabled', true);
        }


        $(function () {

            $("#tbMaritalStatus").change(function () {
                if ($("#tbMaritalStatus option:selected").val() == 'Not Married' || $("#tbMaritalStatus option:selected").val() == 'Not Specified') {
                    $("#tbAnniversaryDate").prop('disabled', true);
                    $('#tbAnniversaryDate').val("").datepicker("update");
                }
                else { $("#tbAnniversaryDate").prop('disabled', false); }
            });

            //Date picker
            $('#tbDate_of_Birth').datepicker({
                format: 'dd-MM-yyyy',
                orientation: "bottom auto",
                autoclose: true
            });
            $('#tbAnniversaryDate').datepicker({
                format: 'dd-MM-yyyy',
                autoclose: true
            });


            $("[class*='datepicker']").datepicker({
                autoclose: true
            })
            //Initialize Select2 Elements
            $("[class*='select2']").select2();

            $('#imgbtnUserImage').click(function () {
                $('input[type=file]').trigger('click');

            });


            $('input[type=file]').change(function () {
                var vals = $(this).val();
                var fileName = vals.length ? vals.split('\\').pop() : '';
                var fileExtension = fileName.split('.').pop();
                var fileUpload = $(this).get(0);
                var files = fileUpload.files;
                var data = new FormData();
                var myid = $("#lblNTID").text() + "_0." + fileExtension;
                //alert(myid);
                for (var i = 0; i < files.length; i++) {
                    data.append(files[i].name, files[i], myid);
                }


                $.ajax({
                    url: "FileUploadHandler.ashx",
                    type: "POST",
                    data: data,
                    contentType: false,
                    processData: false,
                    success: function (result) {
                        alert(result);
                        location.reload();
                    },
                    error: function (err) { alert(err.statusText) }
                });
            });

        });
    </script>

</asp:Content>

