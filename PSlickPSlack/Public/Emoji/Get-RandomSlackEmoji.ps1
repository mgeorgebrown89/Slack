function Get-RandomSlackEmoji {
    <#
    
    #>
    [cmdletbinding()]
    param(
        [ValidateSet("People", "Nature", "Objects", "Places", "Symbols")]
        [string]
        $category
    )

}