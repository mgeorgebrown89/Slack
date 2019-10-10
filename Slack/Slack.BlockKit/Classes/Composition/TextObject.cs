namespace Slack
{
    namespace Composition
    {
        public abstract class TextObject
        {
            public string type;
            public string text;

            public TextObject(string type, string text)
            {
                this.type = type;
                this.text = text;
            }
        }
    }
}