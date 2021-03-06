﻿<%@ Page Language="C#" %>

<%@ Import Namespace="System.Threading" %>
<%@ Import Namespace="Westwind.Globalization.Sample" %>
<script runat="server">
    private string LocaleId;

    protected override void InitializeCulture()
    {
        base.InitializeCulture();

        LocaleId = Request.Params["LocaleId"];
        if (!string.IsNullOrEmpty(LocaleId))
            Westwind.Utilities.WebUtils.SetUserLocale(LocaleId, LocaleId, "$", true, "en,de,fr");
    }
</script>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="description" content="Localization Administration Form">

    <link rel="shortcut icon" href="localizationAdmin\favicon.ico" type="image/x-icon" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="black" />

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
     <![endif]-->

    <title>DbResourceManager Test Page</title>

    <link href="localizationAdmin/bower_components/bootstrap/dist/css/bootstrap.min.css"
        rel="stylesheet" />
    <link href="localizationAdmin/bower_components/fontawesome/css/font-awesome.min.css"
        rel="stylesheet" />

    <link href="localizationAdmin/css/localizationAdmin.css" rel="stylesheet" />
    <style>
        label {
            display: block;
            margin-top: 10px;
            margin-bottom: 0;
        }

        hr {
            margin: 10px 0 -10px;
        }
    </style>
    <script src="LocalizationAdmin/bower_components/jquery/dist/jquery.min.js"></script>
</head>
<body>
    <div class="banner">
        <div id="TitleBar">
            <a href="index.html">
                <img src="localizationAdmin/images/Westwind.Localization_128.png"
                    style="height: 35px; float: left" />
                <div style="float: left; margin-left: 5px; line-height: 1.2">
                    <i style="color: steelblue; font-size: 0.8em; font-weight: bold;">West Wind Globalization</i><br />
                    <i style="color: whitesmoke; font-size: 1.25em; font-weight: bold;">DbResourceManager
                        Test</i>
                </div>
            </a>
        </div>
    </div>

    <nav class="menubar " style="background: #727272;">
        <ul id="MenuButtons" class="nav navbar-nav pull-right navbar">
            <li>
                <a href="localizationAdmin/">
                    <i class="fa fa-gears"></i> Resource Editor
                </a>
            </li>
            <li>
                <a href="resourcetest.cshtml">
                    <i class="fa fa-check-circle"></i> Razor Test Page
                </a>
            </li>
        </ul>
        <div class="clearfix"></div>
    </nav>




    <div class="well container" style="margin-top: 30px;">
        <section class="pull-right" style="text-align: right">
            <div>
                Current Culture: <b><%= Thread.CurrentThread.CurrentCulture.IetfLanguageTag %></b>
            </div>
            <div>
                Current UI Culture: <b><%= Thread.CurrentThread.CurrentUICulture.IetfLanguageTag %></b>
            </div>
            <div>
                <form id="form1" name="form1" action="ResourceTest.aspx" method="GET">
                    <select id="localeId" name="localeId"
                        value="<%= LocaleId %>"
                        value
                        onchange="document.forms['form1'].submit();"
                        class="form-control">
                        <option value="">Browser Default</option>
                        <option value="en">English</option>
                        <option value="de">German</option>
                        <option value="fr">French</option>
                    </select>
                    <script>
                        var localeId = '<%= LocaleId %>';
                        var el = document.getElementById("localeId");
                        for (var i = 0; i < el.options.length; i++) {
                            var opt = el.options[i];
                            if (opt.value == localeId)
                                opt.selected = true;
                            else
                                opt.selected = false;
                        }
                    </script>
                </form>
            </div>
        </section>

        <div class="container">
            <h3>DbRes</h3>

            <label>Using DbRes Direct Access Provider (default locale):</label>
            <%= DbRes.T("HelloWorld","Resources") %>

            <label>Using DbRes Force to German:</label>
            <%= DbRes.T("HelloWorld","Resources","de") %>
        </div>

        <hr />

        <div class="container">

            <h3>ASP.NET ResourceProvider</h3>
            <label>Get GlobalResource Object (default locale):</label>
            <%= GetGlobalResourceObject("Resources","HelloWorld") %>

            <label>Meta Tag (key lblHelloWorldLabel.Text):</label>
            <asp:Label ID="lblHelloLabel" runat="server" meta:resourcekey="lblHelloWorldLabel"></asp:Label>

            <label>Resource Expressions (Global Resources):</label>
            <asp:Label ID="Label1" runat="server" Text="<%$ Resources:Resources,HelloWorld %>"></asp:Label>

            <label>GetLocalResourceObject via Expression:</label>
            <%= GetLocalResourceObject("lblHelloWorldLabel.Text") %>
        </div>

        <hr />

        <div class="container">

            <h3>Strongly Typed Resource (generated)</h3>

            <label>Strongly typed Resource Generated from Db (uses ASP.NET ResourceProvider)</label>
            <%= Resources.HelloWorld %>
        </div>

        <hr />

        <div class="container">

            <h3>JavaScript Resource Handler</h3>

            <label>Localized JavaScript Variable (assigned in JavaScript code from resources.HelloWorld):</label>
            <div id="JavaScriptHelloWorld"></div>

        </div>

    </div>

    <!-- Generates a resources variable that contains all server side resources translated for this resource set-->
    <script src="<%= JavaScriptResourceHandler.GetJavaScriptResourcesUrl("resources","Resources") %>"></script>
    <script>
        document.querySelector("#JavaScriptHelloWorld").innerText = resources.HelloWorld;
    </script>

</body>
</html>
