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

@interface EditorViewController () <UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic) NSMutableArray* trackArray;
@property(strong,nonatomic) NSMutableArray* sampleNameArray;
@property(strong,nonatomic) NSMutableArray* checkboxArray;

@property(strong, nonatomic) RRCheckBox *checkbox1;
@property(strong, nonatomic) RRCheckBox *checkbox2;
@property (nonatomic, strong) UIToolbar	*toolbar;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UISegmentedControl *barStyleSegControl;
@property (nonatomic, strong) IBOutlet UISwitch *tintSwitch;

@property (nonatomic, strong) IBOutlet UISwitch *imageSwitch;
@property (nonatomic, strong) IBOutlet UILabel *imageSwitchLabel;

@property (nonatomic, strong) IBOutlet UISegmentedControl *buttonItemStyleSegControl;
@property (nonatomic, strong) IBOutlet UIPickerView *systemButtonPicker;
@property (nonatomic, assign) UIBarButtonSystemItem	currentSystemItem;
@end

@implementation EditorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITableView* myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.height,self.view.frame.size.width - 20) style:UITableViewStylePlain];
    //setez ca tinta pentru datasource si delegate viewcontroller-url
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background2.jpg"]];
    [self.view addSubview:myTableView];
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background2.jpg"]];
    
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
    
//    UILabel *drums = [[UILabel alloc] initWithFrame:CGRectMake(65, 110, 80, 30)];
//    [drums setText:@"Bass"];
//    drums.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:drums];
//    UILabel *bass = [[UILabel alloc] initWithFrame:CGRectMake(200, 110, 80, 30)];
//    bass.backgroundColor = [UIColor clearColor];
//    [bass setText:@"Drums"];
//    [self.view addSubview:bass];
    
//    _checkbox1 = [[RRCheckBox alloc] initWithCoordinates:CGPointMake(70, 70)];
//    [self.view addSubview:_checkbox1];
    _checkbox2 = [[RRCheckBox alloc] initWithCoordinates:CGPointMake(200, 70)];

    _trackArray = [[NSMutableArray alloc] init];
    _sampleNameArray = [[NSMutableArray alloc] initWithObjects:@"drums.wav",@"bass.wav", nil];
    _checkboxArray = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view.
    [self addTrack];
    [self addTrack];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //returns number of rows
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //returns number of samples
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    RRCheckBox *playButton = [[RRCheckBox alloc] initWithCoordinates:CGPointMake(10, 10)];
    [[cell contentView] addSubview:playButton];
    [_checkboxArray addObject:playButton];
    
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,10,200,60)];
    cellLabel.text = [NSString stringWithString:_sampleNameArray[indexPath.row]];
    cellLabel.textColor = [UIColor blackColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    [[cell contentView] addSubview:cellLabel];
    return cell;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)createToolbarItems
{
	// match each of the toolbar item's style match the selection in the "UIBarButtonItemStyle" segmented control
	UIBarButtonItemStyle style = [self.buttonItemStyleSegControl selectedSegmentIndex];
    
	// create the system-defined "OK or Done" button
    UIBarButtonItem *systemItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:self.currentSystemItem
                                                                                target:self
                                                                                action:@selector(play)];
	systemItem.style = style;
	
//	// flex item used to separate the left groups items and right grouped items
//	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                              target:nil
//                                                                              action:nil];
    
//	// create a special tab bar item with a custom image and title
//	UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"segment_tools"]
//                                                                 style:UIBarButtonItemStyleBordered
//                                                                target:self
//                                                                action:@selector(action:)];
    
//	// Set the accessibility label for an image bar item.
//	[infoItem setAccessibilityLabel:NSLocalizedString(@"ToolsIcon", @"")];
//	
//    // create a custom button with a background image with black text for its title:
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
    
    UIBarButtonItem *customItem3 = [[UIBarButtonItem alloc] initWithTitle:@"Stop"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(goToMainView)];
    [customItem3 setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    
    [self.toolbar setItems:@[customItem1,customItem2,customItem3] animated:NO];
}

-(void)goToMainView
{
}

-(void)addTrack
{
    AudioPlayer *track = [[AudioPlayer alloc] init];
    [_trackArray addObject:track];
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


//AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:audioFileURL options:nil];
//CMTime audioDuration = audioAsset.duration;
//float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
//
//
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
}

-(void) play
{
    for(int i = 0 ; i < _checkboxArray.count; i++)
    {
//        _checkbox2 = [_checkboxArray objectAtIndex:i];
//        if(_checkbox2.checked)
//        {
            [_trackArray[i] startPlaying:_sampleNameArray[i] numberOfLoops:4 volumeLevel:0.8f];
//        }
    }
//    
//    if(_checkbox1.checked)
//    {
//        NSLog(@"Playing bass");
//        [_trackArray[0] startPlaying:@"bass.wav" numberOfLoops:4 volumeLevel:0.9f];
//    }
//    if(_checkbox2.checked)
//    {
//        NSLog(@"Playing drums");
//        [_trackArray[1] startPlaying:@"drums.wav" numberOfLoops:2 volumeLevel:0.6f];
//    }
}

-(void)stop
{
    for(AudioPlayer *player in _trackArray)
    {
        [player stopPlaying];
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
