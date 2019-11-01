namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class PlainTextInput : Element
        {
            private string _action_id;
            private const int action_idLength = 255;
            private PlainText _placeholder;
            private const int placeholderTextLength = 150;
            public string initial_value;
            public bool multiline;
            private uint _min_length;
            private uint _max_length = 100;
            private const int inputLengthMax = 3000;

            public PlainTextInput(string action_id) : base("plain_text_input")
            {
                this.action_id = action_id;
            }

            public string action_id
            {
                get => _action_id; set
                {
                    if (value.Length > action_idLength)
                    {
                        throw new System.Exception($"action id length must be less than {action_idLength} characters.");
                    }
                    _action_id = value;
                }
            }

            public PlainText placeholder
            {
                get => _placeholder; set
                {
                    if (value.text.Length > placeholderTextLength)
                    {
                        throw new System.Exception($"placeholder text length must be less than {placeholderTextLength} characters.");
                    }
                    _placeholder = value;
                }
            }

            public uint min_length
            {
                get => _min_length; set
                {
                    if (value > inputLengthMax)
                    {
                        throw new System.Exception($"min_length must be less than {inputLengthMax} characters.");
                    }
                    _min_length = value;
                }
            }
            public uint max_length
            {
                get => _max_length; set
                {
                    if (value > inputLengthMax)
                    {
                        throw new System.Exception($"max_length must be less than {inputLengthMax} characters.");
                    }
                    _max_length = value;
                }
            }
        }
    }
}