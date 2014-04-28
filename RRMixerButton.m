//
//  RRMixerButton.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 28/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRMixerButton.h"

@implementation RRMixerButton

- (id)initWithFrame:(CGRect)frame andChannelId:(int)channelId
{
    self = [super initWithFrame:frame];
    if (self) {
        self.channelId = channelId;
        [self setBackgroundImage:[UIImage imageNamed:@"mixerBackground.png"] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.3f;

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
