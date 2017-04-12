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

@interface Navigator : NSObject

+(Navigator*) sharedInstance;

-(void)makeRootViewController:(NSString *)storyBoard viewController : (NSString *)VC tabBarController:(NSString *)tabBC;
-(void)presentWithNavigationController:(UIViewController*) presentVC  viewController:(NSString *)VC;
@end
