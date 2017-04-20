//
//  Navigator.h
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <SWRevealViewController.h>

@interface Navigator : NSObject <SWRevealViewControllerDelegate>

+(Navigator*) sharedInstance;

-(Navigator*)initNavigator;

-(void)makeRootViewControllerWithStoryBoard:(NSString *)storyBoard viewController : (NSString *)VC tabBarController:(NSString *)tabBC;

-(void)presentWithNavigationController:(UIViewController*) presentVC  viewController:(NSString *)VC;

-(void) setRevealViewControllerWithFrontTabViewController: (NSString *) tabVC sideViewController:(NSString *) sideVC storyBoard :(NSString *) storyboard;


@end
