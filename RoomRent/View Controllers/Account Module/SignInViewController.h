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
#import"CustomTextField.h"
#import "Alerter.h"
#import "Validator.h"
#import "APICaller.h"
#import "User.h"
#import "Navigator.h"

@interface SignInViewController : KeyboardAvoidingViewController

-(void) makelogin;
-(void) gotoMain;

@end


