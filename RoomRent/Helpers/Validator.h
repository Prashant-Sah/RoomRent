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

// shared instance of Validator
+(Validator *) sharedInstance;

/* validate particular text 
 @param text    The text in the textfiel. use textfield.text
 @param regex   the regular expression to be sent as NSString
 */
- (BOOL)validateText:(NSString *)text regularExpression:(NSString *)regex;


/*
validate the textfield
*/
- (void)startValidation:(UITextField *)textfield;

/* the below methods are not on complete action till now
*/
-(void) addErrorButton:(UITextField *) textfield;
-(void)tapOnError:(UITextField *) textfield;

@end
