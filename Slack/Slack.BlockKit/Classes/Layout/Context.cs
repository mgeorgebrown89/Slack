namespace Slack
{
    namespace Layout
    {
        using Slack.Elements;
        public class Context : Block
        {
            private object[] _elements;
            private string _block_id;
            private const int block_idTextLength = 255;

            public Context(object[] elements) : base("context")
            {
                this.elements = elements;
            }
            public Context(object[] elements, string block_id) : this(elements)
            {
                this.block_id = block_id;
            }
            public object[] elements
            {
                get => _elements; set
                {
                    foreach (object element in value)
                    {
                        if ((element is Slack.Composition.TextObject) || (element is Slack.Elements.Image))
                        {
                            _elements = value;
                        }
                        else
                        {
                            throw new System.Exception($"Context Block elements can only be Image Elements or Text Objects.");
                        }
                    }
                }
            }
            public string block_id
            {
                get => _block_id; set
                {
                    if (value.Length > block_idTextLength)
                    {
                        throw new System.Exception($"Divider block_id must be less than {block_idTextLength} characters");
                    }
                    _block_id = value;
                }
            }
        }
    }
}