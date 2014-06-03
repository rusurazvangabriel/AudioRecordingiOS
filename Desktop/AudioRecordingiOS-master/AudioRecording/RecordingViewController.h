//
//  RecordingViewController.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 26/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RRTextField.h"
#import <objc/message.h>

@interface RecordingViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    BOOL shouldHideStatusBar;
    NSString *currentRecordingSample;
}

@property(strong,nonatomic) AVAudioPlayer *audioPlayer;
- (void)uploadSample;//:(NSString *)sampleName;

@end
