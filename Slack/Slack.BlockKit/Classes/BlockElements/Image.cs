namespace Slack {
    namespace Elements {
        public class Image : Element
        {
            private string _image_url;
            private string _alt_text;

            public Image(string image_url, string alt_text) : base("image")
            {
                this.image_url = image_url;
                this.alt_text = alt_text;
            }
            public string image_url
            {
                get => _image_url; set
                {
                    _image_url = value;
                }
            }
            public string alt_text
            {
                get => _alt_text; set
                {
                    _alt_text = value;
                }
            }
        }
    }
}