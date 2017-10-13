//
//  PostsOnMapViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 5/26/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "APICaller.h"
#import "Post.h"

@interface PostsOnMapViewController : UIViewController <MKMapViewDelegate>

@property NSMutableArray *postsLocationArray;
-(MKPinAnnotationView *) returnPointView :(CLLocationCoordinate2D) location andTitle: (NSString *) title  andColor :(UIColor *) color;
@end
