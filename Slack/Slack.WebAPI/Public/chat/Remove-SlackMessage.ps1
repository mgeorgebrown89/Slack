
function Remove-SlackMessage {
    <#
    .SYNOPSIS
        Removes a Slack Message.
    .DESCRIPTION
        This function deletes a Slack message from a channel.
    .PARAMETER Token
        Authentication token bearing required scopes.
    .PARAMETER ChannelId
        Channel containing the message to be deleted.
    .PARAMETER Timestamp
        Timestamp of the message to be deleted.
    .PARAMETER as_user
        Pass true to delete the message as the authed user with chat:write:user scope. Bot users in this context are considered authed users.
        If unused or false, the message will be deleted with chat:write:bot scope.
    .LINK
        https://api.slack.com/methods/chat.delete
    .EXAMPLE
        Remove-SlackMessage 
    #>
    [CmdletBinding()]
    param (
        [string]
        [Parameter(Mandatory = $true)]
        $Token,

        [string]
        [Parameter(Mandatory = $true)]
        $ChannelId,

        [string]
        [Parameter(Mandatory = $true)]
        $Timestamp,

        [bool]
        $as_user = $true
    )

    $body = [PSCustomObject]@{
        channel = $ChannelId
        ts = $Timestamp
        as_user = $as_user
    }

    Invoke-SlackWebAPI -Token $token -Method_Family "chat.delete" -Body $body
}
Set-Alias -Name 'chat.delete' -Value 'Remove-SlackMessage'