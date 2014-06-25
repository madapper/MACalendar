MACalendar
==========

A customisable calendar with multiple selection types, animations and more. MACalendar is very easy to implement, with the ability to add the calendar to any view by defining the frame and the initial start date:

<pre>
#import "MACalendarMonth.h"

CGRect frame = CGRectMake(0,0,100,100);
NSDate *date = [NSDate date];

MACalendarMonth *month = [[MACalendarMonth alloc]initWithFrame:frame date:date];
    
[sel.view addSubview:fromMonth];

</pre>

The selection style, colour and animation is also available for change, by using the associated enums.

Future improvement is to allow these to be set as part of the initialization or set after.

