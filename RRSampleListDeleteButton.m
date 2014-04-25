//
//  RRSampleListDeleteButton.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 09/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRSampleListDeleteButton.h"

@implementation RRSampleListDeleteButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(285, 10, 30, 30)];
    if (self) {
        [self setTitle:@"D" forState:UIControlStateNormal];
        
        CAGradientLayer *layer = [CAGradientLayer layer];
        NSArray *colors = [NSArray arrayWithObjects:
                           (id)[UIColor colorWithRed:61/255.0f green:107/255.0f blue:226/255.0f alpha:1.0f].CGColor,
                           (id)[UIColor colorWithRed:61/255.0f green:177/255.0f blue:226/255.0f alpha:1.0f].CGColor,
                           nil];
        [layer setColors:colors];
        [layer setFrame:self.bounds];
        [self.layer insertSublayer:layer atIndex:0];
        self.clipsToBounds = YES; // Important!
        self.layer.cornerRadius = 5.0f;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
