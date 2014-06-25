//
//  MACaledarDay.m
//  MACalendarView
//
//  Created by Paul Napier on 8/04/2014.
//  Copyright (c) 2014 MadApper. All rights reserved.
//

#import "MACalendarDay.h"

@implementation MACalendarDay

- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.animationOption = MACalendarDayAnimationOptionFlipVerticalBT;
        
        self.imageHighlighted = [self backgroundWithColor:[UIColor colorWithRed:234.0/255.0 green:160.0/255.0 blue:28.0/255.0 alpha:1.000]withTrim:NULL frame:self.bounds rounded:false];
        self.imageNormal = [self backgroundWithColor:[UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0]withTrim:NULL frame:self.bounds rounded:false];
        self.imageSelected = [self backgroundWithColor:[UIColor colorWithRed:67.0/255.0 green:138.0/255.0 blue:62.0/255.0 alpha:1.000]withTrim:NULL frame:self.bounds rounded:false];
        self.imageDisabled = [self backgroundWithColor:[UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:0.5]withTrim:NULL frame:self.bounds rounded:false];
        
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.image = [self backgroundWithColor:[UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.000] withTrim:NULL frame:self.bounds rounded:false];
        [self addSubview:self.imageView];

        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/5*4)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        icons = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/5*4, frame.size.width, frame.size.height/5)];
        [self addSubview:icons];
        
    }
    return self;
}

-(UIImage *)backgroundWithColor:(UIColor *)backgroundColor withTrim:(UIColor *)trimColor frame:(CGRect)frame rounded:(BOOL)rounded{
    
    if (frame.size.width==0) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, 1, frame.size.height);
    }
    
    if (frame.size.height==0) {
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1);
    }
    
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = [backgroundColor CGColor];
    if (trimColor) {
        layer.borderColor = [trimColor CGColor];
        layer.borderWidth = 1;
    }
    
    if (rounded) layer.cornerRadius = MIN(frame.size.width,frame.size.height)/2;
    
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

-(void)setDate:(NSDate *)date{
    self->_date = date;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *weekdayComponents =[gregorian components:NSDayCalendarUnit fromDate:date];
    
    NSInteger day = [weekdayComponents day];
    
    label.text = [NSString stringWithFormat:@"%d",day];
    
    
}

-(void)setSelected:(BOOL)selected{
    if (!self.isDisabled) {
        self->_selected = selected;
        if (selected) {
            self.imageView.image = self.imageSelected;
        }else{
            
            self.imageView.image = self.imageNormal;
        }
    }
    
}

-(void)setHighlighted:(BOOL)highlighted{
    if (!self.isDisabled) {
    self->_highlighted = highlighted;
    if (highlighted) {
        
        [UIView transitionWithView:self.imageView duration:0.35 options:enter animations:^{
            self.imageView.image = self.imageHighlighted;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [UIView transitionWithView:self.imageView duration:0.35 options:exit animations:^{
            self.imageView.image = self.imageNormal;
        } completion:^(BOOL finished) {
            
        }];
    }
    }
    
}
-(void)setDisabled:(BOOL)disabled{
    self->_disabled = disabled;
    if (disabled) {
        self.imageView.image = self.imageDisabled;
        self.userInteractionEnabled = false;
    }else{
        
        self.imageView.image = self.imageNormal;
        self.userInteractionEnabled = true;
    }
}

-(void)setAnimationOption:(MACalendarDayAnimationOption)animationOption{
    self->_animationOption = animationOption;
    
    switch (self.animationOption) {
        case MACalendarDayAnimationOptionNone:
        {
            enter = UIViewAnimationOptionTransitionNone;
            exit = UIViewAnimationOptionTransitionNone;
        }
            break;
        case MACalendarDayAnimationOptionFlipHorizontalLR:
        {
            enter = UIViewAnimationOptionTransitionFlipFromLeft;
            exit = UIViewAnimationOptionTransitionFlipFromRight;
        }
            break;
        case MACalendarDayAnimationOptionFlipHorizontalRL:
        {
            enter = UIViewAnimationOptionTransitionFlipFromRight;
            exit = UIViewAnimationOptionTransitionFlipFromLeft;
        }
            break;
        case MACalendarDayAnimationOptionFlipVerticalTB:
        {
            enter = UIViewAnimationOptionTransitionFlipFromTop;
            exit = UIViewAnimationOptionTransitionFlipFromBottom;
        }
            break;
        case MACalendarDayAnimationOptionFlipVerticalBT:
        {
            enter = UIViewAnimationOptionTransitionFlipFromBottom;
            exit = UIViewAnimationOptionTransitionFlipFromTop;
        }
            break;
            
        case MACalendarDayAnimationOptionDissolve:
        {
            enter = UIViewAnimationOptionTransitionCrossDissolve;
            exit = UIViewAnimationOptionTransitionCrossDissolve;
        }
            break;
            
        default:{
            enter = UIViewAnimationOptionTransitionNone;
            exit = UIViewAnimationOptionTransitionNone;
        }
            break;
    }
}


@end
