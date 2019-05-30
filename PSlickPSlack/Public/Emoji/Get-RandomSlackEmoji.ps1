function Get-RandomSlackEmoji {
    <#
    
    #>
    [cmdletbinding()]
    param(
        [ValidateSet("People", "Nature", "Objects", "Places", "Symbols")]
        [string]
        $tag
    )
    $emoji = (Get-Content -Path .\Media\SlackEmoji.json | ConvertFrom-Json) | Where-Object -Property "Tags" -Contains $tag | Get-Random
    return $emoji
}

Get-RandomSlackEmoji -tag People