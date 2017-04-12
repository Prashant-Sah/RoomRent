//
//  OffersViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "OffersViewController.h"

@interface OffersViewController ()

@end

@implementation OffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
    logoutButton.tintColor = [UIColor blueColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
}

-(void) onLogout{
    
    [[APICaller sharedInstance] callApi:@"logout" parameters:nil headerFlag:true viewController:self completion:^(NSDictionary *responseObjectDictionary) {
       
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if([code isEqualToString:USER_LOGGED_OUT]){
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userApiToken"];
            [[Navigator sharedInstance] makeRootViewController:@"Account" viewController:@"SignInViewController" tabBarController:nil];
        }
    }];
}

@end
