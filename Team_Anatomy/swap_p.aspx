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
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <div class="box-tools pull-left">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                    <h4 class="box-title">Swap Dashboard : Approve or Decline Pending Swap Requests.
                    </h4>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-12">
                            <asp:GridView ID="gvSwapStatus" CssClass="table table-condensed table-bordered table-responsive"
                                runat="server" AutoGenerateColumns="false"
                                DataKeyNames="Id">
                                <Columns>
                                    <asp:BoundField DataField="Id" HeaderText="Id" />
                                    <asp:BoundField DataField="Date" HeaderText="Swap Date" DataFormatString="{0:ddd, dd-MMM-yyyy}" />
                                    <asp:BoundField DataField="OriginalShift" HeaderText="Initiatior's Shift" />
                                    <asp:BoundField DataField="SwappedShift" HeaderText="Partner's Shift" />
                                    <asp:BoundField DataField="EmpCode1" HeaderText="EmpCode" />
                                    <asp:BoundField DataField="Initiator" HeaderText="Swap Initiator" />
                                    <asp:BoundField DataField="EmpCode2" HeaderText="Partner" />
                                    <asp:BoundField DataField="Approver" HeaderText="Swap Partner" />
                                    <asp:BoundField DataField="RepMgrCode" HeaderText="RM" />
                                    <asp:BoundField DataField="RepMgr" HeaderText="Reporting Manager" />
                                    <asp:BoundField DataField="InitiatedOn" HeaderText="Initiated" DataFormatString="{0:dd-MMM-yyyy HH:mm}" />

                                    <asp:TemplateField HeaderText="Status">
                                        <ItemTemplate>
                                            <asp:Panel ID="pnlPendingActions" CssClass="btn-group" Visible="false" runat="server">
                                                <asp:Button ID="btnApprove" runat="server" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-success btn-sm"
                                                    Text="Approve" BorderWidth="1"
                                                    OnClick="btnApprove_Click" />
                                                <asp:Button ID="btnDecline" runat="server" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-danger btn-sm"
                                                    Text="Decline" BorderWidth="1"
                                                    OnClick="btnDecline_Click" />
                                            </asp:Panel>
                                            <asp:Panel ID="pnlSwapInformation" Visible="false" runat="server">
                                                <asp:Label ID="lblSwapInformation" runat="server" ToolTip='<%# Eval("Id") %>' Text="Status : "></asp:Label>
                                            </asp:Panel>
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
    <!--Swap Stage 1 : Swap Dashboard : View, Approve or Decline Swaps-->

    <div class="row-fluid">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="ltlReportingMgrsTeam" Text="Step 1 : Swap Basics" runat="server"></asp:Literal></h4>
                    <div class="box-tools pull-left">
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
                                <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlRole_SelectedIndexChanged">
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
                    <h4 class="box-title">Step 2 : Select your Shift Swap Partner
                    </h4>
                    <div class="box-tools pull-left">
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
                                <EmptyDataTemplate>
                                    <h4>The Roster for the Selected Week could not be found. Kindly do check with your reporting manager.</h4>
                                </EmptyDataTemplate>
                            </asp:GridView>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--Swap Stage 2: Select the Swap Partner-->

    <div class="row-fluid">
        <div class="col-md-12">
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="ltlSwapInitiator" runat="server" Text="Step 3 : Initiate the Swap Request"></asp:Literal>
                    </h4>
                    <div class="box-tools pull-left">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>
                </div>
                <div class="box-body">
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
                                    <tfoot>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblHCBefore1" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <asp:Label ID="lblHCBefore2" runat="server"></asp:Label>
                                            </td>
                                            <td>
                                                <i class="fa fa-exchange">
                                                    <asp:Label ID="lblHCBefore3" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                                    <asp:Label ID="lblHCAfter3" runat="server" CssClass="label  bg-yellow"></asp:Label>
                                                </i>
                                            </td>
                                            <td>
                                                <i class="fa fa-exchange">
                                                    <asp:Label ID="lblHCBefore4" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                                    <asp:Label ID="lblHCAfter4" runat="server" CssClass="label  bg-yellow"></asp:Label>
                                                </i>
                                            </td>
                                            <td>
                                                <i class="fa fa-exchange">
                                                    <asp:Label ID="lblHCBefore5" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                                    <asp:Label ID="lblHCAfter5" runat="server" CssClass="label  bg-yellow"></asp:Label>
                                                </i>
                                            </td>
                                            <td>
                                                <i class="fa fa-exchange">
                                                    <asp:Label ID="lblHCBefore6" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                                    <asp:Label ID="lblHCAfter6" runat="server" CssClass="label  bg-yellow"></asp:Label>
                                                </i>
                                            </td>
                                            <td>
                                                <i class="fa fa-exchange">
                                                    <asp:Label ID="lblHCBefore7" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                                    <asp:Label ID="lblHCAfter7" runat="server" CssClass="label  bg-yellow"></asp:Label>
                                                </i>
                                            </td>
                                            <td>
                                                <i class="fa fa-exchange">
                                                    <asp:Label ID="lblHCBefore8" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                                    <asp:Label ID="lblHCAfter8" runat="server" CssClass="label  bg-yellow"></asp:Label>
                                                </i>
                                            </td>
                                            <td>
                                                <i class="fa fa-exchange">
                                                    <asp:Label ID="lblHCBefore9" runat="server" CssClass="label pull-left bg-green"></asp:Label>
                                                    <asp:Label ID="lblHCAfter9" runat="server" CssClass="label  bg-yellow"></asp:Label>
                                                </i>
                                            </td>
                                        </tr>
                                    </tfoot>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                        <div class="col-md-12">
                            <div class="box-footer">
                                <div id="dvHelpfulMessage" class="col-md-9 alert alert-warning" style="display: none">
                                    <h4 id="headingHelpfulMessage"><i id="iconHelpfulMessage" class="icon fa fa-warning"></i>Please Note!</h4>
                                    <div id="lblHelpfulMessage"></div>
                                </div>
                                <div id="dvEnableSubmission" class="col-md-3 alert" style="display: none">
                                    <div class="btn-group">
                                        <asp:Button ID="btnSubmitStage3" Text="Confirmed" runat="server" CssClass="btn btn-primary" OnClick="btnSubmitStage3_Click" />
                                        <asp:Button ID="btnCancelStage3" Text="Cancel" runat="server" CssClass="btn btn-warning" OnClick="btnCancelStage3_Click" />
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--Swap Stage 3 : Initiate a Swap Request-->



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
                var Row = $(this).closest("tr");

                var index = Row.index();
                var AmICompliant = true;
                AmICompliant = ShiftSwapper($(this), index);
                var dvEnableSubmission = $("#dvEnableSubmission");
                if (AmICompliant == true) {
                    dvEnableSubmission.show();
                } else {
                    dvEnableSubmission.hide();
                }
            });
            function ShiftSwapper(ddlX, index) {
                var toggle = 0;
                var MyRow;
                var PartnersRow;
                if (index == 1) {
                    toggle = 0;
                    PartnersRow = ddlX.closest("tr");
                    MyRow = PartnersRow.prev();
                } else {
                    toggle = 1;
                    MyRow = ddlX.closest("tr");
                    PartnersRow = MyRow.next();
                }
                var SelectedShift = ddlX.val();
                var ddlID = ddlX.attr('id');
                var myID = ddlID.substring(ddlID.length - 1);
                if (parseInt(myID)) {
                    // Get the Selected shift of the partner's dropdown
                    var theID = '[id ^= "ddl' + myID + '"]';
                    var ddlY = $(theID).eq(toggle);
                    var SelectedShift2 = ddlY.val();

                    // Get the Before shift of my dropdown
                    theID = '[id^="lblBefore' + myID + '"]';
                    var lblBeforeShift = $(theID).eq(index);
                    var BeforeShift = lblBeforeShift.text();


                    // Get the Before shift of the partner's dropdown
                    var lblBeforeShift2 = $(theID).eq(toggle);
                    var BeforeShift2 = lblBeforeShift2.text();

                    // Blank out the AfterShift of my label
                    theID = '[id^="lblAfter' + myID + '"]';
                    var lblAfterShift = $(theID).eq(index);
                    lblAfterShift.text("");

                    // Blank out the AfterShift of my partner's dropdown
                    var lblAfterShift2 = $(theID).eq(toggle);
                    var AfterShift2 = lblAfterShift2.text();

                    // Get the Before Headcount.
                    theID = '[id^="lblHCBefore' + myID + '"]';
                    var lblHCBefore = $(theID);
                    var HCBefore = parseInt(lblHCBefore.text());

                    // Get the handle to the label of the After Headcount.
                    theID = '[id^="lblHCAfter' + myID + '"]';
                    var lblHCAfter = $(theID);
                    var HCAfter = parseInt(lblHCAfter.text());

                    // The only case where we need to calculate headcounts and set labels.
                    lblAfterShift.text(SelectedShift);
                    lblAfterShift2.text(SelectedShift2);


                    // Get the handle to the HelpfulMessage and it's components.
                    var lblHelpfulMessage = $("#lblHelpfulMessage");
                    var dvHelpfulMessage = $("#dvHelpfulMessage");
                    var headingHelpfulMessage = $("#headingHelpfulMessage");
                    var iconHelpfulMessage = $("#iconHelpfulMessage");
                    var dvEnableSubmission = $("dvEnableSubmission");



                    var Compliance = new Object;
                    var message = new Array();
                    Compliance.RuleOfLegalShiftSwaps = RuleOfLegalShiftSwaps(message);
                    Compliance.RuleOfHeadCountInvariance = RuleOfHeadCountInvariance(message);
                    Compliance.RuleOfWorkOffsInvariance = RuleOfWorkOffsInvariance(message);


                    if (Compliance.RuleOfLegalShiftSwaps && Compliance.RuleOfHeadCountInvariance && Compliance.RuleOfWorkOffsInvariance) {
                        AmICompliant = true;
                        dvHelpfulMessage.removeClass("alert-warning");
                        dvHelpfulMessage.addClass("alert-success");
                        iconHelpfulMessage.removeClass("fa-warning");
                        iconHelpfulMessage.addClass("fa-check-square");
                        dvHelpfulMessage.show();
                        dvEnableSubmission.show();
                        headingHelpfulMessage.text("Passed");
                        headingHelpfulMessage.prepend('<i id="iconHelpfulMessage" class="icon fa fa-check-square"></i>');
                    }
                    else {
                        AmICompliant = false;
                        dvHelpfulMessage.removeClass("alert-success");
                        dvHelpfulMessage.addClass("alert-warning");
                        iconHelpfulMessage.removeClass("fa-check-square");
                        iconHelpfulMessage.addClass("fa-warning");
                        dvHelpfulMessage.show();
                        dvEnableSubmission.show();
                    }
                    MessageWriter();
                    return AmICompliant;
                }
                function MessageWriter() {
                    lblHelpfulMessage.text("");
                    lblHelpfulMessage.append("<ul>");
                    for (m in message) {
                        lblHelpfulMessage.append("<li>" + message[m] + "</li>");
                    }
                    lblHelpfulMessage.append("</ul>");
                }
                function RuleOfLegalShiftSwaps(message) {

                    // Stage1 : Validate the Rule of Legal Swap - per change request.
                    if (SelectedShift == BeforeShift2 && SelectedShift2 == BeforeShift) {

                        // Remove warnings
                        lblAfterShift.removeClass("bg-red");
                        lblAfterShift.addClass("bg-yellow");
                        message.push("Legal Shift Swaps : Passed.");
                        return true;
                    } else if (SelectedShift != BeforeShift2) {
                        // Remove warnings
                        lblAfterShift.removeClass("bg-red");
                        lblAfterShift.addClass("bg-yellow");
                        message.push("Legal Shift Swaps : Failed. Your Shift Swap is not valid.");
                        return false;
                    }
                    else if (SelectedShift2 != BeforeShift) {
                        // Remove warnings
                        lblAfterShift.removeClass("bg-red");
                        lblAfterShift.addClass("bg-yellow");
                        message.push("Legal Shift Swaps : Failed. Your Partner's Shift Swap is not valid.");
                        return false;
                    }
                    else {
                        // Set warnings
                        lblAfterShift.text("Un-Actionable Swap");
                        lblAfterShift.removeClass("bg-yellow");
                        lblAfterShift.addClass("bg-red");
                        message.push("Legal Shift Swaps : Failed. Un-Actionable Swap");
                        return false;
                    }
                }
                //Checks for daily Headcount invariance.
                function RuleOfHeadCountInvariance(message) {
                    // Set the HCAfter
                    HCAfter = parseInt(isWorkingShift(SelectedShift) + isWorkingShift(SelectedShift2));
                    lblHCAfter.text(HCAfter);

                    if (HCBefore != HCAfter) {
                        //set warning
                        lblHCAfter.removeClass("bg-yellow");
                        lblHCAfter.addClass("bg-red");
                        message.push("Headcount Invariance : Failed. The Pre and Post Swap Headcounts are different. Swaps are only allowed when the headcount does not change.");

                        return false;
                    } else {
                        //remove warning
                        lblHCAfter.removeClass("bg-red");
                        lblHCAfter.addClass("bg-yellow");
                        message.push("Headcount Invariance : Passed.");
                        return true;
                    }
                }
                function RuleOfWorkOffsInvariance(message) {

                    function WOCounter(TheRow) {
                        var WOCount = 0;
                        var MyShift;
                        TheRow.each(function (e) {

                            // If the ddl selected is an input..
                            if ($(this).is('input,select,textarea')) {
                                MyShift = $(this).val();
                            } else {
                                // If the ddl selected is an text type..
                                MyShift = $(this).html();
                            }

                            if (MyShift.toUpperCase().trim() === "WO") {
                                WOCount++;
                            }

                        });
                        return WOCount;
                    }


                    var MyShifts = MyRow.find('[id^="ddl"]');

                    var MyPartnersShifts = PartnersRow.find('[id^="ddl"]');
                    var MyRosteredShifts = MyRow.find('[id^="lblBefore"]');
                    var PartnersRosteredShifts = PartnersRow.find('[id^="lblBefore"]');

                    var MyWOs = 0;
                    var MyRosteredWOs = 0;
                    var PartnersWOs = 0;
                    var PartnersRosteredWOs = 0;

                    MyWOs = WOCounter(MyShifts);
                    MyRosteredWOs = WOCounter(MyRosteredShifts);

                    PartnersWOs = WOCounter(MyPartnersShifts);
                    PartnersRosteredWOs = WOCounter(PartnersRosteredShifts);

                    // What's the count of WOs after the selected shifts are swapped.
                    if (MyWOs < 1) { message.push("Workoff Checks : Failed. Post the swap, you have " + MyWOs + " WorkOffs of the minimum 1 allowed."); }
                    if (MyWOs > 2) { message.push("Workoff Checks : Failed. Post the swap, you have " + MyWOs + " WorkOffs of the maximum 2 allowed."); }
                    if (PartnersWOs < 1) { message.push("Workoff Checks : Failed. Post the swap, your swap Partner has " + MyWOs + " WorkOffs of the minimum 1 allowed."); }
                    if (PartnersWOs > 2) { message.push("Workoff Checks : Failed. Post the swap, your swap Partner has " + MyWOs + " WorkOffs of the maximum 2 allowed."); }

                    if (MyWOs != MyRosteredWOs) { message.push("Workoff Checks : Failed. You were rostered " + MyRosteredWOs + " WorkOffs and have " + MyWOs + " now. Are you sure?"); }
                    if (PartnersWOs != PartnersRosteredWOs) { message.push("Workoff Checks : Failed. Your Partner was rostered " + MyRosteredWOs + " WorkOffs and has " + PartnersWOs + " now. Are you sure?"); }

                    if (MyWOs >= 1 && MyWOs <= 2 && PartnersWOs >= 1 && PartnersWOs <= 2 && MyWOs == MyRosteredWOs && PartnersWOs == PartnersRosteredWOs) {
                        message.push("Workoff Checks : Passed.");
                        return true;
                    } else {
                        return false;
                    }
                }

                function isWorkingShift(SelectedShift) {
                    if (/[0-9]{2}:[0-9]{2}/.test(SelectedShift)) { return 1; }
                    else { return 0; }
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

