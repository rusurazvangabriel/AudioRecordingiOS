//
//  LoginViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 31/03/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "SignUpViewController.h"
#import "Session.h"

@interface LoginViewController ()

@property(strong,nonatomic) RRButton *signInButton;
@property(strong,nonatomic) RRButton *signUpButton;
@property(strong,nonatomic) MainViewController *mainView;
@property(strong,nonatomic) SignUpViewController *registerView;
@property(strong,nonatomic) RRTextField *usernameTextField;
@property(strong,nonatomic) RRTextField *passwordTextField;
@property(strong,nonatomic) UILabel *signUpLabel;
@property(nonatomic,assign, getter = isFrameUp) BOOL frameUp;

@end

@implementation LoginViewController



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
    self.frameUp = NO;
	
    _mainView = [[MainViewController alloc] init];
    _registerView = [[SignUpViewController alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundMain.jpg"]];
    
    float X_Co = (self.view.frame.size.width - 240)/2;
    float X_Image = (self.view.frame.size.width - 148)/2;
    
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(X_Image, 90, 140, 140)];
    
    [logo setImage:[UIImage imageNamed:@"logo.png"]];
    [self.view addSubview:logo];
    
    _usernameTextField = [[RRTextField alloc] initWithCoordinates:X_Co y:280];
    _usernameTextField.placeholder = @"Username";
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.delegate = self;
    [self.view addSubview:_usernameTextField];
    
    _passwordTextField = [[RRTextField alloc] initWithCoordinates:X_Co y:320];
    _passwordTextField.placeholder = @"Password";
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.delegate = self;
    [self.view addSubview:_passwordTextField];
    
    _signInButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 360, 240, 40)];
    _signInButton.backgroundColor = [UIColor colorWithRed:0/255.0f green:140/255.0f blue:255/255.0f alpha:1.0f];
    [_signInButton setTitle:@"Sign In" forState:normal];
    [_signInButton setTitleColor:[UIColor whiteColor] forState:normal];
    
    [_signInButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signInButton];
    
    _signUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_Co, 425, 240, 40)];
    _signUpLabel.backgroundColor = [UIColor clearColor];
    _signUpLabel.text = @"Don't have an account yet?";
    [_signUpLabel setTextColor:[UIColor darkGrayColor]];
    _signUpLabel.font = [UIFont systemFontOfSize:12];
    _signUpLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_signUpLabel];
    
    
    
    _signUpButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 460, 240, 40)];
    [_signUpButton setTitle:@"Sign Up" forState:normal];
    _signUpButton.backgroundColor = [UIColor colorWithRed:61/255.0f green:200/255.0f blue:211/255.0f alpha:1.0f];
    [_signUpButton addTarget:self action:@selector(goToSignUpView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signUpButton];
    
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {return YES;}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![_usernameTextField.text isEqualToString:@""]) {
        [_usernameTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    }
    
    
    if(![_passwordTextField.text isEqualToString:@""]){
        [_passwordTextField resignFirstResponder];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 216);
            self.frameUp = NO;
        }];
    }
    
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.isFrameUp) {
        self.frameUp  = YES;
        [UIView animateWithDuration:0.3  animations:^{
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 216);
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), UIInterfaceOrientationPortrait);
}

- (void) goToSignUpView
{
    [self.navigationController pushViewController:_registerView animated:YES];
}

- (void)login
{
//    // Create your request string with parameter name as defined in PHP file
//    NSString *myRequestString = [NSString stringWithFormat:@"email=%@&password=%@",_usernameTextField.text,_passwordTextField.text];
//    
//    // Create Data from request
//    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://app.etajul9.ro/api/login.php"]];
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
//    NSLog(@"%@",response);
//    
//    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *e;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
//    
//    if([[dict objectForKey:@"succes"] isEqualToString:@"Valid"])
//    {
//        Session *currentSession = [[Session alloc] initWithSessionID:[dict objectForKey:@"session"]];
//        [self.navigationController pushViewController:_mainView animated:YES];
//    }
    [self.navigationController pushViewController:_mainView animated:YES];
}

@end
