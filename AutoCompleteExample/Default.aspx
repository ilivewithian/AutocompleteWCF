<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="AutoCompleteExample.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Simple Autocomplete Example</title>
    <link href="Styles/jquery-ui-1.8.5.custom.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Try typing something:
        <asp:TextBox runat="server" ID="targetTextbox" />
        <span id="result"></span>
    </div>
    </form>
    <script type="text/javascript" src="Scripts/jquery-1.4.2.min.js"></script>
    <script type="text/javascript" src="Scripts/jquery-ui-1.8.5.custom.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("input[id$='targetTextbox']").autocomplete({
                source: function (request, response) {
                    $.ajax({
                        url: "AutoComplete.svc/WordLookup",
                        data: {
                            text: request.term,
                            count: 15
                        },
                        dataType: "json",
                        contentType: "application/json; charset=utf-8",
                        success: function (data) {
                            response($.map(data.d, function (item) {
                                return {
                                    value: item.Word,
                                    length: item.Length,
                                    otherWayAround: item.Reversed
                                }
                            }))
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                            $("#result").text(textStatus);
                        }
                    });
                },
                minLength: 2,
                select: function (event, ui) {
                    $("#result").text("Selected: " + ui.item.value + " with " + ui.item.length + "characters, and just for fun (of a sort) backwards: " + ui.item.otherWayAround);
                }
            });
        }); 
    </script>
</body>
</html>
