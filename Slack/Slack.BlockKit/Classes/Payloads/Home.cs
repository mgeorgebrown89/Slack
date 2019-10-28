namespace Slack
{
    namespace Payloads
    {
        using Slack.Composition;
        using Slack.Layout;
        public class Home : View
        {
            private Block[] _blocks;
            private const int maxBlocks = 100;
            private string _private_metadata;
            private const int private_metadataLength = 3000;
            private string _callback_id;
            private const int callback_idLength = 255;
            public string external_id;

            public Home(Block[] blocks) : base("home")
            {
                this.blocks = blocks;
            }

            public Block[] blocks
            {
                get => _blocks; set
                {
                    if (value.Length > maxBlocks)
                    {
                        throw new System.Exception($"Modals can only have up to {maxBlocks} blocks.");
                    }
                    _blocks = value;
                }
            }

            public string private_metadata
            {
                get => _private_metadata; set
                {
                    if (value.Length > private_metadataLength)
                    {
                        throw new System.Exception($"private_metadata length must be less than {private_metadataLength} characters.");
                    }
                    _private_metadata = value;
                }
            }

            public string callback_id
            {
                get => _callback_id; set
                {
                    if (value.Length > callback_idLength)
                    {
                        throw new System.Exception($"callback_id length must be less than {callback_idLength} characters.");
                    }
                    _callback_id = value;
                }
            }
        }
    }
}