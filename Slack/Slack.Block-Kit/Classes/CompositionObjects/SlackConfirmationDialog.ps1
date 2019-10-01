class SlackConfirmationDialog {

    [SlackPlainText]
    $title
    [SlackText]
    $text
    [SlackPlainText]
    $confirm
    [SlackPlainText]
    $deny

    SlackConfirmationDialog ([SlackPlainText]$title, [SlackText]$text, [SlackPlainText]$confirm, [SlackPlainText]$deny) {
        if ($title.text.Length -le 100) {
            $this.title = $title
        }
        else {
            Write-Error "Title text can only be 100 characters."
        }

        if ($text.text.Length -le 300) {
            $this.text = $text
        }
        else {
            Write-Error "Text text can only be 300 characters."
        }

        if ($confirm.text.Length -le 30) {
            $this.confirm = $confirm
        }
        else {
            Write-Error "Confirm text can only be 30 characters."
        }

        if ($deny.text.Length -le 30) {
            $this.deny = $deny
        }
        else {
            Write-Error "Deny text can only be 30 characters."
        }
    }
}
