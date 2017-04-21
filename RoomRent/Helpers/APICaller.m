//
//  APICaller.m
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "APICaller.h"
@implementation APICaller

AFHTTPSessionManager *manager = nil;

static APICaller* instance = nil;

+ (APICaller *)sharedInstance{
    if(instance == nil){
        instance = [[APICaller alloc]initAPICaller];
        return instance;
    }
    return instance;
}

-(APICaller *) initAPICaller{
    manager = [AFHTTPSessionManager manager];
    return self;
}

-(void)callApi:(NSString *)appendString headerFlag:(BOOL)headerFlag parameters:(NSDictionary *)params imageData:(NSData *)imageData fileName:(NSString *)fileName viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *))completionBlock{
    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    if(headerFlag){
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        NSLog(@"%@",userApiToken);
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    
    if(imageData == nil){
        [manager POST:[PUSP_BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
            completionBlock(responseObjectDictionary);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{
            }];
        }];
    }
    else{
        
        [manager POST:[PUSP_BASE_URL stringByAppendingString:appendString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"profile_image" fileName:fileName mimeType:@"image/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
            completionBlock(responseObjectDictionary);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{ }];
        }];
    }
}

- (void)callApiForReceivingImage:(NSString *)appendString viewController:(UIViewController *)VC completion:(void (^)(id))completionBlock{
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    NSLog(@"%@",userApiToken);
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[PUSP_BASE_URL stringByAppendingString:appendString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{ }];
    }];
}

@end
