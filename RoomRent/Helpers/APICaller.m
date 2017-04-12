//
//  APICaller.m
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "APICaller.h"
@implementation APICaller

static APICaller* instance = nil;

+ (APICaller *)sharedInstance{
    if(instance == nil){
        instance = [[APICaller alloc]init];
        return instance;
    }
    return instance;
}

-(void)callApi:(NSString *)appendString parameters:(NSDictionary *)params headerFlag:(BOOL) headerFlag viewController:(UIViewController*)VC completion:(void (^)(NSDictionary *responseObjectDictionary))completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if(headerFlag){
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        NSLog(@"%@",userApiToken);
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    [manager POST: [PUSP_BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^
     (NSURLSessionTask *task, id responseObject) {
         
         NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
         completionBlock(responseObjectDictionary);
         
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         
         [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{
         }];
     }];
    
}


@end
