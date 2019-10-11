function Set-SlackDefaults {
    <#
    .SYNOPSIS
        Creates a new Slack config file
    .DESCRIPTION
        This function will create a local configuration file that stores user-specific information like their Slack Workspace token or webhook.
    .PARAMETER botToken
        A Slack Bot token
    .PARAMETER userToken
        A Slack User token
    .PARAMETER defaultChannel
        The name or ID of a default channel to use for output.
    .PARAMETER defaultWebhook
        The url of a default webhook to use for output. If this is set, this will take precedence.
    .EXAMPLE
        Set-SlackDefaults -botToken "xxxx-xxxx-xxxx-xxxx"
    #>
    [CmdletBinding()]
    param(
        [string]
        [ValidatePattern("^xoxb-")]
        $botToken,

        [string]
        [ValidatePattern("^xoxp-")]
        $userToken,

        [string]
        $defaultChannel,

        [string]
        [ValidatePattern("https://hooks.slack.com/services/")]
        $defaultWebhook
    )

    $root = (Get-Item $PSScriptRoot).Parent.FullName

    $value = @"
{
    "botToken":"$botToken",
    "userToken":"$userToken",
    "defaultChannel":"$defaultChannel",
    "defaultWebhook":"$defaultWebhook"
}
"@

    New-Item -Path $root -Name "SlackDefaults.json" -ItemType File -Value $value -Force
}

#Set-SlackDefaults -botToken "xoxb-" -userToken "xoxp-"