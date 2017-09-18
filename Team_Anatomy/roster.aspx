<%@ Page Title="Roster" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="roster.aspx.cs" Inherits="roster" %>

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
        <li class="active"><a href="roster.aspx"><i class="fa fa-calendar-check-o"></i>Roster</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-calendar-check-o"></span></div>
        <div class="pagetitle">
            <h5>Create, Maintain and Upload Reportee Rosters, Swaps and Leaves</h5>
            <h1>Roster</h1>
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
                            <h4 class="box-title">Roster for Team :
                                <asp:Literal ID="ltlReportingMgrsTeam" runat="server"></asp:Literal></h4>
                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <asp:Panel CssClass ="col-md-3" ID="pnlAmIRvwMgr" Visible="true" runat="server">
                                    <div class="form-group">
                                        Reporting Manager
                                        <asp:DropDownList ID="ddlRepManager" runat="server" CssClass="form-control select2" Style="width: 100%;"  AutoPostBack="true" OnSelectedIndexChanged="ddlRepManager_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div><!-- ddlRepManager-->
                                </asp:Panel><!-- pnlAmIRvwMgr-->
                                
                                <div class="col-md-3">
                                    <div class="form-group">
                                        Roster for Week Beginning
                                        <asp:DropDownList ID="ddlWeek" runat="server" CssClass="form-control select2" Style="width: 100%;"  AutoPostBack="true" OnSelectedIndexChanged="ddlWeek_SelectedIndexChanged">
                                        </asp:DropDownList>
                                    </div>
                                </div>
                                <!-- ddlRepManager-->
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
                                <asp:Literal ID="ltlRosterHeading" runat="server" Text="Week : "></asp:Literal></h4>
                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <asp:Panel ID="pnlRoster" runat="server" Visible="true">
                                <asp:GridView ID="gvRoster" runat="server" AutoGenerateColumns="true" CssClass="dataTable">
                                </asp:GridView>
                            </asp:Panel>
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

