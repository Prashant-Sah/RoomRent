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
    
    if (![[userDict valueForKey:@"profile_image"] isEqual:[NSNull null]]) {
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:[userDict valueForKey:@"profile_image"]]];
        
        [self.profileImageButton sd_setImageWithURL:url forState:UIControlStateNormal];
        [self.profileImageButton setContentMode:UIViewContentModeScaleAspectFit];
        
        self.profileImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
         self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height/2;
        self.profileImageButton.layer.borderWidth = 2.0f;
        
    }
    
}
- (IBAction)profileBtnPressed:(UIButton *)sender {
    [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"ProfileViewController" tabBarController:nil];
}

- (IBAction)logoutBtnPressed:(UIButton *)sender {
    
    [[APICaller sharedInstance] callApi:@"logout" useToken:true parameters:nil imageData:nil fileName:nil viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if([code isEqualToString:USER_LOGGED_OUT]){
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userApiToken"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDataKey"];
            [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"SignInViewController" tabBarController:nil];
        }
    }];
    
}
- (IBAction)clear:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userApiToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userDataKey"];
    [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"SignInViewController" tabBarController:nil];
}


@end
