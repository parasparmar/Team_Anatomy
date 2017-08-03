<%@ Page Title="" Language="C#" MasterPageFile="MasterPage.master" AutoEventWireup="true" CodeFile="PMS_ReviewMaster.aspx.cs" Inherits="PMS_ReviewMaster" %>

<%@ MasterType VirtualPath="MasterPage.master" %>

<%--<asp:Content ID="Headers" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>
<asp:Content ID="User_TopMenu" ContentPlaceHolderID="headmenu" runat="Server">
</asp:Content>--%>

<asp:Content ID="User_Menu" ContentPlaceHolderID="leftmenu" runat="Server">
    <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
            <!-- Sidebar user panel -->
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                </div>
                <div class="pull-left info">
                    <p>Alexander Pierce</p>
                    <a href="#"><i class="fa fa-circle text-success"></i>Online</a>
                </div>
            </div>
            <!-- search form -->
            <div class="sidebar-form">
                <h5 style="color: white">Please select your Role</h5>
                <div class="input-group">
                    <asp:DropDownList ID="ddl_Role" runat="server" CssClass="form-control" OnSelectedIndexChanged="ddl_Role_SelectedIndexChanged">
                        <asp:ListItem Text="HR Administrator" Value="hr admin" Enabled="true"></asp:ListItem>
                        <asp:ListItem Text="Reporting Manager" Value="reporting manager" Enabled="true"></asp:ListItem>
                        <asp:ListItem Text="Reviewing Manager" Value="reviewing manager" Enabled="true"></asp:ListItem>
                    </asp:DropDownList>
                    <span class="input-group-btn">
                        <button type="submit" name="search" id="search-btn" class="btn btn-flat">
                            <i class="fa fa-check-square-o"></i>
                        </button>
                    </span>
                </div>
            </div>
            <!-- /.search form -->
            <!-- sidebar menu: : style can be found in sidebar.less -->
            <ul class="sidebar-menu" data-widget="tree">
                <li class="header">ROLE based Tasks</li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-dashboard"></i><span>Dashboard</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="/AdminLTE/index.html"><i class="fa fa-circle-o"></i>Dashboard v1</a></li>
                        <li><a href="/AdminLTE/index2.html"><i class="fa fa-circle-o"></i>Dashboard v2</a></li>
                    </ul>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-files-o"></i>
                        <span>Layout Options</span>
                        <span class="pull-right-container">
                            <span class="label label-primary pull-right">4</span>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li><a href="/AdminLTE/layout/top-nav.html"><i class="fa fa-circle-o"></i>Top Navigation</a></li>
                        <li><a href="/AdminLTE/layout/boxed.html"><i class="fa fa-circle-o"></i>Boxed</a></li>
                        <li><a href="/AdminLTE/layout/fixed.html"><i class="fa fa-circle-o"></i>Fixed</a></li>
                        <li><a href="/AdminLTE/layout/collapsed-sidebar.html"><i class="fa fa-circle-o"></i>Collapsed Sidebar</a></li>
                    </ul>
                </li>

            </ul>
        </section>
        <!-- /.sidebar -->
    </aside>
</asp:Content>
<asp:Content ID="User_Header" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="/PMS_ReviewMaster.aspx"><i class="fa fa-tasks"></i>Review Period Master</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-tasks"></span></div>
        <div class="pagetitle">
            <h5>Define, Set & Publish Review Periods</h5>
            <h1>Review Period Master</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="User_Content" ContentPlaceHolderID="The_Body" runat="Server">
    <asp:UpdatePanel runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:HiddenField ID="hdnIsFormInUpdateOrCeateMode" EnableViewState="true" runat="server" Value="create" />
            <asp:HiddenField ID="hdnPeriodID" EnableViewState="true" runat="server" Value="0" />
            <div class="row-fluid">
                <div class="col-md-12">
                    <!-- Custom Tabs -->
                    <asp:Literal ID="ltlClassForDefineHeader" runat="server" Text='<div class="box box-solid box-primary">'></asp:Literal>
                    <div class="box-header with-border">
                        <h4 class="box-title">
                            <asp:Literal ID="ltlDefineHeader" Text="Define A Review Period" runat="server"></asp:Literal></h4>
                        <div class="box-tools pull-right">
                            <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body">
                        <div class="form-group">

                            <div class="row">
                                <div class="col-xs-2">
                                    <label>Review Year</label>
                                    <asp:DropDownList ID="ddl_PCYear" runat="server" required="true" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="2016" Value="2016"></asp:ListItem>
                                        <asp:ListItem Text="2017" Value="2017"></asp:ListItem>
                                        <asp:ListItem Text="2018" Value="2018"></asp:ListItem>
                                        <asp:ListItem Text="2019" Value="2019"></asp:ListItem>
                                        <asp:ListItem Text="2020" Value="2020"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-2">
                                    <label>Review From Month</label>
                                    <div class="input-group date">
                                        <div class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                        <asp:TextBox ID="tb_FromDate" runat="server" required="true" CssClass="select form-control input-sm pull-right datepicker"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-xs-2">
                                    <label>.. To Month</label>
                                    <div class="input-group date">
                                        <div class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                        <asp:TextBox ID="tb_ToDate" runat="server" required="true" CssClass="select form-control input-sm pull-right datepicker"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-xs-2">
                                    <label>Name this PMS Phase</label>
                                    <asp:TextBox ID="tb_PMSPhase" runat="server" required="true" CssClass="select form-control input-sm"></asp:TextBox>
                                </div>
                                <div class="col-xs-2">
                                    <label>Start</label>
                                    <asp:DropDownList ID="ddl_PCStart" runat="server" required="true" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>

                                <div class="col-xs-2">
                                    <label>Can Lock</label>
                                    <asp:DropDownList ID="ddl_CanLock" runat="server" required="true" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-xs-2">
                                    <label>Enable Rev. Mgr Grace</label>
                                    <asp:DropDownList ID="ddl_OverallGrace" runat="server" required="true" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-2">
                                    <label>Perf. Development Plan</label>
                                    <asp:DropDownList ID="ddl_PDP" runat="server" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-2">
                                    <label>Perf. Imprv. Plan</label>
                                    <asp:DropDownList ID="ddl_PIP" runat="server" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-2">
                                    <label>Enable Polling</label>
                                    <asp:DropDownList ID="ddl_Poll" runat="server" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-2">
                                    <label>3rd Party Feedback</label>
                                    <asp:DropDownList ID="ddl_TPF" runat="server" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-2">
                                    <label>Score Discrepancy</label>
                                    <asp:DropDownList ID="ddl_ShowAutoDisc" runat="server" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Yes" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="No" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <hr />
                            <div class="row">
                                <div class="col-xs-4">
                                    <label>Slab Type</label>
                                    <asp:DropDownList ID="ddl_SlabType" runat="server" CssClass="select form-control input-sm">
                                        <asp:ListItem Text="Weighted Rating Scale (WRS)" Value="wrs" Selected="True"></asp:ListItem>
                                        <asp:ListItem Text="Slab Stack" Value="slabstack" Enabled="true"></asp:ListItem>
                                        <asp:ListItem Text="Stack" Value="stack" Enabled="true"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-xs-2">
                                    <label>
                                        <asp:Literal ID="ltlReviewButton" runat="server" Text="Create Review Period"></asp:Literal></label>
                                    <br />
                                    <asp:Button ID="btn_Submit" CssClass="btn btn-primary btn-rounded form-control" runat="server" Text="Save and Submit" OnClick="btn_Submit_Click" />
                                </div>
                                <div class="col-xs-2">
                                    <label>
                                        <asp:Literal ID="ltlReset" runat="server" Text="Reset"></asp:Literal></label>
                                    <br />
                                    <asp:Button ID="btnReset" CssClass="btn btn-info btn-rounded form-control" runat="server" Text="Reset" OnClick="btnReset_Click" />
                                </div>
                                <div class="col-xs-2">
                                    <label>Show Results</label>
                                    <br />
                                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#pnlModal">
                                        Launch primary Modal             
                                    </button>

                                </div>
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
                    <div class="box box-solid box-warning" style="height: auto;">
                        <div class="box-header with-border">
                            <h4 class="box-title">HR Admin : Modify Selected Review Period</h4>
                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="form-group">
                                <asp:GridView ID="gv_ReviewPeriods" runat="server" CssClass="table table-condensed table-responsive datatable display compact hover stripe" AutoGenerateColumns="false"
                                    OnPreRender="gv_PreRender" ShowHeader="true" OnRowCommand="gv_ReviewPeriods_RowCommand" Style="border: none">
                                    <Columns>
                                        <asp:ButtonField HeaderText="Action" ButtonType="Button" ControlStyle-CssClass="btn btn-primary btn-xs" CommandName="Select" Text=">> " />
                                        <asp:BoundField DataField="PeriodId" HeaderText="Id" />
                                        <asp:BoundField DataField="FromDate" HeaderText="From" />
                                        <asp:BoundField DataField="ToDate" HeaderText="To" />
                                        <asp:BoundField DataField="PMSPhase" HeaderText="Phase" />
                                        <asp:BoundField DataField="PCStart" HeaderText="PC Start" />
                                        <asp:BoundField DataField="PCYear" HeaderText="PC Year" />
                                        <asp:BoundField DataField="CanLock" HeaderText="Lock" />
                                        <asp:BoundField DataField="OverallGrace" HeaderText="Grace" />
                                        <asp:BoundField DataField="SlabType" HeaderText="Slab Type" />
                                    </Columns>

                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                    <!--tabcontent-->
                </div>
                <!-- /.col -->
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btn_Submit" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:Panel ID="pnlModal" runat="server" CssClass="modal modal-primary fade" Visible="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <p>
                        <asp:Label ID="lblResult" runat="server"></asp:Label>&hellip;
                    </p>
                </div>
                <div class="modal-footer">
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </asp:Panel>
</asp:Content>
<asp:Content ID="User_Scripts" ContentPlaceHolderID="below_footer" runat="Server">
    <script>
        //Date picker
        $('[class*="datepicker"]').datepicker({
            autoclose: true,
            format: 'M-yy'
        });
    </script>

</asp:Content>

