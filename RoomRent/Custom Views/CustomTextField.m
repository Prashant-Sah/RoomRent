//
//  CustomTextField.m
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

-(void)drawRect:(CGRect)rect{
    self.delegate = self;
}

//-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField{
//    
//    textField.placeholder = nil;
//    return true;
//}

-(void)drawPlaceholderInRect:(CGRect)rect {
    UIColor *color = [UIColor whiteColor];
    
    if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)]) {
        // iOS7 and later
        NSDictionary *attributes = @{NSForegroundColorAttributeName: color, NSFontAttributeName: self.font};
        CGRect boundingRect = [self.placeholder boundingRectWithSize:rect.size options:0 attributes:attributes context:nil];
        [self.placeholder drawAtPoint:CGPointMake(0, (rect.size.height/2)-boundingRect.size.height/2) withAttributes:attributes];
    }
    else {
        // iOS 6
        [color setFill];
        [self.placeholder drawInRect:rect withFont:self.font lineBreakMode:NSLineBreakByTruncatingTail alignment:self.textAlignment];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self resignFirstResponder];
    return true;
}

@end
