using DotNetNuke.ComponentModel;
using DotNetNuke.Services.FileSystem;
using System;
namespace Mohammad.Modules.CardsAndLink.Controls
{
    public partial class CardsPreview : CardsAndLinkModuleBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            SqlDS_Staff.SelectParameters["ModuleID"].DefaultValue = "" + ModuleId;
            SqlDS_Staff.DataBind();
            Repeater_Staff.DataBind();
        }
        public string getFilePath(string fileID)
        {
            FileInfo file = (FileInfo)ComponentBase<IFileManager, FileManager>.Instance.GetFile(Convert.ToInt32(fileID));
            if (file != null)
                return ComponentBase<IFileManager, FileManager>.Instance.GetUrl(file);
            else
                return "/DesktopModules/CardsAndLink/Images/no-thumb.png";
        }
        public string decodeHTML(string str)
        {
            return Server.HtmlDecode(str);
        }
    }
}