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
    <link href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css" rel="stylesheet" />

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row-fluid">
        <div class="col-md-12">
            <div class="box box-widget widget-user-2" style="height: auto;">
                <div class="widget-user-header bg-aqua-active">
                    <div class="widget-user-image">
                        <img class="img-circle" src="/Sitel/user_images/unknownPerson.jpg" alt="User Avatar">
                    </div>
                    <h3 class="widget-user-username">Chetan Duggal</h3>
                    <h5 class="widget-user-desc">Site Director - All My Reportees at Level 1</h5>
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
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <div class="widget-user-image">
                                            <img class="img-circle" src="http://iaccess.nac.sitel-world.net/TA/Sitel/user_images/<%#Eval("userimage")%>" alt="User Avatar">
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
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
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
    $(document).ready( function () {
    $('#gv_TeamList').DataTable();
} );
</asp:Content>

