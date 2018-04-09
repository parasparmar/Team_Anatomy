<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="swap_p.aspx.cs" Inherits="swap_p" %>

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
    <script>
        function RadioCheck(rb) {
            var gv = document.getElementById("<%=gvRoster.ClientID%>");
            var rbs = gv.getElementsByTagName("input");

            var row = rb.parentNode.parentNode;
            for (var i = 0; i < rbs.length; i++) {
                if (rbs[i].type == "radio") {
                    if (rbs[i].checked && rbs[i] != rb) {
                        rbs[i].checked = false;
                        break;
                    }
                }
            }
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
                    </div>
                </div>
            </div>
            <!--tabcontent-->
        </div>
        <!-- /.col -->
    </div>
    <!--Swap Stage 1-->

    <div class="row-fluid">
        <div class="col-md-12">
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="ltlRosterHeading" runat="server" Text="Week : "></asp:Literal>
                    </h4>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-12">
                            <asp:HiddenField ID="hfSwapSelection" runat="server" />
                            <asp:GridView ID="gvRoster" runat="server" AutoGenerateColumns="false"
                                CssClass="table table-condensed table-responsive compact hover stripe"
                                OnPreRender="gv_PreRender" DataKeyNames="ECN" GridLines="None"
                                OnRowEditing="gvRoster_RowEditing"
                                OnRowDataBound="gvRoster_RowDataBound">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:RadioButton ID="rdSelect" Text='<%#Eval("ECN")%>' ForeColor="White" GroupName="swapPartner" Checked="false" runat="server" onclick="RadioCheck(this);" AutoPostBack="true" OnCheckedChanged="rdSelect_CheckedChanged" />
                                            <asp:HiddenField ID="HiddenField1" runat="server" Value='<%#Eval("ECN")%>' />

                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ECN" HeaderText="EmpID" ReadOnly="true" />
                                    <asp:BoundField DataField="NAME" HeaderText="Name" ReadOnly="true" />
                                    <asp:TemplateField ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl0" Text='<%# Eval(dtSwapRosterWFormattedDates.Columns[3].ColumnName.ToString()) %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl1" Text='<%# Eval(dtSwapRosterWFormattedDates.Columns[4].ColumnName.ToString()) %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl2" Text='<%# Eval(dtSwapRosterWFormattedDates.Columns[5].ColumnName.ToString()) %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl3" Text='<%# Eval(dtSwapRosterWFormattedDates.Columns[6].ColumnName.ToString()) %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl4" Text='<%# Eval(dtSwapRosterWFormattedDates.Columns[7].ColumnName.ToString()) %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl5" Text='<%# Eval(dtSwapRosterWFormattedDates.Columns[8].ColumnName.ToString()) %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-Width="110px">
                                        <ItemTemplate>
                                            <asp:Label ID="lbl6" Text='<%# Eval(dtSwapRosterWFormattedDates.Columns[9].ColumnName.ToString()) %>' runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--Swap Stage 2-->

    <div class="row-fluid">
        <div class="col-md-12">
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="Literal1" runat="server" Text="Week : "></asp:Literal>
                    </h4>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <asp:Panel ID="pnlStage3" runat="server" class="box-body" Visible="true">
                    <div class="row">
                        <div class="col-md-12">
                            <asp:Repeater ID="rptSwapStage2" runat="server" OnItemDataBound="rptSwapStage2_ItemDataBound">
                                <HeaderTemplate>
                                    <table id="tblSwapStage2" class="table table-condensed table-hover table-responsive table-striped">
                                        <thead>
                                            <tr>
                                                <th>
                                                    <asp:Label ID="h1" runat="server"></asp:Label></th>
                                                <th>
                                                    <asp:Label ID="h2" runat="server"></asp:Label></th>
                                                <th style="width: 110px">
                                                    <asp:Label ID="h3" runat="server"></asp:Label></th>
                                                <th style="width: 110px">
                                                    <asp:Label ID="h4" runat="server"></asp:Label></th>
                                                <th style="width: 110px">
                                                    <asp:Label ID="h5" runat="server"></asp:Label></th>
                                                <th style="width: 110px">
                                                    <asp:Label ID="h6" runat="server"></asp:Label></th>
                                                <th style="width: 110px">
                                                    <asp:Label ID="h7" runat="server"></asp:Label></th>
                                                <th style="width: 110px">
                                                    <asp:Label ID="h8" runat="server"></asp:Label></th>
                                                <th style="width: 110px">
                                                    <asp:Label ID="h9" runat="server"></asp:Label></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <asp:Label ID="ddl1" runat="server"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="ddl2" runat="server"></asp:Label>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBefore3" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                            <asp:Label ID="lblAfter3" runat="server" CssClass="label pull-right bg-yellow"></asp:Label>
                                            <asp:DropDownList ID="ddl3" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBefore4" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                            <asp:Label ID="lblAfter4" runat="server" CssClass="label pull-right bg-yellow"></asp:Label>
                                            <asp:DropDownList ID="ddl4" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBefore5" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                            <asp:Label ID="lblAfter5" runat="server" CssClass="label pull-right bg-yellow"></asp:Label>
                                            <asp:DropDownList ID="ddl5" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBefore6" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                            <asp:Label ID="lblAfter6" runat="server" CssClass="label pull-right bg-yellow"></asp:Label>
                                            <asp:DropDownList ID="ddl6" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBefore7" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                            <asp:Label ID="lblAfter7" runat="server" CssClass="label pull-right bg-yellow"></asp:Label>
                                            <asp:DropDownList ID="ddl7" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBefore8" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                            <asp:Label ID="lblAfter8" runat="server" CssClass="label pull-right bg-yellow"></asp:Label>
                                            <asp:DropDownList ID="ddl8" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </td>
                                        <td>
                                            <asp:Label ID="lblBefore9" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                            <asp:Label ID="lblAfter9" runat="server" CssClass="label pull-right bg-yellow"></asp:Label>
                                            <asp:DropDownList ID="ddl9" runat="server" CssClass="form-control"></asp:DropDownList>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </tbody>                                    
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="col-md-12">
                            <div class="box-footer">
                                <div class="btn-group">
                                    <asp:Button ID="btnSubmitStage3" Text="Confirmed" runat="server" CssClass="btn btn-primary disabled" />
                                    <asp:Button ID="btnCancelStage3" Text="Cancel" runat="server" CssClass="btn btn-warning disabled" />
                                </div>
                            </div>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
    <!--Swap Stage 3-->

    <div class="row-fluid">
        <div class="col-md-12">
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="Literal2" runat="server" Text="Week : "></asp:Literal>
                    </h4>
                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-12">
                            <asp:GridView ID="gvStage3" runat="server" AutoGenerateColumns="true"
                                CssClass="table table-condensed table-responsive table-compact table-hover table-stripe"
                                OnPreRender="gv_PreRender" DataKeyNames="ECN" GridLines="None">
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--Swap Stage 4-->

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

            // Bind the validation events to the labels
            $('[id^="ddl"]').change(function () {
                var MyRow = $(this).closest("tr");
                var index = MyRow.index();

                ShiftSwapper($(this), index);
            });

            function ShiftSwapper(ddlX, index) {
                var toggle = 0;
                if (index == 1) { toggle = 0; } else { toggle = 1; }

                var SelectedShift = ddlX.val();
                var ddlID = ddlX.attr('id');
                var myID = ddlID.substring(ddlID.length - 1);
                if (parseInt(myID)) {
                    
                    var theID = '[id^="lblBefore' + + myID + '"]' ;                    
                    var lblBeforeShift = $(theID).eq(index);
                    var BeforeShift = lblBeforeShift.text();
                    
                    theID = '[id^="lblAfter' + + myID + '"]';
                    var lblAfterShift = $(theID).eq(index);
                    lblAfterShift.text("");
                    if (BeforeShift != SelectedShift) {
                        lblAfterShift.text(SelectedShift);
                    }
                }
            }

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

