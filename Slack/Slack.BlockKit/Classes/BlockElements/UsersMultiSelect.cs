namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class UsersMultiSelect : SelectMenu
        {
            public string[] initial_users;
            public ConfirmationDialog confirm;
            public uint max_selected_items = 1;

            public UsersMultiSelect(PlainText placeholder, string action_id) : base("multi_users_select", placeholder, action_id) { }
        }
    }
}