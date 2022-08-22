using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using DotNetNuke.ComponentModel;
using DotNetNuke.Services.FileSystem;
using Microsoft.ApplicationBlocks.Data;
using System.Data;
using System.Data.SqlClient;
using Mohammad.Modules.CardsAndLink.Data;

namespace Mohammad.Modules.CardsAndLink.Controls
{
    public partial class CardsAdmin : CardsAndLinkModuleBase
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!Page.IsPostBack)
            {
                SqlDS_Staff.SelectParameters["ModuleID"].DefaultValue = "" + ModuleId;
                SqlDS_Staff.DataBind();
                GridView_StaffList.DataBind();
                imagePicker1.FolderPath = createUserFolder().FolderPath;

                var val = SqlHelper.ExecuteScalar(DatabaseHelper.SiteConnStr, CommandType.Text, string.Format("select isnull(max(SortOrder),-1) from [CardAndLinks_Items] where isDeleted =0 and [ModuleID] ={0}", ModuleId));
                try
                {
                    val = 1 + Convert.ToInt32(val);
                }
                catch (Exception)
                {
                    val = 0;
                }

                txt_Order.Text = $"{val}";
            }
        }
        public string getFilePath(string fileID)
        {
            FileInfo file = (FileInfo)ComponentBase<IFileManager, FileManager>.Instance.GetFile(Convert.ToInt32(fileID));
            if (file != null)
                return ComponentBase<IFileManager, FileManager>.Instance.GetUrl(file);
            else
                return "/DesktopModules/Staff/Images/no-thumb.png";
        }
        public string decodeHTML(string str)
        {
            return Server.HtmlDecode(str);
        }

        protected void lnkbtn_Cancel_Click(object sender, EventArgs e)
        {
            ClearValriables();
        }

        private void ClearValriables()
        {
            Session["currentControl" + ModuleId] = null;
            Response.Redirect(Request.Url.AbsoluteUri);
        }

        private void ResetVariables()
        {
            Session["CardItemID" + ModuleId] = null;
            txtTitle.Text = string.Empty;
            TextBox_Link.Text = string.Empty;
            description.Value = string.Empty;
            txt_Order.Text = "" + SqlHelper.ExecuteScalar(DatabaseHelper.SiteConnStr, CommandType.Text, string.Format("select isnull(max(SortOrder),-1) from [CardAndLinks_Items] where isDeleted =0 and [ModuleID] ={0}", ModuleId));
            imagePicker1.DataBind();
            Response.Redirect(Request.Url.AbsoluteUri);
        }

        protected void lnkbtn_Save_Click(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(txtTitle.Text) && !string.IsNullOrEmpty(description.Value))
                {
                    SqlParameter[] sqlParameterArray1 = new SqlParameter[8];
                    SqlParameter sqlParameter1 = new SqlParameter("@id", SqlDbType.Int);
                    sqlParameter1.Value = Convert.ToInt32(Session["CardItemID" + ModuleId]);
                    sqlParameterArray1[0] = sqlParameter1;
                    sqlParameterArray1[1] = new SqlParameter("@name", txtTitle.Text);
                    sqlParameterArray1[2] = new SqlParameter("@description", description.Value);
                    sqlParameterArray1[3] = new SqlParameter("@imageFileID", Convert.ToInt32(imagePicker1.FileID));
                    SqlParameter sqlParameter2 = new SqlParameter("@ModuleId", SqlDbType.Int);
                    sqlParameter2.Value = ModuleId;
                    sqlParameterArray1[4] = sqlParameter2;
                    sqlParameterArray1[5] = new SqlParameter("@isActive", CheckBox_isActive.Checked);
                    SqlParameter sqlParameter5 = new SqlParameter("@SortOrder", SqlDbType.Int);
                    sqlParameter5.Value = Convert.ToInt32(string.IsNullOrEmpty(txt_Order.Text) ? string.Concat((Convert.ToInt32(SqlHelper.ExecuteScalar(DatabaseHelper.SiteConnStr, CommandType.Text, string.Format("select isnull(max(SortOrder),-1) from [CardAndLinks_Items] where isDeleted =0 and [ModuleID] ={0}", ModuleId))) + 1)) : txt_Order.Text);
                    sqlParameterArray1[6] = sqlParameter5;
                    sqlParameterArray1[7] = new SqlParameter("@link", TextBox_Link.Text);
                    object obj = SqlHelper.ExecuteScalar(DatabaseHelper.SiteConnStr, "CardAndLinks_insertOrUpdateItems", sqlParameterArray1);
                    if (obj != null)
                    {
                        GridView_StaffList.DataBind();
                        DatabaseHelper.ShowMessage(this, GetType(), "Saved successfully :)", DatabaseHelper.MessageType.Success);
                        ResetVariables();
                    }

                }
                else
                    DatabaseHelper.ShowMessage(this, GetType(), "Something Missing :/", DatabaseHelper.MessageType.Warning);
            }
            catch (Exception ex)
            {
                DatabaseHelper.ShowMessage(this, GetType(), string.Concat(ex), DatabaseHelper.MessageType.Error);
            }
        }
        protected void GridView_StaffList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            Session["CardItemID" + ModuleId] = e.CommandArgument;
            switch (e.CommandName)
            {
                case "Edit":
                    string str = string.Format("SELECT [id],[name],[SortOrder],[description],[imageFileID],[isActive],[link] FROM [CardAndLinks_Items] where [isDeleted]=0 and id = {0}", Session["CardItemID" + ModuleId].ToString());
                    DataSet dataSet1 = SqlHelper.ExecuteDataset(DatabaseHelper.SiteConnStr, CommandType.Text, str);
                    if (dataSet1.Tables[0].Rows.Count > 0)
                    {
                        txtTitle.Text = (dataSet1.Tables[0].Rows[0]["name"].ToString());
                        description.Value = (dataSet1.Tables[0].Rows[0]["description"].ToString());
                        txt_Order.Text = dataSet1.Tables[0].Rows[0]["SortOrder"].ToString();
                        imagePicker1.FileID = ((int)dataSet1.Tables[0].Rows[0]["imageFileID"]);
                        CheckBox_isActive.Checked = (bool)dataSet1.Tables[0].Rows[0]["isActive"];

                    }
                    break;
                case "DeleteRow":
                    if (SqlHelper.ExecuteNonQuery(DatabaseHelper.SiteConnStr, CommandType.Text, string.Format("Update CardAndLinks_Items set isDeleted = 1   where id = {0}", e.CommandArgument)) > 0)
                        DatabaseHelper.ShowMessage(this, GetType(), "Deleted successfully :(", DatabaseHelper.MessageType.Success);
                    GridView_StaffList.DataBind();
                    ResetVariables();
                    break;
            }           
        }
        private IFolderInfo createUserFolder()
        {
            string userFolderPath = "CardsPics";
            IFolderInfo userFolderInfo = null;
            if (!FolderManager.Instance.FolderExists(PortalId, userFolderPath))
            {
                userFolderInfo = FolderManager.Instance.AddFolder(PortalId, userFolderPath);
            }
            else
            {
                userFolderInfo = FolderManager.Instance.GetFolder(PortalId, userFolderPath);
            }
            return userFolderInfo;
        }
    }
}