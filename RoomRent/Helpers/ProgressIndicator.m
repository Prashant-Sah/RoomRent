//
//  ProgressIndicator.m
//  RoomRent
//
//  Created by Prashant Sah on 6/2/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "ProgressIndicator.h"
@implementation ProgressIndicator

UIActivityIndicatorView *activityIndicator;
UIView *activityIndicatorBackgroundView;
UIView *parentView;

- (void)showActivityIndicatorOnView:(UIView *)view{
    
    parentView = view;
    activityIndicatorBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0 ,0, 100, 100)];
    activityIndicatorBackgroundView.center = view.center;
    activityIndicatorBackgroundView.backgroundColor = [UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:0.7];
    activityIndicatorBackgroundView.layer.cornerRadius = 10;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge ];
    activityIndicator.frame = CGRectMake(0, 0, 100, 100);
    activityIndicator.center = CGPointMake(activityIndicatorBackgroundView.frame.size.width/2, activityIndicatorBackgroundView.frame.size.height/2);
    
    [activityIndicatorBackgroundView addSubview:activityIndicator];
    [activityIndicatorBackgroundView bringSubviewToFront:activityIndicator];
    [view addSubview:activityIndicatorBackgroundView];
    [activityIndicatorBackgroundView bringSubviewToFront:view];
    [activityIndicator startAnimating];

    parentView.userInteractionEnabled = false;
    parentView.alpha= 0.7;
}

-(void) hideActivityIndicatorFromView:(UIView *)view{
    
    [activityIndicator stopAnimating];
    [activityIndicatorBackgroundView setHidden: true];
    
    parentView.userInteractionEnabled = true;
    parentView.alpha = 1.0;
    
}
@end
