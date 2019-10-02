#can only be used in section and context blocks
class SlackImage : SlackElement {
    [string]
    $image_url

    [string]
    $alt_text

    SlackImage ([string]$image_url, [string]$alt_text) : base ("image") {
        $this.image_url = $image_url
        $this.alt_text = $alt_text
    }
}