<%@ Page Title="Movement" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="movement.aspx.cs" Inherits="movement" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <link href="Sitel/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="AdminLTE/plugins/iCheck/all.css">
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="movement.aspx"><i class="fa fa-random"></i>Review Period Master</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-random"></span></div>
        <div class="pagetitle">
            <h5>Request to initiate and accept employee and team movements</h5>
            <h1>Movement</h1>
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
                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-3">
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
                                <div class="col-md-3">
                                    <asp:Panel ID="pnlMgrActions" CssClass="span" Visible="false" runat="server">
                                        <%--<input type="checkbox" checked runat="server" id="cbxTransferDirection" class="checkbox2ToggleSwitch" data-toggle="toggle" data-off="Transfer In" data-on="Transfer Out" />--%>
                                        <div class="input-group">
                                            <span class="input-group-addon">
                                                <asp:RadioButton ID="btnMgrPush" runat="server" OnCheckedChanged="btnMgrPush_Click" CssClass="flat-red" GroupName="TransferDirection" AutoPostBack="true" />
                                            </span>
                                            <asp:Button ID="btnMgrPush2" CssClass="btn btn-info btn-flat form-control" Text="Initiate Transfer Out" OnClick="btnMgrPush_Click" runat="server" />
                                        </div>
                                        <div class="input-group">
                                            <span class="input-group-addon">
                                                <asp:RadioButton ID="btnMgrPull" runat="server" OnCheckedChanged="btnMgrPull_Click" CssClass="flat-red" GroupName="TransferDirection" AutoPostBack="true" />
                                            </span>
                                            <asp:Button ID="btnMgrPull2" CssClass="btn btn-info btn-flat  form-control" Text="Request Transfer In" OnClick="btnMgrPull_Click" runat="server" />
                                        </div>
                                    </asp:Panel>
                                </div>
                                <div class="col-md-3">
                                    <asp:Panel ID="pnlEffectiveDate" CssClass="span" Visible="false" runat="server">
                                        <div class="form-group">
                                            <label>Effective Date (As On)</label>
                                            <asp:TextBox ID="tbEffectiveDate" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                        </div>
                                    </asp:Panel>
                                </div>
                                <div class="col-md-3">
                                    <asp:Panel ID="pnlReset" CssClass="span" Visible="true" runat="server">
                                        <div class="input-group">
                                            <label>Reset</label>
                                            <asp:Button ID="btnReset" CssClass="btn btn-primary btn-flat form-control" Text="Reset" Visible="false" OnClick="btnReset_Click" runat="server" />
                                        </div>
                                        <div class="input-group">
                                            <label>Submit</label>
                                            <asp:Button ID="btnSubmitPush" runat="server" CssClass="btn btn-primary btn-flat form-control" Visible="false" Text="Submit Transfer Out Request" />
                                        </div>
                                        <div class="input-group">
                                            <label>Submit</label>
                                            <asp:Button ID="btnSubmitPull" runat="server" CssClass="btn btn-info btn-flat form-control" Visible="false" Text="Submit Transfer In Request" />
                                        </div>
                                    </asp:Panel>
                                </div>

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
                                <div class="box-tools pull-right">
                                    <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                        <i class="fa fa-minus"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="box-body">
                                <div class="form-group">
                                    <div class="col-md-12">
                                        <asp:Panel ID="pnlDeptMovement" runat="server" CssClass="box-body" Visible="false">
                                            <asp:DropDownList ID="ddlFromDept" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlToDept" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlFromDeptMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                            <asp:DropDownList ID="ddlToDeptMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                        </asp:Panel>
                                        <!--Choose Dep and Teams---->
                                        <asp:Panel ID="pnlMgrMovement" runat="server" CssClass="box-body" Visible="false">
                                            <div class="row">
                                                <div class="col-md-5">
                                                    <asp:Label Text="From" ID="lblFromMgr" runat="server"></asp:Label>
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="ddlFromMgr" runat="server" CssClass="form-control select2" Style="width: 100%;" OnSelectedIndexChanged="ddlFromMgr_SelectedIndexChanged"
                                                            AutoPostBack="true">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                                <div class="col-md-2">
                                                    <asp:Literal ID="ltlDirection" Text="" runat="server"></asp:Literal>
                                                </div>
                                                <div class="col-md-5">
                                                    <asp:Label Text="To" ID="lblToMgr" runat="server"></asp:Label>
                                                    <div class="form-group">
                                                        <asp:DropDownList ID="ddlToMgr" runat="server" CssClass="form-control select2" Style="width: 100%;" OnSelectedIndexChanged="ddlToMgr_SelectedIndexChanged"
                                                            OnTextChanged="ddlToMgr_SelectedIndexChanged" AutoPostBack="true">
                                                        </asp:DropDownList>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-5">
                                                    <div class="form-group">
                                                        <asp:GridView ID="gv_LeftHandSideTeamList" runat="server" CssClass="table table-condensed table-responsive" AutoGenerateColumns="false"
                                                            OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Selection">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="cbMyTeamListID" CssClass="flat-red" runat="server" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                                <asp:BoundField DataField="Name" HeaderText="Name" />
                                                            </Columns>
                                                            <EmptyDataTemplate>
                                                                <h5>No Team Members found.</h5>
                                                            </EmptyDataTemplate>

                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                                <!---LHS Team---->
                                                <div class="col-md-2">
                                                </div>
                                                <div class="col-md-5">

                                                    <div class="form-group">
                                                        <asp:GridView ID="gv_RightHandSideTeamList" runat="server"
                                                            CssClass="table table-condensed table-responsive"
                                                            AutoGenerateColumns="false"
                                                            OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none">
                                                            <Columns>
                                                                <asp:TemplateField HeaderText="Selection">
                                                                    <ItemTemplate>
                                                                        <asp:CheckBox ID="cbHisTeamListID" CssClass="flat-red" runat="server" />
                                                                    </ItemTemplate>
                                                                </asp:TemplateField>
                                                                <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                                <asp:BoundField DataField="Name" HeaderText="Name" />

                                                            </Columns>
                                                            <EmptyDataTemplate>
                                                                <h5>No Team Members found.</h5>
                                                            </EmptyDataTemplate>

                                                        </asp:GridView>
                                                    </div>
                                                </div>
                                                <!---RHS Team---->
                                            </div>
                                        </asp:Panel>
                                        <!--Choose Mgr Teams---->
                                    </div>
                                </div>
                            </div>
                            <div class="box-footer">
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
            <asp:AsyncPostBackTrigger ControlID="btnMgrPush" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrPush2" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrPull" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrPull2" EventName="Click" />

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
            $('.select2').select2({

            });
            //Date picker
            $(".datepicker").datepicker({
                autoclose: true,
                format: 'dd-M-yyyy'
            });
        }

        $(function () {
            pluginsInitializer();
        });

        //On UpdatePanel Refresh
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {
                    pluginsInitializer();
                }
            });
        };
    </script>

</asp:Content>

