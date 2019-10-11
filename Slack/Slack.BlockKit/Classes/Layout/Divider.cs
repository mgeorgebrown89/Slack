namespace Slack
{
    namespace Layout
    {
        public class Divider : Block
        {
            private string _block_id;
            private const int block_idTextLength = 255;
            public Divider() : base("divider") { }
            public Divider(string block_id) : this()
            {
                this.block_id = block_id;
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