& .\Slack\Slack.Block-Kit\Classes\CompositionObjects\Text\SlackText.ps1

class SlackConfirmationDialog {

    [SlackPlainText]
    [ValidateScript($_.text)]
    $title
    [SlackText]
    $text
    [SlackPlainText]
    $confirm
    [SlackPlainText]
    $deny
}