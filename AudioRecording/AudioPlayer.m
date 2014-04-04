//
//  AudioPlayer.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "AudioPlayer.h"
#import "AFNetworking.h"

@implementation AudioPlayer


/*---------------------------------------------------
 *   Start playing of given sample using sampleName
 *   and numberOfLoops
 *   if numberOfLoops is 0, sample is played one tim
 *   if numerOfLoops grater than zero (eg: n loops)
 *   it will play the sample n times
 ---------------------------------------------------*/

//-(id) init
//{
//    self = [super init];
//    if(self)
//    {
//        _audioPlayer = [[AVAudioPlayer alloc] init];
//    }
//    return self;
//}

-(void) startPlaying:(NSString *)sampleName numberOfLoops:(NSInteger)loopsNumber volumeLevel:(float)volume
{
    NSLog(@"playRecording");
    
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths[0];
    NSString * samplePath = [NSString stringWithFormat:@"%@/%@",basePath,sampleName];
    NSURL *url = [NSURL fileURLWithPath:samplePath];
    NSError *error;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    _audioPlayer.numberOfLoops = loopsNumber - 1;
    [_audioPlayer setVolume:volume];
    [_audioPlayer play];
    NSLog(@"playing");
}

/*---------------------------------------------------
 *   Stop playing of current audio sample 
 *          that still plays
 ---------------------------------------------------*/

-(void) stopPlaying
{
    NSLog(@"stopPlaying");
    
    [_audioPlayer stop];
    NSLog(@"stopped");
}

/*---------------------------------------------------
 *    Start recording and store resulted audio
 *  file into a temporary file named tempSample
 ---------------------------------------------------*/

-(void) startRecording
{
    NSLog(@"startRecording");
    
    audioRecorder = nil;
    
    /*---------------------------------------------------
     *         Init audio with record capability
     ---------------------------------------------------*/
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    if(recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }
    else
    {
        NSNumber *formatObject;
        
        switch (recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); NSString *basePath = paths[0];
    
    /*---------------------------------------------------
     *    Creating a filename for current recording
     ---------------------------------------------------*/
    
    NSString *sampleName = @"tempSample.caf";
    NSMutableString *samplePath = [[NSMutableString alloc]init];
    [samplePath appendString:@"%@/"];
    [samplePath appendString:sampleName];
    currentRecordingSample = sampleName;
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:samplePath, basePath]];
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if ([audioRecorder prepareToRecord] == YES)
    {
        [audioRecorder record];
    }else
    {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
    
    NSLog(@"recording");
}

/*---------------------------------------------------
 *    Stop recording of your current audio file
 ---------------------------------------------------*/

-(void) stopRecording
{
    NSLog(@"stopRecording");
    
    [audioRecorder stop];
    
    NSLog(@"stopped");
}

/*---------------------------------------------------
 *    Download sample from url with given fileName
 *    eg:
 *      url: http://mysite/sounds/test.mp3
 *      fileName: test.mp3
 ---------------------------------------------------*/

- (void)downloadSample:(NSString *)url
{
    //@"http://app.etajul9.ro/sounds/test2.wav"
    
    NSURL *URL = [NSURL URLWithString:url];
    NSString *fileName = [[URL path] lastPathComponent];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    AFURLConnectionOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setCompletionBlock:^{
        NSLog(@"downloadComplete!");
    }];
    [operation start];
}

@end
