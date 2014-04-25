//
//  SampleListViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 19/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "SampleListViewController.h"
#import "AudioPlayer.h"
#import "RRSampleListPlayButton.h"
#import "RRSampleListDeleteButton.h"
#import "Session.h"
#import "DownloadedSamples.h"
#import "RRSampleAddButton.h"
#import "RRTableViewCell.h"

@interface SampleListViewController () <UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) AudioPlayer *rec;
@property(strong,nonatomic) NSMutableArray *sampleNamesArray;
@property(strong, nonatomic) UITableView *myTableView;
@property(strong,nonatomic) NSMutableArray *samplesArray;
@end



@implementation SampleListViewController

- (BOOL)prefersStatusBarHidden {return YES;}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
    
    _sampleNamesArray = [[NSMutableArray alloc] initWithArray:[self listFileAtPath]];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-20) style:UITableViewStylePlain];
    //setez ca tinta pentru datasource si delegate viewcontroller-url
    
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _rec = [[AudioPlayer alloc] init];
    self.title = @"Samples";
    NSLog(@"Second view");
//    [self getSamples];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    RRSampleListDeleteButton *delBtn = [[RRSampleListDeleteButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    delBtn.index = indexPath.row;
    [delBtn addTarget:self action:@selector(removeSample:) forControlEvents:UIControlEventTouchUpInside];
    [[cell contentView] addSubview:delBtn];
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; // Or pause
    [_rec stopPlaying];
}


- (void)removeSample:(id)sender
{
    NSLog(@"Delete sample");
    RRSampleListDeleteButton *aux = (RRSampleListDeleteButton *)sender;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:_sampleNamesArray[aux.index]];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        UIAlertView *removeSuccessFulAlert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",_sampleNamesArray[aux.index]] message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
        [_sampleNamesArray removeObjectAtIndex:aux.index];
        [_myTableView reloadData];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

//- (void)getSamples
//{
//    // Create your request string with parameter name as defined in PHP file
//    NSString *myRequestString = @"token=673d0fefbee71ca8875ff3b5ac26f98011ade255";
//
//    // Create Data from request
//    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://app.etajul9.ro/api/get_samples.php"]];
//    // set Request Type
//    [request setHTTPMethod: @"POST"];
//    // Set content-type
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
//    // Set Request Body
//    [request setHTTPBody: myRequestData];
//    // Now send a request and get Response
//    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
//    // Log Response
//    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
//   // NSLog(@"%@",response);
//    
//    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *e;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
//    
//    for(NSDictionary *key in dict) {
//        
//        DownloadedSamples *sample = [[DownloadedSamples alloc] initWithSampleName:[NSString stringWithFormat:@"%@",[key objectForKey:@"sample_name"]] andSampleUrl:[NSString stringWithFormat:@"%@",[key objectForKey:@"sample_url"]] andHash:[NSString stringWithFormat:@"%@",[key objectForKey:@"sample_hash"]]];
//        NSLog(@"%@ %@",sample.sampleName,sample.sampleUrl);
//        [_samplesArray insertObject:sample atIndex:[_samplesArray count]];
//    }
//  //  return auxArray;
//}

@end
