<%@ Page Title="TeamList" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="team.aspx.cs" Inherits="team" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="/PMS_ReviewMaster.aspx"><i class="fa fa-tasks"></i>Review Period Master</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-users"></span></div>
        <div class="pagetitle">
            <h5>Team Management Tasks</h5>
            <h1>My Team</h1>
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
                            <h4 class="box-title">The Team List</h4>
                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="form-group">
                                <asp:GridView ID="gv_TeamList" runat="server" CssClass="table table-condensed table-responsive datatable display compact hover stripe" AutoGenerateColumns="false"
                                    OnPreRender="gv_PreRender" ShowHeader="true" OnRowCommand="gv_TeamList_RowCommand" Style="border: none">
                                    <Columns>
                                        <asp:ButtonField HeaderText="Action" ButtonType="Button" ControlStyle-CssClass="btn btn-primary btn-xs" CommandName="Select" Text=">> " />
                                        <asp:BoundField DataField="Employee_ID" HeaderText="Employee Id" />
                                        <asp:BoundField DataField="Name" HeaderText="Name" />
                                        <asp:BoundField DataField="EMAIL_ID" HeaderText="Email" />
                                        <%--<asp:BoundField DataField="PMSPhase" HeaderText="Phase" />
                                        <asp:BoundField DataField="PCStart" HeaderText="PC Start" />
                                        <asp:BoundField DataField="PCYear" HeaderText="PC Year" />
                                        <asp:BoundField DataField="CanLock" HeaderText="Lock" />
                                        <asp:BoundField DataField="OverallGrace" HeaderText="Grace" />
                                        <asp:BoundField DataField="SlabType" HeaderText="Slab Type" />--%>
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <h5>There are no Team Members are currently mapped to me.</h5>
                                    </EmptyDataTemplate>

                                </asp:GridView>
                            </div>
                        </div>
                        <asp:Panel CssClass="box-footer" ID="pnlActions" runat="server">
                            <div class="input-group">
                                <span class="input-group-btn">
                                    <asp:Button ID="btnRHR" runat="server" CssClass="btn btn-primary btn-flat" Text="Initiate Referral to HR" />
                                    <asp:Button ID="btnRes" runat="server" CssClass="btn btn-warning btn-flat" Text="Initiate Resignation" />
                                    <asp:Button ID="btnAOS" runat="server" CssClass="btn btn-info btn-flat" Text="Initiate Abandonment of Service" />
                                    
                                </span>
                            </div>
                        </asp:Panel>
                        <!-- /.box-footer-->
                    </div>
                    <!--tabcontent-->
                </div>
                <!-- /.col -->
            </div>
        </ContentTemplate>
        <Triggers>
        </Triggers>
    </asp:UpdatePanel>
    <asp:Panel ID="pnlModal" runat="server" CssClass="modal modal-primary fade" Visible="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title"></h4>
                </div>
                <div class="modal-body">
                    <p>
                        <asp:Label ID="lblResult" runat="server"></asp:Label>&hellip;
                    </p>
                </div>
                <div class="modal-footer">
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </asp:Panel>

</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
</asp:Content>

