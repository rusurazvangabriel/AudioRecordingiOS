//
//  MIViewController.m
//  AnimationTest2
//
//  Created by LaboratoriOS Cronian Academy on 27/03/14.
//  Copyright (c) 2014 Lab1. All rights reserved.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (weak, nonatomic) UIButton *stopButton;

@property (weak, nonatomic) UIButton *triggerButton;

@property (weak, nonatomic) UIButton *triggerButton2;

@property (weak, nonatomic) UIButton *animationButton;

@property (nonatomic) BOOL start;

@property (nonatomic) BOOL played;

@property (weak, nonatomic) AVAudioPlayer *player;

@property NSMutableArray* channelContainer;

@property (weak, nonatomic) UIButton *selectedSample;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _start = NO;
    _played = NO;
    [self initButtons];
    [self initToolbar];
    
}

-(void)initToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.frame = CGRectMake(0, self.view.frame.size.height-200, self.view.frame.size.width, 44);
    
    // create a bordered style button with custom title
	UIBarButtonItem *playItem = [[UIBarButtonItem alloc] initWithTitle:@"Play/Resume"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(functionTest)];
    
	
	UIBarButtonItem *emailItem = [[UIBarButtonItem alloc] initWithTitle:@"Stop"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(stopButtonPressed)];
	
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:nil];
    
	
	UIBarButtonItem *addSampleButton = [[UIBarButtonItem alloc] initWithTitle:@"Add"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:nil];
    
    UIBarButtonItem *deleteSampleButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:nil];
    
    
	NSArray *items = [NSArray arrayWithObjects:
					  playItem,
					  emailItem,
                      backButton,
                      addSampleButton,
                      deleteSampleButton,
					  nil];
    [toolbar setItems:items
             animated:NO];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin];
    
	[self.view addSubview:toolbar];
    
}

-(void)stopButtonPressed
{
    NSLog(@"STOP");
    _start = NO;
    _animationButton.center = CGPointMake(20, _animationButton.center.y);
}

-(NSMutableArray *)retrieveObjects
{
    NSMutableArray *aArray = [[NSMutableArray alloc] init];
    // add objects
    return aArray;
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    UIControl *control = sender;
    
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}

-(void)initSampleButtonWith: (NSString*) title andLocationX:(int)x andLocationY:(int)y
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithRed:(255/255.0) green:(180/255.0) blue:(180/255.0) alpha:1]];
    
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor darkGrayColor].CGColor;
    button.layer.borderWidth = 1;
    
    button.frame = CGRectMake(x, y, 30, 30);
    [self.view addSubview:button];
}


-(void)initButtons
{
    [self initSampleButtonWith:@"lalala" andLocationX:200 andLocationY:200];
    [self initSampleButtonWith:@"1" andLocationX:150 andLocationY:70];
    [self initSampleButtonWith:@"2" andLocationX:170 andLocationY:70];
    
    _animationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_animationButton setTitle:@">" forState:UIControlStateNormal];
    _animationButton.frame = CGRectMake(20, 100, 1, self.view.frame.size.width);
    [self.view addSubview:_animationButton];
    [_animationButton setBackgroundColor:[UIColor yellowColor]];
    _animationButton.layer.cornerRadius = 5;
    _animationButton.layer.masksToBounds = YES;
    _animationButton.layer.borderColor = [UIColor yellowColor].CGColor;
    _animationButton.layer.borderWidth = 1;
}

-(void)functionTest
{
    if (!_start) {
        _start = YES;
        [self animationControl];
    } else {
        _start = NO;
    }
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(void)animationControl
{
    if(_start) {
        [self animationCycle];
    }
}

-(void)animationCycle
{
    if(!_played && _animationButton.center.x > _triggerButton.center.x) {
        _played = YES;
    }
    
    [UIView animateWithDuration:0.05 delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         _animationButton.center= CGPointMake(_animationButton.center.x + 1, _animationButton.center.y);
                     }
                     completion:^(BOOL finished) {
                         [self animationControl];
                     }];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
