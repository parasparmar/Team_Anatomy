﻿<%@ Page Title="Movement" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="movement.aspx.cs" Inherits="movement" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <link href="Sitel/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="AdminLTE/plugins/iCheck/all.css">
    <style>
        .border-between > [class*='col-']:before {
            background: #e3e3e3;
            bottom: 0;
            content: " ";
            left: 0;
            position: absolute;
            width: 1px;
            top: 0;
        }

        .border-between > [class*='col-']:first-child:before {
            display: none;
        }
    </style>
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="movement.aspx"><i class="fa fa-random"></i>Movement</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-random"></span></div>
        <div class="pagetitle">
            <h5>Initiate or Request an employee or team movement</h5>
            <h1>Initiate Movement</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row-fluid">
                <div class="col-md-12">
                    <!-- Custom Tabs -->
                    <div class="box box-solid box-primary" style="height: auto;">
                        <div class="box-header with-border">
                            <h4 class="box-title">Choose a Movement Type</h4>
                        </div>
                        <div class="box-body">

                            <div class="row">
                                <asp:Panel ID="pnlEnableMovements" Visible="false" runat="server">
                                    <div class="col-md-4">

                                        <div id="divDepMovement" runat="server" class="input-group">
                                            <span class="input-group-addon">
                                                <asp:RadioButton ID="rdoDeptMovement" runat="server" GroupName="Movement" CssClass="flat-red"
                                                    OnCheckedChanged="rdoDeptMovement_CheckedChanged" AutoPostBack="true" />
                                            </span>
                                            <asp:Button ID="btnDeptMovement" CssClass="btn btn-primary btn-flat  form-control" Text="Department Movement"
                                                OnClick="btnDeptMovement_Click" runat="server" />
                                        </div>
                                        <div class="form-group">
                                            <div id="divMgrMovement" runat="server" class="input-group">
                                                <span class="input-group-addon">
                                                    <asp:RadioButton ID="rdoMgrMovement" runat="server" CssClass="flat-red" GroupName="Movement"
                                                        OnCheckedChanged="rdoMgrMovement_CheckedChanged" AutoPostBack="true" />
                                                </span>
                                                <asp:Button ID="btnMgrMovement" CssClass="btn btn-info btn-flat  form-control"
                                                    Text="Reporting Manager Movement" OnClick="btnMgrMovement_Click" runat="server" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2">
                                        <asp:Panel ID="pnlEffectiveDate" CssClass="span" Visible="false" runat="server">
                                            <div class="form-group">
                                                <label>Effective From</label>
                                                <div class="input-group date">
                                                    <div class="input-group-addon"><i class="fa fa-calendar"></i></div>
                                                    <asp:TextBox ID="tbEffectiveDate" CssClass="form-control" runat="server"></asp:TextBox>

                                                </div>
                                                <asp:RequiredFieldValidator ID="datevalidator" runat="server" ControlToValidate="tbEffectiveDate" ErrorMessage="Please enter a valid date" ForeColor="Red"></asp:RequiredFieldValidator>
                                            </div>
                                        </asp:Panel>
                                    </div>
                                    <div class="col-md-4">
                                        <asp:Panel ID="pnlMgrActions" CssClass="span" Visible="false" runat="server">
                                            <%--<input type="checkbox" checked runat="server" id="cbxTransferDirection" class="checkbox2ToggleSwitch" data-toggle="toggle" data-off="Transfer In" data-on="Transfer Out" />--%>
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <asp:RadioButton ID="rdobtnMgrPush" runat="server" OnCheckedChanged="btnMgrPush_Click" CssClass="flat-red" GroupName="TransferDirection" AutoPostBack="true" />
                                                </span>
                                                <asp:Button ID="btnMgrPush2" CssClass="btn btn-info btn-flat form-control" Text="Initiate Transfer Out" OnClick="btnMgrPush_Click" runat="server" />
                                            </div>
                                            <div class="input-group">
                                                <span class="input-group-addon">
                                                    <asp:RadioButton ID="rdobtnMgrPull" runat="server" OnCheckedChanged="btnMgrPull_Click" CssClass="flat-red" GroupName="TransferDirection" AutoPostBack="true" />
                                                </span>
                                                <asp:Button ID="btnMgrPull2" CssClass="btn btn-info btn-flat  form-control" Text="Request Transfer In" OnClick="btnMgrPull_Click" runat="server" />
                                            </div>
                                        </asp:Panel>
                                    </div>
                                </asp:Panel>
                            </div>

                        </div>
                        <!--tabcontent-->
                    </div>
                    <!-- /.col -->
                </div>
                <div class="row-fluid">
                    <div class="col-md-12">
                        <!-- Custom Tabs -->
                        <div class="box box-solid box-primary" style="height: auto;">
                            <div class="box-header with-border">
                                <h4 class="box-title">
                                    <asp:Literal ID="ltlMovementTypeHeading" runat="server" Text="Movement Type : "></asp:Literal></h4>
                            </div>
                            <div class="box-body">

                                <div class="col-md-12">
                                    <asp:Panel ID="pnlDeptMovement" runat="server" CssClass="box-body" Visible="false">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <div class="form-group">
                                                    Reporting Manager
                                                    <asp:DropDownList ID="ddlDepartmentManager" runat="server" CssClass="form-control select2" Style="width: 100%;" OnSelectedIndexChanged="ddlDepartmentManager_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <!-- ddlDepartmentManager-->
                                            <div class="col-md-3">
                                                Function
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlFunctionId" runat="server"
                                                        CssClass="form-control select2" Style="width: 100%;"
                                                        OnSelectedIndexChanged="ddlFunctionId_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <!-- ddlFunctionId-->
                                            <div class="col-md-3">
                                                Department
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlDepartmentID" runat="server"
                                                        CssClass="form-control select2" Style="width: 100%;"
                                                        OnSelectedIndexChanged="ddlDepartmentID_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <!-- ddlDepartmentID-->
                                            <div class="col-md-3">
                                                LOB
                                                <div class="form-group">

                                                    <asp:DropDownList ID="ddlLOBID" runat="server"
                                                        CssClass="form-control select2" Style="width: 100%;"
                                                        OnSelectedIndexChanged="ddlLOBID_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <!-- ddlLOBID-->
                                            <div class="col-md-3">
                                                Skill-Set
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlSkillSet" runat="server"
                                                        CssClass="form-control select2" Style="width: 100%;"
                                                        OnSelectedIndexChanged="ddlSkillSet_SelectedIndexChanged" AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <!-- ddlSkillSet-->
                                            <div class="col-md-3">
                                                Sub Skill-Set
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlSubSkillSet" runat="server"
                                                        CssClass="form-control select2" Style="width: 100%;"
                                                        OnSelectedIndexChanged="ddlSubSkillSet_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <!-- ddlSubSkillSet-->
                                            <div class="col-md-3">
                                                <label style="color: transparent; margin: 0">Submit</label>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <asp:Button ID="btnDepSubmit" runat="server" CssClass="btn btn-info btn-flat  form-control" Text="Submit" OnClick="btnDepSubmit_Click" Enabled="false" />
                                                        <span class="input-group-addon"><i class='fa fa-arrow-circle-right'></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row border-between">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <asp:GridView ID="gv_DepMgrTeamList" runat="server" CssClass="table table-condensed table-responsive" AutoGenerateColumns="false"
                                                        OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none" DataKeyNames="Employee_ID" OnRowDataBound="gv_DepMgrTeamList_RowDataBound">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Selection">
                                                                <HeaderTemplate>
                                                                    <asp:CheckBox ID="cbCheckAll" runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="cbMyTeamListID" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                            <asp:BoundField DataField="Name" HeaderText="Name" />
                                                            <asp:BoundField DataField="RepMgr" HeaderText="Current Reporting Manager" />
                                                            <asp:BoundField DataField="Function" HeaderText="Function" />
                                                            <asp:BoundField DataField="Department" HeaderText="Department" />
                                                            <asp:BoundField DataField="LOB" HeaderText="Line of Business" />
                                                            <asp:BoundField DataField="Skillset" HeaderText="Skill Set" />
                                                            <asp:BoundField DataField="Subskillset" HeaderText="Sub-Skill Set" />

                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            <h5>No Team Members found.</h5>
                                                        </EmptyDataTemplate>

                                                    </asp:GridView>
                                                </div>
                                            </div>
                                            <!---The Dep Mgr's Team---->
                                        </div>
                                        <!-- Team List for Department Movements-->
                                    </asp:Panel>
                                    <!--Choose Dep and Teams---->
                                    <asp:Panel ID="pnlMgrMovement" runat="server" CssClass="box-body" Visible="false">
                                        <div class="row">
                                            <div class="col-md-5">
                                                <asp:Label Text="From" ID="lblFromMgr" runat="server"></asp:Label>
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlFromMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"
                                                        OnSelectedIndexChanged="ddlFromMgr_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>
                                            <div class="col-md-2">
                                                <label style="color: transparent; margin: 0">Submit</label>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-info btn-flat form-control" Text="Submit" OnClick="btnSubmit_Click" />
                                                        <span class="input-group-addon"><i class='fa fa-arrow-circle-right'></i></span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-5">
                                                <asp:Label Text="To" ID="lblToMgr" runat="server"></asp:Label>
                                                <div class="form-group">
                                                    <asp:DropDownList ID="ddlToMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"
                                                        OnSelectedIndexChanged="ddlToMgr_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </div>
                                            </div>

                                        </div>
                                        <div class="row border-between">
                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <asp:GridView ID="gv_LeftHandSideTeamList" runat="server" CssClass="table table-condensed table-responsive" AutoGenerateColumns="false"
                                                        OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none" DataKeyNames="Employee_ID" OnRowDataBound="gv_LeftHandSideTeamList_RowDataBound">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="Selection">
                                                                <HeaderTemplate>
                                                                    <asp:CheckBox ID="cbCheckAll" runat="server" />
                                                                </HeaderTemplate>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="cbMyTeamListID" runat="server" />
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                            <asp:BoundField DataField="Name" HeaderText="Name" />
                                                            <asp:BoundField DataField="State" HeaderText="Status" />
                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            <h5>No Team Members found.</h5>
                                                        </EmptyDataTemplate>

                                                    </asp:GridView>
                                                </div>
                                            </div>
                                            <!---LHS Team---->

                                            <div class="col-md-6">
                                                <div class="form-group">
                                                    <asp:GridView ID="gv_RightHandSideTeamList" runat="server"
                                                        CssClass="table table-condensed table-responsive"
                                                        AutoGenerateColumns="false"
                                                        OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none"
                                                        DataKeyNames="Employee_ID">
                                                        <Columns>
                                                            <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                            <asp:BoundField DataField="Name" HeaderText="Name" />
                                                            <asp:BoundField DataField="State" HeaderText="Status" />
                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            <h5>No Team Members found.</h5>
                                                        </EmptyDataTemplate>

                                                    </asp:GridView>
                                                </div>
                                            </div>
                                            <!---RHS Team---->
                                    </asp:Panel>
                                    <!--Choose Mgr Teams---->
                                </div>

                            </div>
                            <div class="box-footer">
                            </div>
                        </div>
                        <!-- /.box-footer-->
                    </div>
                    <!--tabcontent-->
                </div>
                <!-- /.col -->
            </div>
            <!---LHS Panel---->
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnDeptMovement" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrMovement" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="rdoDeptMovement" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="rdoMgrMovement" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlToMgr" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlFromMgr" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="rdobtnMgrPush" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrPush2" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="rdobtnMgrPull" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrPull2" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="tbEffectiveDate" EventName="TextChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlDepartmentManager" EventName="SelectedIndexChanged" />

            <asp:AsyncPostBackTrigger ControlID="ddlFunctionId" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlDepartmentId" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlLOBID" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlSkillSet" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlSubSkillSet" EventName="SelectedIndexChanged" />
            <asp:PostBackTrigger ControlID="btnSubmit" />
        </Triggers>
    </asp:UpdatePanel>

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>
    <script>


        function pluginsInitializer() {
            //Initialize Select2 Elements
            $('.select2').select2({});

            $('#tbEffectiveDate').datepicker({
                dateFormat: 'dd-mm-yy',
                todayHighlight: true,
                orientation:"bottom",
                //Default: true,
                //defaultDate: new Date(),//'now',
                //defaultViewDate://'now',// or 'now'
                autoclose: true
            });

            //Attach Events to 1. CheckAll, 2. TeamList, 3. Effective date and 4. Submit Button 

            // $("#btnSubmit").attr('disabled', 'disabled');

            //1. CheckAll : If CheckAll is checked, then check all employees in the TeamList except the ones who  are disabled.
            $("#cbCheckAll").change(function () {
                var isChecked = $(this).prop('checked');

                // Toggle the selection state of all the team list checkboxes.
                $('[id*="cbMyTeamListID"]').each(function () {
                    if ($(this).is(':disabled')) { }
                    else { $(this).prop('checked', isChecked); }
                });

                // Enable the Submit if Effectivedate is valid. 
                if (isChecked == true && $('[id*="cbMyTeamListID"]:checked').length > 0) {
                    ToggleButton(checkIfTeamListHasBeenPopulated(), checkIfTeamListHasAtLeastOneCheck(), checkIfEffectiveDateValid());
                } else {
                    ToggleButton(false, false);
                }

            });

            //2. TeamList : If even one id in TeamList is checked then isTeamListChecked = true.
            $('[id*="cbMyTeamListID"]').change(function () {
                ToggleButton(checkIfTeamListHasBeenPopulated(), checkIfTeamListHasAtLeastOneCheck(), checkIfEffectiveDateValid());
            });

            //3. Effective date : If tbEffectiveDate is filled then isEffectiveDateValid = true.
            $('#tbEffectiveDate').change(function () {
                ToggleButton(checkIfTeamListHasBeenPopulated(), checkIfTeamListHasAtLeastOneCheck(), checkIfEffectiveDateValid());
            });

            //4. TeamList : If checkIfTeamListHasBeenPopulated = true.
            $('#ddlToMgr, #ddlFromMgr').change(function () {
                ToggleButton(checkIfTeamListHasBeenPopulated(), checkIfTeamListHasAtLeastOneCheck(), checkIfEffectiveDateValid());
            });


            function checkIfEffectiveDateValid() {
                if ($('#tbEffectiveDate').val().length > 0) {
                    // alert("checkIfEffectiveDateValid : true");
                    return true;
                } else {
                    // alert("checkIfEffectiveDateValid : false");
                    return false;
                }
            }
            function checkIfTeamListHasAtLeastOneCheck() {
                try {
                    if ($('[id*="cbMyTeamListID"]:checked').length > 0) {
                        //alert("checkIfTeamListHasAtLeastOneCheck : true");
                        return true;
                    } else {
                        // alert("checkIfTeamListHasAtLeastOneCheck : false");
                        return false;
                    }
                } catch (e) {
                    //alert(e.message);
                    return false;
                }
            }
            function checkIfTeamListHasBeenPopulated() {
                var LeftGVRowCount = $("#gv_LeftHandSideTeamList >tbody >tr").length;

                var RightGVRowCount = $("#gv_RightHandSideTeamList >tbody >tr").length;

                if (LeftGVRowCount > 0 && RightGVRowCount > 0) {

                    return true;
                } else {

                    return false;
                }

            }


        }

        //On UpdatePanel Refresh, reapply events
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                //alert("Control is back with browser.");
                if (sender._postBackSettings.panelsToUpdate != null) {
                    pluginsInitializer();
                }
            });
        };

        $(function () {
            //ToggleButton(false, false, false);
            pluginsInitializer();
        });

        function ToggleButton(isTeamListPopulated, isTeamListChecked, isEffectiveDateValid) {
            if (isTeamListPopulated == true && isTeamListChecked == true && isEffectiveDateValid == true) {
                //alert("isTeamListPopulated : " + isTeamListPopulated + " isTeamListChecked : " + isTeamListChecked + " isEffectiveDateValid : " + isEffectiveDateValid);
                //alert("Enabled");
                $("#btnSubmit").removeAttr('disabled');
            }
            else {
                //alert("Disabled");
                //alert("isTeamListPopulated : " + isTeamListPopulated + " isTeamListChecked : " + isTeamListChecked + " isEffectiveDateValid : " + isEffectiveDateValid);
                $("#btnSubmit").attr('disabled', 'disabled');
            }
        }
    </script>

</asp:Content>

