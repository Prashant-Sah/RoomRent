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
            regEx = @"(?!.*[\\.\\-\\_]{2,})^[a-zA-Z0-9\\.\\-\\_]{3,24}$";
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
            
        case ROOMS_TEXTFIELD:
            regEx = @"\\d{1,2}";
            break;
            
        case PRICE_TEXTFIELD: // needs to be highly modified
            regEx = @"Rs.(\\d{1,5}([.]\\d{1,3})?|[.]\\d{1,3})";
            break;
            
        default:
            regEx = @".*?";
            break;
    }
    
    y = [self validateText:textfield.text regularExpression:regEx];
    
    if(textfield.tag == ROOMS_TEXTFIELD || textfield.tag == PRICE_TEXTFIELD){
        textfield.textColor = y ?  [UIColor blackColor] : [UIColor redColor] ;
    }else{
        textfield.textColor = y ?  [UIColor whiteColor] : [UIColor redColor] ;
    }
    if (!y) {
        [self addErrorButton:textfield];
    }
    
}

- (void)addErrorButton:(UITextField *)textfield{
    
    UIButton *btnError= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [btnError addTarget:self action:@selector(tapOnError:) forControlEvents:UIControlEventTouchUpInside];
    [btnError setBackgroundImage:[UIImage imageNamed:@"error.png"] forState:UIControlStateNormal];
    
    textfield.rightView = btnError;
    textfield.rightViewMode = UITextFieldViewModeUnlessEditing;
    
}

- (void)tapOnError:(UITextField *)textfield{
    
}
@end
