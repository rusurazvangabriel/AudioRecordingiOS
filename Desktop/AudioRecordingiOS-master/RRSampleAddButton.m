//
//  RRSampleAddButton.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 24/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRSampleAddButton.h"

@implementation RRSampleAddButton

- (id)initWithFrame:(CGRect)frame andSampleName:(NSString *)sampleName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.sampleName = sampleName;
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
