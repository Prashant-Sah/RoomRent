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

NSData *imagedata;
NSString *filename;

-(void)callApi:(NSString *)appendString headerFlag:(BOOL)headerFlag parameters:(NSDictionary *)params imageData:(NSData *)imageData fileName:(NSString *)fileName viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *))completionBlock{
    
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
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[PUSP_BASE_URL stringByAppendingString:appendString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{ }];
    }];
}

-(void) callApiforPost:(NSString *)appendString headerFlag:(BOOL)headerFlag parameters:(NSDictionary *)params imageDataArray:(NSArray *)imageDataArray fileNameArray:(NSArray *)fileNameArray viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *))completionBlock{
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if(headerFlag){
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        NSLog(@"%@",userApiToken);
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    
    if(imageDataArray.count <= 0){
        [manager POST:[PUSP_BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
            completionBlock(responseObjectDictionary);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@", error);
            
            [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{
            }];
            
        }];
    } else {
        
        [manager POST:[PUSP_BASE_URL stringByAppendingString:appendString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (int index=0 ; index<imageDataArray.count ; index++){
                imagedata = imageDataArray[index];
                filename = fileNameArray[index];
                
                [formData appendPartWithFileData:imagedata name:@"images[]" fileName:filename mimeType:@"image/jpeg"];
            }
        }
        progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
            
            completionBlock(responseObjectDictionary);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if(error.code == NSURLErrorTimedOut){
                [[Alerter sharedInstance] createAlert:@"Error" message:@"The server took too long to respond." viewController:VC completion:^{}];
            }else if (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorNotConnectedToInternet){
                [[Alerter sharedInstance] createAlert:@"Error" message:@"No connection to internet" viewController:VC completion:^{}];
            }
            else{
                [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{}];
            }
        }];
        
    }
}

@end
