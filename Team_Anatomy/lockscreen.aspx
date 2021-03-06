﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="lockscreen.aspx.cs" Inherits="lockscreen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>Team Anatomy | Lockscreen</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <!-- Bootstrap 3.3.7 -->
    <link rel="stylesheet" href="AdminLTE/bower_components/bootstrap/dist/css/bootstrap.min.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="AdminLTE/bower_components/font-awesome/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="AdminLTE/bower_components/Ionicons/css/ionicons.min.css" />
    <!-- Theme style -->
    <link rel="stylesheet" href="AdminLTE/dist/css/AdminLTE.min.css" />

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->

    <!-- Google Font -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700,300italic,400italic,600italic" />
</head>
<body class="hold-transition lockscreen">

    <!-- Automatic element centering -->
    <div class="lockscreen-wrapper">
        <form id="form1" runat="server">
            <div class="lockscreen-logo">
                <a href="index.aspx">
                    <img src="sitel/img/sitel_logo.jpg" width="292px" alt="Sitel Logo" />
                    <h1>Team Anatomy</h1>
                </a>
            </div>
            <!-- User name -->
            <div class="lockscreen-name" style="text-align: left; padding-left:5%;">
                Hi <asp:Label ID="ltlUserID" runat="server"></asp:Label>
            </div>

            <!-- START LOCK SCREEN ITEM -->
            <div class="lockscreen-item" style="margin-top: 30px">
                <!-- lockscreen credentials (contains the form) -->
                <div class="lockscreen-credentials">
                </div>
                <!-- /.lockscreen credentials -->
            </div>
            <div class="input-group margin">
                <input id="tbEmpID" runat="server" class="form-control" placeholder="Enter your Employee ID" type="text" />
                <span class="input-group-btn">
                    <asp:Button id="btnSubmit" runat="server"  class="btn btn-info btn-flat" type="button" Text="Go!" OnClick="btnSubmit_Click"></asp:Button>
                </span>
            </div>

            <!-- /.lockscreen-item -->
            <div class="help-block text-center">

                <br />
                Please request your reporting manager to update your details at
                <br />
                Team Anatomy -> Team -> Add/Update Team Member
 
            </div>

            <div class="lockscreen-footer text-center">
                Copyright &copy;
                <asp:Literal ID="currentYear" Text="2017" runat="server"></asp:Literal>
                <b><a href="https://www.sitel.com" class="text-black">Acticall Sitel Ltd.</a></b><br>
                All rights reserved
 
            </div>
        </form>
    </div>
    <!-- /.center -->



    <!-- jQuery 3 -->
    <script src="AdminLTE/bower_components/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap 3.3.7 -->
    <script src="AdminLTE/bower_components/bootstrap/dist/js/bootstrap.min.js"></script>
    <script>
        $("#ltlUserID").css("font-size", "20px");
        $("#ltlUserID").css("font-style", "italic");
    </script>
</body>
</html>
