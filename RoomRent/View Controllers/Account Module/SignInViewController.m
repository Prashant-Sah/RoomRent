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
@property UIActivityIndicatorView *activityIndicator;
@property BOOL emailisValid;
@property BOOL mobileisValid;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _emailAddTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailAddTextField.tag = EMAIL_ADDRESS_TEXTFIELD;
    _passwordTextField.tag = PASSWORD_TEXTFIELD;
    self.emailAddTextField.text = @"baby";
    self.passwordTextField.text = @"baby";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
}

-(void)makelogin{
    
    NSString *username = self.emailAddTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSDictionary *params = @{@"identity": username,
                             @"password": password,
                             @"device_type": DEVICE_TYPE,
                             @"device_token": DEVICE_TOKEN};
    
    [[APICaller sharedInstance] callApi:LOGIN_PATH useToken:false parameters:params imageData:nil fileName:nil viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@",responseObjectDictionary);
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        
        if ([code isEqualToString:LOGIN_SUCCESS ]){
            
            [[NSUserDefaults standardUserDefaults] setObject:[responseObjectDictionary valueForKey:@"api_token"] forKey:@"userApiToken"];
            
            User *user = [[User alloc] initUserFromJson:[responseObjectDictionary valueForKey:@"user"]];
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:USER_DATA_KEY];
            [self.activityIndicator stopAnimating];
            [self gotoMain];
            
        }
        else{
            NSString *errorMessage = [responseObjectDictionary valueForKey:@"message"];
            [[Alerter sharedInstance] createAlert:@"Error" message:errorMessage useCancelButton:false viewController:self completion:^{
            }];
        }
    }];
}

-(void)gotoMain{
    
    [[DatabaseLoader sharedInstance] loadPostsToDatabaseWithTimeStamp:nil andOlder:@"false" andType:@"all"];
    [[Navigator sharedInstance] setRevealViewControllerWithFrontTabViewController:@"MyTabBarController" sideViewController:@"SideBarViewController" storyBoard:@"Main"];
}

// MARK: button handlers

- (IBAction)forgotPasswordPressed:(UIButton *)sender {
    [[Navigator sharedInstance] presentWithNavigationController:self viewController:@"ForgotPasswordViewController"];
}

- (IBAction)signUpPressed:(UIButton *)sender {
    
    [[Navigator sharedInstance] presentWithNavigationController:self viewController:@"SignUpViewController"];
}

- (IBAction)signInPressed:(UIButton *)sender {
    [self makelogin];
}


@end
