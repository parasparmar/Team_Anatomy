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
                                <label>Replicate Shifts across all : </label>
                                <div class="btn-group">
                                    <asp:Button ID="btnCopyToAllRows" CssClass="btn btn-sm btn-warning" Text="Rows" runat="server" />
                                    <asp:Button ID="btnCopyToAllColumns" CssClass="btn btn-sm btn-info" Text="Columns" runat="server" />
                                </div>
                                <div class="btn-group">
                                    <button type="button" class="btn btn-box-tool dropdown-toggle" data-toggle="dropdown">
                                        <i class="fa fa-wrench"></i>
                                    </button>
                                    <ul class="dropdown-menu" role="menu">
                                        <li><a href="#">Replicate Shifts across Rows</a></li>
                                        <li><a href="#">Replicate Shifts across Columns</a></li>
                                    </ul>
                                </div>
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <asp:Panel ID="pnlRoster" runat="server" Visible="true">

                                <asp:GridView ID="gvRoster" runat="server" AutoGenerateColumns="false"
                                    CssClass="table table-condensed table-responsive  display compact hover stripe"
                                    OnPreRender="gv_PreRender">
                                    <Columns>

                                        <asp:BoundField DataField="EmpID" HeaderText="EmpID" />
                                        <asp:BoundField DataField="EmpName" HeaderText="Name" />
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd1" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd2" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd3" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd4" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd5" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd6" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>

                                            <ItemTemplate>
                                                <asp:DropDownList ID="dd7" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
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

