//
//  ProfileViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateProfileBtn;
@property (weak,nonatomic) IBOutlet UIButton *profileImageButton;

@property (weak, nonatomic) IBOutlet UIStackView *passwordStackView;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _updateProfileBtn.hidden = true;
    _cancelBtn.hidden = false;
    
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    
    self.fullnameLabel.text = [userDict valueForKey:@"name"];
    self.mobileLabel.text = [userDict valueForKey:@"phone"];
    self.usernameLabel.text = [userDict valueForKey:@"username"];
    self.emailLabel.text = [userDict valueForKey:@"email"];
    
    if (![[userDict valueForKey:@"profile_image"] isEqual:[NSNull null]]) {
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:[userDict valueForKey:@"profile_image"]]];
        
        [self.profileImageButton sd_setImageWithURL:url forState:UIControlStateNormal];
        [self.profileImageButton setContentMode:UIViewContentModeScaleAspectFit];
        
        self.profileImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height/2;
        self.profileImageButton.layer.borderWidth = 2.0f;
        self.profileImageButton.clipsToBounds = true;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.delaysTouchesBegan = YES;
        lpgr.minimumPressDuration = 1.0;
        [self.profileImageButton addGestureRecognizer:lpgr];
    }
    
}
- (IBAction)editButtonPressed:(UIButton *)sender {
    _updateProfileBtn.hidden = false;
    _cancelBtn.hidden = false;
    _editBtn.hidden = true;
}

- (IBAction)updateProfileBtnPressed:(UIButton *)sender {
    
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
               
                [[Alerter sharedInstance] createAlert:@"Error" message:@"Camera not found" viewController:self completion:^{}];
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
    NSString *imageName = [imageFileURL lastPathComponent];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageFileURL] options:nil];
    imageName = [[result firstObject] filename];
    
    [self dismissViewControllerAnimated:true completion:nil];
    
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.5);
   
    [[APICaller sharedInstance] callApi:@"user/updateavatar/" useToken:true parameters:nil imageData:imageData fileName:imageName viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        if([[responseObjectDictionary valueForKey:@"code"] isEqualToString:IMAGE_UPLOADED_SUCCESSFULLY]){
            [self.profileImageButton setImage:editedImage forState:UIControlStateNormal];
            
            NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
            NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
            //[userDict setValue: forKey:@"profile_image"];
        }
        
    }];
}

@end
