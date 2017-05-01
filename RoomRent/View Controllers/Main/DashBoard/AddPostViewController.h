//
//  AddPostViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "APICaller.h"
#import "KeyboardAvoidingViewController.h"
#import "UserLocationViewController.h"
#import "Validator.h"
#import "Post.h"
#import "LocalDatabase.h"

@interface AddPostViewController : KeyboardAvoidingViewController <UICollectionViewDelegate, UICollectionViewDataSource , UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UserLocationDelegate, UITextFieldDelegate>

- (void) setImageForCellwithImage : (UIImage *) selectedImage;

@end

