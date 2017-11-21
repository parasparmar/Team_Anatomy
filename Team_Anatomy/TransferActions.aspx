<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="TransferActions.aspx.cs" Inherits="TransferActions" %>

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
        <li class="active"><a href="movement.aspx"><i class="fa fa-flag-o"></i>Transfer Actions</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-flag-o"></span></div>
        <div class="pagetitle">
            <h5>Approve or Decline Employee and Team movements</h5>
            <h1>Movement Transfer Actions</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <!-- Pending Transfers List -->
    <div class="box box-warning">
        <div class="box-header">
            <i class="fa fa-flag"></i>
            <h3 class="box-title">Pending Transfers</h3>
            <div class="box-tools pull-right">
            </div>
        </div>
        <!-- /.box-header -->
        <div class="box-body">
            <asp:GridView ID="gvPendingTransfers" runat="server" CssClass="table table-responsive"
                OnPreRender="gv_PreRender" DataKeyNames="Id,EmpId" AutoGenerateColumns="false"
                OnRowCommand="gvPendingTransfers_RowCommand">

                <Columns>

                    <asp:BoundField DataField="EmpName" HeaderText="Employee" />
                    <asp:BoundField DataField="MovementType" HeaderText="Type" />
                    <asp:BoundField DataField="EffectiveDate" HeaderText="Effective" DataFormatString="{0:dd-MMM-yyyy}" />
                    <asp:BoundField DataField="FromMgrName" HeaderText="From" />
                    <asp:BoundField DataField="ToMgrName" HeaderText="To" />

                    <asp:BoundField DataField="InitiatedBy" HeaderText="Initiator" />
                    <asp:BoundField DataField="InitOn" HeaderText="Initiated"  DataFormatString="{0:dd-MMM-yyyy HH:mm:ss.ms}" />
                    <asp:BoundField DataField="MovementProgress" HeaderText="Status" />
                    <asp:TemplateField HeaderText="Pending Action">
                        <ItemTemplate>
                            <asp:Panel class="btn-group" runat="server" ID="pnlPendingAction" Visible="false">
                                <asp:LinkButton ID="btnApprove" CssClass="btn btn-success btn-sm" runat="server" Text='<i class="fa fa-check"></i>'
                                    BorderWidth="1" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"
                                    CommandName="Approve" />
                                <asp:LinkButton ID="btnDecline" CssClass="btn btn-danger btn-sm " runat="server" Text='<i class="fa fa-close"></i>'
                                    BorderWidth="1" CommandArgument="<%# ((GridViewRow)Container).RowIndex %>"
                                    CommandName="Decline" />
                            </asp:Panel>

                            <asp:Panel class="btn-group" runat="server" ID="pnlPendingAtOtherRepMgr" Visible="false">
                                <asp:Label ID="lblPendingAtOtherRepMgr" runat="server" CssClass="label label-warning"></asp:Label>
                            </asp:Panel>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Id" HeaderText="MovementID" />
                </Columns>

                <EmptyDataTemplate>
                    <h1>There are no transfers pending at your end or for anyone in your team.</h1> 
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        <!-- /.box-body -->
        <div class="box-footer clearfix no-border">
        </div>
    </div>
    <!-- /.box -->
    <!-- Completed Transfers List -->
    <div class="box box-success">
        <div class="box-header">
            <i class="fa fa-flag-checkered"></i>
            <h3 class="box-title">Completed Transfers</h3>
            <div class="box-tools pull-right">
            </div>
        </div>
        <!-- /.box-header -->
        <div class="box-body">


            <asp:GridView ID="gvCompletedTransfers" runat="server" CssClass="table table-responsive"
                OnPreRender="gv_PreRender" DataKeyNames="Id,EmpId" AutoGenerateColumns="false">

                <Columns>

                    <asp:BoundField DataField="EmpName" HeaderText="Employee" />
                    <asp:BoundField DataField="MovementType" HeaderText="Type" />
                    <asp:BoundField DataField="EffectiveDate" HeaderText="Effective" DataFormatString="{0:dd-MMM-yyyy}" />
                    <asp:BoundField DataField="FromMgrName" HeaderText="From" />
                    <asp:BoundField DataField="ToMgrName" HeaderText="To" />

                    <asp:BoundField DataField="InitiatedBy" HeaderText="Initiator" />
                    <asp:BoundField DataField="InitOn" HeaderText="Initiated" DataFormatString="{0:dd-MMM-yyyy HH:mm:ss.ms}" />
                    <asp:BoundField DataField="MovementProgress" HeaderText="Status" />
                    <asp:BoundField DataField="UpdatedOn" HeaderText="Completed" DataFormatString="{0:dd-MMM-yyyy HH:mm:ss.ms}" />
                    <asp:BoundField DataField="Id" HeaderText="MovementID" />
                </Columns>

                <EmptyDataTemplate>
                     <h1>No transfers found for anyone in your team.</h1> 
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
        <!-- /.box-body -->
        <div class="box-footer clearfix no-border">
        </div>
    </div>
    <!-- /.box -->


</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script src="Sitel/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js"></script>
    <script>
        //Date picker
        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

            function EndRequestHandler(sender, args) {
                $('#tbEffectiveDate').datepicker({ dateFormat: 'dd-mm-yy' });
            }

        });
    </script>
    <script>
        function pluginsInitializer() {
            $('.select2').select2({

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
                }
            });
        };
    </script>
</asp:Content>

