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

MACalendar also has the ability to change the look and feel of the days, by applying the images for Selected, Highlighted, Normal and Disabled simply by changing these options in the MACalendarMonth Class. MACalendarDay has a useful function for creating an image with a border radius and rounded edges if required:

<pre>

month.imageHighlighted = [self backgroundWithColor:[UIColor colorWithRed:234.0/255.0 green:160.0/255.0 blue:28.0/255.0 alpha:1.000]withTrim:NULL frame:self.bounds rounded:false];
month.imageNormal = [self backgroundWithColor:[UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0]withTrim:NULL frame:self.bounds rounded:false];
month.imageSelected = [self backgroundWithColor:[UIColor colorWithRed:67.0/255.0 green:138.0/255.0 blue:62.0/255.0 alpha:1.000]withTrim:NULL frame:self.bounds rounded:false];
month.imageDisabled = [self backgroundWithColor:[UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:0.5]withTrim:NULL frame:self.bounds rounded:false];
</pre>

You can also change the animation option and selection styles using the associated enum:

<b>Animation Options</b>

<pre>
MACalendarDayAnimationOptionNone // No animation
MACalendarDayAnimationOptionFlipHorizontalLR // Flips horizontally from left to right
MACalendarDayAnimationOptionFlipHorizontalRL // Flips horizontally from right to left
MACalendarDayAnimationOptionFlipVerticalTB // Flips vertically from top to bottom
MACalendarDayAnimationOptionFlipVerticalBT // Flips vertically from bottom to top
MACalendarDayAnimationOptionDissolve // Fades old image out and new image in
</pre>

<b>Selection Types</b>

<pre>
MACalendarSelectionTypeNone // Allows selecting and deselecting multiple dates one at a time
MACalendarSelectionTypeIndividual // Allows selecting and deselecting multiple dates by dragging around with one finger on the calendar
MACalendarSelectionTypeOneAtATime // Allows selecting only one date at a tme
MACalendarSelectionTypeLinear // Allows selecting dates in a linear fashion fro the originating date by draggin with one finger on the calendar
</pre>

MACalendar also has a delegate option which can be implemented using the MACalendarMonthDelegate

This only has one method:
<pre>
-(void)calendarMonthDidSelectDays:(NSArray *)days calendar:(MACalendarMonth *)month;
</pre>
