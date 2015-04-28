//
//  LoginView.m
//  shaorMEv3
//
//  Created by LaboratoriOS Cronian Academy on 01/04/15.
//  Copyright (c) 2015 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "LoginView.h"
#import "ViewController.h"


@interface LoginView () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
- (IBAction)logoutMethod:(UIButton *)sender;

@property (strong, nonatomic) UITableView *tabel;
@property (strong, nonatomic) NSArray *dataSource;

@end

@implementation LoginView {
    NSArray *tableData;
}
static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor greenColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    PFQuery *query = [PFQuery queryWithClassName:@"Shaormerii"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count>0){
            tableData = objects;
            [self.tableView reloadData];
        }
    }];
//    PFObject *newShaormerie = [PFObject objectWithClassName:@"Shaormerii"];
//    newShaormerie[@"name"]=@"§KebabMania Kogalniceanu";
//    newShaormerie[@"rating"]=@3.5;
//    newShaormerie[@"averagePrice"]=@7;
//    newShaormerie[@"noCheckIn"]=@180;
//    [newShaormerie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if(succeeded){
//            NSLog(@"UPLOAD SUCCESFUL!!!!!!!");
//        }
//        else{
//            NSLog(@"NOPE!!!!!!!!!!!!!");
//        }
//    }];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return tableData ? 1 : 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableData? tableData.count : 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RButtonCell *cell = (RButtonCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath: indexPath];
    
    PFObject *item = [tableData objectAtIndex:indexPath.row];
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@", item[@"name"]]];
    PFFile *file = item[@"image"];
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if(!error){
            cell.imageLabel.image = [UIImage imageWithData:data];
        }
    }];
    [cell.yearLabel setText:[NSString stringWithFormat:@"%@", item[@"rating"]]];
    return cell;
}

- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}		

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //fa un dic cu chestiile pe care trebuie sa le trimiti la noul view
    //fa un object de tipul viewului pe care trebuie sa le incarce
    //instantiaza-l cu dictu cu chestii de trimis
    //incarca viewul acela
//    
//    ViewController *viewctrl = [[ViewController alloc] init];
//    UINavigationController *navCtrl = [[UINavigationController alloc] init];
//    [navCtrl pushViewController:viewctrl animated:YES];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Alerta" message:[NSString stringWithFormat:@"%@ %@", @"Ai selectat shaormeria ", @"kebab"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display Alert Message
    [messageAlert show];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)logoutMethod:(UIButton *)sender {
    [PFUser logOut];
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}


@end
