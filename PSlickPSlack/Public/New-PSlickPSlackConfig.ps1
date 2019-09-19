function New-PSlickPSlackConfig {
    <#
    .SYNOPSIS
        Creates a new PSlickPSlack config file
    .DESCRIPTION
        This function will create a local configuration file that stores user-specific information like their Slack Workspace token or webhook.
    .PARAMETER botToken
        A Slack Bot token
    .PARAMETER userToken
        A Slack User token
    .PARAMETER defaultChannel
        The name or ID of a default channel to use for output.
    .EXAMPLE
        New-PSlickPSlackConfig -botToken "xxxx-xxxx-xxxx-xxxx"
    #>
    [CmdletBinding()]
    param(
        [string]
        [ValidateScript({$_ -match "^xoxb-"})]
        $botToken,

        [string]
        [ValidateScript({$_ -match "^xoxp-"})]
        $userToken,

        [string]
        $defaultChannel,

        [string]
        [ValidateScript({$_ -match "https://hooks.slack.com/services/"})]
        $defaultWebhook
    )

    $root = (Get-Item $PSScriptRoot).Parent.FullName

    $value = @"
{
    "botToken":"$botToken",
    "userToken":"$userToken",
    "defaultChannel":"$defaultChannel"
    "defaultWebhook":"$defaultWebhook"
}
"@

    New-Item -Path $root -Name "pslickpslackconfig.json" -ItemType File -Value $value -Force
}
