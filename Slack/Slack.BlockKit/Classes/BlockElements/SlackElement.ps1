enum SlackElementType {
    image
    button
    static_select
    external_select
    users_select
    conversations_select
    channels_select
    multi_static_select
    multi_external_select
    multi_users_select
    multi_conversations_select
    multi_channels_select
    overflow
    datepicker
    plain_text_input
}
class SlackElement {

    [SlackElementType]
    $type
    
    SlackElement ([string]$type) {
        $this.type = $type
    }
}