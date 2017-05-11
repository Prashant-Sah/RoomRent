//
//  ProfileViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateProfileBtn;
@property (weak,nonatomic) IBOutlet UIButton *profileImageButton;

@property (weak, nonatomic) IBOutlet UIStackView *passwordStackView;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _updateProfileBtn.hidden = true;
    _cancelBtn.hidden = false;
    
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    
    self.fullnameLabel.text = [userDict valueForKey:@"name"];
    self.mobileLabel.text = [userDict valueForKey:@"phone"];
    self.usernameLabel.text = [userDict valueForKey:@"username"];
    self.emailLabel.text = [userDict valueForKey:@"email"];
    
    if (![[userDict valueForKey:@"profile_image"] isEqual:[NSNull null]]) {
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        NSURL *url = [NSURL URLWithString:[[PUSP_BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:[userDict valueForKey:@"profile_image"]]];
        
        [self.profileImageButton sd_setImageWithURL:url forState:UIControlStateNormal];
        [self.profileImageButton setContentMode:UIViewContentModeScaleAspectFit];
        
        self.profileImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height/2;
        self.profileImageButton.layer.borderWidth = 2.0f;
        self.profileImageButton.clipsToBounds = true;
    }
    
    
}
- (IBAction)editButtonPressed:(UIButton *)sender {
    _updateProfileBtn.hidden = false;
    _cancelBtn.hidden = false;
    _editBtn.hidden = true;
}

- (IBAction)updateProfileBtnPressed:(UIButton *)sender {
    
}
- (IBAction)cancelBtnPressed:(UIButton *)sender {
    [[Navigator sharedInstance] setRevealViewControllerWithFrontTabViewController:@"MyTabBarController" sideViewController:@"SideBarViewController" storyBoard:@"Main"];
}


@end
