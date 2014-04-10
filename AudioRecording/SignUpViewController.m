//
//  SignUpViewController.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 09/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "RRTextField.h"
#import "RRButton.h"
#import "MainViewController.h"

@interface SignUpViewController ()

@property(strong,nonatomic) RRTextField* usernameTextField;
@property(strong,nonatomic) RRTextField* emailTextField;
@property(strong,nonatomic) RRTextField* passwordTextField;
@property(strong,nonatomic) RRTextField* passwordAgainTextField;
@property(strong,nonatomic) RRButton* signUpButton;
@property(strong,nonatomic) MainViewController *mainView;
@end

@implementation SignUpViewController

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
    _mainView = [[MainViewController alloc] init];
	 self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background2.jpg"]];
    float X_Co = (self.view.frame.size.width - 240)/2;
    
    _usernameTextField = [[RRTextField alloc] initWithCoordinates:X_Co y:100];
    _usernameTextField.placeholder = @"Username";
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.delegate = self;
    [self.view addSubview:_usernameTextField];
    
    _emailTextField = [[RRTextField alloc] initWithCoordinates:X_Co y:145];
    _emailTextField.placeholder = @"Email";
    _emailTextField.returnKeyType = UIReturnKeyNext;
    _emailTextField.delegate = self;
    [self.view addSubview:_emailTextField];
    
    _passwordTextField = [[RRTextField alloc] initWithCoordinates:X_Co y:190];
    _passwordTextField.placeholder = @"Password";
    _passwordTextField.returnKeyType = UIReturnKeyNext;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = YES;
    [self.view addSubview:_passwordTextField];
    
    _passwordAgainTextField = [[RRTextField alloc] initWithCoordinates:X_Co y:235];
    _passwordAgainTextField.placeholder = @"Check password";
    _passwordAgainTextField.returnKeyType = UIReturnKeyNext;
    _passwordAgainTextField.delegate = self;
    _passwordAgainTextField.secureTextEntry = YES;
    
    [self.view addSubview:_passwordAgainTextField];
    
    _signUpButton = [[RRButton alloc] initWithFrame:CGRectMake(X_Co, 280, 240, 35)];
    [_signUpButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [_signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signUpButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUp
{
    // Create your request string with parameter name as defined in PHP file
    NSString *myRequestString = [NSString stringWithFormat:@"username=%@&email=%@&password=%@&password2=%@",_usernameTextField.text,_emailTextField.text,_passwordTextField.text,_passwordAgainTextField.text];
    
    // Create Data from request
    NSData *myRequestData = [NSData dataWithBytes: [myRequestString UTF8String] length: [myRequestString length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://app.etajul9.ro/api/register.php"]];
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
    NSLog(@"%@",response);
    
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&e];
    
    if([[dict objectForKey:@"valid"] isEqualToString:@"1"])
    {
       [self.navigationController pushViewController:_mainView animated:YES];
    }
}

@end
