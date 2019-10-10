namespace Slack
{
    namespace Composition
    {
        public class PlainText : TextObject
        {
            public bool emoji;

            public PlainText(string text) : base("plain_text", text)
            {
                this.emoji = true;
            }
            public PlainText(string text, bool emoji) : base("plain_text", text)
            {
                this.emoji = emoji;
            }
        }
    }
}