namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        public class Button : Element
        {
            private PlainText _text;
            private const int textTextLength = 75;
            private string _action_id;
            private const int action_idLength = 255;
            private string _url;
            private const int urlLength = 3000;
            private string _value;
            private const int valueLength = 2000;
            public string style;
            private readonly string[] styleType = { "primary", "danger" };
            public ConfirmationDialog confirm;

            public Button(PlainText text, string action_id) : base("button")
            {
                this.text = text;
                this.action_id = action_id;
            }
            public static Button WithUrl(PlainText text, string action_id, string url)
            {
                
                this.url = url;
            }
            public Button(PlainText text, string action_id, string value) : this(text, action_id)
            {
                this.value = value;
            }

            public PlainText text
            {
                get => _text; set
                {
                    if (value.text.Length > textTextLength)
                    {
                        throw new System.Exception($"A button text object text must be less than {textTextLength} characters.");
                    }
                    _text = value;
                }
            }

            public string action_id
            {
                get => _action_id; set
                {
                    if(value.Length > action_idLength)
                    {
                        throw new System.Exception($"Action_id length must be less than {action_idLength} characters.");
                    }
                    _action_id = value;
                }
            }

            public string url
            {
                get => _url; set
                {
                    if(value.Length > urlLength)
                    {
                        throw new System.Exception($"Action_id length must be less than {urlLength} characters.");
                    }
                    _url = value;
                }
            }

            public string value
            {
                get => _value; set
                {
                    if(value.Length > valueLength)
                    {
                        throw new System.Exception($"Action_id length must be less than {valueLength} characters.");
                    }
                    _value = value;
                }
            }
        }
    }
}