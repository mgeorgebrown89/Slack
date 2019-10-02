class SlackOption {

    [SlackPlainText]
    $text

    [string]
    $value

    SlackOption ([SlackPlainText]$text, [string]$value) {
        $this.text = $text
        $this.value = $value
    }
}

#can only be used with an overflow menu.
class SlackOptionWithUrl : SlackOption {

    [string]
    $url
    
    SlackOptionWithUrl ([SlackPlainText]$text, [string]$value, [string]$url) : base ($text, $value){
        $this.url = $url
    }
}