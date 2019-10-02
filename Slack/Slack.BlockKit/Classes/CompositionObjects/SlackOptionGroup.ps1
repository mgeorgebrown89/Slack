class SlackOptionGroup {
    [SlackPlainText]
    $label

    [SlackOption[]]
    $options

    SlackOptionGroup ([SlackPlainText]$label, [SlackOption[]]$options) {
        $this.label = $label
        $this.options = $options
    }
}