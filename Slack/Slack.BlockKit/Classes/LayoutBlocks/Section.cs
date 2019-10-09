namespace Slack
{
    namespace Layout
    {
        using Slack.Composition;
        using Slack.Elements;
        public class Section : Block
        {
            private TextObject _text;
            private const int textTextLength = 3000;
            private string _block_id;
            private const int block_idTextLength = 255;
            private TextObject[] _fields;
            private const int fieldsCount = 10;
            private const int fieldsTextLength = 2000;
            private Element _accessory;

            public Section(TextObject text) : base("section")
            {
                this.text = text;
            }
            public Section(TextObject text, string block_id) : this(text)
            {
                this.block_id = block_id;
            }

            public TextObject text
            {
                get => _text; set
                {
                    if (value.text.Length > textTextLength)
                    {
                        throw new System.Exception($"Text Object text must be less than {textTextLength} characters.");
                    }
                    _text = value;
                }
            }

            public string block_id
            {
                get => _block_id; set
                {
                    if (value.Length > block_idTextLength)
                    {
                        throw new System.Exception($"block_id text must be less than {block_idTextLength} characters.");
                    }
                    _block_id = value;
                }
            }
            public TextObject[] fields
            {
                get => _fields; set
                {
                    if (fields.Length > fieldsCount)
                    {
                        throw new System.Exception($"Section Blocks can only have {fieldsCount} TextObjects.");
                    }
                    foreach (TextObject field in fields)
                    {
                        if (field.text.Length > fieldsTextLength)
                        {
                            throw new System.Exception($"TextObject text in a Section Block field must be less than {fieldsTextLength} characters.");
                        }
                    }
                    _fields = value;
                }
            }

            public Element accessory { get => _accessory; set => _accessory = value; }
        }
    }
}