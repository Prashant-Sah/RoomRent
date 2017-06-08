//
//  UserLocationViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "UserLocationViewController.h"

@interface UserLocationViewController () <UserLocationDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak,readwrite) CLLocation *currentLocation;

@end

@implementation UserLocationViewController
MKPointAnnotation *myAnnotation;
CLLocationManager *locationManager;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    self.mapView.showsUserLocation = true;
    self.mapView.delegate = self;
    myAnnotation = [[MKPointAnnotation alloc]init];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addAnnotation:)];
    longPressGesture.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:longPressGesture];
    
    
}

//MARK - CLLocationManager Delegate Functions
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    _currentLocation = newLocation;
    if (self.currentLocation != nil) {
        [locationManager stopUpdatingLocation];
               MKCoordinateRegion region;
        region.center = self.currentLocation.coordinate;
        region.span = MKCoordinateSpanMake(0.05, 0.05);
        
        region = [_mapView regionThatFits:region];
        [self.mapView setRegion:region animated:YES];
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    [[Alerter sharedInstance] createAlert:@"Error" message:@"Faield to get your location" useCancelButton:false viewController:self completion:^
    {}];
}

// Add Annotation on longpres
-(void)addAnnotation:(UIGestureRecognizer *)gesture{
    
    if (gesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint point = [gesture locationInView:self.mapView];
    CLLocationCoordinate2D mapCoordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    myAnnotation.coordinate = mapCoordinate;
    [self.mapView addAnnotation:myAnnotation];
}


//MARK- Button Handlers
- (IBAction)CancelButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)okButtonPressed:(UIButton *)sender {
    [self.userLocationdelegate didSelectLocation:myAnnotation.coordinate];
    [self dismissViewControllerAnimated:true completion:nil];
}



@end
