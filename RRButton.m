//
//  RRButton.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRButton.h"

@implementation RRButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithRed:0/255.0f green:140/255.0f blue:255/255.0f alpha:1.0f];
        self.layer.cornerRadius = 7.0f;
        self.layer.shadowRadius = 3.0f;
        self.layer.borderWidth = 0.3f;
        self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];//[UIColor colorWithRed:0/255.0f green:67/255.0f blue:253/255.0f alpha:1.0f] CGColor];
        self.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
        self.layer.shadowOpacity = 0.8f;
        self.layer.masksToBounds = NO;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
