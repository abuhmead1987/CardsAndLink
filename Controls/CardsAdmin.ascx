<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CardsAdmin.ascx.cs" Inherits="Mohammad.Modules.CardsAndLink.Controls.CardsAdmin" %>
<%@ Register Assembly="DotNetNuke.Web" Namespace="DotNetNuke.Web.UI.WebControls.Internal" TagPrefix="dnn" %>
<%@ Register TagPrefix="dnn" TagName="TextEditor" Src="~/controls/TextEditor.ascx" %>
<%@ Register TagPrefix="dnn" TagName="ImageUploader" Src="~/controls/filepickeruploader.ascx" %>
<div class="container">
    <div id="dnnMyPanels">
        <h2 class="dnnFormSectionHead">
            <a href="#">Add New Card</a>
        </h2>
        <fieldset>
            <div class="dnnClear" id="dnnBlogEditContent"  style="margin:20px auto;">
                <fieldset>
                    <div class="row">
                        <span class="spanLabel" suffix=":">Name : </span>
                        <br />
                        <asp:TextBox ID="txtTitle" runat="server"  Width="100%" ValidationGroup="Save" CausesValidation="true"></asp:TextBox>
                        <br />
                    </div>                    
                    <div class="row">
                        <span class="spanLabel">Link: </span>
                        <br />
                        <asp:TextBox ID="TextBox_Link" runat="server" TextMode="Url"   style="width: 100%;" validationgroup="Save"></asp:TextBox>
                        <br />
                    </div>
                                     
                    <div class="row">
                        <span class="spanLabel">Description : </span>
                        <br />
                        <textarea id="description" runat="server" style="width: 100%; min-height: 100px;" ></textarea>
                    </div>
                    <div class="row">
                        <span class="spanLabel">Order: </span>
                        <br />
                        <asp:TextBox ID="txt_Order" runat="server" type="number"    validationgroup="Save"></asp:TextBox>
                        <br />
                    </div>
                    <div class="row">
                        <span class="spanLabel">Is Active (Published) : </span>
                        <br />
                        <asp:CheckBox ID="CheckBox_isActive" runat="server" Checked="true"  />
                    </div>
                     <div class="row">
                        <span class="spanLabel">Picture : </span>
                        <br />
                        <dnn:imageuploader id="imagePicker1" runat="server"  ShowFolders="false" filefilter="jpg,jpeg,png" validationgroup="Save" causesvalidation="true" />
                        <br />
                    </div>  
                    <div class="row">
                        <asp:LinkButton ID="lnkbtn_Cancel" runat="server" class="dnnSecondaryAction btnMargins" OnClick="lnkbtn_Cancel_Click" CausesValidation="false"
                            Style="margin: 10px !important;">Cancel</asp:LinkButton>
                        <asp:LinkButton ID="lnkbtn_Save" runat="server" class="dnnPrimaryAction btnMargins" ValidationGroup="Save" CausesValidation="true" OnClick="lnkbtn_Save_Click" Style="margin: 10px !important;"> Save</asp:LinkButton>
                    </div>
                </fieldset>
            </div>

        </fieldset>
        <h2 class="dnnFormSectionHead">
            <a href="#">Cards List</a>
        </h2>
        <fieldset>
            <div class="row" style="margin:20px auto;">
                <asp:GridView ID="GridView_StaffList" runat="server" CssClass="table table-bordered" AutoGenerateColumns="False" DataKeyNames="id" DataSourceID="SqlDS_Staff" AllowPaging="True" AllowSorting="True"
                    OnRowCommand="GridView_StaffList_RowCommand">

                    <EmptyDataTemplate>

                        <tr>
                            <td colspan="5">
                                <div>No Data to show</div>
                            </td>
                        </tr>
                    </EmptyDataTemplate>

                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" InsertVisible="False" SortExpression="id"></asp:BoundField>
                        <asp:TemplateField  HeaderText="Link">
                            <ItemTemplate>
                              <a href='<%# Eval("link") %>'><%# Eval("link") %></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="SortOrder" HeaderText="Order" SortExpression="name"></asp:BoundField>
                        <asp:TemplateField  HeaderText="Picture">
                            <ItemTemplate>
                                <img class="cardPic" src='<%# getFilePath(Eval("imageFileID").ToString()) %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField  HeaderText="Description">
                            <ItemTemplate>
                                <asp:Literal ID="Literal1" runat="server" Text='<%# Eval("description") %>'> </asp:Literal>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="isActive" HeaderText="Is Published" SortExpression="isActive"></asp:BoundField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:ImageButton ID="EditButton" CommandArgument='<%# Eval("id") %>' CommandName="Edit" ToolTip="Edit"  AlternateText="Edit" runat="server" ImageUrl="/images/eip_edit.png" CausesValidation="false" validationgroup="none" />
                                <asp:ImageButton ID="DelButton" CommandArgument='<%# Eval("id") %>' CommandName="DeleteRow" ToolTip="Delete" AlternateText="Delete" runat="server" ImageUrl="/images/action_delete.gif" CssClass="gridDeleteCmd" CausesValidation="false" validationgroup="none"/>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDS_Staff" runat="server" ConnectionString='<%$ ConnectionStrings:SiteSqlServer %>'
                    SelectCommand="SELECT [id],[name],[link],[SortOrder],[description],[imageFileID], [isActive] FROM [CardAndLinks_Items] where [isDeleted]=0 and [ModuleID]=@ModuleID order by [SortOrder] asc, insertDate desc">
                    <SelectParameters>
                        <asp:Parameter Name="ModuleID" Type="String"></asp:Parameter>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
        </fieldset>
    </div>
</div>
<script>
    (function ($, Sys) {
        function setupDnnBlogSettings() {
            $('.gridDeleteCmd').dnnConfirm({
                text: '<%=LocalizeString("DeleteConfirm.Text") %>',
                yesText: '<%= LocalizeString("Yes.Text") %>',
                noText: '<%= LocalizeString("No.Text") %>',
                title: '<%=LocalizeString("DeleteConfirm.Header") %>',
                isButton: true
            });
        };

        $(document).ready(function () {
            setupDnnBlogSettings();

            $('#dnnMyPanels').dnnPanels();
            $('#dnnMyPanels h2 a:not(.dnnSectionExpanded)').click();
            $("#dnnMyPanels h2 a").first().click();

            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                setupDnnBlogSettings();
            });
        });

    }(jQuery, window.Sys));

    function OnClientCommandExecuting(editor, args) { }
</script>
