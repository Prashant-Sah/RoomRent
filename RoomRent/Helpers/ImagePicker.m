//
//  ImagePicker.m
//  RoomRent
//
//  Created by Prashant Sah on 4/19/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "ImagePicker.h"


@implementation ImagePicker

UIImage *selectedImage;

-(void)pickImagefromViewController:(UIViewController *)presentVC completion:(void (^)(UIImage *))completionBlock{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = presentVC ;
    //__weak SignUpViewController *weakself;
    //pickerController.delegate = weakself;
    pickerController.allowsEditing = true;
    [presentVC presentViewController:pickerController animated:YES completion:nil];

    completionBlock(selectedImage);

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
}
- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    
    //image = editingInfo[UIImagePickerControllerEditedImage];
    //NSURL *referenceURL = editingInfo[UIImagePickerControllerReferenceURL];
    selectedImage = image;
}

@end

