//
//  AddPostViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICaller.h"
#import "UserLocationViewController.h"

@interface AddPostViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource , UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UserLocationDelegate>

- (void) setImageForCellwithImage : (UIImage *) selectedImage;

@end

