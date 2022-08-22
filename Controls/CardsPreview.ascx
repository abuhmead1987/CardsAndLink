<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CardsPreview.ascx.cs" Inherits="Mohammad.Modules.CardsAndLink.Controls.CardsPreview" %>



<asp:Repeater ID="Repeater_Staff" runat="server" DataSourceID="SqlDS_Staff">
    <HeaderTemplate>
        <div class="intro-container row">
            <div class="col-md-12 main">
                <ul>
    </HeaderTemplate>
    <ItemTemplate>


        <li><a href='<%# Eval("link")%>' rel="nofollow" style="background: url('<%# getFilePath(Eval("imageFileID").ToString()) %>'); background-size: 100% 100%;">
            <span class="overlay">
                <p><%# Eval("description")%></p>
                <label>Read More...</label>
            </span><span class="text"><%# Eval("name")%></span> </a></li>
    </ItemTemplate>
    <FooterTemplate>
        </ul>
</div>
</div>
    </FooterTemplate>
</asp:Repeater>

<asp:SqlDataSource ID="SqlDS_Staff" runat="server" ConnectionString='<%$ ConnectionStrings:SiteSqlServer %>'
    SelectCommand="SELECT [id],[name],[description],[imageFileID], [link] FROM [CardAndLinks_Items]  where [isDeleted]=0 and [isActive]=1 and [ModuleID]=@ModuleID">
    <SelectParameters>
        <asp:Parameter Name="ModuleID" Type="String"></asp:Parameter>
    </SelectParameters>
</asp:SqlDataSource>

<script type="text/javascript">
    $(function () {
        setHeight($('.staffList > li'));
    });


    function setHeight(col) {
        console.info("Called");
        var $col = $(col);

        var $maxHeight = 0;
        $col.each(function () {

            var $thisHeight = $(this).outerHeight();
            if ($thisHeight > $maxHeight) {
                $maxHeight = $thisHeight;
            }
            console.info($maxHeight);
        });
        $col.height($maxHeight);
    }
</script>
