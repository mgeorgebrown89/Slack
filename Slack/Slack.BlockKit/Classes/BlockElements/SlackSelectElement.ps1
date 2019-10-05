#region removethis
enum SlackElementType {
    image
    button
    static_select
    external_select
    users_select
    conversations_select
    channels_select
    multi_static_select
    multi_external_select
    multi_users_select
    multi_conversations_select
    multi_channels_select
    overflow
    datepicker
    plain_text_input
}
class SlackElement {

    [SlackElementType]
    $type
    
    SlackElement ([string]$type) {
        $this.type = $type
    }
}
#endregion

class SlackSelectElement : SlackElement {
    [SlackElementType]
    $type

    [SlackPlainText]
    $placeholder

    [string]
    [ValidateLength(1, 255)]
    $action_id
    
    SlackSelectElement ([SlackElementType]$type, [SlackPlainText]$placeholder, [string]$action_id) : base($type) {
        if ($placeholder.text.Length -gt 150) {
            Write-Error "Slack Select Element's placeholder text must be less than 150 characters."
        }
        else {
            $this.placeholder = $placeholder
        }
        $this.action_id = $action_id
    }
}
