//
//  EditorViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "EditorViewController.h"
#import "AudioPlayer.h"
#import "MainViewController.h"

@interface EditorViewController () //<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray *trackArray;
@property(strong,nonatomic) NSMutableArray *sampleNameArray;
@property(strong,nonatomic) NSMutableArray *checkboxArray;

@property (strong,nonatomic) NSMutableArray *sampleArray;
@property (nonatomic, strong) UIToolbar	*toolbar;
@property (weak, nonatomic) UIButton *animationButton;
@property (nonatomic) BOOL start;
@property (nonatomic) BOOL played;
@property (nonatomic) BOOL snap;
@property (nonatomic, assign) int tempoPlaceholder;
@property (strong, nonatomic) NSMutableArray *eventList;

@end

@implementation EditorViewController

- (void)createToolbarItems
{
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(functionTest)];
    UIImage *baseImage = [UIImage imageNamed:@"play.png"];
    UIImage *backroundImage = [baseImage stretchableImageWithLeftCapWidth:60.0 topCapHeight:60.0];
    [customItem1 setBackgroundImage:backroundImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    NSDictionary *textAttributes = @{ UITextAttributeTextColor:[UIColor blackColor] };
    [customItem1 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Stop"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(stop)];
    [customItem2 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    UIBarButtonItem *customItem3 = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(goToMainView)];
    [customItem3 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    UIBarButtonItem *addTrackItem = [[UIBarButtonItem alloc] initWithTitle:@"AddBass"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(addTrack)];
    [customItem3 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    UIBarButtonItem *addTrackItem1 = [[UIBarButtonItem alloc] initWithTitle:@"AddDrums"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(addTrack1)];
    [customItem3 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    UIBarButtonItem *customItem4 = [[UIBarButtonItem alloc] initWithTitle:@"snap"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(setSnap)];
    
    [customItem4 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [self.toolbar setItems:@[customItem1,customItem2,customItem3,customItem4, addTrackItem,addTrackItem1] animated:NO];
}


-(void)setSnap
{
    _snap = !_snap;
}

- (void)adjustToolbarSize
{
    // size up the toolbar and set its frame
	[self.toolbar sizeToFit];
    
    // since the toolbar may have adjusted its height, it's origin will have to be adjusted too
	CGRect mainViewBounds = self.view.bounds;
	[self.toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
                                      CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - CGRectGetHeight(self.toolbar.frame),
                                      CGRectGetWidth(mainViewBounds),
                                      CGRectGetHeight(self.toolbar.frame))];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ( ! UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [super willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeLeft duration:duration];;
    }else
        
        [super willRotateToInterfaceOrientation:UIInterfaceOrientationLandscapeRight duration:duration];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
	self.toolbar.barStyle = UIBarStyleDefault;
	// size up the toolbar and set its frame
    [self adjustToolbarSize];
	[self.toolbar setFrame:CGRectMake(CGRectGetMinX(self.view.bounds),
                                      CGRectGetMinY(self.view.bounds) + CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.toolbar.frame),
                                      CGRectGetWidth(self.view.bounds),
                                      CGRectGetHeight(self.toolbar.frame))];
    // make so the toolbar stays to the bottom and keep the width matching the device's screen width
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self createToolbarItems];
	[self.view addSubview:self.toolbar];
    
    
    [self initPropertiesBaseValues];
    [self initElements];
    
    _trackArray = [[NSMutableArray alloc] init];
    _sampleNameArray = [[NSMutableArray alloc] initWithObjects:@"drums.wav",@"bass.wav", nil];
    
    _animationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _animationButton.frame = CGRectMake(0, 0, 1, self.view.frame.size.width - 44);
    [_animationButton setBackgroundColor:[UIColor blackColor]];
    _animationButton.layer.masksToBounds = YES;
    _animationButton.layer.borderColor = [UIColor blackColor].CGColor;
    _animationButton.layer.borderWidth = 1;
    [self.view addSubview:_animationButton];
    [self.view bringSubviewToFront:_animationButton];
    
    [self addChannel];
    [self addChannel];
    [self addChannel];
}

-(void) initPropertiesBaseValues
{
    _start = NO;
    _played = NO;
    _snap = NO;
}
-(void) dragEnded:(id) sender
{
    
    RRSample* currentSample = (RRSample*) sender;
    
    int separator = 50;
    int y = currentSample.center.y;
    int channel = 0;
    
    for (int i = 0; i < 6; i++){
        if (y < 30 +  (i)*separator + separator/2) {
            channel = i;
            break;
        }
    }
    
    CGRect frame = currentSample.frame;
    frame.origin.y = 30 + channel*separator - separator/2; // o sa fie rezolvata si asta
    currentSample.frame = frame;
    NSLog(@"S-a pus pe canalul %d", channel);
    currentSample.trackId = channel;
    
    
    if (_snap) {
        int closestSampleCoordonate = [self getClosestSampleHorizontalCoordonate:currentSample];
        if (closestSampleCoordonate != 999) {
            CGRect frame = currentSample.frame;
            frame.origin.x = closestSampleCoordonate;
            currentSample.frame = frame;
        }
    }
    
}

-(int) getClosestSampleHorizontalCoordonate:(RRSample*) currentSample
{
    int vecinity = 20;
    int minDistance = 999;
    RRSample* buttonToSnapTo;
    for (RRSample *button in _eventList)
    {
        if (button != currentSample) {
            int distance = currentSample.frame.origin.x - (button.frame.origin.x + button.frame.size.width);
            if(abs(distance) < vecinity && distance < minDistance && currentSample.trackId == button.trackId){
                    minDistance = distance;
                    buttonToSnapTo = button;
            }
        }
    }
    if (buttonToSnapTo != NULL) {
        NSLog(@"buttonToSnapTo has x coordonate @%f", buttonToSnapTo.frame.origin.x);
        return buttonToSnapTo.frame.origin.x + buttonToSnapTo.frame.size.width;
    } else {
        NSLog(@"null button");
        return 999;
    }
}

-(void)initElements
{
    _tempoPlaceholder = 3;
    _eventList = [[NSMutableArray alloc] init];
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

-(void)animationControl
{
    if(_start) {
        [self animationCycle];
    }
}

-(void)animationCycle
{
    for(RRSample *object in _eventList)
    {
        if(!object.triggered
           && (_animationButton.frame.origin.x >= object.frame.origin.x - 1)
           && (_animationButton.frame.origin.x < object.frame.origin.x + object.frame.size.width))
        {
                [_trackArray[object.trackId] startPlaying:object.sampleName numberOfLoops:1 volumeLevel:0.8];
                object.triggered = YES;
        }
        else if(_animationButton.frame.origin.x > object.frame.origin.x + object.frame.size.width)
        {
            object.triggered = NO;
        }
    }
    
    int currentX = _animationButton.frame.origin.x;
    int newX = currentX + 2;//+ _tempoPlaceholder;
    [UIView animateWithDuration:0.1 delay:0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         _animationButton.center= CGPointMake(newX, _animationButton.center.y);
                     }
                     completion:^(BOOL finished){[self animationControl];
                     }];
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    RRSample *aux = (RRSample *)sender;
    aux.triggered = NO;
    UIControl *control = sender;
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}

-(void)goToMainView
{
    _start = NO;
    MainViewController *mv = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mv animated:YES];
}

-(void)addChannel
{
    AudioPlayer *player = [[AudioPlayer alloc] init];
    [_trackArray insertObject:player atIndex:[_trackArray count]];
}

-(void)addTrack
{
    RRSample *auxButton = [[RRSample alloc]initWithSampleName:@"bass.wav" andSampleURL:@""];
    auxButton.trackId = 1;
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [auxButton addTarget:self action:@selector(dragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:auxButton];
    [_eventList insertObject:auxButton atIndex:[_eventList count]];
}

-(void)addTrack1
{
    RRSample *auxButton = [[RRSample alloc]initWithSampleName:@"drums.wav" andSampleURL:@""];
    auxButton.trackId = 0;
    
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [auxButton addTarget:self action:@selector(dragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:auxButton];
    [_eventList insertObject:auxButton atIndex:[_eventList count]];
}

-(void)addSample
{
    RRSample *newSample = [[RRSample alloc]initWithSampleName:@"SampleName" andSampleURL:@""];
    newSample.trackId = 3;
    [newSample addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [newSample addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [newSample addTarget:self action:@selector(dragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newSample];
    [_eventList insertObject:newSample atIndex:[_eventList count]];
}

-(void)stop
{
    NSLog(@"STOP");
    _animationButton.center = CGPointMake(1, _animationButton.center.y);
    for(AudioPlayer *player in _trackArray)
    {
        [player stopPlaying];
    }
    _start = NO;

    for(AudioPlayer *player in _trackArray)
    {
        [player stopPlaying];
    }
    
    for(RRSample *object in _eventList)
    {
        object.triggered = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    for(AudioPlayer *player in _trackArray)
    {
        [player.audioPlayer stop];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
