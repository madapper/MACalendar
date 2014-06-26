//
//  MACaledarDay.h
//  MACalendarView
//
//  Created by Paul Napier on 8/04/2014.
//  Copyright (c) 2014 MadApper. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MACalendarDayAnimationOptionNone,
    MACalendarDayAnimationOptionFlipHorizontalLR,
    MACalendarDayAnimationOptionFlipHorizontalRL,
    MACalendarDayAnimationOptionFlipVerticalTB,
    MACalendarDayAnimationOptionFlipVerticalBT,
    MACalendarDayAnimationOptionDissolve,
}MACalendarDayAnimationOption;

@interface MACalendarDay : UIView{
    UIView *icons;
    UILabel *label;
    UIViewAnimationOptions enter;
    UIViewAnimationOptions exit;
}

@property (nonatomic, retain) UIImage *imageSelected;
@property (nonatomic, retain) UIImage *imageNormal;
@property (nonatomic, retain) UIImage *imageHighlighted;
@property (nonatomic, retain) UIImage *imageDisabled;
@property (nonatomic) NSDate *date;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic, getter = isHighlighted) BOOL highlighted;
@property (nonatomic, getter = isDisabled) BOOL disabled;
@property (nonatomic, retain) NSArray *colours;
@property (nonatomic) MACalendarDayAnimationOption animationOption;

-(UIImage *)backgroundWithColor:(UIColor *)backgroundColor withTrim:(UIColor *)trimColor frame:(CGRect)frame rounded:(BOOL)rounded;
- (id)initWithFrame:(CGRect)frame animationOption:(MACalendarDayAnimationOption)animationOption;


@end
