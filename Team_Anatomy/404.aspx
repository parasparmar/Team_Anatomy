﻿<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="404.aspx.cs" Inherits="_404" %>

<asp:Content ID="One" ContentPlaceHolderID="pageheader" runat="server"></asp:Content>
<asp:Content ID="Two" ContentPlaceHolderID="headPlaceHolder" runat="server"></asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="The_Body" runat="Server">
    <!-- Main content -->
    <section class="content">
        <asp:Panel ID="pnlError" runat="server" CssClass="error-page text-center" Visible="false">
            <h2 class="headline text-yellow" style="float: none !important"><i class="fa fa-unlink text-yellow"></i>Error!</h2>
            <div class="clearfix"></div>
            <div class="padding-10">
                <h3 class="text-center">This error has been logged with ticket id <strong><%#errorID%></strong></h3>
                <!-- /.error-content -->
                <p class="text-center">
                    Please choose from these options.
                </p>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlSuccess" runat="server" CssClass="error-page text-center" Visible="true">
            <h2 class="headline text-success" style="float: none !important"><i class="fa fa-bullhorn text-success"></i>Hello ...</h2>
            <div class="clearfix"></div>
            <div class="padding-10">
                <h3 class="text-center">If you've landed here, there's nothing more to do.</h3>
                <!-- /.error-content -->
                <p class="text-center">
                    You could of course, choose from these options.
                </p>
            </div>
        </asp:Panel>
        <div class="row">
            <div class="text-center">
                <a href="index.aspx" class="btn btn-flat btn-primary"><i class="fa fa-home"></i>&nbsp Take me Home!</a>
                <asp:LinkButton ID="lnkFlag4Followup" runat="server" CssClass="btn btn-flat btn-warning dropdown-toggle" data-toggle="dropdown"
                    OnClientClick="window.open('mailto:support_iaccess@sitel.com?subject=PACMAN%20Issue%20%3A%20&body=Hi%20Team%2C%0APlease%20help%20me%20with%20my%20PACMAN%20Issue%20logged%20today%20with%20ID%20%3A%20%0A','email');"
                     Text="Email for Support">                    
                </asp:LinkButton>
                <asp:LinkButton ID="btnErrorMessage" CommandArgument="<%#errorID%>" runat="server" CssClass="btn btn-flat  btn-danger" Text="Followup Please!" OnClick="btnErrorMessage_Click"></asp:LinkButton>
                <asp:LinkButton ID="lnkRetry" CssClass="btn btn-flat  btn-success" runat="server" OnClick="lnkRetry_Click"><i class="fa fa-history"></i>&nbsp Retry!</asp:LinkButton>
            </div>


        </div>
        <asp:Panel ID="testPanel" runat="server" Visible="false">
            <asp:DropDownList ID="ddlExceptionType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlExceptionType_SelectedIndexChanged">
                <asp:ListItem Text="InvalidOperationException" Value="InvalidOperationException"></asp:ListItem>
                <asp:ListItem Text="ArgumentException" Value="ArgumentException"></asp:ListItem>
                <asp:ListItem Text="NullReferenceException" Value="NullReferenceException"></asp:ListItem>
                <asp:ListItem Text="AccessViolationException" Value="AccessViolationException"></asp:ListItem>
                <asp:ListItem Text="IndexOutOfRangeException" Value="IndexOutOfRangeException"></asp:ListItem>
                <asp:ListItem Text="StackOverflowException" Value="StackOverflowException"></asp:ListItem>
            </asp:DropDownList> 
        </asp:Panel>
        <!-- /.error-page -->
    </section>
    <!-- /.content -->
</asp:Content>


