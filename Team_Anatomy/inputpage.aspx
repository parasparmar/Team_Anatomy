<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="inputpage.aspx.cs" Inherits="inputpage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceHolder" runat="server">
    <link href="Sitel/toastr/toastr.min.css" rel="stylesheet" />
    <style type="text/css">
        .modals {
            background: rgba(0,0,0,.7) !important;
        }

        .clscustomcenter {
            width: 0%;
            margin: 20% auto;
            padding: 10px;
            opacity: 1;
            z-index: 1000;
        }

        .clscustomcenter img {
            border-radius: 5px;
        }

        .clscustomcenter .clsloadtxt {
            display: block;
            padding-top: 12px;
            color: #fff;
            letter-spacing: 1px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="pageheader" runat="server">
    <%-- <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="inputpage.aspx">
            <i class="fa fa-commenting"></i>Input Page</a></li>
    </ol>
    <div class="pageheader">
        <div class="pageicon">
            <i class="fa fa-commenting"></i>
        </div>
        <div class="pagetitle">
            <h5>To be described...</h5>
            <h1>Input Page</h1>
        </div>
    </div>--%>
    <!--pageheader-->
</asp:Content>

<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <div class="row">
        <div class="col-md-12">
            <div class="box">
                <div class="box-body">
                    <div class="form-group">
                        <div class="col-lg-2">
                            <div class="form-group">
                                <label>Select Month</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlMonth" runat="server" OnSelectedIndexChanged="ddlMonth_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select Market</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlMarket" runat="server" OnSelectedIndexChanged="ddlMarket_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-3">
                            <div class="form-group">
                                <label>Select Facility Name</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlFacility" runat="server" OnSelectedIndexChanged="ddlFacility_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-2">
                            <div class="form-group">
                                <label>Select Account</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlAccount" runat="server" OnSelectedIndexChanged="ddlAccount_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                        <div class="col-lg-2">
                            <div class="form-group">
                                <label>Fetch</label>
                                <div class="input-group">
                                    <div class="input-group-addon">
                                        <i class="fa fa-calendar"></i>
                                    </div>
                                    <asp:LinkButton ID="btnFetch" runat="server" OnClick="btnFetch_Click" Text="Fetch" CssClass="btn btn-primary btn-flat"></asp:LinkButton>
                                    <%--<input type="button" id="btnFetch" class="btn btn-primary" value="Fetch" />--%>
                                </div>
                                <!-- /.input group -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="nav-tabs-custom">
        <ul class="nav nav-tabs">
            <li class="active"><a href="#tabOverall" data-toggle="tab"><span>Overall&nbsp</span></a></li>
            <li><a href="#tabComparison" data-toggle="tab">Comparison&nbsp</a></li>
            <li><a href="#tabSkill" data-toggle="tab">Additional&nbsp</a></li>
            <li class="dropdown pull-right">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                  Export Formats <span class="caret"></span>
                </a>
                <ul class="dropdown-menu">
                  <li role="presentation">
                      <asp:LinkButton ID="btnExport" role="menuitem" tabindex="-1" OnClick="btnExport_Click" runat="server" Text="Export to Excel"></asp:LinkButton>
                </ul>
              </li>
        </ul>
        <div id="tabPrintable" class="tab-content">
            <div class="tab-pane active" id="tabOverall" runat="server">
                <div class="row">
                    <asp:UpdatePanel ID="u1" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div class="col-md-6">
                                <div class="box box-primary box-solid">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">Overall Population</h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <asp:GridView ID="gvOverall1" CssClass="table table-responsive table-condensed makeDataTable" runat="server" AutoGenerateColumns="true" OnPreRender="gv_PreRender"></asp:GridView>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                            </div>
                            <!-- Overall Population-->
                            <div class="col-md-6">
                                <div class="box box-primary box-solid">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">Boost, Kronos and BO Populations</h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <asp:GridView ID="gvOverall2" CssClass="table table-responsive table-condensed makeDataTable" runat="server" AutoGenerateColumns="true" OnPreRender="gv_PreRender"></asp:GridView>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                            </div>
                            <!-- Boost, Kronos and BO Populations-->
                            <div class="col-md-12">
                                <div class="box box-primary box-solid">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">Account Level Populations</h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <asp:GridView ID="gvOverall3" CssClass="table table-responsive table-condensed makeDataTable" runat="server" AutoGenerateColumns="true" OnPreRender="gv_PreRender"></asp:GridView>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                            </div>
                            <!-- Account Level Populations-->
                            <div class="col-md-12">
                                <div class="box box-primary box-solid">
                                    <div class="box-header with-border">
                                        <h3 class="box-title">Site Level Populations</h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <asp:GridView ID="gvOverall4" CssClass="table table-responsive table-condensed makeDataTable" runat="server" AutoGenerateColumns="true" OnPreRender="gv_PreRender"></asp:GridView>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                            </div>
                            <!-- Site Level Populations-->
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnFetch" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>

                </div>
            </div>
            <!-- /.tab-pane Overall-->
            <div class="tab-pane" id="tabComparison">
                <div class="box box-primary box-solid">
                    <div class="box-header with-border">
                        <h3 class="box-title">Agent Level Comparisons</h3>
                    </div>
                    <!-- /.box-header -->
                    <div id="divTable" class="box-body" style="overflow: scroll">
                    </div>
                    <!-- /.box-body -->
                </div>
            </div>
            <!-- /.tab-pane Comparison-->
            <div class="tab-pane" id="tabSkill">
            </div>
            <!-- /.tab-pane Skill-->
        </div>
        <!-- /.tab-content -->
    </div>
    <div id="progress" class="modal">
        <div class="clscustomcenter">
            <img src="Sitel/img/loader.gif" />
            <span class="clsloadtxt">processing....</span>
        </div>
    </div>
    <asp:HiddenField ID="hfNTID" runat="server" />
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <script src="Sitel/toastr/toastr.min.js"></script>
    <script>
        $(function () {
            pluginsInitializer();
        });
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        if (prm != null) {
            prm.add_endRequest(function (sender, e) {
                if (sender._postBackSettings.panelsToUpdate != null) {
                    pluginsInitializer();
                }
            });
        };

        function pluginsInitializer() {
            var table = $('[class*="makeDataTable"]').dataTable({
                destroy: true,
                "responsive": true,
                "autoWidth": true,
                "fixedHeader": true,
                "sPaginationType": "full_numbers",
                "lengthMenu": [15, 10, 25, 50, 75],
                "aaSortingFixed": [[0, 'asc']],
                "bSort": true,
                //dom: 'Bfrltip',
                "columnDefs": [{ "orderable": false, "targets": 0 }],

            });
            toastr.options = {
                "closeButton": true,
                "debug": false,
                "newestOnTop": false,
                "progressBar": false,
                "positionClass": "toast-top-right",
                "preventDuplicates": false,
                "onclick": null,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "5000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut"
            }
        }

        $("#btnFetch").click(function () {
            $('#progress').show();
            var repObj = {
                xMonth: $("#ddlMonth option:selected").val(),
                xMarket: $("#ddlMarket option:selected").val(),
                xFacility: $("#ddlFacility option:selected").val(),
                xAccount: $("#ddlAccount option:selected").val(),
            };

            $.ajax({
                url: "inputpage.aspx/GetData",
                //data: JSON.stringify(repObj),
                data: "{ 'xMonth': '" + $("#ddlMonth option:selected").val() + "', 'xMarket': '" + $("#ddlMarket option:selected").val() + "', 'xFacility': '" + $("#ddlFacility option:selected").val() + "', 'xAccount': '" + $("#ddlAccount option:selected").val() + "'}",
                type: "POST",
                async: true,
                contentType: "application/json;charset=utf-8",
                //dataType: "json",
                success: function (result) {

                    BindDataTable(result.d);
                },
                error: function (errormessage) {

                    alert(errormessage.responseText);

                }
            });

        });

        var BindDataTable = function (response) {
            $('#progress').show();
            $("#divTable").show();
            $("#divTable").html("");
            $("#divTable").html(response);
            //var table =
            $("#MyDataTable").DataTable({
                //dom: 'Bfrtip',
                "bDestroy": true,
                "paging": false,
                "info": false,
                "responsive": true,

            });

            $('#MyDataTable').css("font-size", ".8em");
            $('#MyDataTable > tbody > th').css("padding", "2px 5px !important");
            $('#MyDataTable > tbody > td').css("padding", "2px 5px !important");

            $('#MyDataTable > thead > tr > th:eq(10)').hide();
            $('#MyDataTable > thead > tr > th:eq(11)').hide();

            if ($('#MyDataTable > tbody > tr').length > 0) {
                //debugger;
                $('#MyDataTable > tbody > tr').each(function () {
                    //alert($(this).html());
                    var xEmpCode = $(this).find('td:eq(0)').html();
                    var xMonth = $("#ddlMonth option:selected").val();
                    //$(this).find('td:eq(12)').css("color","#fff");
                    var comments = $(this).find('td:eq(12)').text();
                    $(this).find('td:eq(12)').text("");
                    $(this).find('td:eq(12)').append('<textarea id="btn' + xEmpCode + '" style="width: 136px; height: 43px;resize:none;">' + comments + '</textarea><input style="float:right;width:50px;height:25px;" type="button" value="Save" empcode="' + xEmpCode + '" month="' + xMonth + '" onClick="xSave(this);">');
                    //$(this).find('td:eq(12)').append('<DIV style="color:#fff;">' + comments + '</DIV>');
                    $(this).find('td:eq(10)').hide();
                    $(this).find('td:eq(11)').hide();
                });

            }
            $('#progress').hide();

        }

        function xSave(xThis) {
            var empcode = $(xThis).attr("empcode");
            var month = $(xThis).attr("month");
            var comments = $("#btn" + empcode).val();
            var updatedby = $("#hfNTID").val();

            $.ajax({
                url: "inputpage.aspx/SaveComments",
                //data: JSON.stringify(repObj),
                data: "{ 'empcode': '" + empcode + "', 'month': '" + month + "', 'comments': '" + comments + "'}",
                type: "POST",
                async: true,
                contentType: "application/json;charset=utf-8",
                //dataType: "json",
                success: function (result) {
                    debugger;
                    $(xThis).parent().parent().find('td:eq(13)').html("");
                    $(xThis).parent().parent().find('td:eq(13)').html(updatedby);

                    $(xThis).parent().parent().find('td:eq(14)').html("");
                    $(xThis).parent().parent().find('td:eq(14)').html(result.d);

                    $(xThis).parent().parent().find('td:eq(12)').html("").append('<textarea id="btn' + empcode + '" style="width: 136px; height: 43px;resize:none;">' + comments + '</textarea><input style="float:right;width:50px;height:25px;" type="button" value="Save" empcode="' + empcode + '" month="' + month + '" onClick="xSave(this);">');
                    //parent().parent().find('td:eq(12)').append('<textarea id="btn' + empcode + '" style="width: 136px; height: 43px;resize:none;">' + comments + '</textarea><input style="float:right;width:50px;height:25px;" type="button" value="Save" empcode="' + empcode + '" month="' + month + '" onClick="xSave(this);">');
                    //$(xThis).parent().css("color", "#fff");
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });


        }
        //On UpdatePanel Refresh



    </script>
</asp:Content>

