//
//  ViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 12/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "ViewController.h"
#import "SampleListViewController.h"

@interface ViewController ()

@property BOOL flag;

@end

//global variable for sample index

static int sampleIndex;


@implementation ViewController

- (void)viewDidLoad
{
    /*
     * Create swipe right gesture so you can navigate
     * to sample preview viewController
     */
    
    UISwipeGestureRecognizer *swipeRightToSamples = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    swipeRightToSamples.numberOfTouchesRequired = 1;
    swipeRightToSamples.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightToSamples];
    
    [super viewDidLoad];
    
    //Hide status bar
    shouldHideStatusBar = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    self.flag = NO;
    
    //set the index of current recording session to 0
    sampleIndex = 0;
    
    UIButton * recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    recordButton.center = self.view.center;
    [recordButton setTitle:@"Record" forState:normal];
    recordButton.layer.cornerRadius = 75;
    recordButton.backgroundColor = [UIColor redColor];
    recordButton.layer.borderColor = [[UIColor blackColor] CGColor];
    recordButton.layer.borderWidth = 10;
    [self.view addSubview:recordButton];
    [recordButton addTarget:self action:@selector(recordButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * playButton = [[UIButton alloc] initWithFrame:CGRectMake(80, 0, 150, 150)];
    [playButton setTitle:@"Play" forState:normal];
    playButton.layer.cornerRadius = 75;
    playButton.backgroundColor = [UIColor greenColor];
    playButton.layer.borderColor = [[UIColor blackColor] CGColor];
    playButton.layer.borderWidth = 10;
    [self.view addSubview:playButton];
    [playButton addTarget:self action:@selector(buttonPlay) forControlEvents:UIControlEventTouchUpInside];

    UIButton * showButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 360, 120, 120)];
    [showButton setTitle:@"Show" forState:normal];
    showButton.layer.cornerRadius = 75;
    showButton.backgroundColor = [UIColor greenColor];
    showButton.layer.borderColor = [[UIColor blackColor] CGColor];
    showButton.layer.borderWidth = 5;
    [self.view addSubview:showButton];
    [showButton addTarget:self action:@selector(displayContent) forControlEvents:UIControlEventTouchUpInside];
}

- (void) swipeRight
{
    NSLog(@"Right swipe");
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setDuration:0.40];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:animation forKey:kCATransition];
    
    SampleListViewController * sampleList = [[SampleListViewController alloc] init];
    [self presentViewController:sampleList animated:YES completion:NULL];
}

- (BOOL)prefersStatusBarHidden {
    return shouldHideStatusBar;
}

- (void) recordButtonPressed:(id)sender
{
    UIButton * button = (UIButton*) sender;
   
    
    if(self.flag == NO)
    {
        [button setTitle:@"Stop" forState:normal];
        [self startRecording];
        self.flag = YES;
    }
    else
    {
        [button setTitle:@"Record" forState:normal];
        [self stopRecording];
        self.flag = NO;
    }
}

-(void) buttonPlay
{
    [self playRecording];
}


-(void) startRecording
{
    NSLog(@"startRecording");
    audioRecorder = nil;
    
    // Init audio with record capability
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
        //[recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); NSString *basePath = paths[0];
    
    /*------------------------Creating a filename for current recording-------------------*/
    
    NSString *sampleName = [NSString stringWithFormat:@"sample%d.caf",sampleIndex];
    NSMutableString *samplePath = [[NSMutableString alloc]init];
    [samplePath appendString:@"%@/"];
    [samplePath appendString:sampleName];
    
    
    /*-----------------------Creating a csv file for holding sample names-----------------*/
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    NSString *sampleNamesFile = [docPath stringByAppendingPathComponent:@"samples.csv"];
    NSString *newLine = @"\n";
    if(![[NSFileManager defaultManager]fileExistsAtPath:sampleNamesFile])
    {
        [[NSFileManager defaultManager] createFileAtPath:sampleNamesFile contents:nil attributes:nil];
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sampleNamesFile];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[sampleName dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle writeData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    
    sampleIndex++;
    /*-----------------------------End writting to the file-------------------------------*/
    
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:samplePath, basePath]];
   // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    
    
    NSError *error = nil;
    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    
    if ([audioRecorder prepareToRecord] == YES){
        [audioRecorder record];
    }else {
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
    NSLog(@"recording");
}

-(void) stopRecording
{
    //UIButton *stopButton = (UIButton *)sender;
    NSLog(@"stopRecording");
    [audioRecorder stop];
    NSLog(@"stopped");
    //stopButton.hidden = YES;
}

-(void) playRecording
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); NSString *basePath = paths[0];
    
    //NSString *indexString = [NSString stringWithFormat:@"%d", sampleIndex];
    
    
    NSMutableString *samplePath = [[NSMutableString alloc]init];
    
    [samplePath appendString:@"%@/sample0"];
    //[samplePath appendFormat:@"%d",sampleIndex];
    [samplePath appendString:@".caf"];

    //sampleIndex++;
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:samplePath, basePath]];
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(void) stopPlaying
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Method retrieves content from documents directory and
//displays it in an alert

-(void) displayContent{
    
    NSLog(@"DisplayContent");
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    NSString *sampleNameFile = [docPath stringByAppendingString:@"/samples.csv"];
    if([[NSFileManager defaultManager] fileExistsAtPath:sampleNameFile])
    {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:sampleNameFile];
        NSString *sampleList = [[NSString alloc] initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alerta" message:sampleList delegate:self cancelButtonTitle:@"Stop" otherButtonTitles:nil];
        [alert show];
    }
}

@end
