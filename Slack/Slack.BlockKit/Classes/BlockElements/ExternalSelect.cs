namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class ExternalSelect : SelectMenu
        {
            public Option initial_option;
            public int min_query_length;
            public ConfirmationDialog confirm;

            public ExternalSelect(PlainText placeholder, string action_id) : base("external_select", placeholder, action_id) { }
        }
    }
}