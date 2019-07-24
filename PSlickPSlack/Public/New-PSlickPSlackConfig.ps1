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
        [string]$test
    )

}