function New-SlackImageElement {
    param(
        [string]
        $image_url,

        [string]
        $alt_text
    )

    $SlackImageElement = [pscustomobject]@{
        type = "image"
        image_url = $image_url
        alt_text = $alt_text
    }
    return $SlackImageElement
}