//
//  MACalendarMonth.h
//  MACalendarView
//
//  Created by Paul Napier on 8/04/2014.
//  Copyright (c) 2014 MadApper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MACalendarDay.h"

typedef enum {
    MACalendarSelectionTypeNone,
    MACalendarSelectionTypeIndividual,
    MACalendarSelectionTypeOneAtATime,
    MACalendarSelectionTypeLinear,
}MACalendarSelectionType;

@class MACalendarMonth;

@protocol MACalendarMonthDelegate

-(void)calendarMonthDidSelectDays:(NSArray *)days calendar:(MACalendarMonth *)month;

@end

@protocol MACalendarMonthDatasource



@end

@interface MACalendarMonth : UIView{
    CGRect initialFrame;
    UIView *currentView;
    UIView *startView;
    NSMutableDictionary *dateViews;
    BOOL computing;
    int totalTouches;
    CGPoint startPoint;
    
    MACalendarMonth *nextCalendarMonth;
    MACalendarMonth *prevCalendarMonth;
    
    UIButton *previous;
    UIButton *next;
}

@property (nonatomic, retain) NSDate *initialDate;
@property (nonatomic, retain) NSObject<MACalendarMonthDelegate> *delegate;
@property (nonatomic, retain) NSObject<MACalendarMonthDatasource> *datasource;
@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic) MACalendarSelectionType selectionType;
@property (nonatomic) BOOL enablePreviousDays;
@property (nonatomic) MACalendarDayAnimationOption animationOption;
@property (nonatomic, retain) UIImage *imageHighlighted;
@property (nonatomic, retain) UIImage *imageNormal;
@property (nonatomic, retain) UIImage *imageSelected;
@property (nonatomic, retain) UIImage *imageDisabled;

- (id)initWithFrame:(CGRect)frame date:(NSDate *)date;

@end
