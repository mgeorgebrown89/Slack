namespace Slack
{
    namespace Elements
    {
        using Slack.Composition;
        using System.Text.RegularExpressions;
        public class Datepicker : SelectMenu
        {
            private string _initial_date;
            public ConfirmationDialog confirm;

            public Datepicker(string action_id, PlainText placeholder) : base("datepicker", placeholder, action_id)
            {

            }

            public string initial_date
            {
                get => _initial_date; set
                {
                    Regex regex = new Regex(@"([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))");
                    Match match = regex.Match(value);
                    if (match.Success)
                    {
                        _initial_date = value;
                    }
                    else
                    {
                        throw new System.Exception($"Initial date string format must match YYYY-MM-DD");
                    }
                }
            }

        }
    }
}