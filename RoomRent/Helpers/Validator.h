//
//  Validator.h
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alerter.h"
#import "Constants.h"

@interface Validator : NSObject

+(Validator *) sharedInstance;

- (BOOL)validateText:(NSString *)text regularExpression:(NSString *)regex;

- (void)startValidation:(UITextField *)textfield;
@end
