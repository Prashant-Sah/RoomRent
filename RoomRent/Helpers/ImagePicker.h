//
//  ImagePicker.h
//  RoomRent
//
//  Created by Prashant Sah on 4/19/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImagePicker : NSObject <UIImagePickerControllerDelegate>



- (void)pickImagefromViewController : (UIViewController *) presentVC completion :(void (^) (UIImage * image)) completionBlock ;

@end

