function Get-RandomSlackEmoji {
    <#
    .SYNOPSIS
        Returns a random Slack Emoji
    .DESCRIPTION
        This function returns a random Slack Emoji based on tags.
    .PARAMETER tag
        A string the designates the desired category of emoji from which to select.
    .EXAMPLE
        Get-RandomSlackEmoji -tag "person"
    #>
    [cmdletbinding()]
    param(
        [string]
        $tag
    )
    $emoji = (Get-Content -Path .\PSlickPSlack\Private\Emoji\SlackEmoji.json | ConvertFrom-Json) | Where-Object -Property "Tags" -Contains $tag | Get-Random
    return $emoji
}