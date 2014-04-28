//
//  RecordingViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 26/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RecordingViewController.h"
#import "SampleListViewController.h"
#import "AFNetworking.h"
#import "AudioPlayer.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "RRAFJSONRequestSerializer.h"
#import "RRButton.h"

@interface RecordingViewController ()

@property BOOL flag;
@property (strong, nonatomic)  UIButton *recordButton;
@property (strong, nonatomic)  UIButton *playButton;
@property (strong, nonatomic)  RRButton *saveButton;
@property (strong, nonatomic)  RRButton *restartRecording;
@property (strong, nonatomic)  RRTextField *fileNameTextField;
@property (strong,nonatomic) UITextView *recordingStatusLabel;
@property (strong, nonatomic) SampleListViewController *sampleList;
@property(strong,nonatomic) AudioPlayer *player;
@property(nonatomic,assign, getter = isFrameUp) BOOL frameUp;

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
    
    [super viewDidLoad];
    self.frameUp = NO;
    
    _player = [[AudioPlayer alloc] init];
    self.title = @"Record";
    self.fileNameTextField.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMain.jpg"]];
    self.flag = NO;
    _sampleList = [[SampleListViewController alloc] init];
    
    
    //set the index of current recording session to 0
    sampleIndex = 0;
    
    float X_Co = (self.view.frame.size.width - 240)/2;
    
    _recordingStatusLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 80)];
    _recordingStatusLabel.text = @"Press The Button to record";
    _recordingStatusLabel.textAlignment = NSTextAlignmentCenter;
    _recordingStatusLabel.backgroundColor = [UIColor clearColor];
    [_recordingStatusLabel setTextColor:[UIColor whiteColor]];
	_recordingStatusLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:_recordingStatusLabel];
    
    _recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150 , 160)];
    _recordButton.center = self.view.center;
    [_recordButton setTitle:@"Record" forState:normal];
    [_recordButton setImage:[UIImage imageNamed:@"RecordNormalImage.png"] forState:UIControlStateNormal];
    [self.view addSubview:_recordButton];
    [_recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _recordButton.hidden = NO;
    
    _playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    _playButton.center = self.view.center;
    _playButton.backgroundColor = [UIColor colorWithRed:0 green:0.518 blue:0 alpha:0.6f];
    _playButton.layer.cornerRadius = 75;
    [_playButton setTitle:@"Play" forState:normal];
    [_playButton setImage:[UIImage imageNamed:@"playButton2.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"playButton2.png"] forState:UIControlStateSelected];
    [self.view addSubview:_playButton];
    
    [_playButton addTarget:self action:@selector(buttonPlay) forControlEvents:UIControlEventTouchUpInside];
    _playButton.hidden = YES;
    
    _fileNameTextField = [[RRTextField alloc] initWithCoordinates:X_Co y:self.view.frame.size.height - 185];
    _fileNameTextField.placeholder = @"Sample name";
    _fileNameTextField.text = @"";
    _fileNameTextField.delegate = self;
    _fileNameTextField.returnKeyType = UIReturnKeyDone;
    // [self.view addSubview:_fileNameTextField];
    _fileNameTextField.hidden = YES;
    
    _saveButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, self.view.frame.size.height - 140, 240, 35)];
    [_saveButton setTitle:@"Save Sample" forState:normal];
    [_saveButton addTarget:self action:@selector(saveSample) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_saveButton];
    _saveButton.hidden = YES;
    
    _restartRecording = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, self.view.frame.size.height - 95, 240, 35)];
    [_restartRecording setTitle:@"Record Again" forState:normal];
    [_restartRecording addTarget:self action:@selector(recordAgainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_restartRecording];
    _restartRecording.hidden = YES;
    
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/DubstepBass1.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/DubstepBass2.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/DubstepDrums1.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/DubstepDrums2.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/DubstepDrums3.wav"];
    
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseBass1.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseBass2.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseBass3.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseBass4.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseDrum1.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseDrum2.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseDrum3.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseDrum4.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseSynth1.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseSynth2.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseSynth3.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseSynth4.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/HouseSynth5.wav"];
//    
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/IAmDreamingVoice.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/INeedLoveVoice.wav"];
//    [_player downloadSample:@"http://app.etajul9.ro/sounds/standard_samples/VoxBassVoice.wav"];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) recordAgainButtonPressed
{
    self.title = @"Record";
    [_player stopPlaying];
    [_recordingStatusLabel setText:@"Press THE BUTTON to record"];
    _recordButton.hidden = NO;
    _playButton.hidden = YES;
    _saveButton.hidden = YES;
    _restartRecording.hidden = YES;
    _fileNameTextField.hidden = YES;
    //[self uploadSample];
}

- (void) recordButtonPressed
{
    if(self.flag == NO)
    {
        self.title = @"Record";
        [_recordButton setImage:[UIImage imageNamed:@"RecordPressedImage.png"] forState:UIControlStateNormal];
        [_recordingStatusLabel setText:@"Press again to stop recording"];
        [_player startRecording];
        self.flag = YES;
    }
    else
    {
        
        self.title = @"Play";
        _fileNameTextField.text = @"";
        _recordingStatusLabel.text = @"Play sample";
        [_player stopRecording];
        _fileNameTextField.hidden = NO;
        _playButton.hidden = NO;
        _saveButton.hidden = NO;
        _restartRecording.hidden = NO;
        _recordButton.hidden = YES;
        [_recordButton setImage:[UIImage imageNamed:@"RecordNormalImage.png"] forState:UIControlStateNormal];
        self.flag = NO;
    }
}

-(void) buttonPlay
{
    [_player startPlaying:@"tempSample.caf" numberOfLoops:1 volumeLevel:1.0f];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //SaveLogin
        UITextField *sampleName = [alertView textFieldAtIndex:0];
        
        if(![sampleName.text isEqualToString: @""])
        {
            NSLog(@"SaveFile");
            
            NSString *tempSampleName = [NSString stringWithFormat:@"%@.caf",sampleName.text];
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
            NSError * err = NULL;
            NSFileManager * fm = [[NSFileManager alloc] init];
            
            BOOL result = [fm moveItemAtPath:[docPath stringByAppendingPathComponent:@"tempSample.caf"] toPath:[docPath stringByAppendingPathComponent:tempSampleName] error:&err];
            if(!result)
                NSLog(@"Error: %@", err);
            [self.navigationController pushViewController:_sampleList animated:YES];
        }
    }
}

- (void)saveSample
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Save sample" message:@"Enter sample name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Done"];
    [alert show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![_fileNameTextField.text isEqualToString:@""]) {
        [_fileNameTextField resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 216);
            self.frameUp = NO;
        }];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.isFrameUp) {
        self.frameUp  = YES;
        [UIView animateWithDuration:0.3  animations:^{
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 216);
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self recordAgainButtonPressed];
    
}

- (void)uploadSample//:(NSString *)sampleName
{
    NSLog(@"upload");
    
    NSString *baseurl = @"http://app.etajul9.ro/api/add_sample.php";
    NSURL *dataURL = [NSURL URLWithString:baseurl];
    
    NSMutableURLRequest *dataRqst = [NSMutableURLRequest requestWithURL:dataURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    
    [dataRqst setHTTPMethod:@"POST"];
    
    NSString *stringBoundary = @"----WebKitFormBoundaryEty8uPcNQAYEKwtR";
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    
    [dataRqst addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"token\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"673d0fefbee71ca8875ff3b5ac26f98011ade255\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"userfile\"; filename=\"drums.wav\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: audio/wav\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //*******************load locally store audio file********************//
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *audioUrl = [NSString stringWithFormat:@"%@/drums.wav", documentsDirectory];
    //
    //    // get the audio data from main bundle directly into NSData object
    NSData *audioData;
    audioData = [[NSData alloc] initWithContentsOfFile:audioUrl];
    // add it to body
    [postBody appendData:audioData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // final boundary
    
    [postBody appendData:[[NSString stringWithFormat:@"%--@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add body to post
    NSString *str = [[NSString alloc] initWithData:postBody encoding:NSASCIIStringEncoding];
    NSLog(@"\n\n%@\n\n",str);
    [dataRqst setHTTPBody:postBody];
    
    //NSHTTPURLResponse* response =[[NSHTTPURLResponse alloc] init];
    // NSError* error = [[NSError alloc] init] ;
    
    //synchronous filling of data from HTTP POST response
    //NSData *responseData = [NSURLConnection sendSynchronousRequest:dataRqst returningResponse:&response error:&error];
    [NSURLConnection sendAsynchronousRequest:dataRqst queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"A mers %@",response.description);
    }];
    
    
    //convert data into string
    //NSString *responseString = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
    
    //NSLog(@"Response String %@",responseString);
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    manager.requestSerializer = [RRAFJSONRequestSerializer serializer];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //
    //    NSDictionary *parameters = @{@"token": @"673d0fefbee71ca8875ff3b5ac26f98011ade255"};
    //    [manager POST:@"http://app.etajul9.ro/api/add_sample.php" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    //        [formData appendPartWithFormData:audioData name:@"userfile"];
    //    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //        NSLog(@"Success: %@", responseObject);
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        NSLog(@"Error: %@", error);
    //    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

