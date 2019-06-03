function Get-RandomSlackEmoji {
    <#
    
    #>
    [cmdletbinding()]
    param(
        [string]
        $tag
    )
    $emoji = (Get-Content -Path .\PSlickPSlack\Private\Emoji\SlackEmoji.json | ConvertFrom-Json) | Where-Object -Property "Tags" -Contains $tag | Get-Random
    return $emoji
}