namespace Slack
{
    namespace Composition
    {
        public class OptionGroup
        {
            private const int labelTextLength = 75;
            private PlainText _label;
            private const int optionCount = 100;
            private Option[] _options;

            public OptionGroup(PlainText label, Option[] options)
            {
                this.label = label;
                this.options = options;
            }

            public PlainText label
            {
                get => _label; set
                {
                    if (value.text.Length > labelTextLength)
                    {
                        throw new System.Exception($"Option text must be less than {labelTextLength} characters.");
                    }
                    _label = value;
                }
            }
            public Option[] options
            {
                get => _options; set
                {
                    if(value.Length > optionCount)
                    {
                        throw new System.Exception ($"Only {optionCount} options can be in an option group.");
                    }
                    _options = value;
                }
            }
        }
    }
}