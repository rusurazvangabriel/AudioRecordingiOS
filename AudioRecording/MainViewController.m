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

@interface MainViewController ()

@property (strong, nonatomic)  RRButton *recordViewButton;
@property (strong, nonatomic)  RRButton *sampleListButton;
@property (strong, nonatomic) RRButton *editorViewButton;
@property (strong, nonatomic) EditorViewController *editor;
@property (strong, nonatomic) SampleListViewController *sampleList;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMain.jpg"]];
    
    _editor = [[EditorViewController alloc] init];
    _sampleList = [[SampleListViewController alloc]init];
    
    float X_Image = (self.view.frame.size.width - 148)/2;
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(X_Image, 60, 140, 140)];
    [logo setImage:[UIImage imageNamed:@"logo.png"]];
    [self.view addSubview:logo];
    
    float X_Co = (self.view.frame.size.width - 240)/2;
    
    _recordViewButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 240, 240, 40)];
    [_recordViewButton setTitle:@"Record" forState:normal];
    [_recordViewButton addTarget:self action:@selector(goToRecordingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordViewButton];
    
    _sampleListButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 290, 240, 40)];
    [_sampleListButton setTitle:@"Samples" forState:normal];
    [_sampleListButton addTarget:self action:@selector(goToSampleView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sampleListButton];
    
    _editorViewButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 340, 240, 40)];
    [_editorViewButton setTitle:@"Editor" forState:normal];
    [_editorViewButton addTarget:self action:@selector(goToEditorView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editorViewButton];
    
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
