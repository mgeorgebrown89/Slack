Add-Type -LiteralPath '/Users/Michael/Repositories/Slack/Slack/Slack.BlockKit/Classes/CompositionObjects/Slack.cs'

enum SlackTextType {
    mrkdwn
    plain_text
}

class SlackText {

    [SlackTextType]
    $type

    [string]
    $text

    SlackText ([string]$type, [string]$text) {
        $this.type = $type
        $this.text = $text
    } 
}

class SlackPlainText : SlackText {

    [bool]
    $emoji = $true

    SlackPlainText ([string]$text) : base("plain_text", $text) { }
    
    SlackPlainText ([string]$text, [bool]$emoji) : base("plain_text", $text) {
        $this.emoji = $emoji
    }
}

class SlackMrkdwnText : SlackText {

    [bool]
    $verbatim = $false

    SlackMrkdwnText ([string]$text) : base("mrkdwn", $text) { }

    SlackMrkdwnText ([string]$text, [bool]$verbatim) : base("mrkdwn", $text) {
        $this.verbatim = $verbatim
    }
}
