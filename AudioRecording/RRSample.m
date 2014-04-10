//
//  RRSample.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 07/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRSample.h"

@implementation RRSample

- (id)initWithSampleName:(NSString *)name
{
    self = [super initWithFrame:CGRectMake(100, 100, [self getSampleLengthForSamplename:name] * 10 - 1, 40)];
    if (self) {
        self.triggered = NO;
        self.sampleName = name;
        [self setTitle:name forState:UIControlStateNormal];
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        self.backgroundColor = color;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.4f;
    }
    return self;
}


-(float)getSampleLengthForSamplename:(NSString*)sampleName
{
    NSLog(@"playRecording %@",sampleName);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths[0];
    NSString * samplePath = [NSString stringWithFormat:@"%@/%@",basePath,sampleName];
    NSURL *url = [NSURL fileURLWithPath:samplePath];
    
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
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
