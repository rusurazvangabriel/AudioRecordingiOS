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
    self = [super initWithFrame:CGRectMake(270, 3, 35, 35)];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        
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
