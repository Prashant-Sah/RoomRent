//
//  SinglePostViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>

#import "APICaller.h"
#import "Post.h"
#import "Constants.h"
#import "AddPostViewController.h"
#import "LocalDatabase.h"

@interface SinglePostViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate, AddPostVCDelegate >

@property (weak) id singlePostVCDelegate;
@property NSString *slug;
@property NSString *postType;
@property int postid;
@end

@protocol SinglePostVCDelegate <NSObject>

@optional
-(void) didFinishDeleting;

@end
