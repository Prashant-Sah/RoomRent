//
//  SideBarViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/13/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "SideBarViewController.h"

@interface SideBarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _profileImageButton.userInteractionEnabled = false;
    
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    NSString *username = [userDict valueForKey:@"username"];
    self.userNameLabel.text = username;
    
    NSData *profileImageData = [[NSData alloc] initWithContentsOfURL:[userDict valueForKey:@"profileImageURL"]];
    if(profileImageData != nil){
    [_profileImageButton setImage:[UIImage imageWithData:profileImageData] forState:normal];
    }
}
- (IBAction)profileBtnPressed:(UIButton *)sender {
    [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"ProfileViewController" tabBarController:nil];
}

- (IBAction)logoutBtnPressed:(UIButton *)sender {
    
    [[APICaller sharedInstance] callApi:@"logout" headerFlag:true parameters:nil imageData:nil fileName:nil viewControlller:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if([code isEqualToString:USER_LOGGED_OUT]){
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userApiToken"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDataKey"];
            [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"SignInViewController" tabBarController:nil];
        }
    }];

}
- (IBAction)clear:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDataKey"];
    [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"SignInViewController" tabBarController:nil];
}


@end
