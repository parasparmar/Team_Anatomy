<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="roster_backup.aspx.cs" Inherits="roster_backup" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>

<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="roster.aspx"><i class="fa fa-calendar-check-o"></i>Roster</a></li>
    </ol>
    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-calendar-check-o"></span></div>
        <div class="pagetitle">
            <h5>Create, Maintain and Upload Reportee Rosters, Swaps and Leaves</h5>
            <h1>Roster</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="The_Body" ContentPlaceHolderID="The_Body" runat="Server">
    <div id="Div1" class="row" runat="server">
        <asp:ListView ID="lvwTeamList" runat="server" Visible="true" OnItemDataBound="lvwTeamList_ItemDataBound">
            <LayoutTemplate>

                <div class="col-md-12" id="groupPlaceholder" runat="server">
                </div>

            </LayoutTemplate>

            <GroupTemplate>
                <div class="col-md-12" id="col1" runat="server">
                    <div class="box box-primary box-solid" id="itemPlaceholder" runat="server">
                    </div>
                </div>

            </GroupTemplate>

            <ItemTemplate>
                <div class="box box-primary box-solid" id="box1" runat="server">
                    <div class="box-header with-border" runat="server" id="box2">
                        <h3 id="H2" class="box-title" runat="server">Reporting Manager :
                    <asp:Literal ID="ltlRepMgr" Text='<%# Bind("Name")%>' runat="server"></asp:Literal>
                        </h3>
                        <div id="Div5" class="box-tools pull-right" runat="server">
                            <button id="Button2" type="button" class="btn btn-box-tool" data-widget="collapse" runat="server">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                        <!-- /.box-tools -->
                    </div>
                    <!-- /.box-header -->
                    <div id="boxbody1" class="box-body" runat="server">
                        <asp:HiddenField ID="hdnfld_Employee_ID" Value='<%# Bind("Employee_ID")%>' runat="server"></asp:HiddenField><br />
                        
                        <asp:GridView ID="gvTeamList" runat="server"
                             CssClass="table table-condensed table-responsive datatable display compact hover stripe"
                             AutoGenerateColumns="False" DataKeyNames="Employee_ID"
                             OnPreRender="gv_PreRender">
                            <Columns>
                                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name"></asp:BoundField>
                                <asp:BoundField DataField="Employee_ID" HeaderText="Employee_ID" SortExpression="Employee_ID"></asp:BoundField>
                                <asp:BoundField DataField="RepMgr" HeaderText="RepMgr" SortExpression="RepMgr"></asp:BoundField>
                            </Columns>
                        </asp:GridView>

                    </div>
                    <!-- /.box-body -->
                </div>
                <!-- /.box -->
            </ItemTemplate>
        </asp:ListView>

    </div>

    <asp:Panel ID="pnlAdditional" runat="server" Visible="false">
        <textarea id="excel_data" cols="20" rows="2" style="width: 450px; height: 300px;"></textarea>
        <input type="button" onclick="javascript: convert();" value="Use the Pasted Excel Data" />
        <div id="excel_table">
        </div>
    </asp:Panel>
</asp:Content>
<asp:Content ID="bottom" ContentPlaceHolderID="below_footer" runat="server">
    <script>
        function generateTable() {
            var data = $('#excel_data').val();
            console.log(data);
            var rows = data.split("\n");
            var table = $('<table />');
            for (var y in rows) {
                var cells = rows[y].split("\t");
                var row = $('<tr />');
                for (var x in cells) {
                    row.append('<td>' + cells[x] + '</td>');
                }
                table.append(row);
            }
            // Insert into DOM
            $('#excel_table').html(table);
        }

        function convert() {
            var xl = $('#excel_data').val();
            $('#excel_table').html(
              '<table><tr><td>' +
              xl.replace(/\n+$/i, '').replace(/\n/g, '</tr><tr><td>').replace(/\t/g, '</td><td>') +
              '</tr></table>'
            )

        }
        //http://stackoverflow.com/questions/2006468/copy-paste-from-excel-to-a-web-page
    </script>
</asp:Content>
