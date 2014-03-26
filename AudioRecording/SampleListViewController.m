//
//  SampleListViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 19/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "SampleListViewController.h"
#import "RecordingViewController.h"

@interface SampleListViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation SampleListViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    
    UISwipeGestureRecognizer *swipeLeftToRecording = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    swipeLeftToRecording.numberOfTouchesRequired = 1;
    swipeLeftToRecording.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftToRecording];
    
    [super viewDidLoad];
    NSLog(@"Second view");
	// Do any additional setup after loading the view.
    
    UITableView* myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style:UITableViewStylePlain];
    
    NSString *sampleString = [self getSamplesNameContent];
    sampleNamesArray = [sampleString componentsSeparatedByString:@"\n"];
    
    //setez ca tinta pentru datasource si delegate viewcontroller-url
    
    myTableView.dataSource = self;
    myTableView.delegate = self;
    
    [self.view addSubview:myTableView];
}

- (void) swipeLeft
{
    NSLog(@"Left swipe");
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setDuration:0.40];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.view.layer addAnimation:animation forKey:kCATransition];
    
    
    RecordingViewController * recordingView = [[RecordingViewController alloc] init];
    [self presentViewController:recordingView animated:YES completion:NULL];
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
	return 100.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor orangeColor];
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    [playButton setTitle:@"Play" forState:normal];
    playButton.backgroundColor = [UIColor greenColor];
    playButton.layer.borderColor = [[UIColor blackColor] CGColor];
    playButton.layer.borderWidth = 4;
    playButton.layer.cornerRadius = 30;

    [[cell contentView] addSubview:playButton];
    
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,10,200,60)];
    cellLabel.text = [sampleNamesArray[indexPath.row] substringWithRange:NSMakeRange(0, [sampleNamesArray[indexPath.row] rangeOfString: @"."].location)];
    cellLabel.textColor = [UIColor blackColor];
    
    [[cell contentView] addSubview:cellLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordingViewController * recordingView = [[RecordingViewController alloc] init];
    NSString *testString = sampleNamesArray[indexPath.row];
    [recordingView playRecording:testString];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Sample list";
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
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Alerta" message:sampleList delegate:self cancelButtonTitle:@"Stop" otherButtonTitles:nil];
//        [alert show];
        return sampleList;
    }
    return @"";
}

@end
