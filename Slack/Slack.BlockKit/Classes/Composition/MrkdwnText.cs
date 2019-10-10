namespace Slack
{
    namespace Composition
    {
        public class MrkdwnText : TextObject
        {
            public bool verbatim = false;

            public MrkdwnText(string text) : base("mrkdwn", text) { }
            public MrkdwnText(string text, bool verbatim) : base("mrkdwn", text)
            {
                this.verbatim = verbatim;
            }
        }
    }
}