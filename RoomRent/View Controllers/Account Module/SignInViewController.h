//
//  SignInViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 3/31/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "KeyboardAvoidingViewController.h"
#import "Constants.h"
#import "Alerter.h"

@interface SignInViewController : KeyboardAvoidingViewController <UITextFieldDelegate>

-(void) makelogin;
@end
