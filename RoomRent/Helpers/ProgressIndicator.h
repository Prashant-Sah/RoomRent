//
//  ProgressIndicator.h
//  RoomRent
//
//  Created by Prashant Sah on 6/2/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ProgressIndicator : NSObject

-(void)showActivityIndicatorOnView :(UIView *) view;
-(void) hideActivityIndicatorFromView :(UIView *) view;

@end
