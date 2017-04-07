//
//  KeyboardAvoidingViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "KeyboardAvoidingViewController.h"

@interface KeyboardAvoidingViewController ()


@end

@implementation KeyboardAvoidingViewController

static CGPoint activeTextFieldPosition;
+(void)setActiveTextFieldPosition:(CGPoint)textFieldPosition{
    
    activeTextFieldPosition = textFieldPosition;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];}

-(void)keyboardWillShow:(NSNotification*)notification {
    
    CGRect keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    
    if(activeTextFieldPosition.y > keyboardSize.origin.y - keyboardSize.size.height - 35 ){
    
    [self.view setFrame:CGRectMake(0, -keyboardSize.size.height , self.view.frame.size.width, self.view.frame.size.height)];
    }
}

-(void)keyboardWillHide:(NSNotification*)notification {
    [self.view setFrame:CGRectMake(0, 0 , self.view.frame.size.width, self.view.frame.size.height)];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:TRUE];
}


@end
