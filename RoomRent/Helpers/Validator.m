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

- (BOOL)validateEmail:(NSString *)candidate viewController: (UIViewController*)VC {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:candidate] == NO) {
        
        [[Alerter sharedInstance] createAlert:@"Error" message:@"Email Address is invalid" viewController: VC  completion:^{
            NSLog(@"Error");
        }];
        return false;
    }
    return true;
}

- (BOOL)validateMobile:(NSString *)candidate viewController:(UIViewController *)VC{
    
    NSString *mobileRegEx = @"((\\+){0,1}977(\\s){0,1}(\\-){0,1}(\\s){0,1}){0,1}9[7-8](\\s){0,1}(\\-){0,1}(\\s){0,1}[0-9]{1}[0-9]{7}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegEx];

    if ([mobileTest evaluateWithObject:candidate] == NO) {
        
        [[Alerter sharedInstance] createAlert:@"Error" message:@"Moible number is invalid" viewController: VC  completion:^{
            NSLog(@"Error");
        }];
        return false;
    }
    return true;
}

- (BOOL)validateEmail:(NSString *)candidate  {
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:candidate] == NO) {
            NSLog(@"Error in mail");
    }
    return true;
}

@end
