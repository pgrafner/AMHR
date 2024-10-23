using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace AMHR_Employee_Management_Example
{
    public partial class EmployeeList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            lblResponse.Text = null;
            try
            {
                SqlConnection conn;
                try
                {
                    conn = new SqlConnection(ConfigurationManager.ConnectionStrings["SqlConn"].ConnectionString);
                    conn.Open();
                }
                catch (Exception ex)
                {
                    throw new Exception("Failed To connect to Database", ex);
                }

                DataSet employees = new DataSet();
                SqlCommand loadCommand = new SqlCommand("sp_GetAllEmployees", conn);
                SqlDataAdapter dataAdapter = new SqlDataAdapter(loadCommand);

                try
                {
                    dataAdapter.Fill(employees, "Employees");
                }
                catch (Exception ex)
                {
                    throw new Exception("Failed to retrieve Employees", ex);
                }

                gvEmployees.DataSource = employees.Tables["Employees"];
                gvEmployees.DataBind();
            }
            catch (Exception ex)
            {
                lblResponse.Text = ex.Message;
            }
        }

    }
}