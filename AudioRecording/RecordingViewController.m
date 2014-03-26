//
//  RecordingViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 26/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RecordingViewController.h"
#import "SampleListViewController.h"

@interface RecordingViewController ()

@property BOOL flag;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *restartRecording;
@property (strong, nonatomic) IBOutlet UITextField *fileNameTextField;
@end

//global variable for sample index
static int sampleIndex;


@implementation RecordingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
    
    self.fileNameTextField.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.jpg"]];
    
    //Hide status bar
    shouldHideStatusBar = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    self.flag = NO;
    
    //set the index of current recording session to 0
    sampleIndex = 0;
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _recordButton.center = self.view.center;
    [_recordButton setTitle:@"Record" forState:normal];
    [_recordButton setImage:[UIImage imageNamed:@"RecordNormalImage.png"] forState:UIControlStateNormal];
    [_recordButton setImage:[UIImage imageNamed:@"RecordPressedImage.png"] forState:UIControlStateSelected];
    [self.view addSubview:_recordButton];
    [_recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _recordButton.hidden = NO;
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _playButton.center = self.view.center;
    [_playButton setTitle:@"Play" forState:normal];
    [_playButton setImage:[UIImage imageNamed:@"Play-Disabled-icon.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"Play-Pressed-icon.png"] forState:UIControlStateSelected];
    [self.view addSubview:_playButton];
    [_playButton addTarget:self action:@selector(buttonPlay) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = YES;
    
    _fileNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 40)];
    _fileNameTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_fileNameTextField];
    _fileNameTextField.hidden = YES;
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 60, 120, 50)];
    [_saveButton setTitle:@"Save" forState:normal];
    [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _saveButton.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_saveButton];
    [_saveButton addTarget:self action:@selector(saveSample) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.hidden = YES;
    
    _restartRecording = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 140, self.view.frame.size.height - 60, 120, 50)];
    [_restartRecording setTitle:@"Rec_A" forState:normal];
    [_restartRecording setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _restartRecording.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_restartRecording];
    [_restartRecording addTarget:self action:@selector(recordAgainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _restartRecording.hidden = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void) recordAgainButtonPressed
{
    _recordButton.hidden = NO;
    _playButton.hidden = YES;
    _saveButton.hidden = YES;
    _restartRecording.hidden = YES;
    _fileNameTextField.hidden = YES;
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

- (void) recordButtonPressed
{
    if(self.flag == NO)
    {
        //[_recordButton setTitle:@"Stop" forState:normal];
        [self startRecording];
        self.flag = YES;
    }
    else
    {
        //[_recordButton setTitle:@"Record" forState:normal];
        [self stopRecording];
        _fileNameTextField.hidden = NO;
        _playButton.hidden = NO;
        _saveButton.hidden = NO;
        _restartRecording.hidden = NO;
        _recordButton.hidden = YES;
        self.flag = NO;
    }
}

-(void) buttonPlay
{
    [self playRecording:currentRecordingSample];
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
    currentRecordingSample = sampleName;
    
    /*-----------------------Creating a csv file for holding sample names-----------------*/
    
    //    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    //
    //    NSString *sampleNamesFile = [docPath stringByAppendingPathComponent:@"samples.csv"];
    //    NSString *newLine = @"\n";
    //    if(![[NSFileManager defaultManager]fileExistsAtPath:sampleNamesFile])
    //    {
    //        [[NSFileManager defaultManager] createFileAtPath:sampleNamesFile contents:nil attributes:nil];
    //    }
    //    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sampleNamesFile];
    //    [fileHandle seekToEndOfFile];
    //    [fileHandle writeData:[sampleName dataUsingEncoding:NSUTF8StringEncoding]];
    //    [fileHandle writeData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
    //    [fileHandle closeFile];
    
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
    NSLog(@"stopRecording");
    [audioRecorder stop];
    NSLog(@"stopped");
}

- (void)saveSample
{
    if(_fileNameTextField.text != NULL)
    {
        NSLog(@"SaveFile");
        NSString *sampleName = [NSString stringWithFormat:@"%@.caf",_fileNameTextField.text];
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
        NSString *sampleNamesFile = [docPath stringByAppendingPathComponent:@"samples.csv"];
        NSString *newLine = @"\n";
        
        NSError * err = NULL;
        NSFileManager * fm = [[NSFileManager alloc] init];
        
        BOOL result = [fm moveItemAtPath:[docPath stringByAppendingPathComponent:currentRecordingSample] toPath:[docPath stringByAppendingPathComponent:sampleName] error:&err];
        if(!result)
            NSLog(@"Error: %@", err);
        
        if(![[NSFileManager defaultManager]fileExistsAtPath:sampleNamesFile])
        {
            [[NSFileManager defaultManager] createFileAtPath:sampleNamesFile contents:nil attributes:nil];
        }
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sampleNamesFile];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[sampleName dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle writeData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
}

-(void) playRecording:(NSString *)sampleName
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths[0];
    
    //NSString *indexString = [NSString stringWithFormat:@"%d", sampleIndex];
    
    
    //    NSMutableString *samplePath = [[NSMutableString alloc]init];
    //
    //    [samplePath appendString:@"%@/sample0.caf"];
    //    //[samplePath appendFormat:@"%d",sampleIndex];
    //    [samplePath appendString:forSampleName];
    
    NSString * samplePath = [NSString stringWithFormat:@"%@/%@",basePath,sampleName];
    
    //sampleIndex++;
    
    NSURL *url = [NSURL fileURLWithPath:samplePath];
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
    [audioPlayer stop];
}


@end
