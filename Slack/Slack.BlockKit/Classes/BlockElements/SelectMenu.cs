namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public abstract class SelectMenu : Element
        {
            private PlainText _placeholder;
            private const int placeholderTextLength = 150;
            private string _action_id;
            private const int action_idLength = 255;

            public SelectMenu(PlainText placeholder, string action_id) : base("static_select")
            {
                this.placeholder = placeholder;
                this.action_id = action_id;
            }
            public PlainText placeholder
            {
                get => _placeholder; set
                {
                    if (value.text.Length > placeholderTextLength)
                    {
                        throw new System.Exception($"Placeholder text must be less than {placeholderTextLength} characters.");
                    }
                    _placeholder = value;
                }
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


        }
    }
}