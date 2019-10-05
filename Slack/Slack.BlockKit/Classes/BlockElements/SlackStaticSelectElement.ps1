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