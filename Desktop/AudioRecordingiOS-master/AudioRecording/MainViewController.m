//
//  ViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 12/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "MainViewController.h"
#import "RecordingViewController.h"
#import "SampleListViewController.h"
#import "EditorViewController.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@property (strong, nonatomic)  RRButton *recordViewButton;
@property (strong, nonatomic)  RRButton *sampleListButton;
@property (strong, nonatomic) RRButton *editorViewButton;
@property (strong, nonatomic) EditorViewController *editor;
@property (strong, nonatomic) SampleListViewController *sampleList;
@property (strong, nonatomic) SignUpViewController *signUpViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMain.jpg"]];
    
    _editor = [[EditorViewController alloc] init];
    _sampleList = [[SampleListViewController alloc]init];
    
    float X_Image = (self.view.frame.size.width - 120)/2;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(X_Image, 40, 120, 120)];
    [logo setImage:[UIImage imageNamed:@"logo.png"]];
    [self.view addSubview:logo];
    
    float X_Co = (self.view.frame.size.width - 240)/2;
    
    _recordViewButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 200, 240, 35)];
    [_recordViewButton setTitle:@"Record" forState:normal];
    [_recordViewButton addTarget:self action:@selector(goToRecordingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordViewButton];
    
    _sampleListButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 245, 240, 35)];
    [_sampleListButton setTitle:@"Samples" forState:normal];
    [_sampleListButton addTarget:self action:@selector(goToSampleView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sampleListButton];
    
    _editorViewButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 290, 240, 35)];
    [_editorViewButton setTitle:@"Editor" forState:normal];
    [_editorViewButton addTarget:self action:@selector(goToEditorView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editorViewButton];
    
    
    
    
    
    UITextView *info2 = [[UITextView alloc] initWithFrame:CGRectMake(X_Co - 10, 375, 260, 40)];
    info2.text = @"Sign Up if you want to see community's uploads!";
    info2.layer.backgroundColor = [UIColor clearColor].CGColor;
    info2.textAlignment = NSTextAlignmentCenter;
    [info2 setFont:[UIFont systemFontOfSize:12]];
    info2.textColor =[UIColor whiteColor];
    [self.view addSubview:info2];
    
    float X_Co_login = (self.view.frame.size.width - 180)/2;
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(X_Co_login, 420, 180, 30)];
    [registerButton setTitle:@"Sign Up with Email" forState:UIControlStateNormal];
    registerButton.layer.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:144.0f/255.0f blue:19.0f/255.0f alpha:1.0].CGColor;
    [registerButton setFont:[UIFont systemFontOfSize:13]];
    registerButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    registerButton.layer.borderWidth = 0.5f;
    registerButton.layer.cornerRadius = 7.0f;
    [registerButton addTarget:self action:@selector(goToRegisterView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    UITextView *info = [[UITextView alloc] initWithFrame:CGRectMake(X_Co + 25, 455, 120, 40)];
    info.text = @"Already signed up?";
    info.layer.backgroundColor = [UIColor clearColor].CGColor;
    info.textAlignment = NSTextAlignmentCenter;
    [info setFont:[UIFont systemFontOfSize:12]];
    info.textColor =[UIColor whiteColor];
    [self.view addSubview:info];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(X_Co_login + 95, 463, 100, 15)];
    [loginButton setTitle:@"Login now!" forState:UIControlStateNormal];
    [loginButton setFont:[UIFont systemFontOfSize:13]];
    [loginButton setTitleColor:[UIColor colorWithRed:61.0f/255.0f green:144.0f/255.0f blue:19.0f/255.0f alpha:1.0]forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [loginButton addTarget:self action:@selector(goToLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    //    RRButton *upload = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 390, 240, 40)];
    //    [upload setTitle:@"upload" forState:normal];
    //    [upload addTarget:self action:@selector(uploadSample1) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:upload];
    
}

//-(void) uploadSample1
//{
//    RecordingViewController *rc = [[RecordingViewController alloc] init];
//    [rc uploadSample];
//}

-(void)goToLoginView
{
    _loginViewController = [[LoginViewController alloc] init];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:_loginViewController animated:YES];
}

-(void)goToRegisterView
{
    _signUpViewController = [[SignUpViewController alloc] init];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:_signUpViewController animated:YES];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ( ! UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        [super willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:duration];;
    }else
        
        [super willRotateToInterfaceOrientation:UIInterfaceOrientationPortrait duration:duration];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
}

- (void)goToRecordingView
{
    RecordingViewController *recordingView = [[RecordingViewController alloc] init];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:recordingView animated:YES];
}

- (void) goToSampleView
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController pushViewController:_sampleList animated:YES];
    //     /[self.navigationController pushViewController:_test animated:YES];
}

- (void) goToEditorView
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController pushViewController:_editor animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
