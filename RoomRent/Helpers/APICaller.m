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
NSString *userApiToken = nil;
static APICaller* instance = nil;
NSData *imagedata;
NSString *filename;

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

-(void) callCommonAlertWithError:(NSError *) error viewController:(UIViewController *) VC{
    
    if(error.code == NSURLErrorTimedOut){
        
        [[Alerter sharedInstance] createAlert:@"Error" message:@"The server took too long to respond or is offline." viewController:VC completion:^{}];
        
    }else if (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorNotConnectedToInternet){
        
        [[Alerter sharedInstance] createAlert:@"Error" message:@"No connection to internet" viewController:VC completion:^{}];
    }
    else{
        NSLog(@"%@",error);
        [[Alerter sharedInstance] createAlert:@"Error" message:@"Error in API Call" viewController:VC completion:^{}];
    }
}


-(void)callApi:(NSString *)appendString useToken:(BOOL)useToken parameters:(NSDictionary *)params imageData:(NSData *)imageData fileName:(NSString *)fileName viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *))completionBlock{
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    if(useToken){
        userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    }
    
    if(imageData == nil){
        [manager POST:[BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
            completionBlock(responseObjectDictionary);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self callCommonAlertWithError:error viewController:VC];
        }];
    }
    else{
        
        [manager POST:[BASE_URL stringByAppendingString:appendString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"profile_image" fileName:fileName mimeType:@"image/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
            completionBlock(responseObjectDictionary);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [self callCommonAlertWithError:error viewController:VC];
        }];
    }
}




// Post the Posts
-(void) callApiToCreatePost:(NSString *)appendString parameters:(NSDictionary *)params imageDataArray:(NSArray *)imageDataArray fileNameArray:(NSArray *)fileNameArray viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *))completionBlock{
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    
    if(imageDataArray.count <= 0){
        [manager POST:[BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseObjectDictionary = (NSDictionary*) responseObject;
            completionBlock(responseObjectDictionary);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self callCommonAlertWithError:error viewController:VC];
            
        }];
    } else {
        
        [manager POST:[BASE_URL stringByAppendingString:appendString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (int index=0 ; index<imageDataArray.count ; index++){
                imagedata = imageDataArray[index];
                filename = fileNameArray[index];
                
                [formData appendPartWithFileData:imagedata name:@"images[]" fileName:filename mimeType:@"image/jpeg"];
            }
        }
             progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 
                 completionBlock(responseObject);
                 
             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                 [self callCommonAlertWithError:error viewController:VC];
             }];
        
    }
    
}


/*
 
 
APICalls to get post/s
 
 
*/
-(void) callAPiToGetPost : (NSString *) appendString parameters :(NSDictionary *) params viewController :(UIViewController *)  VC completion:(void (^)(NSDictionary *))completionBlock{
    
    userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completionBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self callCommonAlertWithError:error viewController:VC];
    }];
}

/*

 API calls for receiving image

*/
- (void)callApiForReceivingImage:(NSString *)appendString viewController:(UIViewController *)VC completion:(void (^)(id))completionBlock{
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[BASE_URL stringByAppendingString:appendString] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completionBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self callCommonAlertWithError:error viewController:VC];
    }];
}
/*
 Perform API GET call for any valid URL
 */

-(void)callApiForGETRawUrl:(NSString*)url parameters:(NSDictionary*)params viewController :(UIViewController *) VC completion:(void (^)(id))completionBlock {
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
   [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        completionBlock(responseObject);
        
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [self callCommonAlertWithError:error viewController:VC];
        
    }];
    
}
@end
