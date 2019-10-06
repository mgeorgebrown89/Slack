namespace Slack
{
    public enum TextType
    {
        plain_text,
        mrkdwn
    }

    public class Text
    {
        public TextType type;
        public string text;

        public Text(TextType type, string text){
            this.type = type;
            this.text = text;
        }
    }
}