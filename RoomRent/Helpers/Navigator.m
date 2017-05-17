//
//  Navigator.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "Navigator.h"

@implementation Navigator

UIWindow *window = nil;

static Navigator *instance = nil;

+(Navigator *)sharedInstance{
    if(instance == nil){
        instance = [[Navigator alloc] initNavigator];
        return instance;
    }
    return  instance;
}

-(Navigator*)initNavigator {
    window = [[[UIApplication sharedApplication] delegate] window];
    return self;
}

- (void)makeRootViewControllerWithStoryBoard:(NSString *)storyBoard viewController:(NSString *)VC tabBarController:(NSString *)tabBC{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoard bundle:nil];
    
    if(VC == nil){
        
        UITabBarController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:tabBC];
        window.rootViewController = tabBarVC;
        [window makeKeyAndVisible];
    }else{
        
        UIViewController *newVC = [storyboard instantiateViewControllerWithIdentifier:VC];
        window.rootViewController = newVC;
        [window makeKeyAndVisible];
    }
}

- (void)setRevealViewControllerWithFrontTabViewController:(NSString *)tabVC sideViewController:(NSString *)sideVC storyBoard:(NSString *)storyboard{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    UITabBarController *tabViewController = [storyBoard instantiateViewControllerWithIdentifier:tabVC];
    UIViewController *sideBarVC = [storyBoard instantiateViewControllerWithIdentifier:sideVC];
    SWRevealViewController *revealViewController = [[SWRevealViewController alloc] initWithRearViewController:sideBarVC frontViewController:tabViewController];
    
    window.rootViewController = revealViewController;
    [window makeKeyAndVisible];
    
}


-(void)presentWithNavigationController:(UIViewController*) presentVC  viewController:(NSString *)VC {
    
    UIViewController *nVC = [presentVC.storyboard instantiateViewControllerWithIdentifier:VC];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:nVC];
    [presentVC presentViewController:navVC animated:true completion:nil];
}

@end
