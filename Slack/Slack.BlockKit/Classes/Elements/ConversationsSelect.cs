namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class ConversationsSelect : SelectMenu {
            public string initial_conversation;
            public ConfirmationDialog confirm;

            public ConversationsSelect(PlainText placeholder, string action_id) : base("conversations_select", placeholder, action_id) { }
        }
    }
}