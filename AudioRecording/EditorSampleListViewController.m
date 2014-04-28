//
//  EditorSampleListViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 24/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "EditorSampleListViewController.h"
#import "RRSampleListPlayButton.h"
#import "EditorViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface EditorSampleListViewController () <UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic) NSMutableArray *sampleNameArray;
@property(strong, nonatomic) UITableView *myTableView;
@end

@implementation EditorSampleListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationLandscapeRight);
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.width) style:UITableViewStylePlain];
    CGRect tableFrame = [self.view frame];
    tableFrame.size.height = 170;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view setFrame:tableFrame];
    _myTableView.backgroundColor = [UIColor clearColor];
    //setez ca tinta pentru datasource si delegate viewcontroller-url
    
    _myTableView.separatorColor = [UIColor clearColor];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    
    [self.view addSubview:_myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //returns number of rows
    return [_sampleNameArray count] - 1;
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
    RRSampleListPlayButton *playButton = [[RRSampleListPlayButton alloc] init1];
    playButton.sampleName = _sampleNameArray[indexPath.row];
//    NSLog(@"%@",playButton.sampleName);
//    playButton.sampleUrl = auxSample.sampleUrl;
//    playButton.sampleHash = auxSample.sampleHash;
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(90,5,200,14)];
    [cellLabel setFont:[UIFont systemFontOfSize:12.0f]];
    cellLabel.text = [_sampleNameArray[indexPath.row] substringWithRange:NSMakeRange(0, [_sampleNameArray[indexPath.row] rangeOfString: @"."].location)];
    cellLabel.textColor = [UIColor blackColor];
    cell.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cell.layer.borderWidth = 0.4f;
    cell.layer.cornerRadius = 2.0f;
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 5, 50, 50)];
    addButton.backgroundColor = [UIColor greenColor];
    [addButton addTarget:self action:@selector(addb) forControlEvents:UIControlEventTouchUpInside];
    [[cell contentView] addSubview:addButton];
   // RRSampleListDeleteButton *deleteButton = [[RRSampleListDeleteButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
   // deleteButton.index = indexPath.row;
    //[deleteButton addTarget:self action:@selector(removeSample:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[[cell contentView] addSubview:deleteButton];
    [[cell contentView] addSubview:cellLabel];
    [[cell contentView] addSubview:playButton];
    return cell;
}

-(void)addb
{
    NSLog(@"Add sample");
    _addedSample = @"DubstepDrums1.wav";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; // Or pause
//    [_rec stopPlaying];
}


- (void)removeSample:(id)sender
{
//    RRSampleListDeleteButton *aux = (RRSampleListDeleteButton *)sender;
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    
//    NSString *filePath = [documentsPath stringByAppendingPathComponent:_sampleNamesArray[aux.index]];
//    NSError *error;
//    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
//    if (success) {
//        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
//        [removeSuccessFulAlert show];
//        [_sampleNamesArray removeObjectAtIndex:aux.index];
//        [_myTableView reloadData];
//    }
//    else
//    {
//        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
//    }
}

-(NSArray *)listFileAtPath
{
    //-----> LIST ALL FILES <-----//
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0] error:NULL];
    return directoryContent;
}

- (void)getSamples
{

}

@end
