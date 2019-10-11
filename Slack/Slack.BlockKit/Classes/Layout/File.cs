namespace Slack
{
    namespace Layout
    {
        public class File : Block
        {
            public string external_id;
            public string source;
            private string _block_id;
            private const int block_idLength = 255;

            public File(string external_id, string source) : base("file")
            {
                this.external_id = external_id;
                this.source = source;
            }
            public File(string external_id, string source, string block_id) : this(external_id, source)
            {
                this.block_id = block_id;
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