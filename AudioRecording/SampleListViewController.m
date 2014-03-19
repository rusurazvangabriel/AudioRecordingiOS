//
//  SampleListViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 19/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "SampleListViewController.h"
#import "ViewController.h"

@interface SampleListViewController ()

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
    
    
    ViewController * recordingView = [[ViewController alloc] init];
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
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //returns number of samples
    return [sampleNamesArray count] - 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"Play Sample";

    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sampleNamesArray objectAtIndex:section];
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
