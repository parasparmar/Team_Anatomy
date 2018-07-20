<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="LeaveApproval.aspx.cs" Inherits="LeaveApproval" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
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

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server" ChildrenAsTriggers="false">
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
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="row">
                <div class="col-md-12">
                    <!-- Custom Tabs -->
                    <div class="box box-solid box-primary" style="height: auto;">
                        <div class="box-header with-border">
                            <h4 class="box-title">Employee Leaves</h4>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <asp:Panel CssClass="col-md-12" ID="pnlAmIRvwMgr" Visible="true" runat="server">
                                    <div class="col-md-4">
                                        <label for="ddlRepManager" aria-label="Reporting Manager List">Reporting Manager List</label>
                                        <div class="form-group">
                                            <asp:DropDownList ID="ddlRepManager" runat="server" CssClass="col-md-6 form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlRepManager_SelectedIndexChanged">
                                                <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="ddlActionFilter" aria-label="Filter Leaves Per Stage">Filter Leaves Per Stage</label>
                                        <div class="form-group">
                                            <asp:DropDownList ID="ddlActionFilter" runat="server" CssClass="col-md-6 form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlActionFilter_SelectedIndexChanged">
                                                <asp:ListItem Value="1" Text="All" runat="server"></asp:ListItem>
                                                <asp:ListItem Value="2" Text="Level1 Pending" runat="server"></asp:ListItem>
                                                <asp:ListItem Value="3" Text="Level2 Pending" runat="server"></asp:ListItem>
                                                <asp:ListItem Value="4" Text="Level1 Actioned" runat="server"></asp:ListItem>
                                                <asp:ListItem Value="5" Text="Level2 Actioned" runat="server"></asp:ListItem>
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <label for="ddlEmployee" aria-label="Filter Employees At This Stage">Filter Employees At This Stage</label>
                                        <div class="form-group">
                                            <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="col-md-6 form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlEmployee_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>
                                    </div>
                                    <!-- ddlRepManager-->
                                </asp:Panel>
                                <!-- pnlAmIRvwMgr-->
                                <div class="col-md-12">
                                    <h4>Leave Log</h4>
                                    <asp:GridView ID="gvApprLeaveLog" runat="server"
                                        CssClass="table table-bordered table-hover table-condensed table-responsive datatable"
                                        OnPreRender="gv_PreRender" AutoGenerateColumns="false">
                                        <Columns>
                                            <asp:BoundField DataField="ecn" HeaderText="Emp Code"></asp:BoundField>
                                            <asp:BoundField HeaderStyle-CssClass="apply-filter" DataField="name" HeaderText="Name"></asp:BoundField>
                                            <asp:BoundField DataField="from_date" HeaderText="From Date"></asp:BoundField>
                                            <asp:BoundField DataField="to_date" HeaderText="To Date"></asp:BoundField>
                                            <asp:BoundField DataField="leave_reason" HeaderText="Leave Reason"></asp:BoundField>
                                            <asp:BoundField DataField="applied_on" HeaderText="Applied On"></asp:BoundField>
                                            <asp:BoundField DataField="status" HeaderText="Status" HtmlEncode="false"></asp:BoundField>
                                            <asp:TemplateField HeaderText="Details">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="btn_detail" runat="server" CssClass="btn btn-sm btn-info" Text="open" OnClick="btn_detail_Click"></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="ID" HeaderText="ID"></asp:BoundField>

                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <!-- Leave Log-->
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <!--tabcontent-->
            </div>

            <div class="modal" id="modal-details">
                <div class="modal-dialog">
                    <asp:UpdatePanel ID="upModal" UpdateMode="Conditional" runat="server">
                        <ContentTemplate>
                            <div class="modal-content" style="border: 1px solid #3c8dbc">
                                <div class="modal-header" style="background-color: #3c8dbc">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" style="color: white">Leave Details for
                                <asp:Label ID="lblEmployeeName" runat="server"></asp:Label>
                                        &nbsp Employee ID-
                                <asp:Label ID="lblEmployeeID" runat="server"></asp:Label></h4>
                                </div>
                                <div class="modal-body">
                                    <asp:GridView ID="gvdatewiseAppr" runat="server"
                                        CssClass="table table-bordered table-hover table-condensed datatable"
                                        AutoGenerateColumns="false" OnPreRender="gv_PreRender">
                                        <Columns>
                                            <asp:BoundField DataField="LEAVEDATE" HeaderText="Date"></asp:BoundField>
                                            <asp:BoundField DataField="LEAVEDAY" HeaderText="Day"></asp:BoundField>
                                            <asp:BoundField DataField="LEAVETEXT" HeaderText="Leave Type"></asp:BoundField>
                                            <asp:BoundField DataField="ROSTER" HeaderText="Roster"></asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
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
                                </div>
                            </div>
                            <!-- /.modal-content -->
                        </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btn_appr" />
                            <asp:PostBackTrigger ControlID="btn_dec" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
                <!-- /.modal-dialog -->
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlRepManager" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlActionFilter" EventName="SelectedIndexChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlEmployee" EventName="SelectedIndexChanged" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <link href="CDN/excel-bootstrap-table-filter/excel-bootstrap-table-filter-style.css" rel="stylesheet" />
    <script src="CDN/excel-bootstrap-table-filter/excel-bootstrap-table-filter-bundle.min.js"></script>

    <script type="text/javascript">
        $(function () {
            pluginsInitializer();
        });

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
            $("#modal-details").modal("show");
            $('.modal-backdrop').hide();
        }
        function hideModal() {
            
            $('#modal-details').modal('hide');//#modal-details
            $('.modal-backdrop').hide();
            $('.modal-backdrop').hide();
            
        }
        function hideModalBack() {
            $('.modal-backdrop').hide();
        }

        function pluginsInitializer() {

            $("#gvApprLeaveLog tbody tr").each(function () {
                $(this).find("th:nth-child(12)").hide();
                $(this).find("th:nth-child(9)").hide();
            });
            $("#gvApprLeaveLog tbody tr").each(function () {
                $(this).find("td:nth-child(12)").hide();
                $(this).find("td:nth-child(9)").hide();
            });           
            $('.datatable').excelTableFilter({
                columnSelector: '.apply-filter'
            });
            $('.select2').select2({});
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

