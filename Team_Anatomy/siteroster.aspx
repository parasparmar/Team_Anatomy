<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="siteroster.aspx.cs" Inherits="myroster" %>

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
        <li class="active"><a href="myroster.aspx"><i class="fa fa-building"></i>Site Roster</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-building"></span></div>
        <div class="pagetitle">
            <h5>Administration View of Roster and Leaves for the Entire Site</h5>
            <h1>Site Rosters</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row-fluid">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">
                        <asp:Literal ID="ltlReportingMgrsTeam" Text="Roster For Site" runat="server"></asp:Literal></h4>
<%--                    <div class="box-tools pull-right">
                        <button class="btn btn-box-tool" type="button" data-widget="collapse">
                            <i class="fa fa-minus"></i>
                        </button>
                    </div>--%>
                </div>
                <div class="box-body">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                Country
                                <asp:DropDownList ID="ddlCountry" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged">
                                    <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <!-- Country-->
                        <div class="col-md-4">
                            <div class="form-group">
                                Site
                                        <asp:DropDownList ID="ddlSite" runat="server" CssClass="form-control select2" Style="width: 100%;" AutoPostBack="true" OnSelectedIndexChanged="ddlSite_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                            </div>
                        </div>
                        <!-- Site-->
                        <div class="col-md-4">
                            <div class="form-group">
                                Location
                                        <asp:DropDownList ID="ddlLocation" runat="server"
                                            CssClass="form-control select2" Style="width: 100%;"
                                            AutoPostBack="true" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged">
                                            <asp:ListItem Selected="True" Text="None" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                            </div>
                        </div>
                        <!-- Location-->
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            Week Selection
                            <div class="input-group">
                                <span class="input-group-addon">
                                    <asp:RadioButton ID="rdoWeekSelection" runat="server" GroupName="DateRangeSelection" />
                                </span>
                                <asp:DropDownList ID="ddlWeekSelection" runat="server" CssClass="form-control select2" Style="width: 100%;" OnSelectedIndexChanged="ddlWeekSelection_SelectedIndexChanged">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <!-- For a Selected Week range-->
                        <div class="col-md-4">
                            For a Date Range                            
                                <div class="input-group">
                                    <span class="input-group-addon">
                                        <asp:RadioButton ID="rdoCustomDateSelection" runat="server" GroupName="DateRangeSelection" />
                                    </span>
                                    <asp:TextBox ID="ddlFromDate" runat="server"
                                        CssClass="form-control datepicker" Style="width: 100%;"
                                        placeholder="From Date" OnTextChanged="ddlFromDate_TextChanged">                                            
                                    </asp:TextBox>
                                    <!-- From Date-->
                                    <asp:TextBox ID="ddlToDate" runat="server"
                                        CssClass="form-control datepicker" Style="width: 100%;"
                                        placeholder="To Date" OnTextChanged="ddlToDate_TextChanged">                                            
                                    </asp:TextBox>
                                    <!-- To Date-->
                                </div>
                        </div>
                        <!-- For a Specific Date Range-->
                        <div class="col-md-4">
                            <asp:Label ID="lblRosterTypeSelection" Text="Initiate" runat="server"></asp:Label>
                            <div class="form-group">
                                <asp:Button class="btn btn-primary form-control" ID="btnDownloadRoster" Text="Download" runat="server" OnClick="btnDownloadRoster_Click"></asp:Button>
                            </div>
                        </div>
                        <!-- Submit Button-->
                    </div>
                </div>
            </div>
            <!--tabcontent-->
        </div>
        <!-- /.col -->
    </div>
    <asp:Panel ID="debugZone" Visible="false" runat="server">
        <div class="row-fluid">
            <div class="col-md-12">
                <!-- Custom Tabs -->
                <div class="box box-solid box-primary" style="height: auto;">
                    <div class="box-header with-border">
                        <h4 class="box-title">
                            <asp:Literal ID="ltlRosterHeading" runat="server" Text="Week : "></asp:Literal></h4>


                    </div>
                    <div class="box-body">
                        <asp:GridView ID="gvRoster" runat="server" AutoGenerateColumns="true"
                            CssClass="table table-condensed table-responsive compact hover stripe"
                            OnPreRender="gv_PreRender">
                        </asp:GridView>

                    </div>
                    <div class="box-footer">
                    </div>
                </div>
                <!-- /.box-footer-->
            </div>
            <!--tabcontent-->
        </div>
        <!-- /.col -->
    </asp:Panel>
    <!---LHS Panel---->


</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <!-- Select2 -->
    <script src="AdminLTE/bower_components/select2/dist/js/select2.full.min.js"></script>
    <script>
        $(function () {
            
            //Initialize Select2 Elements
            $("[class*='select2']").select2();
            //Date picker

            $("[class*='datepicker']").datepicker({
                autoclose: true,
                format: "dd-M-yyyy"
            }).on("changeDate", function () {

                $("#rdoCustomDateSelection").prop("checked", true);
                $("#rdoWeekSelection").prop("checked", false);
            });

            $("#ddlWeekSelection").on("select2:close", function () {
                $("#rdoWeekSelection").prop("checked", true);
                $("#rdoCustomDateSelection").prop("checked", false);
            });

        });
    </script>

</asp:Content>
