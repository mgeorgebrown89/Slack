namespace Slack
{
    namespace Layout
    {
        using Slack.Composition;
        using Slack.Elements;
        public class Input : Block
        {
            private TextObject _label;
            private const int labelTextLength = 2000;
            private object _element;
            private PlainText _hint;
            private const int hintTextLength = 2000;
            public bool optional;

            public Input(TextObject label, object element) : base("input")
            {
                this.label = label;
                this.element = element;
            }

            public TextObject label
            {
                get => _label; set
                {
                    if (value.text.Length > labelTextLength)
                    {
                        throw new System.Exception($"Label Text length must be less than {labelTextLength} characters.");
                    }
                    _label = value;
                }
            }
            public object element
            {
                get => _element; set
                {
                    if ((value is Slack.Composition.PlainText) || (value is Slack.Elements.SelectMenu) || (value is Slack.Elements.Datepicker))
                    {
                        _element = value;
                    }
                    else
                    {
                        throw new System.Exception($"Input element must be either a PlainText object, SelectMenu, or Datepicker.");
                    }
                }
            }
            public PlainText hint
            {
                get => _hint; set
                {
                    if (hint.text.Length > hintTextLength)
                    {
                        throw new System.Exception($"hint Text length must be less than {hintTextLength} characters.");
                    }
                    _hint = value;
                }
            }
        }
    }
}