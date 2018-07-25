<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="404.aspx.cs" Inherits="_404" %>

<asp:Content ID="One" ContentPlaceHolderID="pageheader" runat="server"></asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <!-- Main content -->
    <section class="content">
        <div class="error-page">
            <h2 class="headline text-yellow"><i class="fa fa-user-secret text-yellow"></i>Error Detected!</h2>
            <div class="padding-10">    
                <h3>Congratulations! You have found an Error Condition.</h3>
                <p>Thank you for being our Error Detective.</p>
                <p>
                    Please help us resolve it by taking a screenshot and mailing it to <a href="mailto:iaccess_support@sitel.com">iaccess_support@sitel.com</a>
                </p>
            </div>
            <!-- /.error-content -->
        </div>
        <!-- /.error-page -->
    </section>
    <!-- /.content -->
</asp:Content>


