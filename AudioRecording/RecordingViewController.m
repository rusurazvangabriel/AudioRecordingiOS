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

@interface RecordingViewController ()

@property BOOL flag;
@property (strong, nonatomic)  UIButton *recordButton;
@property (strong, nonatomic)  UIButton *playButton;
@property (strong, nonatomic)  UIButton *saveButton;
@property (strong, nonatomic)  UIButton *restartRecording;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background2.jpg"]];
    self.flag = NO;
    _sampleList = [[SampleListViewController alloc] init];
    
    
    //set the index of current recording session to 0
    sampleIndex = 0;
    
    float X_Co = (self.view.frame.size.width - 240)/2;
    
    _recordingStatusLabel = [[UITextView alloc] initWithFrame:CGRectMake(X_Co, 110, 240, 80)];
    _recordingStatusLabel.text = @"Press The Button to record";
    _recordingStatusLabel.textAlignment = NSTextAlignmentCenter;
    _recordingStatusLabel.backgroundColor = [UIColor clearColor];
    [_recordingStatusLabel setTextColor:[UIColor blackColor]];
	_recordingStatusLabel.font = [UIFont systemFontOfSize:17];
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
    [_playButton setTitle:@"Play" forState:normal];
    [_playButton setImage:[UIImage imageNamed:@"Play-Disabled-icon.png"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"Play-Pressed-icon.png"] forState:UIControlStateSelected];
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
    
    _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(X_Co, self.view.frame.size.height - 140, 240, 35)];
    _saveButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:140/255.0f blue:255/255.0f alpha:1.0f];
    _saveButton.layer.cornerRadius = 7.0f;
    _saveButton.layer.shadowRadius = 3.0f;
    _saveButton.layer.borderWidth = 0.3f;
    _saveButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _saveButton.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
    _saveButton.layer.shadowOpacity = 0.8f;
    _saveButton.layer.masksToBounds = NO;
    [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveButton setTitle:@"Save" forState:normal];
    [self.view addSubview:_saveButton];
    [_saveButton addTarget:self action:@selector(saveSample) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.hidden = YES;
    
    _restartRecording = [[UIButton alloc] initWithFrame:CGRectMake(X_Co, self.view.frame.size.height - 95, 240, 35)];
    _restartRecording.backgroundColor = [UIColor colorWithRed:0/255.0f green:140/255.0f blue:255/255.0f alpha:1.0f];
    _restartRecording.layer.cornerRadius = 7.0f;
    _restartRecording.layer.shadowRadius = 3.0f;
    _restartRecording.layer.borderWidth = 0.3f;
    _restartRecording.layer.shadowColor = [UIColor blackColor].CGColor;
    _restartRecording.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
    _restartRecording.layer.shadowOpacity = 0.8f;
    _restartRecording.layer.masksToBounds = NO;
    [_restartRecording setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_restartRecording setTitle:@"Rec_A" forState:normal];
    [self.view addSubview:_restartRecording];
    [_restartRecording addTarget:self action:@selector(recordAgainButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    _restartRecording.hidden = YES;
    //[self downloadSample];
    [_player downloadSample:@"http://app.etajul9.ro/sounds/bass.wav"];
    [_player downloadSample:@"http://app.etajul9.ro/sounds/drums.wav"];
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
    NSLog(@"Button Index =%ld",buttonIndex);
    if (buttonIndex == 1) {  //SaveLogin
        UITextField *sampleName = [alertView textFieldAtIndex:0];
        
        if(![sampleName.text isEqualToString: @""])
        {
            NSLog(@"SaveFile");
            
            NSString *tempSampleName = [NSString stringWithFormat:@"%@.caf",sampleName.text];
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
            NSString *sampleNamesFile = [docPath stringByAppendingPathComponent:@"samples.csv"];
            NSString *newLine = @"\n";
            
            NSError * err = NULL;
            NSFileManager * fm = [[NSFileManager alloc] init];
            
            BOOL result = [fm moveItemAtPath:[docPath stringByAppendingPathComponent:@"tempSample.caf"] toPath:[docPath stringByAppendingPathComponent:tempSampleName] error:&err];
            if(!result)
                NSLog(@"Error: %@", err);
            
            if(![[NSFileManager defaultManager]fileExistsAtPath:sampleNamesFile])
            {
                [[NSFileManager defaultManager] createFileAtPath:sampleNamesFile contents:nil attributes:nil];
            }
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:sampleNamesFile];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:[tempSampleName dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle writeData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
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
//        NSData *file1Data = [[NSData alloc] initWithContentsOfFile:[docPath stringByAppendingString:sampleName]];
//        NSString *urlString = @"http://app.etajul9.ro/mysql_query1.php";
//
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString:urlString]];
//        [request setHTTPMethod:@"POST"];
//
//        NSString *boundary = @"---------------------------14737809831466499882746641449";
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//
//        NSMutableData *body = [NSMutableData data];
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//
//        [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",sampleName]] dataUsingEncoding:NSUTF8StringEncoding]];
//
//        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[NSData dataWithData:file1Data]];
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//
//        [request setHTTPBody:body];
//
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//
//        NSLog(@"Return String= %@",returnString);

- (void)uploadFile
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
