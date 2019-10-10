namespace Slack
{
    namespace Layout
    {
        using Slack.Elements;
        public class Actions : Block
        {
            private Element[] _elements;
            private const int elementsCount = 5;
            private string _block_id;
            private const int block_idLength = 255;

            public Actions(Element[] elements) : base("actions")
            {
                this.elements = elements;
            }
            public Actions(Element[] elements, string block_id) : this(elements)
            {
                this.block_id = block_id;
            }
            public Element[] elements
            {
                get => _elements; set
                {
                    if (value.Length > elementsCount)
                    {
                        throw new System.Exception($"There can only be {elementsCount} elements in an Actions Block.");
                    }
                    _elements = value;
                }
            }
            public string block_id
            {
                get => _block_id; set
                {
                    if (value.Length > block_idLength)
                    {
                        throw new System.Exception($"block_id must be less than {block_idLength} characters.");
                    }
                    _block_id = value;
                }
            }
        }
    }
}