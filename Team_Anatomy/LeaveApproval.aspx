<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="LeaveApproval.aspx.cs" Inherits="LeaveApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <%--toastr--%>
    <%--<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/css/toastr.css" rel="stylesheet" />--%>

    <%--<link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js" rel="stylesheet"/>--%>

    <style>
        /*.example-modal .modal {
            position: relative;
            top: auto;
            bottom: auto;
            right: auto;

            left: auto;
            display: block;
            z-index: 1;
        }*/
        .red {
            color: red;
        }

        .content-wrapper {
            min-height: 897.76px !important;
        }

        .badge {
            border-radius: 100%;
        }

        .bg-red {
            border-radius: 100%;
            background: -ms-linear-gradient(left, rgba(255,52,41,1) 0%, rgba(255,82,77,1) 0%, rgba(255,82,77,1) 0%, rgba(255,9,5,1) 0%, rgba(255,14,10,1) 0%, rgba(235,0,23,1) 100%);
        }

        .bg-green {
            background: -ms-linear-gradient(left, rgba(39,148,0,1) 0%, rgba(255,77,151,1) 0%, rgba(255,5,113,1) 0%, rgba(255,10,116,1) 0%, rgba(255,41,126,1) 0%, rgba(39,148,0,1) 0%, rgba(39,148,0,1) 100%);
        }
        /*.example-modal .modal {
            background: transparent !important;
        }*/

        .left {
            /*float:left;*/
            width: 100%;
        }

        .right {
            /*float:right;*/
            width: 100%;
        }

        .label {
            border: 2px solid black;
        }

        /*#modal-default {
        display:none;
        }*/
    </style>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="leaveApproval.aspx"><i class="fa fa-toggle-on"></i>Employee Leave Requests</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-toggle-on"></span></div>
        <%--fa-exclamation / fa-plane / fa-calendar-times-o--%>
        <div class="pagetitle">
            <h5>Review reportee leave request</h5>
            <h1>Approve/Deny Leave Request</h1>
        </div>
    </div>
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">

    <asp:UpdatePanel ID="UpdatePanel1" runat="server" EnableViewState="true" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row-fluid">
                <div class="col-md-12">
                    <!-- Custom Tabs -->
                    <div class="box box-solid box-primary" style="height: auto;">
                        <div class="box-header with-border">
                            <%--<div class="form-group">
                                <label class="col-sm-2 control-label">Select </label>
                                <div class="col-sm-10">
                                    <asp:DropDownList ID="ddlRepManager" runat="server" CssClass="form-control select2" Style="width: 40%;" AutoPostBack="true" OnSelectedIndexChanged="ddlRepManager_SelectedIndexChanged">
                                        <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>--%>
                            <h4 class="box-title">View Leaves of Employees</h4>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <asp:Panel CssClass="col-md-6" ID="pnlAmIRvwMgr" Visible="true" runat="server">
                                    <div class="form-group">

                                        <asp:DropDownList ID="ddlRepManager" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlRepManager_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                    <!-- ddlRepManager-->
                                </asp:Panel>
                                <!-- pnlAmIRvwMgr-->
                            </div>

                            <%--  <div class="box box-primary">--%>
                            <div class="box-header with-border">
                                <h3 class="box-title">Employee Leave Log</h3>
                            </div>
                            <div class="box-body">
                                <div class="box-body">
                                    <asp:GridView ID="gvApprLeaveLog" runat="server"
                                        CssClass="table table-bordered table-hover " AutoGenerateColumns="false">
                                        <%--ApprleavelogDataTable OnPreRender="gv_PreRender" Datatable--%>
                                        <Columns>
                                            <asp:BoundField DataField="ecn" HeaderText="Emp Code"></asp:BoundField>
                                            <asp:BoundField DataField="name" HeaderText="Name"></asp:BoundField>
                                            <asp:BoundField DataField="from_date" HeaderText="From Date"></asp:BoundField>
                                            <asp:BoundField DataField="to_date" HeaderText="To Date"></asp:BoundField>
                                            <asp:BoundField DataField="leave_reason" HeaderText="Leave Reason"></asp:BoundField>
                                            <asp:BoundField DataField="applied_on" HeaderText="Applied On"></asp:BoundField>
                                            <asp:BoundField DataField="status" HeaderText="Status" HtmlEncode="false"></asp:BoundField>

                                            <asp:TemplateField HeaderText="Details">
                                                <ItemTemplate>
                                                    <asp:Button ID="btn_detail" runat="server" CssClass="btn btn-sm btn-info" Text="open" OnClick="btn_detail_Click" />
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="ID" HeaderText="ID"></asp:BoundField>

                                        </Columns>
                                    </asp:GridView>
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
                    <%--  put here the leave log--%>
                    <!-- /.box-footer-->
                </div>
                <!--tabcontent-->
            </div>
            <!-- /.col -->
            </div>
            <div class="modal" id="modal-details">
                <div class="modal-dialog">
                    <div class="modal-content" style="border: 1px solid #3c8dbc">
                        <div class="modal-header" style="background-color: #3c8dbc">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title" style="color: white">Leave Details for
                                <asp:Label ID="lblEmployeeName" runat="server"></asp:Label>
                                &nbsp<asp:Label ID="lblEmployeeID" runat="server"></asp:Label></h4>
                        </div>
                        <div class="modal-body">
                            <asp:GridView ID="gvdatewiseAppr" runat="server"
                                CssClass="table table-bordered table-hover "
                                AutoGenerateColumns="false">
                                <Columns>
                                    <asp:BoundField DataField="LEAVEDATE" HeaderText="Date"></asp:BoundField>
                                    <asp:BoundField DataField="LEAVETEXT" HeaderText="Leave Type"></asp:BoundField>
                                    <asp:BoundField DataField="ROSTER" HeaderText="Roster"></asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <%--<br>--%>
                            <asp:TextBox ID="txt_reason" TextMode="multiline" Columns="74" Rows="2" runat="server" CssClass="form-control" placeholder="Enter comments...."></asp:TextBox>
                            <asp:Label ID="alert" Visible="false" runat="server" CssClass="red" Text="Leave decline reason required"></asp:Label>
                            <asp:Label ID="lblLeaveID" runat="server" Visible="false"></asp:Label>

                        </div>
                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-md-6">
                                    <asp:Button ID="btn_appr" runat="server" CssClass="btn btn-sm btn-success left" Text="Approve" OnClick="btn_appr_Click" />
                                </div>
                                <div class="col-md-6">
                                    <asp:Button ID="btn_dec" runat="server" CssClass="btn btn-sm btn-danger right" Text="Decline" OnClick="btn_dec_Click" />
                                </div>
                            </div>
                            <%--<asp:Button ID="btn_save_cancel_reason" runat="server" Text="Save" CssClass="btn btn-primary" />--%><%-- OnClick="btn_save_cancel_reason_Click"--%>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!---LHS Panel---->
        </ContentTemplate>        
    </asp:UpdatePanel>

</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <%--<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/js/toastr.js" type="text/javascript"></script>--%>
    <%--<script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>--%>

    <%-- <script type="text/javascript">
        //$(document).ready(function () {
        //    var leave_id; var btn; var status;
        //    //$(".btn-info").click(function (e) {
        //        //
        //        //e.preventDefault();
        //        ////alert("1");
        //        ////btn = $(this);
        //        //$(".modal").modal("show");//#modal-details
        //        //leave_id = $(this).closest('tr').find('td:nth-child(12)').text(); 
        //        //$("#lblLeaveID").val($(this).closest('tr').find('td:nth-child(12)').text());
        //        //alert(leave_id);
        //        //$("#modal-danger").css({ "display": "block" });
        //        //alert("2");
        //        //$("#modal-danger").css({ "display": "block" }); alert("2");
        //    });
        //});
    </script>--%>
    <%--<script>
        function openmodal() {
            $('.modal').modal('show');
        }
    </script>--%>
    <script type="text/javascript">
        function toastA() {
            toastr.success('Leave Approved');//, 'Success'
            toastr.options = {
                "showDuration": "0",
                "hideDuration": "0",
                "timeOut": "1000",
                "extendedTimeOut": "0",
            }
        }
        function Alert() {
            alert("Please enter comments");
        }
        function toastD() {
            toastr.success('Leave Declined');//, 'Success'
            toastr.options = {
                "showDuration": "0",
                "hideDuration": "0",
                "timeOut": "1000",
                "extendedTimeOut": "0",
            }
        }
        function openModal() {
            $("#modal-details").modal("show");//#modal-details
            $('.modal-backdrop').hide();
        }
        function hideModal() {
            //$("#modal-details").modal("hide");//#modal-details
            $('#modal-details').modal('hide');//#modal-details
            $('.modal-backdrop').hide();
            $('.modal-backdrop').hide();
            //$('#modal-details').hide();    
        }
        function hideModalBack() {
            $('.modal-backdrop').hide();
        }
        function pluginsInitializer() {
            //var x = 1;
            //$("#btn_proceed").click(function () {
            //    $("#leave-box").css({ "display": "block" });
            //});


            $("#gvApprLeaveLog tbody tr").each(function () {
                $(this).find("th:nth-child(12)").hide();
                $(this).find("th:nth-child(9)").hide();
            });

            $("#gvApprLeaveLog tbody tr").each(function () {
                $(this).find("td:nth-child(12)").hide();
                $(this).find("td:nth-child(9)").hide();
            });

            //$("#gvdatewiseAppr tbody tr").each(function () {
            //    $(this).find("th:nth-child(4)").hide();
            //});

            //$("#gvdatewiseAppr tbody tr").each(function () {
            //    $(this).find("td:nth-child(4)").hide();
            //});

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

        $(document).ready(function () {
            $('.ApprleavelogDataTable').DataTable({
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
                ],
                "columnDefs": [{
                    "targets": [8], //Comma separated values
                    "visible": false,
                    "searchable": false
                }
                ],

            });
        });

    </script>
</asp:Content>

