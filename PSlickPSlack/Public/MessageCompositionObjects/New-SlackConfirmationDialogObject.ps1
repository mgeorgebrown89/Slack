function New-SlackConfirmationDialogObject {
    <#
    .SYNOPSIS
        Returns a Slack Confirmation Dialog Object.
    .DESCRIPTION
        This function returns a Slack Confirmation Dialog Object as a PSCustomObject ready to combine with any Slack Element,
        ConvertTo-Json, and send to Slack.
    .PARAMETER title
        Text that defines the dialog's title.
    .PARAMETER text
        Text that defines the explanatory text that appears in the confirm dialog.
    .PARAMETER confirm
        Text to define the text of the button that confirms the action.
    .PARAMETER deny
        Text to define the text of the button that cancels the action.
    .LINK
        https://api.slack.com/reference/messaging/composition-objects#confirm
    .EXAMPLE
        New-SlackConfirmationDialogObject -title "Are you sure?" -text "Really?" -confirmationText "Yes" -denialText "No"
    #>
    [CmdletBinding()]
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
        title   = @{
            type = "plain_text"
            text = $title
        }
        text    = @{
            type = "mrkdwn"
            text = $text
        }
        confirm = @{
            type = "plain_text"
            text = $confirm
        }
        deny    = @{
            type = "plain_text"
            text = $deny
        }
    }
    return $SlackConfirmation
}