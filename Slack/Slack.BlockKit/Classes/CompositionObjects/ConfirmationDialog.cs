namespace Slack
{
    namespace Composition
    {
        public class ConfirmationDialog
        {
            private PlainText _title;
            private const int titleTextLength = 100;
            private TextObject _text;
            private const int textTextLength = 300;
            private PlainText _confirm;
            private const int confirmTextLength = 30;
            private PlainText _deny;
            private const int denyTextLength = 30;

            public ConfirmationDialog(PlainText title, TextObject text, PlainText confirm, PlainText deny)
            {
                this.title = title;
                this.text = text;
                this.confirm = confirm;
                this.deny = deny;
            }
            public PlainText title
            {
                get => _title; set
                {
                    if (value.text.Length > titleTextLength)
                    {
                        throw new System.Exception($"Title text must be less than {titleTextLength} characters.");
                    }
                    else
                    {
                        _title = value;
                    }
                }
            }

            public TextObject text
            {
                get => _text; set
                {
                    if (value.text.Length > textTextLength)
                    {
                        throw new System.Exception($"Title text must be less than {textTextLength} characters.");
                    }
                    _text = value;
                }
            }

            public PlainText confirm
            {
                get => _confirm; set
                {
                    if (value.text.Length > confirmTextLength)
                    {
                        throw new System.Exception($"Title text must be less than {confirmTextLength} characters.");
                    }
                    _confirm = value;
                }
            }
            public PlainText deny
            {
                get => _deny; set
                {
                    if (value.text.Length > denyTextLength)
                    {
                        throw new System.Exception($"Title text must be less than {denyTextLength} characters.");
                    }
                    _deny = value;
                }
            }
        }
    }
}