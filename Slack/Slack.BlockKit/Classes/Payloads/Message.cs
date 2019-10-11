namespace Slack
{
    namespace Payloads
    {
        using System.Text.RegularExpressions;
        using Slack.Layout;
        public class Message
        {
            public string channel;
            public string text;
            public bool as_user;
            public Attachment[] attachments;
            public Block[] blocks;
            private string _icon_emoji;
            public string icon_url;
            public bool link_names;
            public bool mrkdwn;
            private string _parse;
            private readonly string[] parseOptions = { "none", "full" };
            public bool reply_broadcast;
            public string thread_ts;
            public bool unfurl_links;
            public bool unfurl_media;
            public string username;

            public Message(string text)
            {
                this.text = text;
            }
            public Message(string channel, string text) : this(text)
            {
                this.channel = channel;
            }

            public Message(Block[] blocks)
            {
                this.blocks = blocks;
            }
            public Message(string channel, Block[] blocks) : this(blocks)
            {
                this.channel = channel;
            }

            public string icon_emoji
            {
                get => _icon_emoji; set
                {
                    Regex regex = new Regex(@"^:\w+:$");
                    Match match = regex.Match(value);
                    if (match.Success)
                    {
                        _icon_emoji = value;
                    }
                    else
                    {
                        throw new System.Exception($"The emoji string {value} doesn't match a valid pattern for a Slack Emoji.");
                    }
                }
            }

            public string parse
            {
                get => _parse; set
                {
                    foreach (string o in parseOptions)
                    {
                        if (value == o)
                        {
                            _parse = value;
                        }
                    }
                    if (this.parse == null)
                    {
                        throw new System.Exception($"Parse options are only full or none.");
                    }
                }
            }
        }
    }
}