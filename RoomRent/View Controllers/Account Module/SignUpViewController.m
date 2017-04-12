//
//  SignUpViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 3/31/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "SignUpViewController.h"
//#import "CustomButton.h"
NSString *msg;
@interface SignUpViewController ()

@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //Assigning tags to textfields
    _nameTextField.tag = NAME_TEXTFIELD;
    _mobileTextField.tag = MOBILE_TEXTFIELD;
    _userNameTextField.tag = USERNAME_TEXTFIELD;
    _emailAddTextField.tag = EMAIL_ADDRESS_TEXTFIELD;
    _passwordTextField.tag = PASSWORD_TEXTFIELD;
    
    
    _nameTextField.text = @"Prashant-Sah";
    _mobileTextField.text =@"9842879727";
    _userNameTextField.text =@"Prashat";
    _emailAddTextField.text = @"068bex@gmail.com";
    _passwordTextField.text = @"12345";
    
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
                             @"profileImage" : @"sdfdxgdf"
                             };
    
    [[APICaller sharedInstance] callApi:@"register" parameters:params headerFlag: false viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@", responseObjectDictionary);
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        
        if ([code isEqualToString:USER_REGISTERED ]){
            
            [self dismissViewControllerAnimated:true  completion:nil];
            
        }
        else{
            
            //NSString *msg = @"";
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
            [[Alerter sharedInstance] createAlert:@"Error" message:errorMessage viewController:self completion:^{
            }];
        }
    }];
}

-(void) onCancel{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma-mark - add profile photo
- (IBAction)addPhoto:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self ;
    //__weak SignUpViewController *weakself;
    //pickerController.delegate = weakself;
    pickerController.allowsEditing = true;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    [self.profileImageButton setImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:true completion:nil];
    
}

@end
