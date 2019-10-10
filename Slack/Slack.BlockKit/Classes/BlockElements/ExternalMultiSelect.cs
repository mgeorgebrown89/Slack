namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class ExternalMultiSelect : SelectMenu
        {
            public int min_query_length;
            public Option[] initial_options;
            public ConfirmationDialog confirm;
            public uint max_selected_items = 1;

            public ExternalMultiSelect(PlainText placeholder, string action_id) : base("multi_external_select", placeholder, action_id) { }

        }
    }
}