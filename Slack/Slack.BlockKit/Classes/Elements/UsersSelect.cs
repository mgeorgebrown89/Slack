namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class UsersSelect : SelectMenu {
            public string initial_user;
            public ConfirmationDialog confirm;

            public UsersSelect(PlainText placeholder, string action_id) : base("users_select", placeholder, action_id) { }
        }
    }
}