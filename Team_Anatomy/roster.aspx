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
            <h5>Create, Maintain and Upload Reportee Rosters</h5>
            <h1>My Team Roster</h1>
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
                            <h4 class="box-title">
                                <asp:Literal ID="ltlReportingMgrsTeam" Text="Roster For Team" runat="server"></asp:Literal></h4>
<%--                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>--%>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <asp:Panel CssClass="col-md-3" ID="pnlAmIRvwMgr" Visible="true" runat="server">
                                    <div class="form-group">
                                        Reporting Manager
                                        <asp:DropDownList ID="ddlRepManager" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlRepManager_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <!-- ddlRepManager-->
                                </asp:Panel>
                                <!-- pnlAmIRvwMgr-->
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
                            <div class="box-tools pull-right">

                                <div class="btn-group">
                                    <a class="btn btn-box-tool"><i class="fa fa-calendar-o"></i></a>
                                    <button type="button" title="Shift Planning" class="btn btn-box-tool dropdown-toggle" data-toggle="dropdown">
                                        Shift Planning
                                    </button>

                                    <ul class="dropdown-menu" role="menu">
                                        <li>
                                            <a><i class="fa fa-beer"></i>
                                                <button id="btnCompOff" class="btn btn-primary form-control disabled" style="text-align: left">Add CompOffs</button>
                                            </a>
                                        </li>
                                        <li>
                                            <a><i class="fa fa-retweet"></i>
                                                <button id="btnSwaps" class="btn btn-info form-control disabled" style="text-align: left">Add Swaps</button>
                                            </a>
                                        </li>
                                        <li>
                                            <a><i class="fa fa-plane"></i>
                                                <asp:Button ID="btnLoadLeaves" Text="Load Approved Leaves"
                                                    CssClass="btn btn-success form-control"
                                                    Style="text-align: left"
                                                    runat="server"
                                                    OnClick="btnLoadLeaves_Click"></asp:Button>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <!-- Shift Planning Tools-->

                                <div class="btn-group">
                                    <a class="btn btn-box-tool">
                                        <i class="fa fa-wrench"></i>
                                    </a>
                                    <button type="button" title="Shift Tools" class="btn btn-box-tool dropdown-toggle" data-toggle="dropdown">
                                        Shift Replication Tools
                                    </button>
                                    <ul class="dropdown-menu" role="menu">
                                        <li>
                                            <a><i class="fa fa-bars"></i>
                                                <button id="btnRows" class="btn btn-primary form-control" style="text-align: left">&nbsp Across Rows</button>
                                            </a>
                                        </li>
                                        <li>
                                            <a><i class="fa fa-columns"></i>
                                                <button id="btnColumns" class="btn btn-info form-control" style="text-align: left">&nbsp Across Columns</button>
                                            </a>
                                        </li>
                                        <li>
                                            <a><i class="fa fa-repeat"></i>
                                                <asp:Button ID="btnWeeks" Text=" From Previous Week"
                                                    CssClass="btn btn-warning form-control"
                                                    Style="text-align: left"
                                                    runat="server"
                                                    OnClick="btnWeeks_Click"></asp:Button>
                                            </a>
                                        </li>
                                    </ul>
                                </div>
                                <!-- Shift Replication Tools-->

                                <div class="btn-group">
                                    <a class="btn btn-box-tool"><i class="fa fa-calendar-o"></i></a>
                                    <button type="button" title="Shift Planning" class="btn btn-box-tool dropdown-toggle" data-toggle="dropdown">
                                        Roster Rules
                                    </button>
                                    <ul class="dropdown-menu" role="menu">
                                        <li class="input-group">
                                            <span class="input-group-addon">
                                                <input id="cbxDualWorkoffs" type="checkbox" runat="server">
                                            </span>
                                            <button id="btnDualWorkoffs"
                                                class="btn btn-primary form-control" style="text-align: left"
                                                title="Min 1 and Max 2 Workoffs per employee per week">
                                                WO's Between 1 & 2
                                            </button>
                                        </li>
                                        <li class="input-group">
                                            <span class="input-group-addon">
                                                <input id="cbxCancelledLeaves" type="checkbox" runat="server">
                                            </span>
                                            <asp:Button ID="btnCancelledLeaves" CssClass="btn btn-primary form-control" runat="server"
                                                Style="text-align: left" ToolTip="See User Cancelled Leaves" Text="Load Cancelled Leaves"
                                                OnClick="btnCancelledLeaves_Click"></asp:Button>
                                        </li>

                                    </ul>
                                </div>
                                <!-- Roster Rules Validation-->
                            </div>

                        </div>
                        <div class="box-body">
                            <asp:Panel ID="pnlRoster" runat="server" Visible="true">
                                <asp:GridView ID="gvRoster" runat="server" AutoGenerateColumns="false"
                                    CssClass="table table-condensed table-responsive compact hover stripe"
                                    OnPreRender="gv_PreRender" DataKeyNames="EmpID">
                                    <Columns>
                                        <asp:BoundField DataField="EmpID" HeaderText="EmpID" />
                                        <asp:BoundField DataField="EmpName" HeaderText="Name" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd1" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd2" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd3" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd4" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd5" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd6" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd7" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                    </Columns>
                                </asp:GridView>
                            </asp:Panel>
                        </div>
                        <div class="box-footer">
                            <asp:Button ID="btnSubmit" Text="Update" runat="server" CssClass="btn btn-primary" OnClick="btnSubmit_Click" />
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
            //Date picker
            $(".datepicker").datepicker({
                autoclose: true,
                format: 'dd-M-yyyy'
            });

            //$().toastr({
            //    "closeButton": false,
            //    "debug": false,
            //    "newestOnTop": false,
            //    "progressBar": true,
            //    "positionClass": "toast-top-right",
            //    "preventDuplicates": true,
            //    "onclick": null,
            //    "showDuration": "300",
            //    "hideDuration": "1000",
            //    "timeOut": "5000",
            //    "extendedTimeOut": "1000",
            //    "showEasing": "swing",
            //    "hideEasing": "linear",
            //    "showMethod": "fadeIn",
            //    "hideMethod": "fadeOut"
            //});

            // Replication Code for Columns. 
            //03-Sep-2017 2.24 AM In Production support : paras.parmar@sitel.com
            var i = 0;
            $("#btnColumns").click(function () {
                //$("#btnRows").click(function () {
                var myShift = 0;
                $("#gvRoster tr:gt(0)").addClass("bg-teal-active").each(function () {

                    $(this).find('td:gt(1):lt(7)').each(function (i) {
                        if (i == 0) {
                            myShift = $(this).find('[class*="select2"]').val();
                        }
                        else {
                            $(this).addClass("bg-teal").find('[class*="select2"]').val(myShift).trigger('change.select2');
                        }

                    });
                });
            });
            // Replication Code for Rows. 
            //03-Sep-2017 01.07 AM In Production support : paras.parmar@sitel.com            
            $("#btnRows").click(function () {
                //$("#btnColumns").click(function () {
                var myShift = [];
                $("#gvRoster tr:nth-child(1) td:gt(1):lt(7)").each(function () {
                    myShift.push($(this).find('[class*="select2"]').val());
                });

                //alert(myShift);

                $("#gvRoster tr:gt(0)").each(function () {
                    $(this).find('td:gt(1):lt(7)').each(function (j) { $(this).find('[class*="select2"]').val(myShift[j]).trigger('change.select2') });
                });

            });

            $("#btnDualWorkoffs").click(function () {
                var myShift = 0;

                $('#gvRoster tr:gt(0)').each(function () {
                    myShift = 0;
                    $(this).find("td:gt(1):lt(7) .select2 :selected").each(function () {
                        if ($(this).val() == "49") {
                            // add the working days in a week.
                            myShift++;
                            $(this).closest("td").addClass("bg-teal");
                        }
                        if (myShift < 1 || myShift > 2) {
                            $(this).closest("td").addClass("bg-orange");
                        }
                    });
                });
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
                    $('.DataTable').DataTable({
                        "sPaginationType": "full_numbers",
                        "lengthMenu": [5, 10, 25, 50, 75, 100],
                        "aaSortingFixed": [[0, 'asc']],
                        "bSort": true,
                        dom: 'Bfrltip',
                        "columnDefs": [{ "orderable": false, "targets": 0 }],
                        buttons: [
                            { extend: 'copyHtml5', text: 'Copy Data' },
                            { extend: 'excelHtml5', text: 'Export to Excel' },
                            { extend: 'csvHtml5', text: 'Export to CSV' },
                            { extend: 'pdfHtml5', text: 'Export to PDF' },
                        ]
                    });
                }
            });
        };
    </script>

</asp:Content>

