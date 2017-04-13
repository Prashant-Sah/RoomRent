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

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    NSString *username = [userDict valueForKey:@"username"];
    self.userNameLabel.text = username;
    
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:false];
}

@end
