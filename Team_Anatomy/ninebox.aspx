<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="ninebox.aspx.cs" Inherits="ninebox" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>
<asp:Content ID="Content4" ContentPlaceHolderID="pageheader" runat="Server">
    <ol class="breadcrumb">
        <li><a href="index.aspx"><i class="iconfa-home"></i>Home</a></li>
        <li class="active"><a href="pacman.aspx">
            <img src="sitel/img/performance-360_bw.png" style="height: 10px" alt="" />PACMAN</a></li>
    </ol>
    <div class="pageheader">
        <div class="pageicon">
            <img src="sitel/img/performance-360_bw.png" style="height: 60px" alt="" />
        </div>
        <div class="pagetitle">
            <h5>Scores acheived by Managers on Performance Tests and Competency</h5>
            <h1>Nine Box</h1>
        </div>
    </div>
    <!--pageheader-->
    <style type="text/css">
        .modal {
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
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">

    <div class="box">
        <div class="box-body">
            <div class="form-group">
                <div class="col-lg-3">
                    <div class="form-group">
                        <label>Select Period</label>
                        <div class="input-group">
                            <div class="input-group-addon">
                                <i class="fa fa-calendar"></i>
                            </div>
                            <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlPeriod" runat="server">
                            </asp:DropDownList>
                        </div>
                        <!-- /.input group -->
                    </div>
                </div>
                <asp:Panel ID="pnlIsPacmanDiscussion" runat="server" Visible="false">
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Drilldown : Reporting Manager</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-calendar-check-o"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select2" ID="ddlMgr" runat="server"
                                    OnSelectedIndexChanged="ddlMgr_SelectedIndexChanged" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Designation</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select2" ID="ddlDesignation"
                                    runat="server" AutoPostBack="true">
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <div class="col-lg-3">
                        <div class="form-group">
                            <label>Select Role</label>
                            <div class="input-group">
                                <div class="input-group-addon">
                                    <i class="fa fa-user"></i>
                                </div>
                                <asp:DropDownList ItemType="text" CssClass="form-control select" ID="ddlSPI" runat="server">
                                    <asp:ListItem Enabled="true" Text="False" Value="0"></asp:ListItem>
                                    <asp:ListItem Enabled="true" Text="True" Value="1"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
    <%--<button id="btnPrint" onclick="convert2PDF()" class="btn btn-primary">Print PDF</button>--%>
    <div class="printable">
        <asp:ListView ID="lvMGR" runat="server">
            <LayoutTemplate>
                <div class="row" id="itemPlaceholderContainer" runat="server">
                    <div class="col-md-6" id="itemPlaceholder" runat="server">
                    </div>
                </div>
            </LayoutTemplate>
            <ItemTemplate>
                <div class="col-md-6" runat="server">
                    <div class="box box-primary" runat="server">
                        <div class="box-header with-border" runat="server">
                            <h3 class="box-title" runat="server"><%#Eval("NAME") %> :
                            <label id="lblEmpID"><%#Eval("EMPCODE") %></label></h3>
                            </a>
                        <div class="box-tools pull-right" runat="server">
                            <button type="button" class="btn btn-box-tool" data-widget="collapse" runat="server">
                                <i class="fa fa-minus" runat="server"></i>
                            </button>
                        </div>
                        </div>
                        <div class="box-body" style="height: 300px; width: 600px" runat="server">
                            <div class="chart-container" runat="server">
                                <canvas id="mgrChart<%#Eval("EMPCODE") %>" class="mgrChart<%#Eval("EMPCODE") %>" style="height: 300px; width: 600px"></canvas>
                            </div>
                        </div>
                        <!-- /.box-body  -->
                        <%--<div class="box-footer">
                        <div class="progress progress-sm">
                            <progress id="mgrChartAnimationProgress<%#Eval("EMPCODE") %>" class="progress-bar progress-bar-primary progress-bar-striped" role="progressbar" max="1" value="0" style="width: 100%"></progress>
                        </div>
                    </div>--%>
                    </div>
                    <!-- /.box -->
                </div>
            </ItemTemplate>
        </asp:ListView>
        <asp:ListView ID="lvSkill" runat="server">
            <LayoutTemplate>
                <div class="row" id="itemPlaceholderContainer" runat="server">
                    <div class="col-md-6" id="itemPlaceholder" runat="server">
                    </div>
                </div>
            </LayoutTemplate>
            <ItemTemplate>
                <div class="col-md-6" runat="server">
                    <div class="box box-default box-solid">
                        <div class="box-header with-border">
                            <h3 class="box-title">Department : <%#Eval("Skillset") %></h3>
                            <div class="box-tools pull-right">
                                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div class="chart-container">
                                <canvas id="skillChart<%#Eval("SkillsetID") %>" class="skillChart<%#Eval("SkillsetID") %>" style="height: 300px; width: 600px"></canvas>
                            </div>
                        </div>
                        <!-- /.box-body  -->
                    </div>
                    <!-- /.box -->
                </div>
            </ItemTemplate>
        </asp:ListView>
    </div>

    <div id="progress" class="modal">
        <div class="clscustomcenter">
            <img src="Sitel/img/loader.gif" />
            <span class="clsloadtxt">processing....</span>
        </div>
    </div>
    <style type="text/css">
        .widget-user .widget-user-image {
            position: absolute;
            top: 25%;
            right: 5%;
            bottom: -6%;
            margin-left: -45px;
        }

        .widget-user-2 .widget-user-username {
            margin-top: 3%;
        }
    </style>
    <div class="modal fade" id="modalEmployee">
        <div class="modal-dialog" style="width: 90%">
            <div class="modal-content">
                <div class="box box-widget widget-user-2">
                    <div class="widget-user-header bg-primary">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                        <div class="widget-user-image" style="margin-bottom: -8%; overflow: hidden;">
                            <img id="mdUserImage" class="img-circle" src="Sitel/user_images/unknownPerson.jpg" alt="User Avatar" style="height: 65px; width: 65px;">
                        </div>
                        <!-- /.widget-user-image -->
                        <h3 class="widget-user-username" id="mdEmpName"></h3>
                        <h5 class="widget-user-desc" id="mdRepMgr"></h5>
                    </div>
                </div>
                <!-- Custom Tabs -->
                <div class="nav-tabs-custom">
                    <ul class="nav nav-tabs">
                        <li class="active"><a href="#tabPacman" data-toggle="tab"><span>Performance&nbsp</span></a></li>
                        <li><a href="#tabCompetency" data-toggle="tab">Competency&nbsp</a></li>
                        <%--<li><a href="#tabSkill" data-toggle="tab">Skill&nbsp</a></li>--%>
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Export As <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:convert2PDF()"><i class="fa fa-fw fa-file-pdf-o"></i>PDF</a></li>
                            </ul>
                        </li>
                    </ul>
                    <div id="tabPrintable" class="tab-content">
                        <!-- /.tab-pane -->
                        <div class="tab-pane active" id="tabPacman" style="overflow-y: scroll; height: 420px; overflow-x: hidden;">
                            <h3 id="spanPacman">Performance Rating : </h3>
                            <div id="divPacman">
                                <table id="tblPacman" class="table table-condensed table-bordered table-striped table-hover table-responsive">
                                    <thead>
                                        <tr>
                                            <th>Pacman Rating</th>
                                            <th>Test Score</th>
                                            <th>Competency Rating</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                            <h3 id="spanTest">Test Score : </h3>
                            <div id="divTest">
                                <table id="tblTest" class="table table-condensed table-bordered table-striped table-hover table-responsive">
                                    <thead>
                                        <tr>
                                            <th>Analytics</th>
                                            <th>Aptitude</th>
                                            <th>Planning</th>
                                            <th>RTA</th>
                                            <th></th>
                                            <th>Scheduling</th>
                                            <th>WFC</th>
                                            <th>Total</th>
                                        </tr>
                                    </thead>
                                </table>
                            </div>
                        </div>
                        <!-- /.tab-pane -->
                        <div class="tab-pane" id="tabCompetency" style="overflow-y: scroll; height: 420px; overflow-x: hidden;">
                            <%--<h3 id="spanCompetency">Competency Score: </h3>--%>
                            <div id="divCompetency">
                            </div>
                        </div>
                        <!-- /.tab-pane -->
                        <%--<div class="tab-pane" id="tabSkill" style="overflow-y: scroll; height: 420px; overflow-x: hidden;">
                            <div id="divSkill">
                                <div class="box box-solid">
                                    <div class="box-header with-border">
                                        <h3 id="spanCompetency" class="box-title">Competency Score: </h3>
                                    </div>
                                    <!-- /.box-header -->
                                    <div class="box-body">
                                        <div class="box-group" id="accordion">
                                            <!-- Panel 1 : Begins -->
                                            <div id="collapse1Panel" class="panel box box-primary">
                                                <div class="box-header with-border">
                                                    <h5 class="box-title">
                                                        <a data-toggle="collapse" id="collapse1Link" data-parent="#accordion" href="#collapse1">Building Effective Teams</a>&nbsp:&nbsp
                                                        <a data-toggle="collapse" id="collapse1Rating" data-parent="#accordion" href="#collapse1">4</a>&nbsp(&nbsp
                                                        <a data-toggle="collapse" id="collapse1Rating_Scale" data-parent="#accordion" href="#collapse1">High Meet Expectations</a>&nbsp)&nbsp
                                                    </h5>
                                                </div>
                                                <div id="collapse1" class="panel-collapse collapse in">
                                                    <div id="collapse1body" class="box-body row">
                                                        <div id="collapse1Description" class="col-md-6 text-muted">
                                                            Interpretation: Understanding that all teams must work towards a common goal is the main lesson for any manager. By helping teams to achieve joint success as well as their own job satisfaction will help them to realise that they need each other to really succeed.
                                                        </div>
                                                        <div id="collapse1Comments" class="col-md-6 well">
                                                            Achieved: Employee has been handling the team efficiently and has been training them for their growth as well. He has handled all escalations pretty well in the past.
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Panel 1 : Ends-->
                                        </div>
                                    </div>
                                    <!-- /.box-body -->
                                </div>
                                <!-- END ACCORDION & CAROUSEL-->
                            </div>
                        </div>--%>
                        <!-- /.tab-pane -->
                    </div>
                    <!-- /.tab-content -->
                </div>
                <!-- nav-tabs-custom -->
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
    <!-- /.modal -->
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="below_footer" runat="Server">
    <script type="text/javascript" src="Sitel/cdn/chartjs/Chart.bundle.min.js"></script>
    <script src="Sitel/cdn/jspdf/jspdf.min.js"></script>
    <script src="Sitel/cdn/jspdf/jspdf.plugin.autotable.js"></script>
    <script type="text/javascript">
        $(function () {
            pluginsInitializer();
            $('#progress').show();
            var EMPCODE = $('#lblEmpID').text();
            $('[class*="mgrChart"]').each(function () {
                var id = $(this).prop('id');
                id = id.replace("mgrChart", "");
                if (parseInt(id) > 0) {
                    fillChart(id, 'H1 2018');
                }
            });
            $('[class*="skillChart"]').each(function () {
                var id = $(this).prop('id');
                id = id.replace("skillChart", "");
                if (parseInt(id) > 0 && parseInt(EMPCODE) > 0) {
                    //Fill the charts with skill based charts
                    fillSkillSetBubble(EMPCODE, id);
                }
            });
        });
        function fillChart(EmpCode, Period) {
            var params = '{"EMPCODE":"' + EmpCode + '", "Period":"' + Period + '"}';
            if (EmpCode != "" && EmpCode != "0") {

                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/GetBubbleChart",
                    data: params,
                    async: true,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (responseData) {
                        if (responseData.d.length > 0) {
                            //// With Fixed Color palette
                            var xDataSets = [];
                            for (var i = 0; i < responseData.d.length; i++) {

                                var SPI = parseFloat(responseData.d[i]["SPI"]);
                                var spiCounter = 0;
                                var myColor = fixedColorPalette(i);
                                var headerTitle = responseData.d[i]["Name"].toString() + " : " + responseData.d[i]["EmpCode"].toString() + " : " + responseData.d[i]["Period"].toString();

                                
                                if (SPI !== undefined && SPI !== NaN && SPI == 0) {
                                    xDataSets[i] = {
                                        label: headerTitle,
                                        backgroundColor: myColor,
                                        borderColor: myColor,
                                        borderWidth: 1,
                                        data: [{
                                            x: responseData.d[i]["Competency"],
                                            y: responseData.d[i]["Performance"],
                                            r: responseData.d[i]["Radius"],
                                        }],
                                    };
                                } else {
                                    // SPI is 1 for New Joinees and 2 for Promotees.
                                 
                                    spiCounter++;
                                    xDataSets[i] = {
                                        label: headerTitle,
                                        backgroundColor: myColor,
                                        borderColor: myColor,
                                        borderWidth: 1,
                                        data: [{
                                            // These are shifted to the bottom right corner of the Chart. x lies in [90-100]
                                            x: (90 + responseData.d[i]["Competency"] / 10),
                                            // y lies in [0-30]
                                            y: (spiCounter + 0.3 * parseFloat(responseData.d[i]["Performance"])),
                                            r: responseData.d[i]["Radius"],
                                        }],
                                    };
                                }


                            }
                            CreateNineBoxChart(xDataSets);
                        }
                    },
                    failure: function (responseData) {
                        alert(responseData.d);
                    }
                });
            }
            function CreateNineBoxChart(xdata) {
                var ctx = $("#mgrChart" + EmpCode);
                if (xdata != null) {
                    ctx.empty();
                }
                var myChart = new Chart(ctx, {
                    type: 'bubble',
                    data: {
                        labels: "Managers",
                        datasets: xdata,
                    },
                    hoverRadius: 0,
                    options: {
                        //events: ['click'],
                        onClick: function (e) {
                            getEmpStats(e, this);
                        },


                        title: {
                            display: false,
                            text: 'Scores acheived by Managers on Performance Tests and Competency'
                        },
                        legend: {
                            display: false,
                            position: 'right'
                        },
                        animation: {
                            duration: 1000,
                            //onProgress: function (animation) {
                            //    progress.val(animation.currentStep / animation.numSteps);
                            //}
                        },
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    min: 0,
                                    max: 100,
                                    stepSize: 30,
                                    maxTicksLimit: 4
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: "Performance (More is better)"
                                }
                            }],
                            xAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    min: 0,
                                    max: 100,
                                    stepSize: 30,
                                    maxTicksLimit: 4
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: "Competency (More is better)"
                                }
                            }]
                        },
                    },
                });
            }

            $('#progress').hide();
        }
        function fillSkillSetBubble(EmpCode, Skill) {
            $('#progress').show();
            var params = '{"EMPCODE":"' + EmpCode + '", "Skill":"' + Skill + '"}';
            if (EmpCode != "" && EmpCode != "0") {

                $.ajax({
                    type: "POST",
                    url: "ninebox.aspx/GetSkillChart",
                    data: params,
                    async: true,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (responseData) {
                        if (responseData.d.length > 0) {
                            var xDataSets = [];
                            for (var i = 0; i < responseData.d.length; i++) {
                                var myColor = fixedColorPalette(i);
                                var headerTitle = responseData.d[i]["Name"].toString() + " : " + responseData.d[i]["EmpCode"].toString() + " : " + responseData.d[i]["Period"].toString();
                                var xDataSet = {
                                    label: headerTitle,
                                    backgroundColor: myColor,
                                    borderColor: myColor,
                                    data: [
                                        {
                                            x: responseData.d[i]["Competency"],
                                            y: responseData.d[i]["Performance"],
                                            r: responseData.d[i]["Radius"],
                                        }],
                                };
                                xDataSets.push(xDataSet);
                            }
                            CreateNineBoxChart(xDataSets);
                        }
                    },
                    failure: function (response) {
                        alert(response.d);
                    }
                });
            }
            function CreateNineBoxChart(xdata) {
                var ctx = $("#skillChart" + Skill);
                if (xdata != null) {
                    ctx.empty();
                }
                var myChart = new Chart(ctx, {
                    type: 'bubble',
                    data: {
                        labels: "Managers",
                        datasets: xdata,
                    },
                    hoverRadius: 0,
                    options: {
                        //events: ['click'],
                        onClick: function (e) {
                            getEmpStats(e, this);
                        },
                        title: {
                            display: false,
                            text: 'Scores acheived by Managers on Performance Tests and Competency'
                        },
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    min: 0,
                                    max: 100,
                                    stepSize: 30,
                                    maxTicksLimit: 4
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: "Performance (More is better)"
                                }
                            }],
                            xAxes: [{
                                ticks: {
                                    beginAtZero: true,
                                    min: 0,
                                    max: 100,
                                    stepSize: 30,
                                    maxTicksLimit: 4
                                },
                                scaleLabel: {
                                    display: true,
                                    labelString: "Competency (More is better)"
                                }
                            }]
                        },
                        legend: {
                            display: false
                        },
                        animation: {
                            duration: 1000,
                            //onProgress: function (animation) {                                
                            //    progress.val(animation.currentStep / animation.numSteps);
                            //}
                        },

                    },
                });
            }
            $('#progress').hide();
        }
        function fixedColorPalette(i) {
            var palette = [
                "rgba(54, 109, 209, 1)",
                "rgba(103, 158, 2, 1)",
                "rgba(163, 212, 68, 1)",
                "rgba(206, 235, 129, 1)",
                "rgba(242, 255, 181, 1)",
                "rgba(105, 22, 3, 1)",
                "rgba(158, 68, 34, 1)",
                "rgba(212, 132, 84, 1)",
                "rgba(235, 181, 127, 1)",
                "rgba(255, 226, 170, 1)",
            ];
            var l = palette.length - 1;

            l = i % l;
            // ;
            //var dynamicColors = function () {
            //    var r = Math.floor(Math.random() * 255);
            //    var g = Math.floor(Math.random() * 255);
            //    var b = Math.floor(Math.random() * 255);
            //    return "rgb(" + r + "," + g + "," + b + ")";
            //};

            return palette[l].toString();

            return dynamicColors;
        }
        function getEmpStats(e, me) {
            var element = me.getElementAtEvent(e);
            // If you click on at least 1 element ...
            if (element.length > 0) {
                // Here we get the data linked to the clicked bubble ...
                var Header = me.config.data.datasets[element[0]._datasetIndex].label;
                EmpName = Header.split(":");
                var EmpCode = EmpName[1].trim();
                var Period = EmpName[2].trim();
                showEmployeeModal(EmpCode, Period);
            }
        }
        function showEmployeeModal(EmpCode, Period) {
            var params = '{"empcode":"' + EmpCode + '", "period":"' + Period + '"}';

            // get Employee Competency
            $.ajax({
                type: "POST",
                url: "ninebox.aspx/getEmpCompetencyFromDB",
                data: params,
                async: true,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (responseData) {
                    if (responseData.d.length > 0) {
                        var d = responseData.d;
                        var strTable = '<table id="tableCompetency" class="table table-condensed table-bordered table-striped table-hover table-responsive makeDataTable" ><thead><tr><th>COMPETENCY</th><th>DESCRIPTION</th><th>COMMENTS</th><th>RATING</th><th>RATING SCALE</th></tr></thead><tbody>';
                        for (var i = 0; i < d.length - 1; i++) {
                            strTable += '<tr><td>' + d[i].COMPETENCY + '</td><td>' + d[i].DESCRIPTION + '</td><td>' + d[i].COMMENTS + '</td><td>' + d[i].RATING + '</td><td>' + d[i].RATINGSCALE + '</td></tr>';
                        }
                        strTable += '</tbody></table>';
                        $('#divCompetency').html("");
                        $('#divCompetency').append(strTable);
                    }

                },
                failure: function (responseData) {
                    alert(responseData.d);
                }
            });

            // get Employee Stats
            $.ajax({
                type: "POST",
                url: "ninebox.aspx/getEmpStatsFromDB",
                data: params,
                async: true,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (responseData) {
                    if (responseData.d.length > 0) {
                        var d = responseData.d;
                        if (d[0].UserImage) {
                            $('#mdUserImage').attr('src', 'Sitel/user_images/' + d[0].UserImage);
                        } else {
                            $('#mdUserImage').attr('src', 'Sitel/user_images/unknownPerson.jpg');
                        }
                        var SPI = d[0].SPI;
                        if (SPI == "1") { SPI = "SPI"; }
                        else if (SPI == "2") { SPI = "Recent Promotion"; }
                        $('#mdEmpName').text(d[0].Name + " : " + EmpCode + " : " + Period + " : " + SPI);
                        $('#mdRepMgr').text("Reports to : " + d[0].RepMgr + " : " + d[0].RepMgrCode);
                        
                        $('#spanPacman').text('Performance Rating : ' + d[0].PacManRating);
                        $('#spanTest').text('Test Score : ' + d[0].TestScore);
                        $('#spanCompetency').text('Competency Score: ' + d[0].CompetencyRating);

                        $('#tdEmpcode').text(EmpCode);
                        $('#tdName').text(EmpName[0].trim());
                        $('#tdReportingManager').text();
                        // Populate the Employee PACMAN Table                        
                        var strTable = '<table id="tblPacman" class="table table-condensed table-bordered table-striped table-hover table-responsive makeDataTable">';
                        strTable += '<thead><tr><th>Pacman Rating</th><th>Test Score</th><th>Competency Rating</th></tr></thead><tbody>'
                        var e;
                        for (var i = 0; i < d.length; i++) {
                            e = d[i];
                            strTable += '<tr><td>' + e.PacManRating + '</td><td>' + e.TestScore + '</td><td>' + e.CompetencyRating + '</td></tr>';
                        }
                        strTable += '</tbody></table>';
                        $('#divPacman').html("");
                        $('#divPacman').append(strTable);

                        // Populate the Employee Test Table
                        strTable = '<table id="tblTest" class="table table-condensed table-bordered table-striped table-hover table-responsive makeDataTable">';
                        strTable += '<thead><tr><th>Analytics</th><th>Aptitude</th><th>Planning</th><th>RTA</th><th>Scheduling</th><th>WFC</th><th>Total</th></tr></thead><tbody>'

                        for (var i = 0; i < d.length; i++) {
                            e = d[i];
                            strTable += '<tr><td>' + e.Analytics + '</td><td>' + e.Aptitude + '</td><td>' + e.Planning + '</td><td>' + e.RTA + '</td><td>' + e.Scheduling + '</td><td>' + e.WFC + '</td><td>' + e.Total + '</td></tr>';
                        }
                        strTable += '</tbody></table>';
                        $('#divTest').html("");
                        $('#divTest').append(strTable);
                    }
                },
                failure: function (responseData) {
                    alert(responseData.d);
                }
            });

            // Provision the above as datatables
            // pluginsInitializer();

            // Show the fully built up modal
            $('#modalEmployee').modal({
                backdrop: 'static'
            });
        }
        function convert2PDF() {
            var pdf = new jsPDF('l', 'pt', 'A3');

            //$('#tabPacman').tabs({ active: 1 });
            source = $('#tabPacman')[0];
            specialElementHandlers = {
                'canvas': function (element, renderer) {
                    return true;
                }
            };
            var margins = {
                top: 12.7,
                bottom: 12.7,
                left: 12.7,
                width: 522
            };
            pdf.fromHTML(source, margins.left, margins.top, {
                'width': margins.width, // max width of content on PDF
                'elementHandlers': specialElementHandlers
            });
            pdf.addPage('l');
            source = $("#divCompetency").find('table')[0];
            source = pdf.autoTableHtmlToJson(source);
            pdf.autoTable(source.columns, source.data, {
                startY: 20,
                margin: {
                    top: 10,
                    right: 10,
                    bottom: 10,
                    left: 10,
                    useFor: 'page'
                },
                bodyStyles: {
                    valign: 'middle'
                },
                styles: {
                    overflow: 'linebreak',
                    columnWidth: 'wrap'
                },
                theme: 'grid',
                columnStyles: {
                    0: { columnWidth: 120 },
                    1: { columnWidth: 450 },
                    2: { columnWidth: 450 },
                    3: { columnWidth: 50 },
                    4: { columnWidth: 100 },
                }

            });
            var reportName = $('#mdEmpName').text();
            reportName = reportName.replace(":", " ");
            reportName = reportName.replace("  ", " ");
            pdf.save('Nine Box Report for ' + reportName + '.pdf');
        }
        function pluginsInitializer() {
            var table = $('[class*="makeDataTable"]').dataTable({
                destroy: true,
                "responsive": true,
                "fixedHeader": true,
                "sPaginationType": "full_numbers",
                "lengthMenu": [2, 5, 10, 25, 50, 75],
                "aaSortingFixed": [[0, 'asc']],
                "bSort": true,
                //dom: 'Bfrltip',
                "columnDefs": [{ "orderable": false, "targets": 0 }],

            });
        }
    </script>
</asp:Content>

