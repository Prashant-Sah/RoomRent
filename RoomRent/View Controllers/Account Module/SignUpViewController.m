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
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _emailAddTextField.tag = EMAILADDRESSTEXTFIELD;
    //navigation Bar clear
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    cancelButton.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
}

- (IBAction)create:(UIButton *)sender {
    [self dismissViewControllerAnimated:true  completion:nil];
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
