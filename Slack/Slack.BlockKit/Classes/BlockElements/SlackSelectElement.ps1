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

class SlackStaticSelectElement : SlackSelectElement {
    [SlackOption[]]
    [ValidateCount(1, 100)]
    $options

    [SlackOption]
    $initial_option

    SlackStaticSelectElement ([SlackOption[]]$options, [SlackOption]$initial_option, [SlackPlainText]$placeholder, [string]$action_id) : base('static_select', $placeholder, $action_id) {
        $this.options = $options
        $this.initial_option = $initial_option
    }
}

class SlackStaticSelectElementWithConfirm : SlackStaticSelectElement {

    [SlackConfirmationDialog]
    $confirm

    SlackStaticSelectElementWithConfirm (
        [SlackConfirmationDialog]$confirm, [SlackOption[]]$options, [SlackOption]$initial_option, [SlackPlainText]$placeholder, [string]$action_id
    ) : base(
        'static_select', $placeholder, $action_id, $options, $initial_option
    ) {
        $this.confirm = $confirm
    }
}

class SlackStaticSelectElementWithGroups : SlackSelectElement {
    [SlackOptionGroup[]]
    [ValidateCount(1, 100)]
    $option_groups
    
    [SlackOption]
    $initial_option

    SlackStaticSelectElementWithGroups ([SlackOptionGroup[]]$option_groups, [SlackOption]$initial_option, [SlackPlainText]$placeholder, [string]$action_id) : base('static_select', $placeholder, $action_id) {
        $this.option_groups = $option_groups
        $this.initial_option = $initial_option
    }
}

class SlackStaticSelectElementWithGroupsAndConfirm : SlackStaticSelectElementWithGroups {

    [SlackConfirmationDialog]
    $confirm

    SlackStaticSelectElementWithGroupsAndConfirm (
        [SlackOptionGroup[]]$option_groups, [SlackOption]$initial_option, [SlackPlainText]$placeholder, [string]$action_id, [SlackConfirmationDialog]$confirm
    ) : base(
        'static_select', $placeholder, $action_id, $option_groups, $initial_option
    ) {
        $this.confirm = $confirm
    }
}