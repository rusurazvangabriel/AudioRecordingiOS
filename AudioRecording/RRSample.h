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

@property (nonatomic,assign) BOOL triggered;

- (id)initWithSampleName:(NSString *)name;

@end