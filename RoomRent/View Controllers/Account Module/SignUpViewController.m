//
//  SignUpViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 3/31/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "SignUpViewController.h"
//#import "CustomButton.h"

@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property UIImage *profileImage;
@property NSData *imageData;
@property NSString *imageName;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Assigning tags to textfields
    self.nameTextField.tag = NAME_TEXTFIELD;
    self.mobileTextField.tag = MOBILE_TEXTFIELD;
    self.userNameTextField.tag = USERNAME_TEXTFIELD;
    self.emailAddTextField.tag = EMAIL_ADDRESS_TEXTFIELD;
    self.passwordTextField.tag = PASSWORD_TEXTFIELD;
    
    
    self.nameTextField.text = @"Puspa Raaz";
    self.mobileTextField.text =@"9876543210";
    self.userNameTextField.text =@"Puspa";
    self.emailAddTextField.text = @"069bct429@gmail.com";
    self.passwordTextField.text = @"Puspa123#";
    
    //navigation Bar clear
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    cancelButton.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (IBAction)create:(UIButton *)sender {
    
    NSString *name = self.nameTextField.text;
    NSString *mobile = self.mobileTextField.text;
    NSString *username = self.userNameTextField.text;
    NSString *emailAddress = self.emailAddTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSDictionary *params = @{@"email": emailAddress,
                             @"username": username,
                             @"name": name,
                             @"password" : password,
                             @"phone" : mobile,
                             };
    
    if(self.profileImage != nil){
        self.imageData = UIImageJPEGRepresentation(self.profileImage, 0.5);
    }else{
        self.imageData = nil;
    }
    [[APICaller sharedInstance] callApi:SIGNUP_PATH useToken:false parameters:params imageData: _imageData fileName: self.imageName  viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@", responseObjectDictionary);
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        
        if ([code isEqualToString:USER_REGISTERED ]){
            
            [self dismissViewControllerAnimated:true  completion:nil];
            
        }
        else{
            
            NSString *errorMessage = [responseObjectDictionary valueForKey:@"message"];
            
            NSDictionary *validationErrors = [responseObjectDictionary valueForKey:@"errors"];
            NSArray *errArrKeys = [validationErrors allKeys];
            NSLog(@"%@", errArrKeys);
            for (NSString *key in errArrKeys){
                
                for (NSString *msg in [validationErrors valueForKey:key]){
                    
                    errorMessage = [errorMessage stringByAppendingString:@"\n"];
                    errorMessage = [errorMessage stringByAppendingString:msg];
                }
            }
            [[Alerter sharedInstance] createAlert:@"Error" message:errorMessage useCancelButton:false viewController:self completion:^{
            }];
        }
    }];
}


-(void) onCancel{
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)addPhoto:(id)sender{
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self ;
    pickerController.allowsEditing = true;
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:pickerController animated:YES completion:nil];
        }else{
            [[Alerter sharedInstance] createAlert:@"Error" message:@"Camera not found" useCancelButton:false viewController:self completion:^{}];
        }
        
    }];
    
    UIAlertAction *chooseFromGallery = [UIAlertAction actionWithTitle:@"Choose photo from gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pickerController animated:YES completion:nil];
    }];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"Choose Image" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:takePhoto];
    [alertController addAction:chooseFromGallery];
    
    [self presentViewController:alertController animated:true completion:nil];
}

#pragma-mark - add profile photo

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    _imageName = [imageFileURL lastPathComponent];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageFileURL] options:nil];
    _imageName = [[result firstObject] filename];
    
    if(editedImage!= nil){
        self.profileImage = editedImage;
        [self.profileImageButton setImage:editedImage forState:UIControlStateNormal];
    }else{
        self.profileImage = nil;
        [self.profileImageButton setImage:nil forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
