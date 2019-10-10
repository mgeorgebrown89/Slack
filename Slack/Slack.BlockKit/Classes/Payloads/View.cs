namespace Slack
{
    namespace Payloads
    {
        public abstract class View
        {
            public string type;
            private readonly string[] viewTypes = { "modal" };

            public View(string type)
            {
                foreach (string t in viewTypes)
                {
                    if (type == t)
                    {
                        this.type = type;
                    }
                }
                if (this.type == null)
                {
                    throw new System.Exception($"{type} is not a supported ViewPayload type.");
                }
            }
        }
    }
}