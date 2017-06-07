//
//  Alerter.h
//  RoomRent
//
//  Created by Prashant Sah on 4/5/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Alerter : NSObject

// create a shared instance for Alerter
+(Alerter *)sharedInstance;

/*
Creates alert on the passed viewcontroller
 
@param alertTitle       title to be shown in alert
@param alertmessage     message to be shown
@param VC               the view controller alertcontroller is to be shown on
 */

-(void)createAlert:(NSString*)alertTitle message:(NSString*)alertMessage useCancelButton :(BOOL) useCancelButton viewController:(UIViewController*)VC  completion:(void (^)(void))completionBlock;

@end
