namespace Slack
{
    namespace Composition
    {
        public class Option
        {
            private PlainText _text;
            private const int textTextLength = 75;
            private string _value;
            private const int valueLength = 75;
            private string _url;
            private const int urlLength = 3000;

            public Option(PlainText text, string value)
            {
                this.text = text;
                this.value = value;
            }
            public Option(PlainText text, string value, string url)
            {
                this.text = text;
                this.value = value;
                this.url = url;
            }
            public PlainText text
            {
                get => _text; set
                {
                    if (value.text.Length > textTextLength)
                    {
                        throw new System.Exception($"Option text must be less than {textTextLength} characters.");
                    }
                    _text = value;
                }
            }

            public string value
            {
                get => _value; set
                {
                    if (value.Length > valueLength)
                    {
                        throw new System.Exception($"Option text must be less than {valueLength} characters.");
                    }
                    _value = value;
                }
            }

            public string url
            {
                get => _url; set
                {
                    if (value.Length > urlLength)
                    {
                        throw new System.Exception($"Option text must be less than {urlLength} characters.");
                    }
                    _url = value;
                }
            }
        }
    }
}