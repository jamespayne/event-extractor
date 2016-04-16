# forward dd/mm

my dateTime =~ /\b(\d{1,2})t?h?\h(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)/gi;

# reverse mm/yy

my date =~ /\b(january|jan|february|feb|march|mar|april|apr|may|june|jun|july|jul|august|aug|september|sept|sep|october|oct|november|nov|december|dec)\.?,?\h?(\d{1,2})t?h?,/gi;
