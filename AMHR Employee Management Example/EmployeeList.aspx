<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeList.aspx.cs" Inherits="AMHR_Employee_Management_Example.EmployeeList" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/jquery-3.7.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Employees</h1>
            <asp:Label ID="lblResponse" runat="server" />
            <div style="float:right">
                <a href="AddEmployee.aspx">Add Employee</a>
            </div>
            <div>
                <input type="text" id="txtFilter" placeholder="Filter by First, Last Name or Email" />
                <button type="button" onclick="filterList();">Filter</button>
                <button type="button" onclick="resetList();">Reset</button>
                <div id="divFilterResults" style="display:none;"><span id="spanCount"></span> found.</div>
            </div>
            <asp:GridView runat="server" ID="gvEmployees" AutoGenerateColumns="false" Width="100%">
                <Columns>
                    <asp:BoundField HeaderText="Last Name" DataField="LastName" />
                    <asp:BoundField HeaderText="First Name" DataField="FirstName" />
                    <asp:BoundField HeaderText="Email" DataField="Email" />
                </Columns>
            </asp:GridView>
        </div>
        <script>
            function filterList() {
                var value = $("#txtFilter").val().toLowerCase();
                if (value == "") {
                    alert("No Filter Entered");
                } else {

                    var regex = new RegExp(value);
                    var count = 0;
                    $("#gvEmployees tr:has(td)").each(function () {
                        if (regex.test($(this).find("td:eq(1)").text().toLowerCase())
                            || regex.test($(this).find("td:eq(2)").text().toLowerCase())
                            || regex.test($(this).find("td:eq(3)").text().toLowerCase())
                        ) {
                            count++;
                            $(this).css('display', '');
                        } else {
                            $(this).css('display', 'none');
                        }
                    });
                    $("#spanCount").html(count);
                    $("#divFilterResults").show();
                }
            }
            function resetList(){
                $("#txtFilter").val("");
                $("#divFilterResults").hide();
                $("#gvEmployees tr:has(td)").each(function () {
                    $(this).css('display', '');
                });
            }
        </script>
    </form>
</body>
</html>
