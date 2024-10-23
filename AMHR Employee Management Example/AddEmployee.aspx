<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEmployee.aspx.cs" Inherits="AMHR_Employee_Management_Example.AddEmployee" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="Scripts/jquery-3.7.1.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>Add Employee</h1>
            <div style="float:right"><a href="EmployeeList.aspx">Employee List</a></div>
            <div>
                <div style="display:inline-block">First Name</div>
                <div style="display:inline-block">
                    <input type="text" id="txtFirstName" placeholder="John" onchange="validateAll(this);"/>*
                    <span id="lblFNameVal"></span>
                </div>
            </div>
            <div>
                <div style="display:inline-block">Last Name</div>
                <div style="display:inline-block">
                    <input type="text" id="txtLastName" placeholder="Doe" onchange="validateAll(this);"/>*
                    <span id="lblLNameVal"></span>
                </div>
            </div>
            <div>
                <div style="display:inline-block">Email</div>
                <div style="display:inline-block">
                    <input type="text" id="txtEmail" placeholder="jdoe@amhr.org" onchange="validateAll(this);"/>*
                    <span id="lblEmailVal"></span>
                </div>
            </div>
            <div>
                <div style="display:inline-block">Position</div>
                <div style="display:inline-block">
                    <input type="text" id="txtPosition" />
                </div>
            </div>
            <div><button id="btnSubmit" type="button" onclick="addEmployee();" disabled="disabled">Save</button></div>
        </div>
        <script>
            function addEmployee() {
                if (validateAll()) {
                    $(btnSubmit).prop("disabled", true);
                    $.ajax({
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({
                            first: $(txtFirstName).val(),
                            last: $(txtLastName).val(),
                            email: $(txtEmail).val(),
                            position: $(txtPosition).val()
                        }),
                        url: "AddEmployee.aspx/Add",
                        dataType: "json",
                        success: function (result) {
                            if (result.d.Success) {
                                alert("Employee Added Successfully");
                                //clear data Fields for next entry, but after alert so user can see what was added
                                $(txtFirstName).val("");
                                $(txtLastName).val("");
                                $(txtEmail).val("");
                                $(txtPosition).val("");
                            } else {
                                alert("Failed to add employee: " + result.d.Message); 
                            }
                        },
                        error: function () {
                            alert("Failed to communicate with server")
                        }        
                    });
                }
            }
            function validateAll(currentControl) {
                var valid = validateRequired(txtFirstName, lblFNameVal, "First Name", currentControl == txtFirstName || !currentControl )
                    && validateRequired(txtLastName, lblLNameVal, "Last Name", currentControl == txtLastName || !currentControl)
                    && validateEmailFormat(txtEmail, lblEmailVal, "Email", currentControl == txtEmail || !currentControl);

                if (valid) {
                    $(btnSubmit).prop("disabled", false);
                } else {
                    $(btnSubmit).prop("disabled", true);
                }
                return valid;
            }
            function validateRequired(txtControl, lblResult, friendlyName, showError) {
                var value = $(txtControl).val();
                if (value == "") {
                    if (showError) { $(lblResult).html(friendlyName + " is required"); }
                    return false;
                } else {
                    $(lblResult).html("");
                    return true;
                }
            }
            function validateEmailFormat(txtControl, lblResult, friendlyName, showError) {
                var regex = new RegExp("^[^@]+@[^@]+\.[^@]+$");

                var value = $(txtControl).val();
                if (value == "") {
                    if (showError) { $(lblResult).html(friendlyName + " is required"); }
                    return false;
                } else if (!regex.test(value)) {
                    if (showError) { $(lblResult).html(friendlyName + " is not in a valid format"); }
                    return false;
                } else {
                    var results = $.ajax({
                        async: true,
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        data: JSON.stringify({ email: $(txtEmail).val() }),
                        url: "AddEmployee.aspx/CheckEmailUnique",
                        dataType: "json",
                        success: function (result) {
                            if (! result.d.Success) {
                                if (showError) { $(lblResult).html(friendlyName + " is not unique"); }
                                return false;
                            }
                        },
                        error: function () {
                            alert("Failed to communicate with server")
                        }
                    });
                }

                $(lblResult).html("");
                return true;
            }
        </script>
    </form>
</body>
</html>
