<%@ Page Title="Movement" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="movement.aspx.cs" Inherits="movement" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
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
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <asp:RadioButton ID="rdoDeptMovement" runat="server" GroupName="Movement"
                                                OnCheckedChanged="rdoDeptMovement_CheckedChanged" AutoPostBack="true" />
                                        </span>
                                        <asp:Button ID="btnDeptMovement" CssClass="btn btn-primary btn-flat" Text="Department Movement"
                                            OnClick="btnDeptMovement_Click" runat="server" />

                                        <span class="input-group-addon">
                                            <asp:RadioButton ID="rdoMgrMovement" runat="server" GroupName="Movement"
                                                OnCheckedChanged="rdoMgrMovement_CheckedChanged" AutoPostBack="true" />
                                        </span>
                                        <asp:Button ID="btnMgrMovement" CssClass="btn btn-info btn-flat"
                                            Text="Reporting Manager Movement" OnClick="btnMgrMovement_Click" runat="server" />
                                    </div>
                                </div>
                                <hr />


                                <asp:Panel ID="pnlMgrActions" CssClass="col-md-6" Visible="false" runat="server">
                                    <span class="input-group-btn">
                                        <asp:Button ID="btnMgrPush" runat="server" CssClass="btn btn-primary btn-flat" Text="Initiate Transfer Out" OnClick="btnMgrPush_Click" />
                                        <asp:Button ID="btnMgrPull" runat="server" CssClass="btn btn-info btn-flat" Text="Request Transfer In" OnClick="btnMgrPull_Click" />
                                    </span>



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
                                    <asp:Panel ID="pnlDeptMovement" runat="server" CssClass="" Visible="false">
                                        <asp:DropDownList ID="ddlFromDept" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlToDept" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlFromDeptMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlToDeptMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                    </asp:Panel>
                                    <asp:Panel ID="pnlMgrMovement" runat="server" CssClass="" Visible="false">
                                        <asp:DropDownList ID="ddlFromMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>
                                        <asp:DropDownList ID="ddlToMgr" runat="server" CssClass="form-control select2" Style="width: 100%;"></asp:DropDownList>

                                        <div class="form-group">
                                            <asp:GridView ID="gv_TeamList" runat="server" CssClass="table table-condensed table-responsive datatable display compact hover stripe" AutoGenerateColumns="false"
                                                OnPreRender="gv_PreRender" ShowHeader="true" Style="border: none">
                                                <Columns>
                                                    <asp:TemplateField HeaderText="Select Data">
                                                        <ItemTemplate>
                                                            <asp:CheckBox ID="CheckBox1" runat="server" />
                                                        </ItemTemplate>
                                                    </asp:TemplateField>


                                                    <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                                    <asp:BoundField DataField="Name" HeaderText="Name" />
                                                    <asp:BoundField DataField="EMAIL_ID" HeaderText="Email" />

                                                </Columns>
                                                <EmptyDataTemplate>
                                                    <h5>There are no Team Members are currently mapped to me.</h5>
                                                </EmptyDataTemplate>

                                            </asp:GridView>
                                        </div>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                        <div class="box-footer">
                            <div class="input-group">
                                <span class="input-group-btn">
                                    <asp:Button ID="btnPush" runat="server" CssClass="btn btn-primary btn-flat" Text="Initiate Transfer Out" />
                                    <asp:Button ID="btnPull" runat="server" CssClass="btn btn-info btn-flat" Text="Request Transfer In" />
                                </span>
                            </div>
                        </div>
                        <!-- /.box-footer-->
                    </div>
                    <!--tabcontent-->
                </div>
                <!-- /.col -->
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnDeptMovement" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnMgrMovement" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="rdoDeptMovement" EventName="CheckedChanged" />
            <asp:AsyncPostBackTrigger ControlID="rdoMgrMovement" EventName="CheckedChanged" />
        </Triggers>
    </asp:UpdatePanel>


</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script>
        $(function () {
            //Initialize Select2 Elements
            $('.select2').select2()
        });
    </script>
</asp:Content>

