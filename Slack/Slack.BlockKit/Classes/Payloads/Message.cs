namespace Slack
{
    namespace Payloads
    {
        using Slack.Layout;
        public class Message
        {
            public string text;
            public Block[] blocks;
            public Attachment[] attachments;
            public string thread_ts;
            public string channel;
            public bool mrkdwn;

            public Message(string text)
            {
                this.text = text;
            }
            public Message(Block[] blocks)
            {
                this.blocks = blocks;
            }
            public Message(string text, Block[] blocks) : this(text)
            {
                this.blocks = blocks;
            }
        }
    }
}