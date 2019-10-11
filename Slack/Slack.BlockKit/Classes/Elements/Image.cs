namespace Slack
{
    namespace Elements
    {
        public class Image : Element
        {
            public string image_url;
            public string alt_text;

            public Image(string image_url, string alt_text) : base("image")
            {
                this.image_url = image_url;
                this.alt_text = alt_text;
            }
        }
    }
}