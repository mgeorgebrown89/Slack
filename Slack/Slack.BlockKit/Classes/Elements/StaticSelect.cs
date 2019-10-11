namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class StaticSelect : SelectMenu
        {
            private Option[] _options;
            private const int optionsCount = 100;
            private OptionGroup[] _option_groups;
            private const int option_groupsCount = 100;
            public Option initial_option;
            public ConfirmationDialog confirm;

            public StaticSelect(PlainText placeholder, string action_id, Option[] options) : base("static_select", placeholder, action_id)
            {
                this.options = options;
            }
            public StaticSelect(PlainText placeholder, string action_id, OptionGroup[] option_groups) : base("static_select", placeholder, action_id)
            {
                this.option_groups = option_groups;
            }

            public Option[] options
            {
                get => _options; set
                {
                    if (value.Length > optionsCount)
                    {
                        throw new System.Exception($"There can only be {optionsCount} options in a Static Select Menu.");
                    }
                    _options = value;
                }
            }
            public OptionGroup[] option_groups
            {
                get => _option_groups; set
                {
                    if (value.Length > option_groupsCount)
                    {
                        throw new System.Exception($"There can only be {option_groupsCount} options in a Static Select Menu.");
                    }
                    _option_groups = value;
                }
            }
        }
    }
}