namespace Slack
{
    namespace Layout
    {
        public class Attachment
        {
            public Block[] blocks;
            public string color;

            public Attachment(Block[] blocks)
            {
                this.blocks = blocks;
            }
            public Attachment(Block[] blocks, string color) : this(blocks)
            {
                this.color = color;
            }
        }
    }
}