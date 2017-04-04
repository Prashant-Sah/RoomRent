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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
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

    //AppDelegate* sharedDelegate = [AppDelegate appDelegate];
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"MyTabBarController"];
    window.rootViewController = tabBarController;
    [window makeKeyAndVisible];
    
}

@end
