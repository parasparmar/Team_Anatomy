<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="swap_wip.aspx.cs" Inherits="swap_wip" %>

<%@ MasterType VirtualPath="~/MasterPage.master" %>



<asp:Content ContentPlaceHolderID="below_footer" runat="server">
    


    <script type="text/javascript">
        function pluginsInitializer() {

            ////Initialize DataTable Elements
            //$('.DataTable').DataTable({
            //    "sPaginationType": "full_numbers",
            //    "lengthMenu": [5, 10, 25, 50, 75, 100],
            //    "aaSortingFixed": [[0, 'asc']],
            //    "bSort": true,
            //    dom: 'Bfrltip',
            //    "columnDefs": [{ "orderable": false, "targets": 0 }],
            //    buttons: [
            //        { extend: 'copyHtml5', text: 'Copy Data' },
            //        { extend: 'excelHtml5', text: 'Export to Excel' },
            //        { extend: 'csvHtml5', text: 'Export to CSV' },
            //        { extend: 'pdfHtml5', text: 'Export to PDF' },
            //    ]
            //});

            //Initialize Select2 Elements
            $('.select2').select2({});


            $('btn[id*="btnSwapShift"]').click(function () {
                $(this).toggleClass('btn-primary btn-warning');

                var myRow = $(this).parents('tr');
                var ddl1 = myRow.find('#ddl1');
                var ddl2 = myRow.find('#ddl2');
                var a = ddl1.val();
                var b = ddl2.val();
                //alert('Paras Original Shift : ' + a);
                //alert('Vishal Original Shift :' + b);
                // Initiate swap...

                ddl1.val(b);
                ddl1.trigger('change');

                ddl2.val(a);
                ddl2.trigger('change');

                //alert('Paras Swapped Shift : ' + ddl1.val());
                //alert('Vishal Swapped Shift : ' + ddl2.val());

            });
            $(".select2").change(function () {
                var myRow = $(this).parents('tr');

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

<asp:Content runat="server" ContentPlaceHolderID="The_Body">

    <div class="row-fluid">
        <div class="col-md-12">
            <!-- Custom Tabs -->
            <div class="box box-solid box-primary" style="height: auto;">
                <div class="box-header with-border">
                    <h4 class="box-title">Week : </h4>
                </div>
                <div class="box-body">

                    <div id="pnlSwap">


                        <table class="table table-condensed table-striped table-responsive compact hover stripe">
                            <thead>
                                <th>
                                    <h4>Shift Date</h4>
                                </th>
                                <!--Header1-->
                                <th>
                                    <h4>Paras Chandrakant Parmar</h4>
                                </th>
                                <!--Header2-->
                                <th>
                                    <h4></h4>
                                </th>
                                <!--Header3-->
                                <th>
                                    <strong>
                                        <h4>Vishal Shirsat</h4>
                                    </strong>
                                </th>
                                <!--Header4-->
                                <th>
                                    <h4>Headcount</h4>
                                </th>
                                <!--Header5-->
                            </thead>
                            <tbody>

                                <tr>
                                    <td>
                                        <p></p>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift1" class="link-muted">10:00-19:00</span>
                                        </em>
                                    </td>
                                    <!--Column2-->
                                    <td></td>
                                    <!--Column3-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift2" class="link-muted">WO</span>
                                        </em>
                                    </td>
                                    <!--Column4-->
                                    <td></td>
                                    <!--Column5-->
                                </tr>
                                <!--Row1-->
                                <tr>
                                    <td>
                                        <strong>
                                            <span id="lblDate">Mon, 01-Jan-2018</span>
                                        </strong>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl01$ddl1" id="ddl1" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="10:00-19:00">10:00-19:00</option>
                                            <option value="WO">WO</option>

                                        </select>
                                    </td>
                                    <!--Column2-->
                                    <td>
                                        <div class="btn-group">
                                            <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                        </div>

                                    </td>
                                    <!--Column3-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl01$ddl2" id="ddl2" class="form-control select2" style="width: 100%">
                                            <option value="10:00-19:00">10:00-19:00</option>
                                            <option selected="selected" value="WO">WO</option>

                                        </select>
                                    </td>
                                    <!--Column4-->
                                    <td>
                                        <input name="ctl00$The_Body$rptrSwapForm$ctl01$tbHeadCount" type="text" value="1" readonly="readonly" id="tbHeadCount" class="form-control" placeholder="HeadCount" />
                                        <input type="text" id="tbPostSwapHeadCount" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                    </td>
                                    <!--Column5-->
                                </tr>
                                <!--Row2-->

                                <tr>
                                    <td>
                                        <p></p>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift1" class="link-muted">WO</span>
                                        </em>
                                    </td>
                                    <!--Column2-->
                                    <td></td>
                                    <!--Column3-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift2" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column4-->
                                    <td></td>
                                    <!--Column5-->
                                </tr>
                                <!--Row1-->
                                <tr>
                                    <td>
                                        <strong>
                                            <span id="lblDate">Tue, 02-Jan-2018</span>
                                        </strong>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl02$ddl1" id="ddl1" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="WO">WO</option>
                                            <option value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column2-->
                                    <td>
                                        <div class="btn-group">
                                            <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                        </div>

                                    </td>
                                    <!--Column3-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl02$ddl2" id="ddl2" class="form-control select2" style="width: 100%">
                                            <option value="WO">WO</option>
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column4-->
                                    <td>
                                        <input name="ctl00$The_Body$rptrSwapForm$ctl02$tbHeadCount" type="text" value="1" readonly="readonly" id="tbHeadCount" class="form-control" placeholder="HeadCount" />
                                        <input type="text" id="tbPostSwapHeadCount" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                    </td>
                                    <!--Column5-->
                                </tr>
                                <!--Row2-->

                                <tr>
                                    <td>
                                        <p></p>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift1" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column2-->
                                    <td></td>
                                    <!--Column3-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift2" class="link-muted">WO</span>
                                        </em>
                                    </td>
                                    <!--Column4-->
                                    <td></td>
                                    <!--Column5-->
                                </tr>
                                <!--Row1-->
                                <tr>
                                    <td>
                                        <strong>
                                            <span id="lblDate">Wed, 03-Jan-2018</span>
                                        </strong>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl03$ddl1" id="ddl1" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>
                                            <option value="WO">WO</option>

                                        </select>
                                    </td>
                                    <!--Column2-->
                                    <td>
                                        <div class="btn-group">
                                            <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                        </div>

                                    </td>
                                    <!--Column3-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl03$ddl2" id="ddl2" class="form-control select2" style="width: 100%">
                                            <option value="17:30-02:30">17:30-02:30</option>
                                            <option selected="selected" value="WO">WO</option>

                                        </select>
                                    </td>
                                    <!--Column4-->
                                    <td>
                                        <input name="ctl00$The_Body$rptrSwapForm$ctl03$tbHeadCount" type="text" value="1" readonly="readonly" id="tbHeadCount" class="form-control" placeholder="HeadCount" />
                                        <input type="text" id="tbPostSwapHeadCount" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                    </td>
                                    <!--Column5-->
                                </tr>
                                <!--Row2-->

                                <tr>
                                    <td>
                                        <p></p>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift1" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column2-->
                                    <td></td>
                                    <!--Column3-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift2" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column4-->
                                    <td></td>
                                    <!--Column5-->
                                </tr>
                                <!--Row1-->
                                <tr>
                                    <td>
                                        <strong>
                                            <span id="lblDate">Thu, 04-Jan-2018</span>
                                        </strong>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl04$ddl1" id="ddl1" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>
                                            <option value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column2-->
                                    <td>
                                        <div class="btn-group">
                                            <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                        </div>

                                    </td>
                                    <!--Column3-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl04$ddl2" id="ddl2" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>
                                            <option value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column4-->
                                    <td>
                                        <input name="ctl00$The_Body$rptrSwapForm$ctl04$tbHeadCount" type="text" value="2" readonly="readonly" id="tbHeadCount" class="form-control" placeholder="HeadCount" />
                                        <input type="text" id="tbPostSwapHeadCount" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                    </td>
                                    <!--Column5-->
                                </tr>
                                <!--Row2-->

                                <tr>
                                    <td>
                                        <p></p>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift1" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column2-->
                                    <td></td>
                                    <!--Column3-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift2" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column4-->
                                    <td></td>
                                    <!--Column5-->
                                </tr>
                                <!--Row1-->
                                <tr>
                                    <td>
                                        <strong>
                                            <span id="lblDate">Fri, 05-Jan-2018</span>
                                        </strong>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl05$ddl1" id="ddl1" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>
                                            <option value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column2-->
                                    <td>
                                        <div class="btn-group">
                                            <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                        </div>

                                    </td>
                                    <!--Column3-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl05$ddl2" id="ddl2" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>
                                            <option value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column4-->
                                    <td>
                                        <input name="ctl00$The_Body$rptrSwapForm$ctl05$tbHeadCount" type="text" value="2" readonly="readonly" id="tbHeadCount" class="form-control" placeholder="HeadCount" />
                                        <input type="text" id="tbPostSwapHeadCount" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                    </td>
                                    <!--Column5-->
                                </tr>
                                <!--Row2-->

                                <tr>
                                    <td>
                                        <p></p>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift1" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column2-->
                                    <td></td>
                                    <!--Column3-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift2" class="link-muted">10:00-19:00</span>
                                        </em>
                                    </td>
                                    <!--Column4-->
                                    <td></td>
                                    <!--Column5-->
                                </tr>
                                <!--Row1-->
                                <tr>
                                    <td>
                                        <strong>
                                            <span id="lblDate">Sat, 06-Jan-2018</span>
                                        </strong>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl06$ddl1" id="ddl1" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>
                                            <option value="10:00-19:00">10:00-19:00</option>

                                        </select>
                                    </td>
                                    <!--Column2-->
                                    <td>
                                        <div class="btn-group">
                                            <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                        </div>

                                    </td>
                                    <!--Column3-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl06$ddl2" id="ddl2" class="form-control select2" style="width: 100%">
                                            <option value="17:30-02:30">17:30-02:30</option>
                                            <option selected="selected" value="10:00-19:00">10:00-19:00</option>

                                        </select>
                                    </td>
                                    <!--Column4-->
                                    <td>
                                        <input name="ctl00$The_Body$rptrSwapForm$ctl06$tbHeadCount" type="text" value="2" readonly="readonly" id="tbHeadCount" class="form-control" placeholder="HeadCount" />
                                        <input type="text" id="tbPostSwapHeadCount" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                    </td>
                                    <!--Column5-->
                                </tr>
                                <!--Row2-->

                                <tr>
                                    <td>
                                        <p></p>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift1" class="link-muted">WO</span>
                                        </em>
                                    </td>
                                    <!--Column2-->
                                    <td></td>
                                    <!--Column3-->
                                    <td>
                                        <em>Original Shift : 
                                                    <span id="lblOriginalShift2" class="link-muted">17:30-02:30</span>
                                        </em>
                                    </td>
                                    <!--Column4-->
                                    <td></td>
                                    <!--Column5-->
                                </tr>
                                <!--Row1-->
                                <tr>
                                    <td>
                                        <strong>
                                            <span id="lblDate">Sun, 07-Jan-2018</span>
                                        </strong>
                                    </td>
                                    <!--Column1-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl07$ddl1" id="ddl1" class="form-control select2" style="width: 100%">
                                            <option selected="selected" value="WO">WO</option>
                                            <option value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column2-->
                                    <td>
                                        <div class="btn-group">
                                            <btn id="btnSwapShift" class="btn btn-primary"><i class="fa fa-exchange"></i>&nbsp</btn>
                                        </div>

                                    </td>
                                    <!--Column3-->
                                    <td>
                                        <select name="ctl00$The_Body$rptrSwapForm$ctl07$ddl2" id="ddl2" class="form-control select2" style="width: 100%">
                                            <option value="WO">WO</option>
                                            <option selected="selected" value="17:30-02:30">17:30-02:30</option>

                                        </select>
                                    </td>
                                    <!--Column4-->
                                    <td>
                                        <input name="ctl00$The_Body$rptrSwapForm$ctl07$tbHeadCount" type="text" value="1" readonly="readonly" id="tbHeadCount" class="form-control" placeholder="HeadCount" />
                                        <input type="text" id="tbPostSwapHeadCount" readonly="readonly" class="form-control text-muted" placeholder="..." />
                                    </td>
                                    <!--Column5-->
                                </tr>
                                <!--Row2-->

                            </tbody>
                        </table>

                        <div class="row">
                            <div class="col-md-offset-6">
                                <div class="btn-group">
                                    <input type="submit" name="ctl00$The_Body$btnSubmit" value="Submit Shift Swap" id="btnSubmit" disabled="disabled" class="aspNetDisabled btn btn-primary btn-flat disabled" />
                                    <input type="submit" name="ctl00$The_Body$btnCancel" value="Cancel Swap Request" id="btnCancel" class="btn btn-warning btn-flat" />
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="box-footer">
                </div>
            </div>
            <!-- /.box-footer-->
        </div>
        <!--tabcontent-->
    </div>
</asp:Content>
