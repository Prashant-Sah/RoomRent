//
//  SignInViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 3/31/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property BOOL emailisValid;
@property BOOL mobileisValid;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _emailAddTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailAddTextField.tag = EMAIL_ADDRESS_TEXTFIELD;
    _passwordTextField.tag = PASSWORD_TEXTFIELD;
    //self.emailAddTextField.text = @"baby";
    //self.passwordTextField.text = @"baby";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
}

-(void)makelogin{
    
    NSString *username = self.emailAddTextField.text;
    NSString *password = self.passwordTextField.text;
    
    //_mobileisValid = [[Validator sharedInstance] validateMobile:_passwordTextField.text viewController:self];
    //_emailisValid  = [[Validator sharedInstance] validateEmail:_emailAddTextField.text viewController:self];
    
    NSDictionary *params = @{@"identity": username,
                             @"password": password,
                             @"device_type": DEVICE_TYPE,
                             @"device_id": DEVICE_TOKEN};
    
    [[APICaller sharedInstance] callSome:@"login" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        
        if ([code isEqualToString:LOGIN_SUCCESS ]){
            
            [self gotoMain];
            
        }
        else{
            NSString *errorMessage = [responseObjectDictionary valueForKey:@"message"];
            [[Alerter sharedInstance] createAlert:@"Error" message:errorMessage viewController:self completion:^{
            }];
        }
    }];
    
    
}


-(void)gotoMain{
    
    //AppDelegate* sharedDelegate = [AppDelegate appDelegate];
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MyTabBarController"];
    window.rootViewController = tabBarController;
    [window makeKeyAndVisible];
    
}

// MARK: button handlers

- (IBAction)forgotPasswordPressed:(UIButton *)sender {
    UIViewController *forgotPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:forgotPasswordVC];
    [self presentViewController:navVC animated:true completion:nil];
}

- (IBAction)signUpPressed:(UIButton *)sender {
    
    UIViewController *signUpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    //[self.navigationController pushViewController:signUpVC animated:true];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:signUpVC];
    [self.navigationController presentViewController:navVC animated:true completion:nil];
}

- (IBAction)signInPressed:(UIButton *)sender {
    
    [self makelogin];
    
}


@end
