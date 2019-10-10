namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class ChannelsMultiSelect : SelectMenu
        {
            public string[] initial_channels;
            public ConfirmationDialog confirm;
            public uint max_selected_items = 1;

            public ChannelsMultiSelect(PlainText placeholder, string action_id) : base("multi_channels_select", placeholder, action_id) { }
        }
    }
}