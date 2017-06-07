//
//  SideBarViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/13/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "SideBarViewController.h"

@interface SideBarViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property UIActivityIndicatorView *activityIndicator;

@end

@implementation SideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImageButton.userInteractionEnabled = false;
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DATA_KEY];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];

    self.userNameLabel.text = user.username;
    
    if (user.profileImageURL != nil) {
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:[NSString stringWithFormat:@"%@", user.profileImageURL]]];
        
        [self.profileImageButton sd_setImageWithURL:url forState:UIControlStateNormal];
        [self.profileImageButton setContentMode:UIViewContentModeScaleAspectFit];
        
        self.profileImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
         self.profileImageButton.layer.cornerRadius = self.profileImageButton.frame.size.height/2;
        self.profileImageButton.layer.borderWidth = 2.0f;
        
    }
    
}
- (IBAction)profileBtnPressed:(UIButton *)sender {
    [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"ProfileViewController" tabBarController:nil];
}

- (IBAction)logoutBtnPressed:(UIButton *)sender {
    
    [self showActivityIndicator];
    
    [[APICaller sharedInstance] callApiForDelete:@"logout" parameters:nil viewController:self completion:^(NSDictionary *responseObjectDictionary){
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if([code isEqualToString:USER_LOGGED_OUT]){
            
            [self.activityIndicator stopAnimating];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userApiToken"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DATA_KEY];
            [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"SignInViewController" tabBarController:nil];
        }
    }];
    
}
- (IBAction)clear:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userApiToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DATA_KEY];
    [[Navigator sharedInstance] makeRootViewControllerWithStoryBoard:@"Account" viewController:@"SignInViewController" tabBarController:nil];
}

-(void) showActivityIndicator{
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.frame = CGRectMake(0, 0, 100, 100);
    self.activityIndicator.center = self.view.center;
    
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator bringSubviewToFront:self.view];
    [self.activityIndicator startAnimating];
    
}

@end
