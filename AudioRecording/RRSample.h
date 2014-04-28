//
//  RRSample.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 07/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface RRSample : UIButton

@property (strong,nonatomic) NSString *sampleName;
@property (nonatomic,assign) NSURL *sampleURL;
@property (nonatomic,assign) int trackId;

@property (nonatomic,assign) BOOL triggered;
@property (assign, nonatomic) UIColor *color;
- (id)initWithSampleName:(NSString *)name andSampleURL:(NSString *)url;
- (id)initWithSampleName:(NSString *)name andSampleURL:(NSString *)url andChannel:(int) ch andX:(float)x;

@end
