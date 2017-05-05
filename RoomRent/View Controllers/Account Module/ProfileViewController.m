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
    _cancelBtn.hidden = true;
    
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    
    self.fullnameLabel.text = [userDict valueForKey:@"name"];
    self.mobileLabel.text = [userDict valueForKey:@"phone"];
    self.usernameLabel.text = [userDict valueForKey:@"username"];
    self.emailLabel.text = [userDict valueForKey:@"email"];
    
    if([[userDict valueForKey:@"profile_image"]  isEqualToString:@"<null>" ]){
    }else{
        [[APICaller sharedInstance] callApiForReceivingImage:[@"getfile/" stringByAppendingString:[userDict valueForKey:@"profile_image"]?  : @""] viewController:self completion:^(id responseObjectFromApi) {
            if(responseObjectFromApi != nil){
                
                CGSize destinationSize = CGSizeMake(100, 100);
                UIGraphicsBeginImageContext(destinationSize);
                [responseObjectFromApi drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
                UIImage *resizedProfileImage = UIGraphicsGetImageFromCurrentImageContext();
                
                [self.profileImageButton setImage:resizedProfileImage forState:UIControlStateNormal];
            }
        }];
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
