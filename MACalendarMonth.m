//
//  MACalendarMonth.m
//  MACalendarView
//
//  Created by Paul Napier on 8/04/2014.
//  Copyright (c) 2014 MadApper. All rights reserved.
//

#import "MACalendarMonth.h"

@implementation MACalendarMonth

- (void)resetWithDate:(NSDate *)date frame:(CGRect)frame
{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    self.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:60.0/255.0 blue:48.0/255.0 alpha:1.0];
    
    self.clipsToBounds = true;
    self.layer.cornerRadius = self.frame.size.width*.05;
    
    UILabel *monthName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
    monthName.textAlignment = NSTextAlignmentCenter;
    monthName.textColor = [UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.000];
    [self addSubview:monthName];
    
    next = [UIButton buttonWithType:UIButtonTypeCustom];
    next.frame = CGRectMake(monthName.frame.size.width-25, 0, 20, 20);
    [next setTitle:@">>" forState:UIControlStateNormal];
    [next.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [next setTitleColor:monthName.textColor forState:UIControlStateNormal];
    [next addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:next];
    
    previous = [UIButton buttonWithType:UIButtonTypeCustom];
    previous.frame = CGRectMake(5, 0, 20, 20);
    [previous setTitle:@"<<" forState:UIControlStateNormal];
    [previous setTitleColor:monthName.textColor forState:UIControlStateNormal];
    [previous addTarget:self action:@selector(previous:) forControlEvents:UIControlEventTouchUpInside];
    [previous.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [self addSubview:previous];
    
    self.dates = [NSMutableArray new];
    dateViews = [NSMutableDictionary new];
    
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:date];
    
    NSDateComponents *comp1 =[c components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    
    NSInteger day = [comp1 day];
    NSInteger month = [comp1 month];
    NSInteger year = [comp1 year];
    
    int myDay = day;
    
    switch (month) {
        case 1:monthName.text=[NSString stringWithFormat:@"Jan %d",year];break;
        case 2:monthName.text=[NSString stringWithFormat:@"Feb %d",year];break;
        case 3:monthName.text=[NSString stringWithFormat:@"Mar %d",year];break;
        case 4:monthName.text=[NSString stringWithFormat:@"Apr %d",year];break;
        case 5:monthName.text=[NSString stringWithFormat:@"May %d",year];break;
        case 6:monthName.text=[NSString stringWithFormat:@"Jun %d",year];break;
        case 7:monthName.text=[NSString stringWithFormat:@"Jul %d",year];break;
        case 8:monthName.text=[NSString stringWithFormat:@"Aug %d",year];break;
        case 9:monthName.text=[NSString stringWithFormat:@"Sep %d",year];break;
        case 10:monthName.text=[NSString stringWithFormat:@"Oct %d",year];break;
        case 11:monthName.text=[NSString stringWithFormat:@"Nov %d",year];break;
        case 12:monthName.text=[NSString stringWithFormat:@"Dec %d",year];break;
        default:
            break;
    }
    
    int weeks = 1;
    
    
    
    for (int a = 0; a<days.length; a++) {
        
        NSDateComponents *comp = [NSDateComponents new];
        [comp setDay:a+1];
        [comp setMonth:month];
        [comp setYear:year];
        
        NSDate *newDate = [c dateFromComponents:comp];
        
        NSDateComponents *comp2 =[c components:NSWeekdayCalendarUnit fromDate:newDate];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        
        newDate = [newDate dateByAddingTimeInterval:timeZone.secondsFromGMT+60*60];
        if (a==0) {
            self.initialDate = newDate;
        }
        
        NSUInteger weekday = [comp2 weekday];
        
        if (weekday==1&a<=days.length-1) {
            weeks++;
        }
    }
    
    
    float width = frame.size.width/7;
    float height = (frame.size.height-monthName.frame.size.height)/weeks;
    
    int week = 0;
    
    for (int a = 0; a<days.length; a++) {
        
        NSDateComponents *comp = [NSDateComponents new];
        [comp setDay:a+1];
        [comp setMonth:month];
        [comp setYear:year];
        
        NSDate *newDate = [c dateFromComponents:comp];
        
        NSDateComponents *comp2 =[c components:NSWeekdayCalendarUnit fromDate:newDate];
        
        NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
        
        newDate = [newDate dateByAddingTimeInterval:timeZone.secondsFromGMT+60*60];
        NSUInteger weekday = [comp2 weekday];
        
        if (weekday==1) {
            weekday = 6;
        }else{
            weekday = weekday-2;
        }
        
        MACalendarDay *calDay = [[MACalendarDay alloc]initWithFrame:CGRectMake(width*weekday, monthName.frame.size.height+week*height, width, height)];
        calDay.date = newDate;
        [dateViews setObject:calDay forKey:@(a+1)];
        
        if (a==myDay-1) {
            [self.dates addObject:calDay];
        }
        if (!self.enablePreviousDays) {
            if (a+1<day) {
                calDay.disabled = true;
            }
        }
        
        [self addSubview:calDay];
        
        if (weekday==6) {
            week++;
        }
    }
    [self setSelected];
}

-(IBAction)next:(id)sender{
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *nextComp = [NSDateComponents new];
    [nextComp setMonth:1];
    
    NSDate *nextDate = [c dateByAddingComponents:nextComp toDate:self.initialDate options:0];
    
    [self resetWithDate:nextDate frame:self.frame];
}

-(IBAction)previous:(id)sender{
    NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *prevComp = [NSDateComponents new];
    [prevComp setMonth:-1];
    
    NSDate *prevDate = [c dateByAddingComponents:prevComp toDate:self.initialDate options:0];
    
    [self resetWithDate:prevDate frame:self.frame];
}

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        initialFrame = frame;
        self.selectionType = MACalendarSelectionTypeOneAtATime;
        self.enablePreviousDays = true;
        [self resetWithDate:date frame:frame];
        
    }
    return self;
}

-(void)setHighlighted{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[MACalendarDay class]]) {
            if ([self.dates containsObject:v]) {
                if (!((MACalendarDay *)v).highlighted)((MACalendarDay *)v).highlighted = true;
                if (((MACalendarDay *)v).selected&&self.selectionType==MACalendarSelectionTypeLinear)((MACalendarDay *)v).selected = false;
            }else{
                if (((MACalendarDay *)v).highlighted) ((MACalendarDay *)v).highlighted = false;
                if (((MACalendarDay *)v).selected&&self.selectionType==MACalendarSelectionTypeLinear)((MACalendarDay *)v).selected = false;
            }
        }
    }
}

-(void)setSelected{
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[MACalendarDay class]]) {
            if ([self.dates containsObject:v]) {
                if (!((MACalendarDay *)v).selected)((MACalendarDay *)v).selected = true;
            }else{
                if (((MACalendarDay *)v).selected)((MACalendarDay *)v).selected = false;
            }
        }
    }
}


-(void)setRemoveStatus{
    self.dates = [NSMutableArray new];
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[MACalendarDay class]]) {
            if (((MACalendarDay *)v).selected)((MACalendarDay *)v).selected = false;
            if (((MACalendarDay *)v).highlighted)((MACalendarDay *)v).highlighted = false;
        }
    }
    [self setHighlighted];
    [self setSelected];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    totalTouches +=[touches count];
    if (totalTouches==1) {
        
        if(self.selectionType==MACalendarSelectionTypeLinear)[self setRemoveStatus];
        for (UIView *v in self.subviews) {
            CGPoint point = [[touches anyObject]locationInView:v];
            if ([v hitTest:point withEvent:event]) {
                if ([v isKindOfClass:[MACalendarDay class]]) {
                    if (self.selectionType==MACalendarSelectionTypeIndividual) {
                        if ([self.dates containsObject:v]) {
                            [self.dates removeObject:v];
                            if (((MACalendarDay *)v).selected)((MACalendarDay *)v).selected = false;
                        }else{
                            if ([v isKindOfClass:[MACalendarDay class]]) {
                                [self.dates addObject:v];
                            }
                        }
                    }else if (self.selectionType==MACalendarSelectionTypeLinear){
                        [self.dates addObject:v];
                    }else if (self.selectionType==MACalendarSelectionTypeOneAtATime){
                        if (self.dates) {
                            [self.dates removeAllObjects];
                        }else{
                            self.dates = [NSMutableArray new];
                        }
                        if ([v isKindOfClass:[MACalendarDay class]]) {
                            [self.dates addObject:v];
                        }
                        
                        
                    }else if (self.selectionType==MACalendarSelectionTypeNone){
                        if ([self.dates containsObject:v]) {
                            [self.dates removeObject:v];
                            if (((MACalendarDay *)v).selected)((MACalendarDay *)v).selected = false;
                        }else{
                            if ([v isKindOfClass:[MACalendarDay class]]) {
                                [self.dates addObject:v];
                            }
                        }
                    }
                    if ([v isKindOfClass:[MACalendarDay class]]) {
                        startView = currentView = v;
                    }
                    
                }
            }
        }
        [self setHighlighted];
    }else if (totalTouches==2){
        startPoint = [[touches anyObject]locationInView:self];
        
        if ([self hitTest:startPoint withEvent:event]) {
            
            
            NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSDateComponents *prevComp = [NSDateComponents new];
            [prevComp setMonth:-1];
            
            NSDateComponents *nextComp = [NSDateComponents new];
            [nextComp setMonth:1];
            
            NSDate *nextDate = [c dateByAddingComponents:nextComp toDate:self.initialDate options:0];
            
            NSDate *prevDate = [c dateByAddingComponents:prevComp toDate:self.initialDate options:0];
            
            nextCalendarMonth = [[MACalendarMonth alloc]initWithFrame:CGRectMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height) date:nextDate];
            [self.superview addSubview:nextCalendarMonth];
            
            prevCalendarMonth = [[MACalendarMonth alloc]initWithFrame:CGRectMake(self.frame.origin.x-self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height) date:prevDate];
            [self.superview addSubview:prevCalendarMonth];
            
        }
        
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if (totalTouches==1) {
        
        if (!computing) {
            computing=true;
            for (UIView *v in self.subviews) {
                if (currentView == v) {
                    
                }else{
                    
                    CGPoint point = [[touches anyObject]locationInView:v];
                    if ([v hitTest:point withEvent:event]) {
                        currentView = v;
                        if ([v isKindOfClass:[MACalendarDay class]]) {
                            if (self.selectionType==MACalendarSelectionTypeIndividual) {
                                if (![self.dates containsObject:v]) {
                                    [self.dates addObject:v];
                                }else{
                                    [self.dates removeObject:v];
                                }
                            }else if (self.selectionType==MACalendarSelectionTypeLinear){
                                NSDate *startDate = ((MACalendarDay *)startView).date;
                                
                                NSDate *currentDate = ((MACalendarDay *)v).date;
                                
                                NSCalendar *c = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                                
                                NSDateComponents *components = [c components:NSDayCalendarUnit
                                                                    fromDate:startDate
                                                                      toDate:currentDate
                                                                     options:0];
                                
                                NSDateComponents *comp2 = [c components:NSDayCalendarUnit fromDate:startDate];
                                NSUInteger startDay = [comp2 day];
                                NSInteger days = [components day];
                                self.dates = [NSMutableArray new];
                                int stage = (days==0)?0:(int)days/abs((int)days);
                                for (int a = 0; a<ABS(days)+1; a++) {
                                    UIView *v2 = dateViews[@(startDay+stage*a)];
                                    [self.dates addObject:v2];
                                    
                                }
                            }
                        }
                    }
                }
            }
            [self setHighlighted];
            computing=false;
        }
    }else if (totalTouches==2){
        
        CGPoint currentPoint = [[touches anyObject]locationInView:self];
        //        if (currentPoint.x>startPoint.x) {
        self.center = CGPointMake(self.center.x+(currentPoint.x-startPoint.x), self.center.y);
        prevCalendarMonth.center = CGPointMake(prevCalendarMonth.center.x+(currentPoint.x-startPoint.x), self.center.y);
        nextCalendarMonth.center = CGPointMake(nextCalendarMonth.center.x+(currentPoint.x-startPoint.x), self.center.y);
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    if (totalTouches==2) {
        if (self.center.x<[self superview].frame.size.width/3) {
            [UIView animateWithDuration:0.35 animations:^{
                self.center = CGPointMake(-[self superview].frame.size.width/2, self.center.y);
                nextCalendarMonth.center = CGPointMake([self superview].frame.size.width/2, self.center.y);
            } completion:^(BOOL finished) {
                self.center = CGPointMake(initialFrame.origin.x+initialFrame.size.width/2, initialFrame.origin.y+initialFrame.size.height/2);
                [self resetWithDate:nextCalendarMonth.initialDate frame:initialFrame];
                [nextCalendarMonth removeFromSuperview];
                [prevCalendarMonth removeFromSuperview];
            }];
        }else if (self.center.x>[self superview].frame.size.width/3*2){
            [UIView animateWithDuration:0.35 animations:^{
                self.center = CGPointMake([self superview].frame.size.width/2+[self superview].frame.size.width, self.center.y);
                prevCalendarMonth.center = CGPointMake([self superview].frame.size.width/2, self.center.y);
            } completion:^(BOOL finished) {
                self.center = CGPointMake(initialFrame.origin.x+initialFrame.size.width/2, initialFrame.origin.y+initialFrame.size.height/2);
                [self resetWithDate:prevCalendarMonth.initialDate frame:initialFrame];
                [nextCalendarMonth removeFromSuperview];
                [prevCalendarMonth removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.35 animations:^{
                self.center = CGPointMake([self superview].frame.size.width/2, self.center.y);
                prevCalendarMonth.center = CGPointMake(-[self superview].frame.size.width/2, self.center.y);
                nextCalendarMonth.center = CGPointMake([self superview].frame.size.width/2+[self superview].frame.size.width, self.center.y);
            } completion:^(BOOL finished) {
                [nextCalendarMonth removeFromSuperview];
                [prevCalendarMonth removeFromSuperview];
            }];
        }
    }
    totalTouches = 0;
    self.dates = [NSMutableArray new];
    [self setSelected];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (totalTouches==2) {
        if (self.center.x<[self superview].frame.size.width/3) {
            [UIView animateWithDuration:0.35 animations:^{
                self.center = CGPointMake(-[self superview].frame.size.width/2, self.center.y);
                nextCalendarMonth.center = CGPointMake([self superview].frame.size.width/2, self.center.y);
            } completion:^(BOOL finished) {
                self.center = CGPointMake(initialFrame.origin.x+initialFrame.size.width/2, initialFrame.origin.y+initialFrame.size.height/2);
                [self resetWithDate:nextCalendarMonth.initialDate frame:nextCalendarMonth.frame];
                
                [nextCalendarMonth removeFromSuperview];
                [prevCalendarMonth removeFromSuperview];
            }];
        }else if (self.center.x>[self superview].frame.size.width/3*2){
            [UIView animateWithDuration:0.35 animations:^{
                self.center = CGPointMake([self superview].frame.size.width/2+[self superview].frame.size.width, self.center.y);
                prevCalendarMonth.center = CGPointMake([self superview].frame.size.width/2, self.center.y);
            } completion:^(BOOL finished) {
                self.center = CGPointMake(initialFrame.origin.x+initialFrame.size.width/2, initialFrame.origin.y+initialFrame.size.height/2);
                [self resetWithDate:prevCalendarMonth.initialDate frame:prevCalendarMonth.frame];
                [nextCalendarMonth removeFromSuperview];
                [prevCalendarMonth removeFromSuperview];
            }];
        }else{
            [UIView animateWithDuration:0.35 animations:^{
                self.center = CGPointMake([self superview].frame.size.width/2, self.center.y);
                prevCalendarMonth.center = CGPointMake(-[self superview].frame.size.width/2, self.center.y);
                nextCalendarMonth.center = CGPointMake([self superview].frame.size.width/2+[self superview].frame.size.width, self.center.y);
            } completion:^(BOOL finished) {
                [nextCalendarMonth removeFromSuperview];
                [prevCalendarMonth removeFromSuperview];
            }];
        }
    }else if (totalTouches==1){
        
        //        for (MACalendarDay *day in self.subviews) {
        //            if ([day isKindOfClass:[MACalendarDay class]]) {
        //                NSLog(@"%@",day.date);
        //            }
        //
        //        }
        
        if ([self.delegate respondsToSelector:@selector(calendarMonthDidSelectDays:calendar:)]) {
            [self.delegate calendarMonthDidSelectDays:self.dates calendar:self];
        }
    }
    totalTouches = 0;
    [self setSelected];
}

@end
