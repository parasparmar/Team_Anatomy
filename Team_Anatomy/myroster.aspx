<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="myroster.aspx.cs" Inherits="myroster" %>

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
        <li class="active"><a href="myroster.aspx"><i class="fa fa-calendar-check-o"></i>Roster</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-calendar-check-o"></span></div>
        <div class="pagetitle">
            <h5>View Roster, Swaps and Leaves for my Team</h5>
            <h1>My Roster</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row-fluid">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="ltlReportingMgrsTeam" Text="Roster For Team" runat="server"></asp:Literal></h4>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-3">
                            <div class="form-group">
                                Year
                                        <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlYear_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                            </div>
                        </div>
                        <!-- Roster Year-->
                        <div class="col-md-3">
                            <div class="form-group">
                                Week
                                        <asp:DropDownList ID="ddlWeek" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlWeek_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                            </div>
                        </div>
                        <!-- Roster Dates-->
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


                </div>
                <div class="box-body">
                    <asp:Panel ID="pnlRoster" runat="server" Visible="true">
                        <asp:GridView ID="gvRoster" runat="server" AutoGenerateColumns="false"
                            CssClass="table table-condensed table-responsive compact hover stripe DataTable"
                            OnPreRender="gv_PreRender">
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

    <!---LHS Panel---->


</asp:Content>
<asp:Content ID="content6" runat="server" ContentPlaceHolderID="below_footer">

    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>

    <script>
        $(function () {
            //Initialize Select2 Elements
            $('.select2').select2({
            });


        });

    </script>

</asp:Content>

