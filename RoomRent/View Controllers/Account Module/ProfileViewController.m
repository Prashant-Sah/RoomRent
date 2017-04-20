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
    
    _fullnameLabel.text = [userDict valueForKey:@"name"];
     _mobileLabel.text = [userDict valueForKey:@"mobile"];
    _usernameLabel.text = [userDict valueForKey:@"username"];
    _emailLabel.text = [userDict valueForKey:@"email"];
   
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
