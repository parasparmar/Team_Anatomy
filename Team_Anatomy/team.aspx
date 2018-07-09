<%@ Page Title="TeamList" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="team.aspx.cs" Inherits="team" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="Server">
</asp:Content>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="Summary.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="/PMS_ReviewMaster.aspx"><i class="fa fa-users"></i>My Team</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-users"></span></div>
        <div class="pagetitle">
            <h5>View My Team Infromation</h5>
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
                            <h4 class="box-title">My Team List</h4>
<%--                            <div class="box-tools pull-right">
                                <button class="btn btn-box-tool" type="button" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>--%>
                        </div>
                        <div class="box-body">
                            <div class="form-group">
                                <asp:GridView ID="gv_TeamList" runat="server" CssClass="table table-condensed table-responsive datatable display compact hover stripe" AutoGenerateColumns="false"
                                    OnPreRender="gv_PreRender" ShowHeader="true" OnRowCommand="gv_TeamList_RowCommand" Style="border: none">
                                    <Columns>
                                        <asp:BoundField DataField="Employee_ID" HeaderText="Emp Code" />
                                        <asp:BoundField DataField="Name" HeaderText="Name" />
                                        <asp:BoundField DataField="Designation" HeaderText="Designation" />
                                        <asp:BoundField DataField="Contact_Number" HeaderText="Contact Number" />
                                        <asp:BoundField DataField="EMAIL_ID" HeaderText="Email" />
                                        
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <h5>There are no Team Members are currently mapped to me.</h5>
                                    </EmptyDataTemplate>

                                </asp:GridView>
                            </div>
                        </div>
                        
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

