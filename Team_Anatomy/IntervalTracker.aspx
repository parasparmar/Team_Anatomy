<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="IntervalTracker.aspx.cs" Inherits="IntervalTracker" %>


<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="IntervalTracker.aspx">
            <i class="fa fa-sliders"></i>Interval Tracker</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon">
            <span class="fa fa-sliders"></span>
        </div>
        <div class="pagetitle">
            <h5>Track & Log Performance Data <strong>Client and LOB Intervals</strong></h5>
            <h1>Interval Tracker</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <section class="content">
        <div class="box box-primary">
            <div class="box-body">
                <div class="row">
                    <div class="col-lg-3">
                    <div class="form-group">
                                <label>Select Date</label>
                                    <div class="input-group">
                                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                        <asp:TextBox ID="tbDate" CssClass="form-control datepicker" runat="server"></asp:TextBox>
                                    </div>
                            </div>
                        </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Interval</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlInterval" runat="server">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" Display="Dynamic" ErrorMessage="Select an interval" ForeColor="Red" ControlToValidate="ddlInterval" ValidationGroup="downtime"></asp:RequiredFieldValidator>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Account</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-calendar-check-o"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlAccount" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlAccount_SelectedIndexChanged">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="Select an Account" ForeColor="Red" ControlToValidate="ddlAccount" ValidationGroup="downtime"></asp:RequiredFieldValidator>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>LOB</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlLOB" runat="server">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="Dynamic" ErrorMessage="Select a LOB" ForeColor="Red" ControlToValidate="ddlLOB" ValidationGroup="downtime"></asp:RequiredFieldValidator>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    
                </div>

                <div class="row">

                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Sites</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                <%--<asp:ListBox  ItemType="text" CssClass="form-control select" ID="lbSites" SelectionMode="Multiple" runat="server">
                            </asp:ListBox>--%>
                                <div style="height: 60px; overflow-y: auto" class="form-control select"><%--"height: 50px;--%>
                                    <asp:CheckBoxList ID="lbSites" runat="server"></asp:CheckBoxList>
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Display="Dynamic" ErrorMessage="Select a Site" ForeColor="Red" ControlToValidate="lbSites" ValidationGroup="downtime"></asp:RequiredFieldValidator>--%>
                                    <asp:CustomValidator ID="CustomValidator1" ErrorMessage="Please select at least one item." ForeColor="Red" ClientValidationFunction="ValidateCheckBoxList" runat="server" ValidationGroup="downtime"/>
                                </div>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="form-group">
                            <label>Describe Issue</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                                <asp:TextBox runat="server" ID="txtIssue" CssClass="form-control select" TextMode="MultiLine" Rows="2"/><%----%>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" Display="Dynamic" ErrorMessage="Issue Description is required" ForeColor="Red" ControlToValidate="txtIssue" ValidationGroup="downtime"></asp:RequiredFieldValidator>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Incident Type</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlIncident" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlIncident_SelectedIndexChanged">
                                    <asp:ListItem Enabled="true" Selected="True" Text="Select Incident Type" Value="0"></asp:ListItem>
                                <asp:ListItem Enabled="true" Text="Client External" Value="1"></asp:ListItem>
                                <asp:ListItem Enabled="true" Text="Sitel Internal" Value="2"></asp:ListItem>
                                    <asp:ListItem Enabled="true" Text="Others" Value="3"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" Display="Dynamic" ErrorMessage="Select Incident Type" ForeColor="Red" ControlToValidate="ddlIncident" ValidationGroup="downtime"></asp:RequiredFieldValidator>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    

                </div>

                <div class="row">

                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Enter Client Ticket</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                <asp:TextBox runat="server" ID="txtClientTicket" CssClass="form-control select" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" Display="Dynamic" ErrorMessage="Client Ticket is Required" ForeColor="Red" ControlToValidate="txtClientTicket" ValidationGroup="downtime"></asp:RequiredFieldValidator>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>

                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Enter Sitel Ticket</label>
                            <div class="input-group">
                                <span class="input-group-addon"><i class="fa fa-user"></i></span>
                                <asp:TextBox runat="server" ID="txtSitelTicket" CssClass="form-control select" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" Display="Dynamic" ErrorMessage="Sitel Ticket is Required" ForeColor="Red" ControlToValidate="txtSitelTicket" ValidationGroup="downtime"></asp:RequiredFieldValidator>

                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>

                    <div class="col-lg-3">
                    <div class="form-group">
                        <label>Add Attachment</label>
                        <div class="input-group">
                            <%--<asp:ListBox  ItemType="text" CssClass="form-control select" ID="lbSites" SelectionMode="Multiple" runat="server">
                            </asp:ListBox>--%>
                            <asp:FileUpload ID="AttachIssueMail" runat="server"  accept=".msg" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" Display="Dynamic" ErrorMessage="Attach refrence Mail" ForeColor="Red" ControlToValidate="AttachIssueMail" ValidationGroup="downtime"></asp:RequiredFieldValidator>
                             <asp:RegularExpressionValidator ID="RegularExpressionValidatorAttachment" ValidationExpression="([a-zA-Z0-9\s_\\.\-:])+(.msg)$"

    ControlToValidate="AttachIssueMail" runat="server" ForeColor="Red" ErrorMessage="Please select a valid mail file."

    Display="Dynamic" />

                        </div>
                        <!-- /.input group -->
                    </div>
                </div>

                    <div class="col-lg-3" ><%--style="margin-top:1%;"--%>
               <%-- <div class="pull-right" >--%>
<div class="row" style="margin-top:2.5%;">
    <div class="col-lg-6">
                    <asp:Button ID="btnDiscardEsc" runat="server" Text="Discard" CssClass="btn btn-default" OnClick="btnDiscardEsc_Click" Width="100%" />
                    </div><%--&nbsp--%>
    <div class="col-lg-6">
                        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="btnSave_Click" ValidationGroup="downtime" Width="100%" />
    </div>
    </div>            
    <%--</div>--%>
                    </div>

                </div>

            </div>

           <%-- <div class="box-footer">               
            </div>--%>
        </div>
        <%--</div>--%>

        <div class="row">
            <div class="col-md-12">
                <div class="box box-primary">
                    <div class="box-header with-border">
                        <h3 class="box-title">Downtime Log </h3>
                    </div>
                    <!-- /.box-header -->
                    <div class="box-body">
                        
                       <asp:GridView ID="gvDowntimeLog" runat="server" CssClass="table table-bordered table-hover DataTable" AutoGenerateColumns="false" ShowHeaderWhenEmpty="true" OnPreRender="gv_PreRender"><%--OnPreRender="gv_PreRender"--%>
                           <Columns>
                               <asp:BoundField DataField="Date" HeaderText="Date" SortExpression="Date"></asp:BoundField>
                               <asp:BoundField DataField="Interval" HeaderText="Interval" SortExpression="Interval"></asp:BoundField>
                               <asp:BoundField DataField="AccountName" HeaderText="AccountName" SortExpression="Account"></asp:BoundField>
                               <asp:BoundField DataField="LOB" HeaderText="LOB" SortExpression="LOB"></asp:BoundField>
                               <asp:BoundField DataField="Sites" HeaderText="Sites" SortExpression="Sites"></asp:BoundField>
                               <asp:BoundField DataField="Issue" HeaderText="Issue" SortExpression="Issue"></asp:BoundField>
                               <asp:BoundField DataField="IncidentType" HeaderText="IncidentType" SortExpression="IncidentType"></asp:BoundField>
                               <asp:BoundField DataField="ClientTicket" HeaderText="ClientTicket" SortExpression="ClientTicket"></asp:BoundField>
                               <asp:BoundField DataField="SitelTicket" HeaderText="SitelTicket" SortExpression="SitelTicket"></asp:BoundField>
                               <asp:TemplateField HeaderText="Attachment">
                                   <ItemTemplate>
                                       <asp:LinkButton ID="lbDownload" Text="download" CommandArgument='<%# Eval("Attachment") %>' runat="server" OnClick="lbDownload_Click"></asp:LinkButton>
                                   </ItemTemplate>
                               </asp:TemplateField>
                               <asp:BoundField DataField="Name" HeaderText="Issued By" SortExpression="ActionBy"></asp:BoundField>
                               <asp:BoundField DataField="ActionOn" HeaderText="Issued On" SortExpression="ActionOn"></asp:BoundField>
                           </Columns>
                       </asp:GridView>

                    </div>
                    <!-- /.box-body -->
                    <div class="box-footer clearfix">
                       
                    </div>
                </div>
                <!-- /.box -->
            </div>
            <!-- /.col -->

        </div>
        <!-- /.row -->

    </section>
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

            $('#tbDate').datepicker({
                format: 'dd-MM-yyyy',
                //orientation: "bottom auto",
                autoclose: true
            });

        });

        function ValidateCheckBoxList(sender, args) {

            var checkBoxList = document.getElementById("<%=lbSites.ClientID %>");

            var checkboxes = checkBoxList.getElementsByTagName("input");

            var isValid = false;

            for (var i = 0; i < checkboxes.length; i++) {

                if (checkboxes[i].checked) {

                    isValid = true;

                    break;

                }

            }

            args.IsValid = isValid;

        }
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
