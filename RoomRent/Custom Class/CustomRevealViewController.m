//
//  CustomRevealViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//


#import "CustomRevealViewController.h"
#import <UIKit/UIKit.h>
#import <SWRevealViewController.h>

@interface CustomRevealViewController () <SWRevealViewControllerDelegate>
@property UIView *activityIndicatorBackgroundView;
@property UIActivityIndicatorView *activityIndicator;
@end

@implementation CustomRevealViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    revealViewController.delegate = self;
    
    UIBarButtonItem *sideBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon.png"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = sideBarButton;
    [self.view addGestureRecognizer: revealViewController.panGestureRecognizer];
    
    revealViewController.rearViewRevealOverdraw = 0.0f;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position{
    
    if(position == FrontViewPositionLeft){
        [revealController.frontViewController.view setUserInteractionEnabled:true];
    }else{
        [revealController.frontViewController.view setUserInteractionEnabled:false];
        [revealController.frontViewController.revealViewController tapGestureRecognizer];
    }
}

@end
