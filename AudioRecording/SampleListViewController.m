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

@interface SampleListViewController () <UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) AudioPlayer *rec;
@property(strong,nonatomic) NSMutableArray *sampleNamesArray;
@property(strong, nonatomic) UITableView *myTableView;
@property(strong,nonatomic) NSMutableArray *samplesArray;
@end



@implementation SampleListViewController

- (void)viewDidDisappear:(BOOL)animated
{

}

- (BOOL)prefersStatusBarHidden {return YES;}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
    
    _sampleNamesArray = [[NSMutableArray alloc] initWithArray:[self listFileAtPath]];
    _samplesArray = [[NSMutableArray alloc] init];
    [self getSamples];
    
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
    [self getSamples];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //returns number of rows
    //return [_sampleNamesArray count] - 1;
    return [_samplesArray count];
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
    
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    DownloadedSamples *auxSample = (DownloadedSamples *)_samplesArray[indexPath.row];
    RRSampleListPlayButton *playButton = [[RRSampleListPlayButton alloc] init1];
    playButton.sampleName = auxSample.sampleUrl;
    NSLog(@"%@",playButton.sampleName);
    playButton.sampleUrl = auxSample.sampleUrl;
    playButton.sampleHash = auxSample.sampleHash;
//    playButton.sampleName = _sampleNamesArray[indexPath.row];
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,5,200,14)];
    [cellLabel setFont:[UIFont systemFontOfSize:12.0f]];
    //cellLabel.text = [_sampleNamesArray[indexPath.row] substringWithRange:NSMakeRange(0, [_sampleNamesArray[indexPath.row] rangeOfString: @"."].location)];
    cellLabel.text = [auxSample.sampleName substringWithRange:NSMakeRange(0, [auxSample.sampleName rangeOfString: @"."].location)];
    cellLabel.textColor = [UIColor blackColor];
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth = 0.4f;
    RRSampleListDeleteButton *deleteButton = [[RRSampleListDeleteButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    deleteButton.index = indexPath.row;
    [deleteButton addTarget:self action:@selector(removeSample:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell contentView] addSubview:deleteButton];
    [[cell contentView] addSubview:cellLabel];
    [[cell contentView] addSubview:playButton];
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; // Or pause
    [_rec stopPlaying];
}


- (void)removeSample:(id)sender
{
    RRSampleListDeleteButton *aux = (RRSampleListDeleteButton *)sender;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:_sampleNamesArray[aux.index]];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
        [_sampleNamesArray removeObjectAtIndex:aux.index];
        [_myTableView reloadData];
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

-(NSArray *)listFileAtPath
{
    //-----> LIST ALL FILES <-----// 
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0] error:NULL];
    return directoryContent;
}

- (void)getSamples
{
    // Create your request string with parameter name as defined in PHP file
    NSString *myRequestString = @"token=673d0fefbee71ca8875ff3b5ac26f98011ade255";

    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://app.etajul9.ro/api/get_samples.php"]];
    // set Request Type
    [request setHTTPMethod: @"POST"];
    // Set content-type
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    // Set Request Body
    [request setHTTPBody: myRequestData];
    // Now send a request and get Response
    NSData *returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: nil error: nil];
    // Log Response
    NSString *response = [[NSString alloc] initWithBytes:[returnData bytes] length:[returnData length] encoding:NSUTF8StringEncoding];
   // NSLog(@"%@",response);
    
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    
    for(NSDictionary *key in dict) {
        
        DownloadedSamples *sample = [[DownloadedSamples alloc] initWithSampleName:[NSString stringWithFormat:@"%@",[key objectForKey:@"sample_name"]] andSampleUrl:[NSString stringWithFormat:@"%@",[key objectForKey:@"sample_url"]] andHash:[NSString stringWithFormat:@"%@",[key objectForKey:@"sample_hash"]]];
        NSLog(@"%@ %@",sample.sampleName,sample.sampleUrl);
        [_samplesArray insertObject:sample atIndex:[_samplesArray count]];
    }
  //  return auxArray;
}

@end
