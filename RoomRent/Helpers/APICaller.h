//
//  APICaller.h
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import"Constants.h"
#import "Alerter.h"

@interface APICaller : NSObject

+(APICaller *) sharedInstance;

-(void)callSome:(NSString *)appendString parameters:(NSDictionary *)params viewController:(UIViewController*)VC completion:(void (^)(NSDictionary *responseObjectDictionary))completionBlock  ;

//-(APICaller *) initAPICaller;

@end
