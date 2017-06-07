//
//  PostsOnMapViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 5/26/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "PostsOnMapViewController.h"

@interface PostsOnMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property NSMutableArray *postsArray;
@property CLLocation *postLocation;
@end

@implementation PostsOnMapViewController

CLLocationDegrees centerLatitude = 0.0;
CLLocationDegrees centerLongitude = 0.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    
    NSDictionary *params = @{
                             @"offset" :  @"0",
                             @"type" : @"all"
                             };
    
    [[APICaller sharedInstance] callAPiToGetPost:@"posts" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if ([code isEqualToString:POSTS_FOUND]){
            
            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
            NSLog(@"%@",responseObjectDictionary);
            for (NSDictionary *singlePost in postData) {
                
                Post *post = [[Post alloc] initPostFromJson:singlePost];
                [self.postsArray addObject:post];
                CLLocation *postLocation = [[CLLocation alloc] initWithLatitude:post.latitude longitude:post.longitude];
                [self.postsLocationArray addObject:postLocation];
                MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
                annotationPoint.coordinate = postLocation.coordinate;
                annotationPoint.title = post.title;
                [annotationArray addObject:annotationPoint];
                
                if(post.postType == 1){
                    annotationPoint.subtitle = [NSString stringWithFormat:@"%d rooms availabe for Rs. %d", post.numberOfRooms,(int)post.price];
                }else{
                    annotationPoint.subtitle = [NSString stringWithFormat:@"%d rooms required for Rs. %d", post.numberOfRooms,(int)post.price];
                }
//                UIColor *pinColor;
//                if(post.postType == 1){
//                    pinColor = [UIColor greenColor];
//                }else{
//                    pinColor = [UIColor redColor];
//                }
//                
//                MKPinAnnotationView *pin = [self returnPointView:postLocation.coordinate andTitle:[NSString stringWithFormat:@"%d rooms at Rs. %d", post.numberOfRooms,(int)post.price] andColor:pinColor];
//                [annotationArray addObject:pin.annotation];
                
                centerLatitude += annotationPoint.coordinate.latitude;
                centerLongitude += annotationPoint.coordinate.longitude;
            }
            
            centerLatitude = centerLatitude/(annotationArray.count);
            centerLongitude = centerLongitude/(annotationArray.count);
            
                        NSLog(@"%f",centerLatitude);
                        NSLog(@"%f",centerLongitude);
                        NSLog(@"%lu", (unsigned long)annotationArray.count);
            [self.mapView addAnnotations:annotationArray];
            
                        MKCoordinateRegion region;
                        region.center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude);
                        region.span = MKCoordinateSpanMake(0.05, 0.05);
                        region = [self.mapView regionThatFits:region];
                        [self.mapView setRegion:region animated:YES];
            
        }
        else if ([code isEqualToString:NO_POSTS_FOUND]){
            // code to show something
        }
    }];
    
    //
    //        NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
    //        for (CLLocation *singlePostLocation in self.postsLocationArray) {
    //
    //            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    //
    //            annotationPoint.coordinate = singlePostLocation.coordinate;
    //            [annotationArray addObject:annotationPoint];
    //            centerLatitude = annotationPoint.coordinate.latitude + centerLatitude;
    //            centerLongitude = annotationPoint.coordinate.longitude + centerLongitude;
    //        }
    //        centerLatitude = centerLatitude/(annotationArray.count);
    //        centerLongitude = centerLongitude/(annotationArray.count);
    //
    //        NSLog(@"%f",centerLatitude);
    //        NSLog(@"%f",centerLongitude);
    //        NSLog(@"%lu", (unsigned long)annotationArray.count);
    
    
    
}

-(MKPinAnnotationView *) returnPointView :(CLLocationCoordinate2D) location andTitle: (NSString *) title  andColor :(UIColor *) color{
    
    MKPointAnnotation *resultPin = [[MKPointAnnotation alloc] init];
    MKPinAnnotationView *result = [[MKPinAnnotationView alloc] initWithAnnotation:resultPin reuseIdentifier:Nil];
    [resultPin setCoordinate:location];
    
    resultPin.title = title;
    result.pinTintColor = color;
    return result;
}

@end
