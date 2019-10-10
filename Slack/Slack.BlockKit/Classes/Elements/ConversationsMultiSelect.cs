namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class ConversationsMultiSelect : SelectMenu
        {
            public string[] initial_conversations;
            public ConfirmationDialog confirm;
            public uint max_selected_items = 1;

            public ConversationsMultiSelect(PlainText placeholder, string action_id) : base("multi_conversations_select", placeholder, action_id) { }
        }
    }
}