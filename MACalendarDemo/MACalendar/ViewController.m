//
//  ViewController.m
//  MACalendar
//
//  Created by Paul Napier on 25/06/2014.
//  Copyright (c) 2014 madapper. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
            

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    MACalendarMonth *month = [[MACalendarMonth alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) date:[NSDate date]];
    month.delegate = self;
    month.animationOption = MACalendarDayAnimationOptionDissolve;
    month.selectionType = MACalendarSelectionTypeIndividual;
    [self.view addSubview:month];
}

-(void)calendarMonthDidSelectDays:(NSArray *)days calendar:(MACalendarMonth *)month{
    NSLog(@"%@",days);
}

@end
