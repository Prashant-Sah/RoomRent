//
//  UserLocationViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 4/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Alerter.h"

@interface UserLocationViewController : UIViewController <CLLocationManagerDelegate , UIGestureRecognizerDelegate>
@property id userLocationdelegate;

-(void) addAnnotation :(UIGestureRecognizer *) gesture;

@end

@protocol UserLocationDelegate <NSObject>

-(void)didSelectLocation  :(CLLocationCoordinate2D) annotationCoordinate;

@end
