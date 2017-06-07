//
//  ProfileViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *fullnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddTextField;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateProfileBtn;
@property (weak,nonatomic) IBOutlet UIButton *profileImageButton;

@property (weak, nonatomic) IBOutlet UIStackView *passwordStackView;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.updateProfileBtn.hidden = true;
    self.cancelBtn.hidden = false;
    
    self.fullnameTextField.tag = NAME_TEXTFIELD;
    self.mobileTextField.tag = MOBILE_TEXTFIELD;
    
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA_KEY];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    
    self.fullnameTextField.text = user.fullname;
    self.mobileTextField.text = user.mobile;
    self.usernameTextField.text = user.username;
    self.emailAddTextField.text = user.email;
    
    if (user.profileImageURL != nil) {
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:[NSString stringWithFormat:@"%@", user.profileImageURL]]];
        
        [self.profileImageButton sd_setImageWithURL:url forState:UIControlStateNormal];
    }
    [self.profileImageButton setContentMode:UIViewContentModeScaleAspectFit];
    
    self.profileImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height/2;
    self.profileImageButton.layer.borderWidth = 2.0f;
    self.profileImageButton.clipsToBounds = true;
    
    //Add longpress gesture to change profile photo
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delaysTouchesBegan = YES;
    lpgr.minimumPressDuration = 0.5;
    [self.profileImageButton addGestureRecognizer:lpgr];
    
    
}
- (IBAction)editButtonPressed:(UIButton *)sender {
    
    self.updateProfileBtn.hidden = false;
    self.editBtn.hidden = true;
    
    self.fullnameTextField.enabled = true;
    self.mobileTextField.enabled = true;
}

- (IBAction)updateProfileBtnPressed:(UIButton *)sender {
    
    NSDictionary *params = @{
                             @"name" : self.fullnameTextField.text,
                             @"phone" : self.mobileTextField.text
                             };
    [[APICaller sharedInstance] callApiToEditPost:@"user" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@",responseObjectDictionary);
        
        if([[responseObjectDictionary valueForKey:@"code"] isEqualToString:PROFILE_UPDATED_SUCCESSFULLY]){
            
            [self goNonEditingMode];
            
            NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA_KEY];
            User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
            
            user.fullname = self.fullnameTextField.text;
            user.mobile = self.mobileTextField.text;
            
            userDataDict = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:userDataDict forKey:USER_DATA_KEY];
            
            [[Alerter sharedInstance] createAlert:@"SUCCESS" message:@"Your profile has been updated" useCancelButton:false viewController:self completion:^{}];
            
        }else if([[responseObjectDictionary valueForKey:@"code"] isEqualToString:VALIDATION_ERRORS]){
            
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
            [[Alerter sharedInstance] createAlert:@"Profile could not be updated" message:errorMessage useCancelButton:false viewController:self completion:^{
            }];
        }
    }];
}


- (IBAction)cancelBtnPressed:(UIButton *)sender {
    
    [[Navigator sharedInstance] setRevealViewControllerWithFrontTabViewController:@"MyTabBarController" sideViewController:@"SideBarViewController" storyBoard:@"Main"];
}

-(void) handleLongPress:(UILongPressGestureRecognizer *) gesture{
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
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
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Change Profile?" message:@"Choose ImageSource" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertController addAction:takePhoto];
        [alertController addAction:chooseFromGallery];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageFileURL] options:nil];
    NSString *imageName = [[result firstObject] filename];
    
    [self dismissViewControllerAnimated:true completion:nil];
    
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.5);
    
    [[APICaller sharedInstance] callApi:@"updateavatar" useToken:true parameters:nil imageData:imageData fileName:imageName viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        if([[responseObjectDictionary valueForKey:@"code"] isEqualToString:IMAGE_UPLOADED_SUCCESSFULLY]){
            
            [self.profileImageButton setImage:editedImage forState:UIControlStateNormal];
            
            NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA_KEY];
            User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
            NSString *profileImageName = [responseObjectDictionary valueForKey:@"data"];
            user.profileImageURL = profileImageName;
            
            userDataDict = [NSKeyedArchiver archivedDataWithRootObject:user];
            [[NSUserDefaults standardUserDefaults] setObject:userDataDict forKey:USER_DATA_KEY];
            
        }
        
    }];
}

-(void)goNonEditingMode{
    self.updateProfileBtn.hidden= true;
    self.editBtn.hidden = false;
    self.fullnameTextField.enabled = false;
    self.mobileTextField.enabled = false;
}
@end
