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
    
    static NSInteger tagLockView = 4207868622;
    if (revealController.frontViewPosition == FrontViewPositionRight) {
        
        UIView *lock = [revealController.frontViewController.view viewWithTag:tagLockView];
        [lock addGestureRecognizer:revealController.frontViewController.revealViewController.panGestureRecognizer];
        [lock addGestureRecognizer:revealController.frontViewController.revealViewController.tapGestureRecognizer];
        [UIView animateWithDuration:0.25 animations:^{
            lock.alpha = 0;
        } completion:^(BOOL finished) {
            [lock removeFromSuperview];
        }];
    } else if (revealController.frontViewPosition == FrontViewPositionLeft) {
        
        UIView *lock = [[UIView alloc] initWithFrame:revealController.frontViewController.view.bounds];
        lock.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        lock.tag = tagLockView;
        [lock addGestureRecognizer:revealController.frontViewController.revealViewController.tapGestureRecognizer];
        [lock addGestureRecognizer:revealController.frontViewController.revealViewController.panGestureRecognizer];
        [revealController.frontViewController.view addSubview:lock];
        [UIView animateWithDuration:0.75 animations:^{}];
    }
    

}

@end
