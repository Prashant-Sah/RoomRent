//
//  SinglePostViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "APICaller.h"

@interface SinglePostViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate >

@property int postId;

@end
