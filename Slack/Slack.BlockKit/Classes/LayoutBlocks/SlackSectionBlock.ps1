class SlackSectionBlock : SlackBlock {

    [SlackText]
    $text

    [string]
    [ValidateLength(255)]
    $block_id

    SlackSectionBlock ([SlackText]$text, [string]$block_id) : base("section") {
        if ($text.text -le 3000) {
            $this.text = $text
        }
        else {
            Write-Error "Slack Section Block text must be less than 3000 characters."
        }
        $this.block_id = $block_id
    }
}

class SlackSectionBlockWithFields : SlackSectionBlock {
    [SlackText[]]
    [ValidateCount(10)]
    $fields

    SlackSectionBlockWithFields([SlackText]$text, [string]$block_id, [SlackText[]]$fields) : base ($text, $block_id) {
        foreach ($field in $fields) {
            if ($field.text.length -gt 2000) {
                Write-Error "Slack Fields' text must be less than 2000 characters."
            }
        }
        $this.fields = $fields
        $this.text = $text
    }
    SlackSectionBlockWithFields([string]$block_id, [SlackText[]]$fields) : base ($block_id) {
        $this.fields = $fields
    }
}

class SlackSectionBlockWithAccessory : SlackSectionBlock {
    [SlackElement]
    $accessory

    SlackSectionBlockWithAccessory([SlackText]$text, [string]$block_id, [SlackElement]$accessory) : base ($text, $block_id) {
        $this.accessory = $accessory
    }
}

class SlackSectionBlockWithFieldsAndAccessory : SlackSectionBlockWithFields {
    [SlackElement]
    $accessory

    SlackSectionBlockWithFieldsAndAccessory ([SlackText]$text, [string]$block_id, [SlackText[]]$fields, [SlackElement]$accessory) : base ($text, $block_id, $fields) {
        $this.accessory = $accessory
    }
}