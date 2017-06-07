//
//  Alerter.m
//  RoomRent
//
//  Created by Prashant Sah on 4/5/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "Alerter.h"

@implementation Alerter

static Alerter *instance = nil;

+(Alerter*) sharedInstance {
    if (instance == nil){
        instance = [[Alerter alloc] init];
    }
    return instance;
}

-(void)createAlert:(NSString*)alertTitle message:(NSString*)alertMessage useCancelButton :(BOOL) useCancelButton viewController:(UIViewController*)VC  completion:(void (^)(void))completionBlock {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        completionBlock();
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [VC dismissViewControllerAnimated:true  completion:nil];
    }];
    
    [alert addAction:actionOk];
    if(useCancelButton){
        [alert addAction:cancel];
    }
    [VC presentViewController: alert animated:true completion:nil];
}
@end

