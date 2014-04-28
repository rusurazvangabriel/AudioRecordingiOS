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
#import "RRSampleListPlayButton.h"

#import "VBProjectState.h"
#import "VBSampleForSerialization.h"

#import "EditorSampleListViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "RRTableViewCell.h"
#import "RRSampleAddButton.h"

#import "NSString+FontAwesome.h"
#import "RRMixerButton.h"

@interface EditorViewController () <UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray *sampleNamesArray;

@property(strong,nonatomic) NSMutableArray *trackArray;
@property(strong,nonatomic) NSMutableArray *checkboxArray;

@property (nonatomic, strong) UIToolbar	*toolbar;
@property (strong, nonatomic) UIButton *animationButton;
@property (nonatomic) BOOL start;
@property (nonatomic) BOOL played;
@property (nonatomic) BOOL snap;
@property (nonatomic, assign) int tempoPlaceholder;
@property (strong, nonatomic) NSMutableArray *eventList;
@property (strong,nonatomic) NSMutableArray *currentlyPausedPlayers;

@property (assign,nonatomic) int index;

@property (strong, nonatomic) UIView *sampleListView;
@property (strong, nonatomic) UITableView *sampleListTableView;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSMutableArray *colorArray;
@end

@implementation EditorViewController

/*========================================================================================================================*/
/*========================================== VIEW INITIALIZATION =========================================================*/
/*========================================================================================================================*/


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"editorBackground.jpg"]];
    
    [self initToolbarWithButtons];
	[self.view addSubview:self.toolbar];
    [self initPropertiesWithBaseValues];
    
    _sampleNamesArray = [[NSMutableArray alloc] initWithArray:[self listFileAtPath]];
    _colorArray = [[NSMutableArray alloc] initWithArray:[self getColorArray]];
    
    _animationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _animationButton.frame = CGRectMake(0, 0, 0.5f, self.view.frame.size.width - 30);
    [_animationButton setBackgroundColor:[UIColor yellowColor]];
    _animationButton.layer.masksToBounds = YES;
    _animationButton.layer.borderColor = [UIColor yellowColor].CGColor;
    _animationButton.layer.borderWidth = 0.5f;
    [self.view addSubview:_animationButton];
    [self.view bringSubviewToFront:_animationButton];
    _animationButton.hidden = YES;
    _index = 0;
    UIButton *recycleBin = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.height - 30,self.view.frame.size.width - 28,24,24)]; // ,  , 20, 20)];
    [recycleBin setBackgroundImage:[UIImage imageNamed:@"recyclebinIcon.png"] forState:UIControlStateNormal];
    [self.view addSubview:recycleBin];
    [self.view bringSubviewToFront:recycleBin];
    
    [self addChannel];
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

-(void)pausePlayers
{
    for(AudioPlayer *player in _trackArray)
    {
        if ([player.audioPlayer isPlaying]) {
            [player.audioPlayer pause];
            [_currentlyPausedPlayers addObject:player];
        }
    }
}

-(void)goToMainView
{
    _start = NO;
    MainViewController *mv = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mv animated:YES];
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


/*========================================================================================================================*/



/*========================================================================================================================*/
/*======================================== TOOLBAR INITIALIZATION ========================================================*/
/*========================================================================================================================*/

- (void)createToolbarItems
{
    UIBarButtonItem *playToolbarButton = [[UIBarButtonItem alloc] initWithTitle:@"Play"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(functionTest)];
    UIBarButtonItem *stopToolbarButton = [self createBarButtonWithTitle:@"Stop" andDelegate:@selector(stop)];
    UIBarButtonItem *backToolbarButton = [self createBarButtonWithTitle:@"Back" andDelegate:@selector(goToMainView)];
    UIBarButtonItem *snapToolbarButton = [self createBarButtonWithTitle:@"Snap" andDelegate:@selector(setSnap)];
    UIBarButtonItem *saveToolbarButton = [self createBarButtonWithTitle:@"Save" andDelegate:@selector(saveProject)];
    UIBarButtonItem *addToolbarButton = [self createBarButtonWithTitle:@"+" andDelegate:@selector(addSampleToProject)];
    UIBarButtonItem *addChannelButton = [self createBarButtonWithTitle:@"Add Channel" andDelegate:@selector(addChannel)];
    
    UIBarButtonItem *addChannelButton2 = [self createBarButtonWithTitle:@"Load" andDelegate:@selector(loadProjectFromNSData)];
    
    [self.toolbar setItems:@[playToolbarButton,stopToolbarButton,backToolbarButton,snapToolbarButton,saveToolbarButton, addChannelButton2, addChannelButton,addToolbarButton] animated:NO];
}

-(UIBarButtonItem*) createBarButtonWithTitle:(NSString*) title andDelegate:(SEL)delegate
{
    NSDictionary *textAttributes = @{ UITextAttributeTextColor:[UIColor blackColor] };
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:delegate];
    [barButton setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    return barButton;
}

-(void)initToolbarWithButtons
{
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
                                      30)]; //CGRectGetHeight(self.toolbar.frame)
}

/*========================================================================================================================*/



/*========================================================================================================================*/
/*==================================== SAMPLE TABLE VIEW INITIALIZATION ==================================================*/
/*========================================================================================================================*/

-(NSArray *)listFileAtPath
{
    //-----> LIST ALL FILES <-----//
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0] error:NULL];
    return directoryContent;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //returns number of rows
    return [_sampleNamesArray count] - 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //returns number of samples
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    RRTableViewCell *cell = [[RRTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault andSampleName:_sampleNamesArray[indexPath.row] reuseIdentifier:cellIdentifier];
    RRSampleAddButton *addButton = [[RRSampleAddButton alloc] initWithFrame:CGRectMake(285, 15, 25, 25) andSampleName:_sampleNamesArray[indexPath.row]];
    addButton.backgroundColor = [UIColor lightGrayColor];
    addButton.layer.borderWidth = 0.7f;
    addButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    addButton.layer.cornerRadius = 12.5f;
    [addButton setTitle:@"+" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addSample:) forControlEvents:UIControlEventTouchUpInside];
    [[cell contentView] addSubview:addButton];
    return cell;
}

/*========================================================================================================================*/




/*========================================================================================================================*/
/*======================================== PROJECT SAVE AND LOAD =========================================================*/
/*========================================================================================================================*/

-(void) saveProject
{
    NSLog(@"SAVE");
    NSMutableArray* sampleList = [[NSMutableArray alloc] init];
    for (RRSample* sample in _eventList){
        VBSampleForSerialization* s = [[VBSampleForSerialization alloc] initWithUrl:sample.sampleName andChannel:sample.trackId andPosition:sample.frame.origin.x];
     //   BOOL ceva = [NSJSONSerialization isValidJSONObject:[s dictionary]];
        [sampleList addObject:[s dictionary]];
    }
    
    VBProjectState *project = [[VBProjectState alloc]initWithSampleList:sampleList];
 //   BOOL ceva = [NSJSONSerialization isValidJSONObject:[project dictionary]];
    NSData* data = [NSJSONSerialization dataWithJSONObject:[project dictionary] options:(0) error:nil];
    
    
    // asta e pus de test aici, sa vad ca imi deserializeaza calumea chestia serializata
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    NSString *savePath = [NSString stringWithFormat:@"%@%@", docPath, @"savetest"];
    
    [data writeToFile:savePath atomically:NO];
    
}

/*
 E cam intuitiv ce trebuie facut.. la saveProject NSData-ul ala trebuie salvat intr-un file ceva, iar cand dai load si il alegi sa se apeleze asta de mai jos cu NSData-ul ala. Asta iti da project
 */
-(void) loadProjectFromNSData
{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    NSString *savePath = [NSString stringWithFormat:@"%@%@", docPath, @"savetest"];
    
    NSData *data1 = [[NSFileManager defaultManager] contentsAtPath:savePath];
    
    
    NSDictionary* project = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* sample in project[@"sampleList"]){
       
        
        
        RRSample *newSample = [[RRSample alloc]initWithSampleName:sample[@"url"]
                                                     andSampleURL:@""
                                                       andChannel:[[sample valueForKey:@"channel"] integerValue]
                                                             andX:[[sample valueForKey:@"xvalue"] floatValue]];
        
        [newSample addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [newSample addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        [newSample addTarget:self action:@selector(dragEnded:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:newSample];
        [_eventList insertObject:newSample atIndex:[_eventList count]];
        [self.view bringSubviewToFront:_animationButton];
        
        
        // IMPORTANT ar fi ok sa se apeleze saveProject intr-un NSData global sau ceva de genul atunci cand te muti din ecranul asta in altul ca mai apoi sa se apeleze loadProject cand te intorci in editor, ca sa nu pierzi informatia.
    }
    NSLog(@"pam pam");
}

/*========================================================================================================================*/



/*========================================================================================================================*/
/*============================================== EDITOR FUNCTIONS ========================================================*/
/*========================================================================================================================*/


-(NSArray *)getColorArray
{
    NSMutableArray *auxArray = [[NSMutableArray alloc] init];
    
    for(int i = 0 ; i < [_sampleNamesArray count]; i++)
    {
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [_colorArray insertObject:color atIndex:i];
    }
    return auxArray;
}

-(void)addSampleToProject
{
    
    NSLog(@"w:%f,h:%f",self.view.frame.size.width,self.view.frame.size.height);
    
    if(_sampleListView == nil)
    {
        float Y_BCO = 13;
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(443, Y_BCO, 20, 20)];
        _backButton.backgroundColor = [UIColor blackColor];
        [_backButton setTitle:@"X" forState:UIControlStateNormal];
        _backButton.layer.cornerRadius = 1;
        [_backButton addTarget:self action:@selector(backToEditor) forControlEvents:UIControlEventTouchUpInside];
        
        _sampleListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _sampleListView.backgroundColor = [UIColor colorWithRed:0/255.0f green:1/255.0f blue:0/255.0f alpha:0.5f];
        float x_co = (self.view.frame.size.width - self.view.frame.size.height ) / 2;
        _sampleListTableView = [[UITableView alloc] initWithFrame:CGRectMake(x_co, 5, self.view.frame.size.height , self.view.frame.size.height - 10)];
        _sampleListTableView.backgroundColor = [UIColor whiteColor];
        _sampleListTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _sampleListTableView.layer.borderWidth = 1.0f;
        _sampleListTableView.layer.cornerRadius = 10.0f;
        _sampleListTableView.delegate = self;
        _sampleListTableView.dataSource = self;
        [_sampleListView addSubview:_sampleListTableView];
        [_sampleListView addSubview:_backButton];
        
        [self.view addSubview:_sampleListView];
    }
    else
    {
        [self.view bringSubviewToFront:_sampleListView];
        _sampleListView.hidden = NO;
    }
};

-(void)addChannel
{
    if(!_start)
    {
        _animationButton.center = CGPointMake(40, _animationButton.center.y);
    }
    UIView *channelView = [[UIView alloc] initWithFrame:CGRectMake(0, _index * 40, 1000, 40)]; //self.view.frame.size.width
    channelView.layer.borderWidth = 0.3f;
    channelView.layer.borderColor = [UIColor blackColor].CGColor;
    channelView.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:0.3f];
    
    RRMixerButton *mixerButton = [[RRMixerButton alloc] initWithFrame:CGRectMake(0, channelView.frame.origin.y, 40, 40) andChannelId:_index];
    [mixerButton addTarget:self action:@selector(openMixer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:channelView];
    [self.view addSubview:mixerButton];
    _index++;
    
    AudioPlayer *player = [[AudioPlayer alloc] init];
    player.volumeLevel = 1.0f;
    [_trackArray insertObject:player atIndex:[_trackArray count]];
}

-(void)openMixer:(id)sender
{
    RRMixerButton *auxButton = (RRMixerButton *)sender;
    AudioPlayer *auxPlayer = (AudioPlayer *)_trackArray[auxButton.channelId];
    auxPlayer.volumeLevel = 0.5f;
}

-(void)backToEditor
{
    for(int i = 0 ; i < [_sampleNamesArray count]; i++)
    {
        RRTableViewCell *auxCell = (RRTableViewCell *)[_sampleListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [auxCell.playButton stopSample];
    }
    
    _sampleListView.hidden = YES;
}

-(void)addSample:(id)sender
{
    RRSampleAddButton *addBtn = (RRSampleAddButton *)sender;
    RRSample *newSample = [[RRSample alloc]initWithSampleName:addBtn.sampleName andSampleURL:@""];
    newSample.trackId = 3;
    [newSample addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [newSample addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [newSample addTarget:self action:@selector(dragEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newSample];
    [_eventList insertObject:newSample atIndex:[_eventList count]];
    _sampleListView.hidden = YES;
    [self.view bringSubviewToFront:_animationButton];
}

-(void)stop
{
    _animationButton.center = CGPointMake(40, _animationButton.center.y);
    [self.view bringSubviewToFront:_animationButton];
    _animationButton.hidden = YES;
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

/*========================================================================================================================*/




/*========================================================================================================================*/
/*======================================== PLAY ANIMATION FUNCTIONS ======================================================*/
/*========================================================================================================================*/




-(void)setSnap
{
    _snap = !_snap;
}

-(void) dragEnded:(id) sender
{
    RRSample* currentSample = (RRSample*) sender;
    
    int separator = 40;
    int y = currentSample.center.y;
    int channel = 0;
    
    for (int i = 0; i < [_trackArray count]; i++){
        if (y < 40 +  (i)*separator + separator/2) {
            channel = i;
            break;
        }
    }

    CGRect frame = currentSample.frame;
    frame.origin.y = channel * 40 + 1 ;
    currentSample.frame = frame;
    currentSample.trackId = channel;
    
    if (_snap) {
        int closestSampleCoordonate = [self getClosestSampleHorizontalCoordonate:currentSample];
        if (closestSampleCoordonate != 9999) {
            CGRect frame = currentSample.frame;
            frame.origin.x = closestSampleCoordonate;
            currentSample.frame = frame;
        }
    }
    
}

-(int) getClosestSampleHorizontalCoordonate:(RRSample*) currentSample
{
    int vecinity = 50;
    int minDistance = 9999;
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
        return buttonToSnapTo.frame.origin.x + buttonToSnapTo.frame.size.width;
    }
    else
    {
        for(RRSample *sample in _eventList)
        {
            if(currentSample.trackId == sample.trackId && ![currentSample isEqual:sample])
            {
                return 9999;
            }
        }
        return 40;
    }
}

-(void)initPropertiesWithBaseValues
{
    _start = NO;
    _played = NO;
    _snap = NO;
    _tempoPlaceholder = 3;
    _eventList = [[NSMutableArray alloc] init];
    _trackArray = [[NSMutableArray alloc] init];
    _currentlyPausedPlayers = [[NSMutableArray alloc] init];
}

-(void)functionTest
{
    _animationButton.hidden = NO;
    [self.view bringSubviewToFront:_animationButton];
    if (!_start) {
        _start = YES;
        [self runAnimationController];
    } else {
        _start = NO;
        [self pausePlayers];
    }
}

-(void)runAnimationController
{
    if(_start) {
        [self animationCycle];
    }
}

-(void)animationCycle
{
    for (AudioPlayer* player in _currentlyPausedPlayers) {
        if (player){
            [player.audioPlayer play];
        }
    }
    [_currentlyPausedPlayers removeAllObjects];
    
    for(RRSample *object in _eventList)
    {
        if(!object.triggered
           && (_animationButton.frame.origin.x >= object.frame.origin.x)
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
                     completion:^(BOOL finished){[self runAnimationController];
                     }];
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    RRSample *aux = (RRSample *)sender;
    aux.triggered = NO;
    
    NSLog(@"%f",self.view.frame.size.height);
    
    if((aux.frame.origin.y + aux.frame.size.height >= self.view.frame.size.height - 30) && (aux.frame.origin.x + aux.frame.size.width >= self.view.frame.size.width - 30))
    {
        [aux removeFromSuperview];
        for(RRSample *item in _eventList) {
            if([item isEqual:aux]){
                [_eventList removeObject:aux];
                break;
            }
        }
        return;
    }
    else
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
}


/*========================================================================================================================*/


@end
