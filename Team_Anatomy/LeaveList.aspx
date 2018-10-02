<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="LeaveList.aspx.cs" Inherits="LeaveList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <link href="Sitel/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="AdminLTE/plugins/iCheck/all.css">
    <link href="Sitel/cdn/yadcf/jquery.dataTables.yadcf.css" rel="stylesheet" />
    <link href="Sitel/cdn/cdn.datatables.net/1.10.15/css/fixedColumns.dataTables.min.css" rel="stylesheet" />
    <link href="Sitel/cdn/cdn.datatables.net/1.10.15/css/fixedHeader.dataTables.min.css" rel="stylesheet" />

    <style>
        table thead tr th,
        table tbody tr td{
            font-size:11px !important;
        }

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

        /*.list {
            overflow: auto;
        }*/

        .pos {
            margin-left: 35%;
        }

        .badge {
            border-radius: 100%;
        }

        .bg-orange {
            border-radius: 5%;
            /*background: -ms-linear-gradient(left, rgba(255,52,41,1) 0%, rgba(255,82,77,1) 0%, rgba(255,82,77,1) 0%, rgba(255,9,5,1) 0%, rgba(255,14,10,1) 0%, rgba(235,0,23,1) 100%);*/
            background-color:orange;
        }

        .bg-green {
            border-radius: 5%;
            background: -ms-linear-gradient(left, rgba(39,148,0,1) 0%, rgba(255,77,151,1) 0%, rgba(255,5,113,1) 0%, rgba(255,10,116,1) 0%, rgba(255,41,126,1) 0%, rgba(39,148,0,1) 0%, rgba(39,148,0,1) 100%);
        }

        .bg-grey {
            border-radius: 5%;
            background-color:floralwhite;
        }

    </style>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="LeaveList.aspx"><i class="fa fa-calendar"></i>LeaveList</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-calendar"></span></div>
        <div class="pagetitle">
            <h5>View Manager Leave List</h5>
            <%--, Swaps and Leaves for my Team--%>
            <h1>Leave List</h1>
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
                        <asp:Literal ID="ltlReportingMgrsTeam" Text="Leave List" runat="server"></asp:Literal></h4>
                </div>
                <div class="box-body">
                    <div class="row">

                        <div class="col-md-3">
                            <div class="form-group">

                                <asp:DropDownList ID="ddlManager" runat="server" CssClass="form-control select2" Style="width: 100%;">
                                    <%-- AutoPostBack="true"--%>
                                    <asp:ListItem Selected="True" Text="All" Value="0"></asp:ListItem>
                                    <asp:ListItem Text="Manager I" Value="80"></asp:ListItem>
                                    <asp:ListItem Text="Manager II" Value="75"></asp:ListItem>
                                </asp:DropDownList>

                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">

                                <asp:Button ID="btn_current" CssClass="btn btn-primary pos" runat="server" Text="Current Month" OnClick="btn_current_Click" /><%--ValidationGroup="Proceed"--%> <%--CausesValidation="False" --%>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">

                                <asp:Button ID="Button1" CssClass="btn btn-primary pos" runat="server" Text="Next 3 Months" OnClick="Button1_Click" />
                                <%--OnClick="btn_proceed_Click" ValidationGroup="Proceed"--%> <%--CausesValidation="False" --%>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="form-group">

                                <asp:Button ID="Button2" CssClass="btn btn-primary pos" runat="server" Text="Next 6 Months" OnClick="Button2_Click" /><%--OnClick="btn_proceed_Click" ValidationGroup="Proceed"--%> <%--CausesValidation="False" --%>
                            </div>
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
            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="ltlRosterHeading" runat="server" Text="Leave List : "></asp:Literal></h4>


                </div>
                <div class="box-body">
                    <asp:Panel ID="pnlRoster" runat="server" Visible="true" CssClass="list ">
                        <asp:GridView ID="gvLeaveList" runat="server" AutoGenerateColumns="true"
                            CssClass="table table-condensed table-responsive compact hover stripe"
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
    <%--<script src="Sitel/cdn/yadcf/jquery.dataTables.yadcf.js"></script>--%>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>
    <script src="Sitel/cdn/cdn.datatables.net/1.10.15/js/dataTables.fixedColumns.min.js"></script>
    <script src="Sitel/cdn/cdn.datatables.net/1.10.15/js/dataTables.fixedHeader.min.js"></script>

    <script>


        $(function () {

            var oTable;

            oTable = $('#gvLeaveList').dataTable(
                {
                    destroy: true,
                    //bJQueryUI: true,
                    fixedColumns: {
                        leftColumns: 3
                    },
                    fixedHeader: {
                        header: true,
                        //footer: true
                    },
                    scrollY: "500px",
                    scrollX: true,
                    scrollCollapse: true,
                    bStateSave: true,
                    paging: false,
                    ordering: false,
                    dom: 'Bfrlti',
                    buttons: [
                        { extend: 'copyHtml5', text: 'Copy Data' },
                        { extend: 'excelHtml5', text: 'Export to Excel' }
                    ],
                }
            )
            //    .yadcf([{
            //    column_number: 1,
            //    filter_type: "multi_select",
            //    select_type: 'select2'
            //},
            //{
            //    column_number: 2,
            //    filter_type: "multi_select",
            //    select_type: 'select2'
            //}]);
        });

        $('td').each(function () {
            var myText = $(this).text();

            if (myText == "Approved Leave" || myText == "Approved WO") { $(this).addClass("bg-green"); }
            else if (myText == "Pending Leave" || myText == "L2 Pending Leave" || myText == "L2 Pending WO" || myText == "Pending WO") { $(this).addClass("bg-orange"); }
            else if (myText == "WO") { $(this).addClass("bg-grey"); }
        });

    </script>

</asp:Content>

