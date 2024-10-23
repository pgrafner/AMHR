using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace AMHR_Employee_Management_Example
{
    public partial class AddEmployee : System.Web.UI.Page
    {

        [WebMethod()]
        public static Result Add(string first, string last, string email, string position)
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

            SqlCommand addCommand = new SqlCommand("sp_AddEmployee", conn) { CommandType = CommandType.StoredProcedure };
            addCommand.Parameters.AddWithValue("ID", Guid.NewGuid());
            addCommand.Parameters.AddWithValue("FirstName", first);
            addCommand.Parameters.AddWithValue("LastName", last);
            addCommand.Parameters.AddWithValue("Email", email.ToLowerInvariant());
            addCommand.Parameters.AddWithValue("Position", position);

            try
            {
                int added = addCommand.ExecuteNonQuery();
                conn.Close();
                return new Result() { Success = true };
            }
            catch (Exception ex)
            {
                return new Result() { Message = ex.Message };
            }
        }

        [WebMethod()]
        public static Result CheckEmailUnique(string email)
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
            SqlCommand getCommand = new SqlCommand("sp_GetEmployeeByEmail", conn) { CommandType = CommandType.StoredProcedure };
            getCommand.Parameters.AddWithValue("Email", email.ToLowerInvariant());

            DataSet employees = new DataSet();
            SqlDataAdapter dataAdapter = new SqlDataAdapter(getCommand);

            try
            {
                dataAdapter.Fill(employees, "Employees");
                if (employees.Tables["Employees"].Rows.Count > 0)
                {
                    return new Result() { Message = "Email Already in Use" };
                }
                else { return new Result() { Success = true }; }
            }
            catch (Exception ex)
            {
                throw new Exception("Failed to retrieve Employees", ex);
            }
        }
    }

    public class Result
    {
        public Boolean Success;
        public String Message;
    }
}