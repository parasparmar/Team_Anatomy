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
    <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
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
                    </div>

                </div>
            </div>
            <!--tabcontent-->
        </div>
        <!-- /.col -->
    </div>

    <h2 class="page-header">
        <asp:Literal ID="ltlRosterHeading" runat="server" Text="Week : "></asp:Literal></h2>
    <div class="box-body">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#tab_1" data-toggle="tab">1. Select Employee</a></li>
                    <li><a href="#tab_2" data-toggle="tab">2. Select Shifts</a></li>
                    <li><a href="#tab_3" data-toggle="tab">3. Check Status</a></li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane active" id="tab_1">
                        <asp:Panel ID="pnlRoster" runat="server" Visible="true">
                            <asp:GridView ID="gvRoster" runat="server" AutoGenerateColumns="false"
                                CssClass="table table-condensed table-responsive compact hover stripe"
                                OnPreRender="gv_PreRender" DataKeyNames="ECN" OnRowEditing="gvRoster_RowEditing"
                                OnRowUpdating="gvRoster_RowUpdating" OnRowCancelingEdit="gvRoster_RowCancelingEdit">
                                <Columns>
                                    <asp:TemplateField HeaderText="Swap With">
                                        <ItemTemplate>
                                            <asp:Button ID="btnInitiateSwap" runat="server" CommandName="Edit" CssClass="btn btn-primary" Text="Select" />
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:BoundField DataField="ECN" HeaderText="EmpID" ReadOnly="true" />
                                    <asp:BoundField DataField="NAME" HeaderText="Name" ReadOnly="true" />
                                    <asp:BoundField DataField="TEAM_LEADER" HeaderText="RepMgr" ReadOnly="true" />

                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Label ID="lbl0" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>

                                        <ItemTemplate>
                                            <asp:Label ID="lbl1" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>

                                        <ItemTemplate>
                                            <asp:Label ID="lbl2" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>

                                        <ItemTemplate>
                                            <asp:Label ID="lbl3" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>

                                        <ItemTemplate>
                                            <asp:Label ID="lbl4" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>

                                        <ItemTemplate>
                                            <asp:Label ID="lbl5" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Label ID="lbl6" runat="server"></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                    </div>
                    <!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_2">
                        <asp:Panel ID="pnlSwap" runat="server" Visible="true">
                            <asp:Repeater ID="rptrSwapForm" runat="server" OnItemDataBound="rptrSwapForm_ItemDataBound">
                                <HeaderTemplate>
                                    <table class="table table-condensed table-striped table-responsive compact hover stripe">
                                        <thead>
                                            <th>
                                                <h4>Shift Date</h4>
                                            </th>
                                            <!--Header1-->
                                            <th>
                                                <h4>
                                                    <asp:Label ID="lblEmp1"  runat="server"></asp:Label>
                                                        -<asp:Label ID="lblEmpName1"  runat="server"></asp:Label>
                                                </h4>
                                            </th>
                                            <!--Header2-->
                                            <th>
                                                <h4></h4>
                                            </th>
                                            <!--Header3-->
                                            <th>
                                                <strong>
                                                    <h4><asp:Label ID="lblEmp2" runat="server"></asp:Label>
                                                        -<asp:Label ID="lblEmpName2" runat="server"></asp:Label></h4>
                                                </strong>
                                            </th>
                                            <!--Header4-->
                                            <th>
                                                <h4>Headcount</h4>
                                            </th>
                                            <!--Header5-->
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <p></p>
                                        </td>
                                        <!--Column1-->
                                        <td>
                                            <em>Original Shift : </em>
                                            <asp:Label ID="lblOriginalShift1" CssClass="label pull-right bg-green" runat="server" Text='<%#Eval("ShiftCode1") %>'></asp:Label>

                                        </td>
                                        <!--Column2-->
                                        <td></td>
                                        <!--Column3-->
                                        <td>
                                            <em>Original Shift : </em>
                                            <asp:Label ID="lblOriginalShift2" CssClass="label pull-right bg-green" runat="server" Text='<%#Eval("ShiftCode2") %>'></asp:Label>

                                        </td>
                                        <!--Column4-->
                                        <td>
                                            <em>Pre-Swap Headcount : </em>
                                            <asp:Label ID="lblPreSwapHeadCount" CssClass="link-muted" Text='<%# Convert.ToInt32(Eval("isWorkingShift1")) + Convert.ToInt32(Eval("isWorkingShift2")) %>' runat="server"></asp:Label>

                                        </td>
                                        <!--Column5-->
                                    </tr>
                                    <!--Row1-->
                                    <tr>
                                        <td>
                                            <strong>
                                                <asp:Label ID="lblDate" runat="server" Text='<%# Convert.ToDateTime(Eval("ShiftDate1")).ToString("ddd, dd-MMM-yyyy") %>'></asp:Label>
                                            </strong>
                                        </td>
                                        <!--Column1-->
                                        <td>
                                            <asp:DropDownList ID="ddl1" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                        </td>
                                        <!--Column2-->
                                        <td>
                                            <div class="btn-group">
                                                <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                            </div>

                                        </td>
                                        <!--Column3-->
                                        <td>
                                            <asp:DropDownList ID="ddl2" runat="server" CssClass="form-control select2" Style="width: 100%"></asp:DropDownList>
                                        </td>
                                        <!--Column4-->
                                        <td>
                                            <input type="text" id="tbPostSwapHeadCount" style="width: 15%" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                        </td>
                                        <!--Column5-->

                                    </tr>
                                    <!--Row2-->
                                </ItemTemplate>
                                <FooterTemplate>
                                    </tbody>
                                </table>
                                    <div class="row-fluid">
                                        <div class="col-md-offset-8">
                                            <div class="btn-group">
                                                <asp:Button ID="btnSubmit" CssClass="btn btn-primary btn-flat" runat="server" OnClick="btnSubmit_Click" Text="Submit Shift Swap" />
                                                <asp:Button ID="btnCancel" CssClass="btn btn-warning btn-flat" runat="server" OnClick="btnCancel_Click" Text="Cancel Swap Request" />
                                            </div>
                                        </div>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>

                        </asp:Panel>
                    </div>
                    <!-- /.tab-pane -->
                    <div class="tab-pane" id="tab_3">
                    </div>
                    <!-- /.tab-pane -->
                </div>
                <!-- /.tab-content -->
            </div>
            <!-- nav-tabs-custom -->
        </div>
        <!-- /.col -->



        <br />

    </div>



    <%--</ContentTemplate>
        <Triggers>
            
        </Triggers>
    </asp:UpdatePanel>--%>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>

    <script>
        function pluginsInitializer() {

            ////Initialize DataTable Elements
            //$('.DataTable').DataTable({
            //    "sPaginationType": "full_numbers",
            //    "lengthMenu": [5, 10, 25, 50, 75, 100],
            //    "aaSortingFixed": [[0, 'asc']],
            //    "bSort": true,
            //    dom: 'Bfrltip',
            //    "columnDefs": [{ "orderable": false, "targets": 0 }],
            //    buttons: [
            //        { extend: 'copyHtml5', text: 'Copy Data' },
            //        { extend: 'excelHtml5', text: 'Export to Excel' },
            //        { extend: 'csvHtml5', text: 'Export to CSV' },
            //        { extend: 'pdfHtml5', text: 'Export to PDF' },
            //    ]
            //});

            //Initialize Select2 Elements
            $('.select2').select2({});


            $('btn[id*="btnSwapShift"]').click(function () {

                var myRow = $(this).parents('tr');

                var ddl1 = myRow.find('#ddl1');
                var ddl2 = myRow.find('#ddl2');
                var a = ddl1.val();
                var b = ddl2.val();
                //alert('Paras Original Shift : ' + a);
                //alert('Vishal Original Shift :' + b);
                // Initiate swap...

                ddl1.val(b);
                ddl1.trigger('change');

                ddl2.val(a);
                ddl2.trigger('change');

                //alert('Paras Swapped Shift : ' + ddl1.val());
                //alert('Vishal Swapped Shift : ' + ddl2.val());

            });
            $(".select2").change(function () {
                var myRow = $(this).parents('tr');
                var btnSwapShift = myRow.find("#btnSwapShift");


                var lblOriginalShift1 = myRow.prev().find('#lblOriginalShift1');
                //alert('originalShift1 : ' + lblOriginalShift1.html());

                var lblOriginalShift2 = myRow.prev().find('#lblOriginalShift2');
                // alert('originalShift2 : ' + lblOriginalShift2.html());

                var ddl1 = myRow.find('#ddl1');
                var ddl2 = myRow.find('#ddl2');

                var originalShift1 = lblOriginalShift1.text();
                var selectedShift1 = ddl1.find(':selected').first().val();
                //alert('originalShift1 : ' + originalShift1 + ' & selectedShift1 : ' + selectedShift1);


                var originalShift2 = lblOriginalShift2.text();
                var selectedShift2 = ddl2.find(':selected').first().val();

                // When the dropdownlist is changed, check if the original shift matches the selected shift.
                // check if the original shift matches the selected shift. If it does then ensure that the button is of primary class. else warning.

                var originalHC1 = 0;
                var originalHC2 = 0;
                var selectedShiftHC1 = 0;
                var selectedShiftHC2 = 0;
                if (isWorkingShift(originalShift1)) { originalHC1 = 1; } else { originalHC1 = 0; }
                if (isWorkingShift(originalShift2)) { originalHC2 = 1; } else { originalHC2 = 0; }
                if (isWorkingShift(selectedShift1)) { selectedShiftHC1 = 1; } else { selectedShiftHC1 = 0; }
                if (isWorkingShift(selectedShift2)) { selectedShiftHC2 = 1; } else { selectedShiftHC2 = 0; }
                var originalHC = parseInt(originalHC1) + parseInt(originalHC2);
                var selectedShiftHC = parseInt(selectedShiftHC1) + parseInt(selectedShiftHC2);

                var tbPostSwapHeadCount = myRow.find('#tbPostSwapHeadCount');
                tbPostSwapHeadCount.val(selectedShiftHC);

                btnSwapShift.toggleClass('btn-primary btn-warning');
                if (originalHC == selectedShiftHC) {

                    $('#btnSubmit').removeAttr('disabled');
                    $(this).enabled = true;
                    if (originalShift1 == selectedShift1) {
                        lblOriginalShift1.removeClass('bg-red');
                        lblOriginalShift1.removeClass('bg-yellow');
                        lblOriginalShift1.addClass('bg-green');

                    } else {
                        lblOriginalShift1.removeClass('bg-red');
                        lblOriginalShift1.removeClass('bg-green');
                        lblOriginalShift1.addClass('bg-yellow');
                    }

                    if (originalShift2 == selectedShift2) {
                        lblOriginalShift2.removeClass('bg-red');
                        lblOriginalShift2.removeClass('bg-yellow');
                        lblOriginalShift2.addClass('bg-green');
                    } else {
                        lblOriginalShift2.removeClass('bg-red');
                        lblOriginalShift2.removeClass('bg-green');
                        lblOriginalShift2.addClass('bg-yellow');
                    }

                } else {

                    $('#btnSubmit').attr('disabled');
                    $(this).enabled = false;
                    if (originalShift1 == selectedShift1) {
                        lblOriginalShift1.removeClass('bg-red');
                        lblOriginalShift1.removeClass('bg-yellow');
                        lblOriginalShift1.addClass('bg-green');

                    } else {
                        lblOriginalShift1.removeClass('bg-green');
                        lblOriginalShift1.removeClass('bg-yellow');
                        lblOriginalShift1.addClass('bg-red');
                    }

                    if (originalShift2 == selectedShift2) {
                        lblOriginalShift2.removeClass('bg-red');
                        lblOriginalShift2.removeClass('bg-yellow');
                        lblOriginalShift2.addClass('bg-green');
                    } else {
                        lblOriginalShift2.removeClass('bg-green');
                        lblOriginalShift2.removeClass('bg-yellow');
                        lblOriginalShift2.addClass('bg-red');
                    }

                }

                // Check if the DDL1 OR DDL2 shiftS contain WO, then HC=0, take the sum of ddl1&2_HC and populate the tbPostSwapHeadCount textbox.



            });




        }

        function isWorkingShift(Shift) {
            if (Shift.length > 0) {
                if (Shift.indexOf(":") > 0) {
                    return true;
                } else if (Shift == "W0") {
                    return false;
                } else {
                    return false;
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

                }
            });
        };
    </script>

</asp:Content>

