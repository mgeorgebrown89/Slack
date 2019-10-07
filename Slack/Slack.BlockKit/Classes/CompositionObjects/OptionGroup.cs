using System.ComponentModel.DataAnnotations;
namespace Slack
{
    namespace Composition
    {
        public class OptionGroup {
            private const int labelTextLength = 75;
            private PlainText _label;
            private const int optionCount = 100;
            [MaxLengthAttribute(100)]
            private Option[] _options;

            public OptionGroup()
            {
            }

            public OptionGroup(PlainText label, Option[] options)
            {
                this.label = label;
                this.options = options;
            }

            public PlainText label { get => _label; set => _label = value; }
            public Option[] options { get => _options; set => _options = value; }
        }
    }
}