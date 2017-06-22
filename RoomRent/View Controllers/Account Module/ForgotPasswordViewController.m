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
                             @"email" : self.emailAddressTextField.text
                             };
    
    [[APICaller sharedInstance] callApi:FORGOT_PASSWORD_PATH useToken:false parameters:params imageData:nil fileName:nil viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@",responseObjectDictionary);
            
        if([[responseObjectDictionary valueForKey:@"code"] isEqualToString:PASSWORD_RESET_LINK_SENT]){
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else{
            NSString *errorMessage = [responseObjectDictionary valueForKey:@"message"];
            [[Alerter sharedInstance] createAlert:@"Error" message:errorMessage useCancelButton:false viewController:self completion:^{
            }];
        }
    }];
    
}

@end
