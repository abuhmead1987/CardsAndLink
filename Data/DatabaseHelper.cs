using System;
using System.Web.Configuration;
using System.Web.UI;


namespace Mohammad.Modules.CardsAndLink.Data
{
    public class DatabaseHelper
    {
        public static string SiteConnStr = WebConfigurationManager.ConnectionStrings["SiteSqlServer"].ConnectionString;

        public static void ShowMessage(Control c, Type t, string Message, DatabaseHelper.MessageType type)
        {
            ScriptManager.RegisterStartupScript(c, t, Guid.NewGuid().ToString(), "ShowMessage('" + Message + "','" + (object)type + "');", true);
        }

        public enum MessageType
        {
            Success,
            Error,
            Info,
            Warning,
        }
    }
}