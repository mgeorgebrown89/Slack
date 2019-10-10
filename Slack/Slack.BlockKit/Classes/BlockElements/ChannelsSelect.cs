namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class ChannelsSelect : SelectMenu {
            public string initial_user;
            public ConfirmationDialog confirm;

            public ChannelsSelect(PlainText placeholder, string action_id) : base("channels_select", placeholder, action_id) { }
        }
    }
}