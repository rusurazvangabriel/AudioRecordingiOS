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

@property(strong,nonatomic) NSMutableArray* trackArray;
@property(strong,nonatomic) NSMutableArray* sampleNameArray;
@property(strong,nonatomic) NSMutableArray* checkboxArray;

@property(strong, nonatomic) RRCheckBox *checkbox1;
@property(strong, nonatomic) RRCheckBox *checkbox2;
@property(strong, nonatomic) AudioPlayer *player;


@property (strong,nonatomic) NSMutableArray *sampleArray;

@property (nonatomic, strong) UIToolbar	*toolbar;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *Button;

@property (strong, nonatomic) IBOutlet RRSample *triggerButton;

@property (strong, nonatomic) IBOutlet RRSample *triggerButton2;

@property (weak, nonatomic) UIButton *animationButton;

@property (nonatomic) BOOL start;

@property (nonatomic) BOOL played;

// general control references

@property (nonatomic, assign) int tempoPlaceholder;

// event object references

@property (nonatomic, assign) int nextEventTriggerTime;

@property (strong, nonatomic) NSMutableArray *eventList;

@property (strong, nonatomic) NSMutableArray *playerList; // a channel is




@end

@implementation EditorViewController



- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)createToolbarItems
{
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(play)];
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
    
    [self.toolbar setItems:@[customItem1,customItem2,customItem3,addTrackItem,addTrackItem1] animated:NO];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _start = NO;
    _played = NO;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _player = [[AudioPlayer alloc]init];
    [self initElements];
    
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
    
    _checkbox2 = [[RRCheckBox alloc] initWithCoordinates:CGPointMake(200, 70)];
    
    _trackArray = [[NSMutableArray alloc] init];
    _sampleNameArray = [[NSMutableArray alloc] initWithObjects:@"drums.wav",@"bass.wav", nil];
    _checkboxArray = [[NSMutableArray alloc] init];
    
    
    _animationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _animationButton.frame = CGRectMake(0, 0, 1, self.view.frame.size.width - 44);
    [_animationButton setBackgroundColor:[UIColor blackColor]];
    _animationButton.layer.masksToBounds = YES;
    _animationButton.layer.borderColor = [UIColor blackColor].CGColor;
    _animationButton.layer.borderWidth = 1;
    [self.view addSubview:_animationButton];
    [self.view bringSubviewToFront:_animationButton];
    
}

/*----------------------------------------------------------------------------------------------------*/
-(void)initElements
{
    _tempoPlaceholder = 3;
    [self initTestButtons];
}

-(void)initTestButtons
{
    _triggerButton = [[RRSample alloc] initWithSampleName:@"bass.wav"];
    [_triggerButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_triggerButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:_triggerButton];
    
    _triggerButton2 = [[RRSample alloc ]initWithSampleName:@"drums.wav"];
    [_triggerButton2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_triggerButton2 addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:_triggerButton2];
    
    _eventList = [[NSMutableArray alloc] init];
    
    [_eventList insertObject:_triggerButton atIndex:[_eventList count]];
    [_eventList insertObject:_triggerButton2 atIndex:[_eventList count]];
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
            [_player startPlaying:object.sampleName numberOfLoops:1 volumeLevel:0.8];
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
                     completion:^(BOOL finished){[self animationControl];}];
}



- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    RRSample *aux = (RRSample *)sender;
    aux.triggered = NO;
    NSLog(@"moved");
    UIControl *control = sender;
    UITouch *t = [[event allTouches] anyObject];
    CGPoint pPrev = [t previousLocationInView:control];
    CGPoint p = [t locationInView:control];
    CGPoint center = control.center;
    center.x += p.x - pPrev.x;
    center.y += p.y - pPrev.y;
    control.center = center;
}


/*----------------------------------------------------------------------------------------------------*/

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    //returns number of rows
//    return 2;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    //returns number of samples
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	return 70;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString* cellIdentifier = @"Cell";
//
//    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    RRCheckBox *playButton = [[RRCheckBox alloc] initWithCoordinates:CGPointMake(10, 10)];
//    [[cell contentView] addSubview:playButton];
//    [_checkboxArray addObject:playButton];
//
//    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,10,200,60)];
//    cellLabel.text = [NSString stringWithString:_sampleNameArray[indexPath.row]];
//    cellLabel.textColor = [UIColor blackColor];
//    [cell setBackgroundColor:[UIColor clearColor]];
//    [[cell contentView] addSubview:cellLabel];
//    return cell;
//}

-(void)goToMainView
{
    _start = NO;
    [_player stopPlaying];
    MainViewController *mv = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mv animated:YES];
}

-(void)addTrack
{
    RRSample *auxButton = [[RRSample alloc]initWithSampleName:@"bass.wav"];
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:auxButton];
    [_eventList insertObject:auxButton atIndex:[_eventList count]];
}

-(void)addTrack1
{
    RRSample *auxButton = [[RRSample alloc]initWithSampleName:@"drums.wav"];
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [auxButton addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [self.view addSubview:auxButton];
    [_eventList insertObject:auxButton atIndex:[_eventList count]];
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

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

-(void) play
{
    [self functionTest];
    for(int i = 0 ; i < _checkboxArray.count; i++)
    {
        [_trackArray[i] startPlaying:_sampleNameArray[i] numberOfLoops:4 volumeLevel:0.8f];
    }
}

-(void)stop
{
    NSLog(@"STOP");
    _animationButton.center = CGPointMake(1, _animationButton.center.y);
    for(AudioPlayer *player in _trackArray)
    {
        [player stopPlaying];
    }
    [_player stopPlaying];
    _start = NO;
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
