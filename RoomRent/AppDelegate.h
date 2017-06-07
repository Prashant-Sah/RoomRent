//
//  AppDelegate.h
//  RoomRent
//
//  Created by Prashant Sah on 3/30/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import <SWRevealViewController.h>
#import "Navigator.h"
#import "Constants.h"
#import "LocalDatabase.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)appDelegate;

@end

