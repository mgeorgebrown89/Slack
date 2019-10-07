namespace Slack
{
    namespace Layout
    {
        public abstract class Block
        {
            public string type;
            private readonly string[] BlockTypes = { "section", "divider", "image", "actions", "context", "input", "file" };
            protected Block(string type)
            {
                foreach (string t in BlockTypes)
                {
                    if (type == t)
                    {
                        this.type = type;
                    }
                }
                if (this.type == null)
                {
                    throw new System.Exception($"{type} is not a supported Block type.");
                }
            }
        }
    }
}