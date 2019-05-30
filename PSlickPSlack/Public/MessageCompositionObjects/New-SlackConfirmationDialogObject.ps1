function New-SlackConfirmationDialogObject {
    param(
        [string]
        $title,

        [string]
        $text,

        [string]
        $confirmationText,

        [string]
        $denialText
    )
    $SlackConfirmation = [pscustomobject]@{
        title = @{
            type = "plain_text"
            text = $title
        }
        text = @{
            type = "mrkdwn"
            text = $text
        }
        confirm = @{
            type = "plain_text"
            text = $confirm
        }
        deny = @{
            type = "plain_text"
            text = $deny
        }
    }
    return $SlackConfirmation
}