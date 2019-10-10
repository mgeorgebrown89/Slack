namespace Slack
{
    namespace Payloads
    {
        using Slack.Composition;
        using Slack.Layout;
        public class Modal : View
        {
            private PlainText _title;
            private const int titleTextLength = 24;
            private Block[] _blocks;
            private const int maxBlocks = 100;
            private PlainText _close;
            private const int closeTextLength = 24;
            private PlainText _submit;
            private const int submitTextLength = 24;
            private string _private_metadata;
            private const int private_metadataLength = 3000;
            private string _callback_id;
            private const int callback_idLength = 255;
            public bool clear_on_close;
            public bool notify_on_close;
            public string hash;
            public string external_id;

            public Modal(PlainText title, Block[] blocks) : base("modal")
            {
                this.title = title;
                this.blocks = blocks;
            }

            public PlainText title
            {
                get => _title; set
                {
                    if (value.text.Length > titleTextLength)
                    {
                        throw new System.Exception($"Title text length must be less than {titleTextLength} characters.");
                    }
                    _title = value;
                }
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

            public PlainText close
            {
                get => _close; set
                {
                    if (value.text.Length > closeTextLength)
                    {
                        throw new System.Exception($"close text length must be less than {closeTextLength} characters.");
                    }
                    _close = value;
                }
            }

            public PlainText submit
            {
                get => _submit; set
                {
                    if (value.text.Length > submitTextLength)
                    {
                        throw new System.Exception($"submit text length must be less than {submitTextLength} characters.");
                    }
                    _submit = value;
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