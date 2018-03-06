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
                                    CssClass="table table-condensed table-responsive compact hover stripe"
                                    OnPreRender="gv_PreRender" DataKeyNames="ECN" OnRowEditing="gvRoster_RowEditing"
                                    OnRowUpdating="gvRoster_RowUpdating" OnRowCancelingEdit="gvRoster_RowCancelingEdit">
                                    <Columns>
                                        <asp:TemplateField HeaderText ="Swap With" >
                                            <ItemTemplate>
                                                <asp:Button runat="server" CommandName="Edit" CssClass="btn btn-primary" Text="Select" />
                                            </ItemTemplate>
                                            <EditItemTemplate>
                                                <asp:Button runat="server" CommandName="Update" CssClass="btn btn-info" Text="Update" />
                                                <asp:Button runat="server" CommandName="Cancel" CssClass="btn btn-default" Text="Cancel" />
                                            </EditItemTemplate>
                                        </asp:TemplateField>
                                        

                                        <asp:BoundField DataField="ECN" HeaderText="EmpID" ReadOnly="true" />
                                        <asp:BoundField DataField="NAME" HeaderText="Name"  ReadOnly="true" />
                                        <asp:BoundField DataField="TEAM_LEADER" HeaderText="RepMgr"  ReadOnly="true" />
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="dd1" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </EditItemTemplate>
                                            
                                            <ItemTemplate>
                                                <asp:Label ID="lbl1" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="dd2" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lbl2" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="dd3" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lbl3" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="dd4" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lbl4" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="dd5" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lbl5" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="dd6" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lbl6" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <EditItemTemplate>
                                                <asp:DropDownList ID="dd7" runat="server" CssClass="input-group-sm form-control select2" Style="width: 100%"></asp:DropDownList>
                                            </EditItemTemplate>
                                            <ItemTemplate>
                                                <asp:Label ID="lbl7" runat="server"></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
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

