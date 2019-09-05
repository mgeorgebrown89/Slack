function New-PSlickPSlackConfig {
    <#
    .SYNOPSIS
        Creates a new PSlickPSlack config file
    .DESCRIPTION
        This function will create a local configuration file that stores user-specific information like their Slack Workspace token or webhook.
    .PARAMETER test
        blah blahy blah
    .EXAMPLE
        New-PSlickPSlackConfig -token "xxxx-xxxx-xxxx-xxxx"
    #>
    [CmdletBinding()]
    param(
        [string]$token
    )

    $value = @"
{
    "slacktoken":"$token"
}
"@

    New-Item -ItemType File -Path "..\PSlickPSlack" -Name "PSlickPSlackConfig.json" -Value $value -Force

    $env:SLACK_TOKEN = $token
}
