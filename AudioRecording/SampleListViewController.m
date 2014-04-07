//
//  SampleListViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 19/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "SampleListViewController.h"
#import "AudioPlayer.h"

@interface SampleListViewController () <UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) AudioPlayer *rec;
@end

NSArray *sampleNamesArray;

@implementation SampleListViewController

- (void)viewDidDisappear:(BOOL)animated
{

}

- (BOOL)prefersStatusBarHidden {return YES;}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
    NSString *sampleString = [self getSamplesNameContent];
    sampleNamesArray = [sampleString componentsSeparatedByString:@"\n"];
    
    UITableView* myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20) style:UITableViewStylePlain];
    
    //setez ca tinta pentru datasource si delegate viewcontroller-url
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    
    [self.view addSubview:myTableView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _rec = [[AudioPlayer alloc] init];
    self.title = @"Samples";
    NSLog(@"Second view");
	// Do any additional setup after loading the view.
//    
//    UITableView* myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];
//
//    //setez ca tinta pentru datasource si delegate viewcontroller-url
//    
//    myTableView.dataSource = self;
//    myTableView.delegate = self;
//    
//    [self.view addSubview:myTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //returns number of rows
    return [sampleNamesArray count] - 1;
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
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 48, 48)];
    [playButton setBackgroundImage:[UIImage imageNamed:@"button_play_green.png"] forState:UIControlStateNormal];
    cell.layer.borderWidth = 0.6f;
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    playButton.layer.borderColor = [[UIColor blackColor] CGColor];
    playButton.layer.borderWidth = 3.5f;
    playButton.layer.cornerRadius = 24;

    [[cell contentView] addSubview:playButton];
    
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,10,200,60)];
    cellLabel.text = [sampleNamesArray[indexPath.row] substringWithRange:NSMakeRange(0, [sampleNamesArray[indexPath.row] rangeOfString: @"."].location)];
    cellLabel.textColor = [UIColor blackColor];
    
    [[cell contentView] addSubview:cellLabel];
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; // Or pause
    [_rec stopPlaying];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_rec startPlaying:sampleNamesArray[indexPath.row] numberOfLoops:4 volumeLevel:1.0f];
}

- (NSString*) getSamplesNameContent{
    
    NSLog(@"DisplayContent");
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    NSString *sampleNameFile = [docPath stringByAppendingString:@"/samples.csv"];
    if([[NSFileManager defaultManager] fileExistsAtPath:sampleNameFile])
    {
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:sampleNameFile];
        NSString *sampleList = [[NSString alloc] initWithData:[fileHandle availableData] encoding:NSUTF8StringEncoding];
        [fileHandle closeFile];
        return sampleList;
    }
    return @"";
}

@end
