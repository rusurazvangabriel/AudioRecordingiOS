//
//  RecordingViewController.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 26/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface RecordingViewController : UIViewController <UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    BOOL shouldHideStatusBar;
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    int recordEncoding;
    NSString *currentRecordingSample;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
}

-(IBAction) startRecording;
-(IBAction) stopRecording;
-(IBAction) playRecording;
-(IBAction) stopPlaying;
-(void) playRecording:(NSString *)sampleName;

@end
