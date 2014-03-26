//
//  ViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 12/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "ViewController.h"
#import "RecordingViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UIButton *recordViewButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor greenColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgImage.jpg"]];
    

    
    _recordViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 60)];
    _recordViewButton.center = self.view.center;
    _recordViewButton.layer.cornerRadius = 10;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = _recordViewButton.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                            (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    gradientLayer.cornerRadius = _recordViewButton.layer.cornerRadius;
    [_recordViewButton.layer addSublayer:gradientLayer];
    _recordViewButton.tintColor = [UIColor purpleColor];
    _recordViewButton.layer.cornerRadius = 10;
    [_recordViewButton setTitle:@"Record" forState:normal];
    [_recordViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_recordViewButton addTarget:self action:@selector(goToRecordingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordViewButton];
}

- (void)goToRecordingView
{
    RecordingViewController * sampleList = [[RecordingViewController alloc] init];
    [self presentViewController:sampleList animated:YES completion:NULL];
}

//
//- (void) swipeRight
//{
//    NSLog(@"Right swipe");
//    
//    CATransition *animation = [CATransition animation];
//    [animation setDelegate:self];
//    [animation setType:kCATransitionPush];
//    [animation setSubtype:kCATransitionFromLeft];
//    [animation setDuration:0.40];
//    [animation setTimingFunction:
//     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [self.view.layer addAnimation:animation forKey:kCATransition];
//    
////    SampleListViewController * sampleList = [[SampleListViewController alloc] init];
////    [self presentViewController:sampleList animated:YES completion:NULL];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
