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

@end

@implementation PostsOnMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CLLocationDegrees centerLatitude = 0.0;
    CLLocationDegrees centerLongitude = 0.0;
    

    
    @autoreleasepool {
        
        NSMutableArray *annotationArray = [[NSMutableArray alloc] init];
        for (CLLocation *singlePostLocation in self.postsLocationArray) {
            
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            
            annotationPoint.coordinate = singlePostLocation.coordinate;
            [annotationArray addObject:annotationPoint];
            centerLatitude = annotationPoint.coordinate.latitude + centerLatitude;
            centerLongitude = annotationPoint.coordinate.longitude + centerLongitude;
        }
        centerLatitude = centerLatitude/(annotationArray.count);
        centerLongitude = centerLongitude/(annotationArray.count);
        
        NSLog(@"%f",centerLatitude);
        NSLog(@"%f",centerLongitude);
        
        MKCoordinateRegion region;
        region.center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude);
        region.span = MKCoordinateSpanMake(0.05, 0.05);
        region = [self.mapView regionThatFits:region];
        [self.mapView setRegion:region animated:YES];
        [self.mapView addAnnotations:annotationArray];

    }
   
}








- (void)zoomToFitMapAnnotations {
    
    int i = 0;
    MKMapPoint points[[self.mapView.annotations count]];
    
    //build array of annotation points
    for (id<MKAnnotation> annotation in [self.mapView annotations])
        points[i++] = MKMapPointForCoordinate(annotation.coordinate);
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:i];
    
    [self.mapView setRegion:MKCoordinateRegionForMapRect([poly boundingMapRect]) animated:YES];
}
    
@end
