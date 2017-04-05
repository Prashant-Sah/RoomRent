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

@end

@implementation SignInViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _emailAddTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.emailAddTextField.text = @"roomrent";
    self.passwordTextField.text = @"roomrent";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

}

-(void)makelogin{
    
    NSString *username = self.emailAddTextField.text;
    NSString *password = self.passwordTextField.text;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *params = @{@"username": username,
                             @"password": password,
                             @"device_type": DEVICE_TYPE,
                             @"device_id": DEVICE_TOKEN};
    
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:APITOKEN] forHTTPHeaderField:@"Authorization"];
    [manager POST: [BASEURL stringByAppendingString:@"login"] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        NSString *code = [responseObject valueForKey:@"code"];
        NSLog(@"%@", code);
        if ([code isEqualToString:LOGIN_SUCCESS ])
        {
            [self gotoMain];
        }
        else{
            
            NSString *errorMessage = [responseObject valueForKey:@"message"];
            //Alerter *alertObject = [[Alerter alloc] init];
            
            [[Alerter sharedInstance] createAlert:@"Error" message:errorMessage viewController:self completion:^{
                NSLog(@"Error");
            }];
        }
        
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
