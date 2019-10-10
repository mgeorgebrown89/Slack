namespace Slack
{
    namespace Elements
    {
        public abstract class Element
        {
            public string type;
            private readonly string[] ElementTypes = {
                "image",
                "button",
                "static_select",
                "external_select",
                "users_select",
                "conversations_select",
                "channels_select",
                "multi_static_select",
                "multi_external_select",
                "multi_users_select",
                "multi_conversations_select",
                "multi_channels_select",
                "overflow",
                "datepicker",
                "plain_text_input"
                };
            protected Element(string type)
            {
                foreach (string t in ElementTypes)
                {
                    if (type == t)
                    {
                        this.type = type;
                    }
                }
                if (this.type == null)
                {
                    throw new System.Exception($"{type} is not a supported Element type.");
                }
            }
        }
    }
}