//
//  CustomButton.m
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (![super pointInside:point withEvent:event])
    {
        return NO;
    }
    BOOL isInside = (pow((point.x-self.frame.size.width/2), 2) + pow((point.y - self.frame.size.height/2), 2) < pow((self.frame.size.width/2), 2)) ? YES:NO;
    [UIButton buttonWithType:UIButtonTypeSystem];
    return isInside;
}

- (void)drawRect:(CGRect)rect{
    
    self.clipsToBounds = true;
    self.layer.cornerRadius = self.frame.size.height/2;
}

@end
