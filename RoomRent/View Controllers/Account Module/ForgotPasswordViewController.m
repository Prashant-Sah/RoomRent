//
//  ForgotPasswordViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 3/31/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation bar clear
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    cancelButton.tintColor =[UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
}

-(void) onCancel{
    [self dismissViewControllerAnimated:NO completion:nil];
}

//MARK -Button handlers

- (IBAction)sendPasswordButtonPressed:(UIButton *)sender {
    
    NSDictionary *params = @{
                             @"email" : _emailAddressTextField.text
                             };
    [[APICaller sharedInstance] callApi:@"forgetpassword" headerFlag:false parameters:params imageData:nil fileName:nil viewControlller:self completion:^(NSDictionary *responseObjectDictionary) {
    
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        
        if ([code isEqualToString:USER_REGISTERED ]){
            
            NSString *message = [responseObjectDictionary valueForKey:@"message"];
            [[Alerter sharedInstance] createAlert:@"Success" message:message viewController:self completion:^{
            }];
            [self dismissViewControllerAnimated:true  completion:nil];
            
        }
        else{
            
            NSString *errorMessage = [responseObjectDictionary valueForKey:@"message"];
            [[Alerter sharedInstance] createAlert:@"Error" message:errorMessage viewController:self completion:^{
            }];
        }
    }];
    
}

@end
