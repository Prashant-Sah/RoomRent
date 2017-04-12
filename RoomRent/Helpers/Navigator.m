//
//  Navigator.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "Navigator.h"

@implementation Navigator
static Navigator *instance = nil;

+(Navigator *)sharedInstance{
    if(instance == nil){
        instance = [[Navigator alloc] init];
        return instance;
    }
    return  instance;
}

-(void)makeRootViewController:(NSString *)storyBoard viewController:(NSString *)VC tabBarController:(NSString *)tabBC {
    
    //AppDelegate* sharedDelegate = [AppDelegate appDelegate];
    //AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoard bundle:nil];
    
    if(VC == nil){
        
        UITabBarController *tabBarVC = [storyboard instantiateViewControllerWithIdentifier:tabBC];
        window.rootViewController = tabBarVC;
        [window makeKeyAndVisible];
    }else{
        
        UIViewController *nVC = [storyboard instantiateViewControllerWithIdentifier:VC];
        window.rootViewController = nVC;
        [window makeKeyAndVisible];
    }
}

-(void)presentWithNavigationController:(UIViewController*) presentVC  viewController:(NSString *)VC {
    
    UIViewController *nVC = [presentVC.storyboard instantiateViewControllerWithIdentifier:VC];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:nVC];
    [presentVC presentViewController:navVC animated:true completion:nil];
}

@end
