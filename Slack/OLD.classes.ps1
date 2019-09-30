#region Message Composition Classes ################################################################
####################################################################################################
class SlackText {
    [ValidateSet("mrkdwn", "plain_text")]
    [String]
    $type

    [String]
    $text

    [bool]
    $verbatim = $false

    SlackText ([string]$type, [string]$text) {
        $this.type = $type
        $this.text = $text
    }    
    SlackText ([string]$type, [string]$text, [bool]$verbatim) {
        $this.type = $type
        $this.text = $text
        $this.verbatim = $verbatim
    }
}
class SlackPlainText : SlackText {
    [bool]
    $emoji = $true

    SlackPlainText ([string]$text) : base("plain_text", $text) {

    }

    SlackPlainText ([string]$text, [bool]$emoji) : base("plain_text", $text) {
        $this.emoji = $emoji
    }
}

class SlackConfirmation {
    [SlackPlainText]
    $title
    [SlackText]
    $text
    [SlackPlainText]
    $confirm
    [SlackPlainText]
    $deny

    SlackConfirmation ([SlackPlainText]$title, [SlackText]$text, [SlackPlainText]$confirm, [SlackPlainText]$deny) {
        $this.title = $title
        $this.text = $text
        $this.confirm = $confirm
        $this.deny = $deny
    }
}

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
#endregion

#region Slack Block Elements ######################################################################
####################################################################################################
class SlackElement {
    [ValidateSet(
        "image", "button", "static_select", "external_select", "users_select", "conversations_select", "channels_select", "overflow", "datepicker"
    )]
    [string]
    $type
    
    SlackElement ([string]$type) {
        $this.type = $type
    }

    [void] Confirmation([SlackConfirmation]$confirmation) {
        $this | Add-Member -NotePropertyName "confirm" -NotePropertyValue $confirmation
    }
}

#region Slack Image Elements ##################################################
################################################################################
class SlackImageElement : SlackElement {
    [string]
    $image_url

    [string]
    $alt_text

    SlackImageElement ([string]$image_url, [string]$alt_text) : base ("image") {
        $this.image_url = $image_url
        $this.alt_text = $alt_text
    }
}
#endregion

#region Slack Button Elements ##################################################
################################################################################
class SlackButton : SlackElement {
    [SlackPlainText]
    $text

    [string]
    $action_id

    SlackButton ([SlackPlainText]$text, [string]$action_id) : base ("button") {
        $this.text = $text
        $this.action_id = $action_id
    }

    [void] Style([string]$style) {
        $this | Add-Member -NotePropertyName "style" -NotePropertyValue $style -Force
    }
    [void] Value([string]$value) {
        $this | Add-Member -NotePropertyName "value" -NotePropertyValue $value -Force
    }
    [void] Url([string]$url) {
        $this | Add-Member -NotePropertyName "url" -NotePropertyValue $url -Force
    }
}
#endregion

#region Slack Select Menu Elements #############################################
################################################################################
class SlackSelectMenu : SlackElement {
    [ValidateSet(
        "static_select", "external_select", "users_select", "conversations_select", "channels_select"
    )]
    [string]
    $type

    [SlackPlainText]
    $placeholder

    [string]
    $action_id

    SlackSelectMenu ([string]$type, [SlackPlainText]$placeholder, [string]$action_id) : base($type) {
        $this.type = $type
        $this.placeholder = $placeholder
        $this.action_id = $action_id
    }
}
class SlackStaticSelect : SlackSelectMenu {

    SlackStaticSelect ([SlackPlainText]$placeholder, [string]$action_id) : base ("static_select", $placeholder, $action_id) {
    }

    [void] Options ([SlackOption[]]$options) {
        $this | Add-Member -NotePropertyName "options" -NotePropertyValue $options -Force
    }
    [void] OptionGroups ([SlackOptionGroup[]]$option_groups) {
        $this | Add-Member -NotePropertyName "option_groups" -NotePropertyValue $option_groups -Force
    }
    [void] InitialOption ([SlackOption]$initial_option) {
        $this | Add-Member -NotePropertyName "initial_option" -NotePropertyValue $initial_option -Force
    }
}
class SlackExternalSelect : SlackSelectMenu {
    #TODO
    SlackExternalSelect (){}
}
class SlackUserList : SlackSelectMenu {

    SlackUserList ([SlackPlainText]$placeholder, [string]$action_id) : base ("users_select", $placeholder, $action_id) {
    }
    [void] InitialUser ([string]$initial_user) {
        $this | Add-Member -NotePropertyName "initial_user" -NotePropertyValue $initial_user -Force
    }
}
class SlackConversationsList : SlackSelectMenu {
    #TODO
    SlackConversationsList(){}
}
class SlackChannelsList : SlackSelectMenu {
    #TODO
    SlackChannelsList(){}
}
#endregion

#region Slack Overflow Menu Elements ###########################################
################################################################################
class SlackOverflow : SlackElement {
    [ValidateCount(2, 5)]
    [SlackOption[]]
    $options

    [string]
    $action_id

    SlackOverflow ([SlackOption[]]$options, [string]$action_id) : base ("overflow") {
        $this.options = $options
        $this.action_id = $action_id
    }
}
#endregion

#region Slack Date Picker Elements ############################################
################################################################################
class SlackDatePicker : SlackElement {
    [string]
    $action_id

    SlackDatePicker ([string]$action_id) : base("datepicker"){
        $this.action_id = $action_id
    }

    [void] Placeholder ([SlackPlainText]$placeholder){
        $this | Add-Member -NotePropertyName "placeholder" -NotePropertyValue $placeholder -Force
    }
    [void] InitialDate ([string]$initial_date){
        $this | Add-Member -NotePropertyName "initial_date" -NotePropertyValue $initial_date -Force
    }
}
#endregion
#endregion

#region Slack Message Layout Blocks ###############################################################
###################################################################################################
class SlackBlock {
    [ValidateSet("divider", "section","image","actions","context")]
    [String]
    $type

    SlackBlock ([string]$type) {
        $this.type = $type
    }

    [void] BlockId ([string]$block_id){
        $this | Add-Member -NotePropertyName "block_id" -NotePropertyValue $block_id -Force
    }
}
class SlackSectionBlock : SlackBlock {
    [SlackText]
    $text

    SlackSectionBlock ([SlackText]$text) : base("section") {
        $this.text = $text
    }
    [void] Fields ([SlackText[]]$fields){
        $this | Add-Member -NotePropertyName "fields" -NotePropertyValue $fields -Force
    }
    [void] Accessory ([SlackElement]$accessory){
        $this | Add-Member -NotePropertyName "accessory" -NotePropertyValue $accessory -Force
    }
}

class SlackImageBlock : SlackBlock {
    [string]
    $image_url

    [string]
    $alt_text

    SlackImageBlock ([string]$image_url,[string]$alt_text) : base ("image"){
        $this.image_url = $image_url
        $this.alt_text = $alt_text
    }

    [void] Title ([string]$title) {
        $this | Add-Member -NotePropertyName "title" -NotePropertyValue $title -Force
    }
}

class SlackActionsBlock : SlackBlock {
    [SlackElement[]]
    $elements

    SlackActionsBlock ([SlackElement[]]$elements) : base ("actions"){
        $this.elements = $elements
    }
}

class SlackContextBlock : SlackBlock{
    [ValidateCount(1,10)]
    [System.Object[]]
    $elements

    SlackContextBlock ([SlackElement[]]$elements) : base ("context"){
        $this.elements = $elements
    }
}
#endregion

#region tests
[PSObject[]]$Blocks = @()

$headerText = [SlackText]::new("mrkdwn","This is the _title_ of my *message*.")
$buttonText = [SlackPlainText]::new("testing text")
$headerBlock = [SlackSectionBlock]::new($headerText)
$button = [SlackButton]::new($buttonText,"id1")
$button.Style("danger")
$headerBlock.Accessory($button)
$Blocks += $headerBlock
$Blocks += $headerBlock

ConvertTo-Json -InputObject $Blocks -Depth 100
#endregion