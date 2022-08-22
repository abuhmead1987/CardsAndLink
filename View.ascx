<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="View.ascx.cs" Inherits="Mohammad.Modules.CardsAndLink.View" %>
<div class="container">
    <asp:Panel ID="Panel_cmd" runat="server" Visible="false" Enabled="false">
        <asp:LinkButton ID="btn_addRemoveStaff" Text="Manage Cards List" runat="server" CssClass="dnnPrimaryAction" OnClick="btn_addRemoveStaff_Click" ValidationGroup="cmd"></asp:LinkButton>
         <asp:LinkButton ID="btn_previewStaff" Text="Preview" runat="server" CssClass="dnnSecondaryAction" OnClick="btn_previewStaff_Click" ValidationGroup="cmd"></asp:LinkButton>
    </asp:Panel>
</div>
<div class="staffHolder"> 
            <div class="row">
                <asp:PlaceHolder ID="PlaceHolder1" runat="server"></asp:PlaceHolder>
            </div>
            <div class="row">
                <div class="messagealert" id="alert_container">
                </div>
            </div>
</div>
<script type="text/javascript">
    function ShowMessage(message, messagetype) {
        var cssclass;
        switch (messagetype) {
            case 'Success':
                cssclass = 'alert-success'
                break;
            case 'Error':
                cssclass = 'alert-danger'
                break;
            case 'Warning':
                cssclass = 'alert-warning'
                break;
            default:
                cssclass = 'alert-info'
        }
        $('#alert_container').append('<div id="alert_div" style="margin: 0 0.5%; -webkit-box-shadow: 3px 4px 6px #999;" class="alert fade in ' + cssclass + '"><a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a><span>' + message + '</span></div>');
        $('html,body').animate({ scrollTop: $('#alert_container').offset().top });
        setTimeout(function () {
            $('#alert_container').hide();
        }, 5000);
    }
</script>
