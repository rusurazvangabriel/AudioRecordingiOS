//
//  AudioPlayer.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioPlayer : NSObject
{
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

@property(strong,nonatomic) AVAudioPlayer *audioPlayer;

-(float)getSampleLengthForSamplename:(NSString*)sampleName;

-(void) startPlaying:(NSString *)sampleName numberOfLoops:(NSInteger)loopsNumber volumeLevel:(float)volume;
-(void) stopPlaying;

-(void) stopRecording;
-(void) startRecording;

- (void)downloadSample:(NSString *)url;
@end
