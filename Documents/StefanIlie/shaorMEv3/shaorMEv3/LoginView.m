//
//  LoginView.m
//  shaorMEv3
//
//  Created by LaboratoriOS Cronian Academy on 01/04/15.
//  Copyright (c) 2015 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "LoginView.h"


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
    self.view.backgroundColor=[UIColor blueColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    PFQuery *query = [PFQuery queryWithClassName:@"Shaormerii"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects.count>0){
            tableData = objects;
            [self.tableView reloadData];
        }
    }];
    //    self.dataSource = @[
    //                        @{ @"title" : @"Gravity", @"year" : @(2013) },
    //                        @{ @"title" : @"12 Years a Slave", @"year" : @(2013) },
    //                        @{ @"title" : @"Before Midnight", @"year" : @(2013) },
    //                        @{ @"title" : @"American Hustle", @"year" : @(2013) },
    //                        @{ @"title" : @"Blackfish", @"year" : @(2013) },
    //                        @{ @"title" : @"Captain Phillips", @"year" : @(2013) },
    //                        @{ @"title" : @"Nebraska", @"year" : @(2013) },
    //                        @{ @"title" : @"Rush", @"year" : @(2013) },
    //                        @{ @"title" : @"Frozen", @"year" : @(2013) },
    //                        @{ @"title" : @"Star Trek Into Darkness", @"year" : @(2013) },
    //                        @{ @"title" : @"The Conjuring", @"year" : @(2013) },
    //                        @{ @"title" : @"Side Effects", @"year" : @(2013) },
    //                        @{ @"title" : @"The Attack", @"year" : @(2013) },
    //                        @{ @"title" : @"The Hobbit", @"year" : @(2013) },
    //                        @{ @"title" : @"We Are What We Are", @"year" : @(2013) },
    //                        @{ @"title" : @"Something in the Air", @"year" : @(2013) }
    //                        ];
    [self.tableView reloadData];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return tableData ? 1 : 0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableData? tableData.count : 0;
}

- (void)didTapButton:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
    //    [cell.actionButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchDragInside];
    cell.imageLabel.image = [UIImage imageNamed:@"ciorba.png"];
    [cell.yearLabel setText:[NSString stringWithFormat:@"%@", item[@"rating"]]];
    //    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    //
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    //
    //    if (cell == nil) {
    //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    //    }
    //
    //    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    //    cell.imageView.image = [UIImage imageNamed:@"ciorba.png"];
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

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
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