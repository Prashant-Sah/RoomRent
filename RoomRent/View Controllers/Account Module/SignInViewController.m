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
    self.emailAddTextField.text = @"Prashant";
    self.passwordTextField.text = @"12345";
    
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
                             @"device_id": DEVICE_TOKEN};
    
    [[APICaller sharedInstance] callApi:@"login" parameters:params headerFlag : false viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@",responseObjectDictionary);
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        
        NSLog(@"%@",responseObjectDictionary);
        if ([code isEqualToString:LOGIN_SUCCESS ]){
            
            [[NSUserDefaults standardUserDefaults] setObject:[responseObjectDictionary valueForKey:@"api_token"] forKey:@"userApiToken"];
            
            [[User alloc] initUser:[responseObjectDictionary valueForKey:@"name"] username:[responseObjectDictionary valueForKey:@"username"] email:[responseObjectDictionary valueForKey:@"email"] mobile:[responseObjectDictionary valueForKey:@"mobile"]];
            
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
    
    [[Navigator sharedInstance] makeRootViewController:@"Main" viewController:nil tabBarController:@"MyTabBarController"];
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
