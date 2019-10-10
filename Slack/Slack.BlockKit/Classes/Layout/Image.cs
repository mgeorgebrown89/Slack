namespace Slack
{
    namespace Layout
    {
        using Slack.Composition;
        public class Image : Block
        {
            private string _image_url;
            private const int image_urlLength = 3000;
            private string _alt_text;
            private const int alt_textLength = 2000;
            private TextObject _title;
            private const int titleTextLength = 2000;
            private string _block_id;
            private const int block_idLength = 255;

            public Image(string image_url, string alt_text) : base("image")
            {
                this.image_url = image_url;
                this.alt_text = alt_text;
            }
            public string image_url
            {
                get => _image_url; set
                {
                    if (value.Length > image_urlLength)
                    {
                        throw new System.Exception($"image_url length must be less than {image_urlLength} characters.");
                    }
                    _image_url = value;
                }
            }
            public string alt_text
            {
                get => _alt_text; set
                {
                    if (value.Length > alt_textLength)
                    {
                        throw new System.Exception($"alt_text length must be less than {alt_textLength} characters.");
                    }
                    _alt_text = value;
                }
            }
            public TextObject title
            {
                get => _title; set
                {
                    if (value.text.Length > titleTextLength)
                    {
                        throw new System.Exception($"title Text length must be less than {titleTextLength} characters.");
                    }
                    _title = value;
                }
            }

            public string block_id
            {
                get => _block_id; set
                {
                    if (value.Length > block_idLength)
                    {
                        throw new System.Exception($"block_id length must be less than {block_idLength} characters.");
                    }
                    _block_id = value;
                }
            }
        }
    }
}