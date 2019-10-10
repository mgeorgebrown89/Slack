namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class Overflow : Element
        {
            private string _action_id;
            private const int action_idLength = 255;
            private Option[] _options;
            private const int optionsMinCount = 2;
            private const int optionsMaxCount = 5;
            public ConfirmationDialog confirm;

            public Overflow(string action_id, Option[] options) : base("overflow")
            {
                this.action_id = action_id;
                this.options = options;
            }
            public string action_id
            {
                get => _action_id; set
                {
                    if (value.Length > action_idLength)
                    {
                        throw new System.Exception($"Action_id text must be less than {action_idLength} characters.");
                    }
                    _action_id = value;
                }
            }

            public Option[] options
            {
                get => _options; set
                {
                    if(value.Length < optionsMinCount || value.Length > optionsMaxCount)
                    {
                        throw new System.Exception($"Overflows can only have between {optionsMinCount} and {optionsMaxCount} options.");
                    }
                    _options = value;
                }
            }
        }
    }
}