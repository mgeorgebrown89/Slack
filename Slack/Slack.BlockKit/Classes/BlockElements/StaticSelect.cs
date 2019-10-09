namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class StaticSelect : SelectMenu
        {
            private Option[] _options;
            private const int optionsCount = 100;
            //private OptionGroup[] option_groups;
            private const int option_groupsCount = 100;
            private Option _initial_option;
            private ConfirmationDialog _confirm;

            public StaticSelect(PlainText placeholder, string action_id, Option[] options) : base(placeholder, action_id)
            {
                this.options = options;
            }
            public StaticSelect(PlainText placeholder, string action_id, Option[] options, Option initial_option) : this(placeholder, action_id, options)
            {
                this.initial_option = initial_option;
            }
            public StaticSelect(PlainText placeholder, string action_id, Option[] options, Option initial_option, ConfirmationDialog confirm) : this(placeholder, action_id, options)
            {
                this.initial_option = initial_option;
                this.confirm = confirm;
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
            //public OptionGroup[] option_groups { get => option_groups; set => option_groups = value; }
            public Option initial_option { get => _initial_option; set => _initial_option = value; }
            public ConfirmationDialog confirm { get => _confirm; set => _confirm = value; }


        }
    }
}