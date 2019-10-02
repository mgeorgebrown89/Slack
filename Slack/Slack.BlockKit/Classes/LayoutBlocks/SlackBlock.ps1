enum SlackBlockType {
    section
    divider
    image
    actions
    context
    input
    file
}

class SlackBlock {
    [SlackBlockType]
    $type

    SlackBlock ([SlackBlockType]$type) {
        $this.type = $type
    }
}