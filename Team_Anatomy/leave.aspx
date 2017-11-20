<%@ Page Title="LeaveRequest" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="leave.aspx.cs" Inherits="leave" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>


<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
    <%--  <link href="Sitel/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="AdminLTE/plugins/iCheck/all.css">
    <style>
        /*#leave-box {
            display: none;
        }*/

        /*@media only screen and (min-width: 900px) {
            .daterangepicker {
                width: 38%;
            }
        }*/
    </style>
    <%--toastr--%>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/2.0.1/css/toastr.css" rel="stylesheet" />



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

        /*#modal-default {
        display:none;
        }*/
    </style>

</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">

    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="leave.aspx"><i class="fa fa-plane"></i>Leave Request</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-plane"></span></div>
        <%--fa-exclamation / fa-plane / fa-calendar-times-o--%>
        <div class="pagetitle">
            <h5>Initiate leave request</h5>
            <h1>Leave Request</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">


    <div class="box box-primary">
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
                            <%--<input type="text" class="form-control pull-right" id="reservation">--%>
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
                        <asp:TextBox ID="txt_leave_reason" CssClass="form-control" runat="server" placeholder="Enter Reason....." ></asp:TextBox>
                        <%--<textarea id="txt_leave_reason" placeholder="Enter Reason....." class="form-control" runat="server"></textarea>--%>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="Leave Reason required" ForeColor="Red" ControlToValidate="txt_leave_reason"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" Display="Dynamic" ControlToValidate="txt_leave_reason" ErrorMessage="enter valid reason" ForeColor="Red" ValidationExpression="^[a-zA-Z ]+$"></asp:RegularExpressionValidator>
                    </div>
                </div>
            </div>
        </div>
        <div class="box-footer">
            <asp:Button ID="btn_proceed" CssClass="btn btn-primary pull-right" runat="server" Text="Proceed" OnClick="btn_proceed_Click" />
            <%--<button class="btn btn-primary" type="submit" id="proceed">Proceed</button>--%>
        </div>
    </div>

    <div class="box box-primary" id="pnlLeaveBox" visible="false">
        <div class="box-header with-border">
            <h3 class="box-title">Select Leave Type for each day</h3>
        </div>
        <div class="box-body">
            <div class="box-body">
                <asp:GridView ID="gvLeaveDetails" runat="server" CssClass="table table-bordered table-hover Datatable" OnRowDataBound="gvLeaveDetails_RowDataBound" AutoGenerateColumns="false">

                    <Columns>
                        <asp:BoundField DataField="Date" HeaderText="Date" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="day" HeaderText="day" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:TemplateField HeaderText="Select Leave" HeaderStyle-CssClass="mid">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlSelectLeave" runat="server"></asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--<asp:BoundField DataField="roster" HeaderText="roster"></asp:BoundField>--%>
                    </Columns>
                </asp:GridView>

            </div>
        </div>
        <div class="box-footer">
            <asp:Button ID="btn_submit" CssClass="btn btn-primary pull-right" runat="server" Text="Submit" OnClick="btn_submit_Click" />
            <%--<button class="btn btn-primary" type="submit">Submit</button>--%>
        </div>
    </div>

    <div class="box box-primary">
        <div class="box-header with-border">
            <h3 class="box-title">Leave Log</h3>
        </div>
        <div class="box-body">
            <div class="box-body">
                <asp:GridView ID="gvLeaveLog" runat="server"
                    CssClass="table table-bordered table-hover Datatable" OnRowEditing="gvLeaveLog_RowEditing"
                    OnRowDataBound="gvLeaveLog_RowDataBound" OnRowUpdating="gvLeaveLog_RowUpdating"
                    OnRowCancelingEdit="gvLeaveLog_RowCancelingEdit"
                    AutoGenerateColumns="false" DataKeyNames="ID" OnSelectedIndexChanged="gvLeaveLog_SelectedIndexChanged">
                    <Columns>
                        <asp:BoundField DataField="From_Date" HeaderText="From Date" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="To_Date" HeaderText="To Date" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="leave_reason" HeaderText="Leave Reason" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="Applied_on" HeaderText="Applied On" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="Status" HeaderText="Status" HtmlEncode="false" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:TemplateField HeaderText="Cancel" HeaderStyle-CssClass="mid">
                            <ItemTemplate>
                                <asp:Button ID="btn_Cancel" runat="server" CssClass="btn btn-sm btn-danger" Text="cancel" OnClick="btn_Cancel_Click" />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ID" HeaderText="ID" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="Level1_Action" HeaderText="Level1" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="Level2_Action" HeaderText="Level2" HeaderStyle-CssClass="mid"></asp:BoundField>
                        <asp:BoundField DataField="CancelDate" HeaderText="CancelDate" HeaderStyle-CssClass="mid"></asp:BoundField>

                        <%--<asp:BoundField DataField="comments" HeaderText="Comments"></asp:BoundField>--%>


                        <%--<asp:TemplateField HeaderText="Cancel Reason">
                            <EditItemTemplate>
                                <asp:TextBox ID="txt_cancel_reason" Text="editmode" runat="server"></asp:TextBox>
                            </EditItemTemplate>
                            <ItemTemplate>
                                <asp:Label ID="lbl_cancel_reason" runat="server"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                        <%--<asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Literal ID="lblStatus" runat="server"></asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

    </div>

    <%--<asp:Panel ID="pnl_modal_danger" runat="server" CssClass="modal fade">--%>
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
                    <asp:HiddenField ID="lblLeaveID" runat="server"></asp:HiddenField>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                    <%--<button type="button" id="btn_save_cancel_reason" class="btn btn-primary">Save changes</button>--%>
                    <asp:Button ID="btn_save_cancel_reason" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btn_save_cancel_reason_Click" /><%----%>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <%--</asp:Panel>--%>

    <!-- Edit  Modal Popup-->

</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <%--        <Link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet" />
     <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>--%>

    <script type="text/javascript">
        $(document).ready(function () {
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
                $(".modal").modal("show");//.modal
                leave_id = $(this).closest('tr').find('td:nth-child(7)').text();
                $('#lblLeaveID').val(leave_id);

            });




            $("#btn_save_cancel_reason-----").click(function () {
                var reason = $("#txt_cancel_reason").val();
                if (reason.valueOf() == '') {
                    alert("enter reason");
                    return false;
                }
                else {
                    status = 3;
                    var dataToPass = "{'cancel_reason':'" + reason + "','id':'" + leave_id + "','status':'" + status + "'}";
                    alert(dataToPass);
                    $.ajax({
                        method: "POST",
                        url: "leave.aspx/CancelData",
                        async: false,
                        data: dataToPass,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (Record) {
                            $("#txt_cancel_reason").val("");
                        },
                        error: function (Record) {
                            alert("Error: " + Record.d);
                        }
                    });

                }
            });
        });


        function pluginsInitializer() {
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

            $('#reservation').daterangepicker({ format: 'DD-MMM-YYYY' })

            //Date range picker

            $('#reservation').on('apply.daterangepicker', function (ev, picker) {
                var startdate = picker.endDate.format('DD-MMM-YYYY');
                var enddate = picker.endDate.format('DD-MMM-YYYY');
                picker.minDate = startdate;
                picker.maxDate = enddate;
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
    <script>
        function toast() {
            toastr.success('Have fun storming the castle!', 'Miracle Max Says');
        }

    </script>
</asp:Content>

