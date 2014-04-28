//
//  RRMixerButton.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 28/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRMixerButton : UIButton

@property (assign,nonatomic) int channelId;
- (id)initWithFrame:(CGRect)frame andChannelId:(int)channelId;

@end
