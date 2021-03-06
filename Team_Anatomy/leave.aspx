﻿<%@ Page Title="LeaveRequest" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="leave.aspx.cs" Inherits="leave" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="AdminLTE/plugins/iCheck/all.css">
    <style>
        #pnlLeaveBox {
            display: none;
        }
    </style>
    <style>
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

        .example-modal .modal {
            position: relative;
            top: auto;
            bottom: auto;
            right: auto;
            left: auto;
            display: block;
            z-index: 1;
        }

        .example-modal .modal {
            background: transparent !important;
        }

        .table {
            text-align: center;
        }

        .mid {
            text-align: center;
        }
    </style>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="leave.aspx"><i class="fa fa-plane"></i>Leave Request</a></li>
    </ol>
    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-plane"></span></div>
        <div class="pagetitle">
            <h5>Initiate leave request</h5>
            <h1>Request Leave</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <asp:UpdatePanel ID="upnlOne" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Apply Leave</h3>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label>Leave Date range:</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:TextBox ID="reservation" runat="server" CssClass="form-control pull-right" OnTextChanged="reservation_TextChanged"></asp:TextBox>

                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="form-group">
                                <label>Leave Type</label>
                                <asp:DropDownList ID="ddl_leave_dropdown" CssClass="form-control select2" runat="server">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="col-md-5">
                            <div class="form-group">
                                <label>Leave Reason</label>
                                <asp:TextBox ID="txt_leave_reason" CssClass="form-control" runat="server" placeholder="Enter Reason....."></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="Leave Reason required" ForeColor="Red" ControlToValidate="txt_leave_reason" ValidationGroup="Proceed"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box-footer">
                    <asp:Button ID="btn_proceed" CssClass="btn btn-primary pull-right" runat="server" Text="Proceed" OnClick="btn_proceed_Click" ValidationGroup="Proceed" /><%--CausesValidation="False" --%>
                </div>
            </div>
            <div class="box box-solid box-primary" id="pnlLeaveBox">
                <div class="box-header with-border">
                    <h3 class="box-title">Select Leave Type for each day</h3>
                </div>
                <div class="box-body">
                    <div class="box-body">
                        <asp:GridView ID="gvLeaveDetails" runat="server" CssClass="table table-bordered table-hover"
                            OnRowDataBound="gvLeaveDetails_RowDataBound" AutoGenerateColumns="false">
                            <Columns>
                                <asp:BoundField DataField="Date" HeaderText="Date" DataFormatString="{0:dd-MMM-yyyy}" HeaderStyle-CssClass="mid"></asp:BoundField>
                                <asp:BoundField DataField="Day" HeaderText="Day" HeaderStyle-CssClass="mid"></asp:BoundField>
                                <asp:TemplateField HeaderText="Select Leave" HeaderStyle-CssClass="mid">
                                    <ItemTemplate>
                                        <asp:DropDownList ID="ddlSelectLeave" CssClass="form-control" Style="width: 100%" runat="server"></asp:DropDownList>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ShiftCode" HeaderText="Roster"></asp:BoundField>
                            </Columns>
                        </asp:GridView>

                    </div>
                </div>
                <div class="box-footer">
                    <asp:Button ID="btn_submit" CssClass="btn btn-primary pull-right" runat="server" Text="Submit" OnClick="btn_submit_Click" CausesValidation="False" />
                </div>
            </div>
            <div class="box box-solid box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Leave Log</h3>
                </div>
                <div class="box-body">
                    <div class="box-body">
                        <asp:GridView ID="gvLeaveLog" runat="server"
                            CssClass="table table-bordered table-hover"
                            OnRowDataBound="gvLeaveLog_RowDataBound" AllowPaging="true"
                            PageSize="10" OnPageIndexChanging="gvLeaveLog_PageIndexChanging"
                            AllowSorting="true" OnSorting="gvLeaveLog_Sorting"
                            AutoGenerateColumns="false">

                            <Columns>
                                <asp:BoundField DataField="From_Date" HeaderText="From Date" HeaderStyle-CssClass="mid" SortExpression="From_Date"></asp:BoundField>
                                <asp:BoundField DataField="To_Date" HeaderText="To Date" HeaderStyle-CssClass="mid" SortExpression="To_Date"></asp:BoundField>
                                <asp:BoundField DataField="leave_reason" HeaderText="Leave Reason" HeaderStyle-CssClass="mid" SortExpression="leave_reason"></asp:BoundField>
                                <asp:BoundField DataField="Applied_on" HeaderText="Applied On" HeaderStyle-CssClass="mid" SortExpression="Applied_on"></asp:BoundField>
                                <asp:BoundField DataField="Status" HeaderText="Status" HtmlEncode="false" HeaderStyle-CssClass="mid" SortExpression="Status"></asp:BoundField>
                                <asp:TemplateField HeaderText="Cancel" HeaderStyle-CssClass="mid" SortExpression="Cancel">
                                    <ItemTemplate>
                                        <asp:Button ID="btn_Cancel" runat="server" CssClass="btn btn-sm btn-danger" Text="cancel" OnClick="btn_Cancel_Click" AutoPostback="true" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ID" HeaderText="ID" HeaderStyle-CssClass="mid"></asp:BoundField>
                                <asp:BoundField DataField="Level1_Action" HeaderText="Level1" HeaderStyle-CssClass="mid"></asp:BoundField>
                                <asp:BoundField DataField="Level2_Action" HeaderText="Level2" HeaderStyle-CssClass="mid"></asp:BoundField>
                                <asp:BoundField DataField="CancelDate" HeaderText="CancelDate" HeaderStyle-CssClass="mid"></asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
            <div class="modal" id="modal-danger">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">Leave Cancel Reason</h4>
                        </div>
                        <div class="modal-body">
                            <asp:TextBox ID="txt_cancel_reason" TextMode="multiline" Columns="74" Rows="3" runat="server" CssClass="form-control" placeholder="Enter reason for cancelling leave request....."></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txt_cancel_reason" ErrorMessage="enter cancel reason" ForeColor="Red"
                                runat="server" ValidationGroup="Save"></asp:RequiredFieldValidator>
                            <asp:HiddenField ID="lblLeaveID" runat="server"></asp:HiddenField>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                            <asp:Button ID="btn_save_cancel_reason" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btn_save_cancel_reason_Click" ValidationGroup="Save" /><%--CausesValidation="false"--%>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btn_proceed" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_submit" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btn_save_cancel_reason" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <script src="CDN/toastr/toastr.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            pluginsInitializer();
        });
        function pluginsInitializer() {
            //debugger;
            var date;
            var startdate = Thedate();
            var value;
            function Thedate() {
                $.ajax({
                    type: "post",
                    dataType: "json",
                    data: {},
                    contentType: "application/json; charset=utf-8",
                    url: "leave.aspx/getDates",
                    async: true,
                    success: function (Record) {
                        value = Record.d;
                        //alert(value);
                        doWork(value);
                    }

                });
            }
            function doWork(value) {
                date = value;
                //alert(date);
                $('#reservation').daterangepicker({
                    minDate: date,
                });
            }
            var leave_id; var btn; var status;
            $(".btn-danger").click(function (e) {
                e.preventDefault();                
                btn = $(this);
                $(".modal").modal("show");
                leave_id = $(this).closest('tr').find('td:nth-child(7)').text();
                $('#lblLeaveID').val(leave_id);
            });

            $("#gvLeaveLog tbody tr").each(function () {
                $(this).find("th:nth-child(7)").hide();
                $(this).find("th:nth-child(8)").hide();
                $(this).find("th:nth-child(9)").hide();
                $(this).find("th:nth-child(10)").hide();
            });
            $("#gvLeaveLog tbody tr").each(function () {
                $(this).find("td:nth-child(7)").hide();
                $(this).find("td:nth-child(8)").hide();
                $(this).find("td:nth-child(9)").hide();
                $(this).find("td:nth-child(10)").hide();
            });
            $('#reservation').daterangepicker({ format: 'DD-MMM-YYYY' });
            $('#reservation').on('apply.daterangepicker', function (ev, picker) {
                //var startdate = Thedate();
                var startdate = picker.endDate.format('DD-MMM-YYYY');
                var enddate = picker.endDate.format('DD-MMM-YYYY');
                picker.minDate = startdate;
                picker.maxDate = enddate;

                //alert("startdate: "+startdate + " enddate: "+ enddate);
            });
            ////$('#gvLeaveLog').DataTable({
            ////    "sPaginationType": "full_numbers",
            ////    "lengthMenu": [5, 10, 25, 50, 75, 100],
            ////    "aaSortingFixed": [[0, 'asc']],
            ////    "bSort": true,
            ////    dom: 'Bfrltip',
            ////    "columnDefs": [{ "orderable": false, "targets": 0 }],
            ////    buttons: [
            ////        { extend: 'copyHtml5', text: 'Copy Data' },
            ////        { extend: 'excelHtml5', text: 'Export to Excel' },
            ////        { extend: 'csvHtml5', text: 'Export to CSV' },
            ////        { extend: 'pdfHtml5', text: 'Export to PDF' },
            ////    ]
            ////});
        }

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

