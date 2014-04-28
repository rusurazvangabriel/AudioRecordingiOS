//
//  RRSampleListPlayButton.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 09/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRSampleListPlayButton.h"
#import "AudioPlayer.h"

AudioPlayer *ap;

@implementation RRSampleListPlayButton

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(5, 10, 30, 30)];
    if (self) {
        [self setTitle:@"P" forState:UIControlStateNormal];
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5.0f;
        [self addTarget:self action:@selector(playSample) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)playSample
{
    ap = [[AudioPlayer alloc] init];
    //[ap downloadSample:self.sampleUrl];
    [ap startPlaying:self.sampleName numberOfLoops:1 volumeLevel:1.0f];
}

- (void)stopSample
{
    ap = [[AudioPlayer alloc] init];
    [ap stopPlaying];
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
