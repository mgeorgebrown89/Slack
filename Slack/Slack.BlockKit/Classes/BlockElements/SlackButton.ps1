class SlackButton : SlackElement {
    [SlackPlainText]
    $text

    [string]
    $action_id

    SlackButton ([SlackPlainText]$text, [string]$action_id) : base ("button") {
        if ($text.text -gt 75) {
            $this.text = $text
        }
        else {
            Write-Error "The maximum length for a button's text field is 75 characters."
        }
        $this.action_id = $action_id
    }
}

class SlackButtonWithUrl : SlackButton {
    [string]
    $url

    SlackButtonWithUrl ([SlackPlainText]$text, [string]$action_id, [string]$url) : base ($text, $action_id) {
        if ($url.Length -le 3000) {
            $this.url = $url
        }
        else {
            Write-Error "This maximum length for a Slack Button's URL value is 3000 characters."
        }
    }
}

class SlackButtonWithValue : SlackButton {
    [string]
    $value

    SlackButtonWithValue ([SlackPlainText]$text, [string]$action_id, [string]$value) : base ($text, $action_id) {
        if ($value.Length -le 2000) {
            $this.value = $value
        }
        else {
            Write-Error "This maximum length for a Slack Button's Value value is 2000 characters."
        }
    }
}

enum SlackButtonStyle {
    primary
    danger
}

class SlackButtonWithStyle : SlackButtonWithValue {
    [SlackButtonStyle]
    $style

    SlackButtonWithStyle ([SlackPlainText]$text, [string]$action_id, [string]$value, [SlackButtonStyle]$style) : base ($text, $action_id, $value) {
        $this.style = $style
    }
}

class SlackButtonWithConfirm : SlackButtonWithValue {
    [SlackConfirmationDialog]
    $confirm

    SlackButtonWithConfirm ([SlackPlainText]$text, [string]$action_id, [string]$value, [SlackConfirmationDialog]$confirm) : base ($text, $action_id, $value) {
        $this.confirm = $confirm
    }
}

class SlackButtonWithStyleAndConfirm : SlackButtonWithStyle {
    [SlackConfirmationDialog]
    $confirm

    SlackButtonWithStyleAndConfirm (
        [SlackPlainText]$text, [string]$action_id, [string]$value, [SlackButtonStyle]$stytle, [SlackConfirmationDialog]$confirm
    ) : base (
        $text, $action_id, $style, $value
    ) {
        $this.confirm = $confirm
    }
}
