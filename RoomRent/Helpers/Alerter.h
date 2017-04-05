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

+(Alerter *)sharedInstance;

-(void)createAlert:(NSString*)alertTitle message:(NSString*)alertMessage viewController:(UIViewController*)VC  completion:(void (^)(void))completionBlock;

@end
