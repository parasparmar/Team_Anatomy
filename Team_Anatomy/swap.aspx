<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="swap.aspx.cs" Inherits="swap" %>

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

        .content-wrapper {
            min-height: 897.76px !important;
        }

        .border-between > [class*='col-']:first-child:before {
            display: none;
        }
    </style>
    <script type="text/javascript">
function SetMyID(xID) {
                $('#xMyID').val(xID);

            }
    </script>

</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="roster.aspx"><i class="fa fa-exchange"></i>Shift Swaps</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-exchange"></span></div>
        <div class="pagetitle">
            <h5>Request and Negotiate Shift Swaps for Future Dated Rosters</h5>
            <h1>Shift Swaps</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>--%>
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
                    <asp:Panel ID="pnl1" runat="server" Visible="true" CssClass="row">
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
                        <div class="col-md-3">
                            <div class="form-group">
                                My Role
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true">
                                    <asp:ListItem Selected="True" Text="Employee" Value="Employee"></asp:ListItem>
                                    <asp:ListItem Text="Reporting Manager" Value="Reporting_Manager"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <!-- Role Selection-->
                    </asp:Panel>
                    <!--Roster Wise View-->
                </div>
            </div>
            <!--tabcontent-->
        </div>
        <!-- /.col -->
    </div>
    <asp:Panel ID="pnl2" runat="server" CssClass="row-fluid" Visible="true">
        <div class="col-md-12">
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="ltlRosterHeading" runat="server" Text="Week : "></asp:Literal>
                        <asp:Button ID="btnSubmit" runat="server" CssClass="btn btn-info" OnClick="btnSubmit_Click" />
                    </h4>
                </div>
                <div class="box-body">
                    <div class="row">
                        <asp:HiddenField ID="xMyID" runat="server" Value="" />

                        <div id="dvRoster" class="col-md-12" runat="server">
                            <%--<asp:Table ID="tblRoster" runat="server" CssClass="xcls datatable table table-responsive table-condensed">--%>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="Panel1" runat="server" CssClass="row-fluid" Visible="true">
        <div class="col-md-12">
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="Literal1" runat="server" Text="Week : "></asp:Literal><asp:Button ID="Button1" runat="server" CssClass="btn btn-info" />
                    </h4>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div id="dvSwap" class="col-md-12" runat="server">
                            <%--<asp:Table ID="tblRoster" runat="server" CssClass="xcls datatable table table-responsive table-condensed">--%>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </asp:Panel>
    <asp:Panel runat="server" ID="pnl3" CssClass="row-fluid" Visible="false">
    </asp:Panel>
    <%--</ContentTemplate>
        <Triggers>
        </Triggers>
    </asp:UpdatePanel>--%>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>

    <script type="text/javascript">

        function pluginsInitializer() {

            //Initialize Select2 Elements
            $('.select2').select2({});
            // Bind an event
            $('.select2[id*="ddl"]').on('select2:select', function (e) {
                var ddlX = $(this).attr('id')
                var myID = ddlX.substring(ddlX.length - 1);

                var data = e.params.data;
                var lblOriginalShift = "lbl" + myID;
                var lblSelectedShift = "Newlbl" + myID;
                var HiddenField = "hf" + myID;
                $("#" + lblSelectedShift).text(data.text);
                $("#" + HiddenField).val(data.id);
                //alert(myID + " Set ID : " + $("#" + HiddenField).val() + " value : " + $("#" + lblSelectedShift).text());
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

                    $('.Datatable').DataTable({
                        "sPaginationType": "full_numbers",
                        "lengthMenu": [5, 10, 25, 50, 75, 100],
                        "aaSortingFixed": [[0, 'asc']],
                        "bSort": true,
                        dom: 'Bfrltip',
                        "columnDefs": [{ "orderable": false, "targets": 0 }],
                    });
                }
            });
        };
    </script>

</asp:Content>

