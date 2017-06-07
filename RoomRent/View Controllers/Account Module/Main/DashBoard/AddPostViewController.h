//
//  AddPostViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AFNetworking.h>

#import "APICaller.h"
#import "KeyboardAvoidingViewController.h"
#import "UserLocationViewController.h"
#import "Validator.h"
#import "Post.h"
#import "LocalDatabase.h"
#import "CustomTextField.h"

@interface AddPostViewController : KeyboardAvoidingViewController <UICollectionViewDelegate, UICollectionViewDataSource , UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UserLocationDelegate, UITextFieldDelegate, UITextViewDelegate>

@property NSString *postType;
@property Post *passedPost;
@property (weak) id addPostVCDelegate;

- (void) setImageForCellwithImage : (UIImage *) selectedImage;
-(void) removePhotosViewFromSuperView;
- (void)didSelectLocation:(CLLocationCoordinate2D)annotationCoordinate;

@end

@protocol AddPostVCDelegate <NSObject>

@optional
-(void) didFinishEditingPost;
-(void) didFinishAddingPost ;

@end

