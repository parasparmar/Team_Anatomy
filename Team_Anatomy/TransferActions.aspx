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
        <li class="active"><a href="movement.aspx"><i class="fa fa-plus-square"></i>Transfer Actions</a></li>
    </ol>

    <div class="pageheader">
        <div class="pageicon"><span class="fa fa-plus-square"></span></div>
        <div class="pagetitle">
            <h5>Approve or Decline Employee and Team movements</h5>
            <h1>Transfer Actions</h1>
        </div>
    </div>
    <!--pageheader-->
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
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
            $("#btnSubmit").attr('disabled', 'disabled');
            //Initialize Select2 Elements
            $('.select2').select2({

            });

            //$('#tbEffectiveDate').datepicker({// "[class*='datepicker']"
            //    autoclose: true,
            //    format: 'dd-M-yyyy'
            //});

            $("#cbCheckAll").change(function () {
                var xChk = $(this).prop('checked');
                $('[id*="cbMyTeamListID"]').each(function () {
                    if ($(this).is(':disabled')) {
                    }
                    else {
                        $(this).prop('checked', xChk);
                    }
                });

                if (xChk == true && $('[id*="cbMyTeamListID"]:checked').length > 0) {
                    xChk = true;
                }
                ToggleButton(xChk);
            });

            var xChk = false;
            $('[id*="cbMyTeamListID"]').change(function () {
                if ($('[id*="cbMyTeamListID"]:checked').length <= 0) {
                    xChk = false;
                };
                if ($(this).prop('checked') == true && $('[id*="cbMyTeamListID"]:checked').length > 0) {
                    xChk = true;
                }
                ToggleButton(xChk);
            });

            $('#tbEffectiveDate').change(function () {
                var xChk = false;
                if ($('#tbEffectiveDate').val().length > 0 && $('[id*="cbMyTeamListID"]:checked').length > 0) {
                    xChk = true;
                }
                ToggleButton(xChk);
            })

            function ToggleButton(xChk) {
                $("#btnSubmit").attr('disabled', 'disabled');

                if (xChk == true && $('#tbEffectiveDate').val().length > 0) {
                    $("#btnSubmit").removeAttr('disabled');
                }
                else {
                    $("#btnSubmit").attr('disabled', 'disabled');
                }
            }
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

