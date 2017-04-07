//
//  Validator.h
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alerter.h"

@interface Validator : NSObject

+(Validator *) sharedInstance;

-(BOOL) validateEmail : (NSString*) candidate viewController:(UIViewController*) VC ;
-(BOOL) validateMobile : (NSString*) candidate viewController:(UIViewController*) VC ;
- (BOOL)validateEmail:(NSString *)candidate;
@end
