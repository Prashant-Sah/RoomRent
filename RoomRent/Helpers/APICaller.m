//
//  APICaller.m
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "APICaller.h"

@implementation APICaller

//AFHTTPSessionManager *manager;
static APICaller* instance = nil;

+ (APICaller *)sharedInstance{
    if(instance == nil){
        instance = [[APICaller alloc]init];
        return instance;
    }
    return instance;
}

//-(APICaller *)initAPICaller{
//    manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    return self;
//}

-(void)callSome:(NSString *)appendString parameters:(NSDictionary *)params viewController:(UIViewController*)VC completion:(void (^)(NSDictionary *responseObjectDictionary))completionBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //[manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:APITOKEN] forHTTPHeaderField:@"Authorization"];
    [manager POST: [BASEURL stringByAppendingString:appendString] parameters:params progress:nil success:^
     
     (NSURLSessionTask *task, id responseObject) {
         NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
         completionBlock(responseObjectDictionary);
         
     } failure:^(NSURLSessionTask *operation, NSError *error) {
         [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{
             NSLog(@"Error");
         }];
     }];
    
}


@end
