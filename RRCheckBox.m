//
//  RRCheckBox.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRCheckBox.h"



@implementation RRCheckBox

- (id)initWithCoordinates:(CGPoint)point
{
    self = [super initWithFrame:CGRectMake(point.x, point.y, 26,26)];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"uncheckedCheckbox.png"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(checkOrUncheck) forControlEvents:UIControlEventTouchUpInside];
        self.checked = NO;
    }
    return self;
}

- (void)checkOrUncheck
{
        if(!self.checked)
        {
            self.checked = YES;
            [self setBackgroundImage:[UIImage imageNamed:@"checkedCheckbox.png"] forState:UIControlStateNormal];
        }else
        {
            self.checked = NO;
            [self setBackgroundImage:[UIImage imageNamed:@"uncheckedCheckbox.png"] forState:UIControlStateNormal];
        }
}

@end
