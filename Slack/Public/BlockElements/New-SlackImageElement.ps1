function New-SlackImageElement {
    <#
    .SYNOPSIS
        Returns a Slack Image Element.
    .DESCRIPTION
        This function returns a Slack Image Element as a PSCustomObject ready to combine with other Slack Blocks,
        ConvertTo-Json, and send to Slack.
    .PARAMETER image_url
        The URL of the image to be displayed.
    .PARAMETER alt_text
        A plain-text summary of the image. This should not contain any markup.
    .LINK
        https://api.slack.com/reference/messaging/block-elements#image
    .EXAMPLE
        New-SlackImageElement -image_url "http://placekitten.com/700/500" -alt_text "meow!"
    #>
    [CmdletBinding()]
    param(
        [string]
        $image_url,

        [string]
        $alt_text
    )

    $SlackImageElement = [pscustomobject]@{
        type      = "image"
        image_url = $image_url
        alt_text  = $alt_text
    }
    return $SlackImageElement
}