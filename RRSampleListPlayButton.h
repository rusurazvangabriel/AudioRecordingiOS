//
//  RRSampleListPlayButton.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 09/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRSampleListPlayButton : UIButton

@property(nonatomic,strong) NSString *sampleName;
@property(nonatomic,strong) NSString *sampleUrl;
@property(nonatomic,strong) NSString *sampleHash;
- (void)stopSample;
@end
