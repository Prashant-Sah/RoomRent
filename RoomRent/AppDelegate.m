//
//  AppDelegate.m
//  RoomRent
//
//  Created by Prashant Sah on 3/30/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA_KEY];
    if (userData!= nil){
        
        NSString *timeStampForLastPost = [[NSUserDefaults standardUserDefaults] objectForKey:@"updatedDateOfLastPostAmongAllPosts"];
        
        [self loadPostsToDatabaseWithTimeStamp: timeStampForLastPost ? timeStampForLastPost : nil ];
        [[Navigator sharedInstance] setRevealViewControllerWithFrontTabViewController:@"MyTabBarController" sideViewController:@"SideBarViewController" storyBoard:@"Main"];
        [self.window makeKeyAndVisible];
    }else{
        
        [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"SignInViewController" tabBarController:nil];
    }
    return YES;
}

-(void) loadPostsToDatabaseWithTimeStamp:(NSString *) timeStamp{
    
    NSDictionary *params = nil;
    
    if(timeStamp != nil){
        params = @{
                   @"type" : @"all",
                   @"older" : @"false",
                   @"timestamp" : timeStamp
                   };
        
        [[APICaller sharedInstance] callAPiToGetPost:@"posts" parameters:params viewController:nil completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            if ([[responseObjectDictionary valueForKey:@"code" ] isEqualToString:POSTS_FOUND]){
                
                NSDictionary *updatedPostDictionary = [responseObjectDictionary valueForKey:@"updated"];
                NSDictionary *updatedpostData = [updatedPostDictionary valueForKey:@"data"];
                if(updatedpostData != nil){
                    [[LocalDatabase sharedInstance] pushUpdatedPostsToDatabase:updatedpostData];
                }
                
                NSDictionary *createdPostsDictionary = [responseObjectDictionary valueForKey:@"created"];
                
                NSDictionary *createdpostData = [createdPostsDictionary valueForKey:@"data"];
                if(createdpostData != nil){
                    
                    NSString *updatedDateOfLastPostAmongAllPosts = [[LocalDatabase sharedInstance] pushPostToDatabase:createdpostData];
                    [[NSUserDefaults standardUserDefaults] setObject:updatedDateOfLastPostAmongAllPosts forKey:@"updatedDateOfLastPostAmongAllPosts"];
                }
                
                NSDictionary *deletedPostDictionary = [responseObjectDictionary valueForKey:@"deleted"];
                NSDictionary *deletedPostData = [deletedPostDictionary valueForKey:@"data"];
                if(deletedPostData != nil){
                    [[LocalDatabase sharedInstance] deletePostsFromDatabase:deletedPostData];
                }
            }
        }];
        
    }else{
        [[APICaller sharedInstance] callAPiToGetPost:@"posts" parameters:params viewController:nil completion:^(NSDictionary *responseObjectDictionary) {
            
            if ([[responseObjectDictionary valueForKey:@"code" ] isEqualToString:POSTS_FOUND]){
                NSLog(@"%@",responseObjectDictionary);

                NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
                
                NSString *updatedDateOfLastPostAmongAllPosts = [[LocalDatabase sharedInstance] pushPostToDatabase:postData];
                [[NSUserDefaults standardUserDefaults] setObject:updatedDateOfLastPostAmongAllPosts forKey:@"updatedDateOfLastPostAmongAllPosts"];
            }
        }];
    }
}

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
