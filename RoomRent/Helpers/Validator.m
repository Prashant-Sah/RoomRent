//
//  Validator.m
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "Validator.h"

@implementation Validator

static Validator * instance = nil;

+ (Validator *)sharedInstance{
    if (instance == nil){
        instance = [[Validator alloc] init];
        return instance;
    }
    return instance;
}

- (BOOL)validateText:(NSString *)text regularExpression:(NSString *)regex{
    
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:text];
    
}

- (void)startValidation:(UITextField *)textfield{
    
    NSString *regEx = nil;
    BOOL y = nil;
    
    switch (textfield.tag) {
        case NAME_TEXTFIELD:
            regEx = @"^[A-Za-z]+([\\s][A-Za-z]+)*$";
            break;
        case USERNAME_TEXTFIELD:
            regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
            break;
            
        case MOBILE_TEXTFIELD:
            regEx = @"((\\+){0,1}977(\\s){0,1}(\\-){0,1}(\\s){0,1}){0,1}9[7-8](\\s){0,1}(\\-){0,1}(\\s){0,1}[0-9]{1}[0-9]{7}$";
            break;
            
        case EMAIL_ADDRESS_TEXTFIELD:
            regEx =  @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
            break;
            
        case PASSWORD_TEXTFIELD:
            regEx = @"^.{4,50}$";
            break;
            
        default:
            break;
    }
    
    y = [self validateText:textfield.text regularExpression:regEx];
    
    textfield.textColor = y ?  [UIColor whiteColor] : [UIColor redColor] ;
    y = nil;
}

@end
