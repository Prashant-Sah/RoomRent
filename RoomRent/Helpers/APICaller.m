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
    
    [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
    
    if(error.code == NSURLErrorTimedOut){
        
        [[Alerter sharedInstance] createAlert:@"Error" message:@"The server took too long to respond or is offline." useCancelButton:false viewController:VC completion:^{}];
        
    }else if (error.code == NSURLErrorCannotConnectToHost || error.code == NSURLErrorNotConnectedToInternet){
        
        [[Alerter sharedInstance] createAlert:@"Error" message:@"No connection to internet" useCancelButton:false viewController:VC completion:^{}];
    }
    else{
        NSLog(@"%@",error);
        [[Alerter sharedInstance] createAlert:@"Error" message:@"Server is offline! \nSorry for the inconvenience. \nPlease try again later." useCancelButton:false viewController:VC completion:^{}];
    }
    
    
}

-(void) sendUserApiToken{
    
    self.userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    NSLog(@"%@",_userApiToken);
    [manager.requestSerializer setValue:[@"Bearer " stringByAppendingString:self.userApiToken] forHTTPHeaderField:@"Authorization"];
}



-(void)callApi:(NSString *)appendString useToken:(BOOL)useToken parameters:(NSDictionary *)params imageData:(NSData *)imageData fileName:(NSString *)fileName viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *))completionBlock{
    
    [[ProgressIndicator alloc] showActivityIndicatorOnView:VC.view];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    if(useToken){
        [self sendUserApiToken];
    }
    
    if(imageData == nil){
        [manager POST:[BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
             [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
            completionBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self callCommonAlertWithError:error viewController:VC];
        }];
    }
    else{
        
        [manager POST:[BASE_URL stringByAppendingString:appendString] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:imageData name:@"profile_image" fileName:fileName mimeType:@"image/jpeg"];
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
           [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
            completionBlock(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [self callCommonAlertWithError:error viewController:VC];
        }];
    }
}




// Post the Posts
-(void) callApiToCreatePost:(NSString *)appendString parameters:(NSDictionary *)params imageDataArray:(NSArray *)imageDataArray fileNameArray:(NSArray *)fileNameArray viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *))completionBlock{
    
    [[ProgressIndicator alloc] showActivityIndicatorOnView:VC.view];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self sendUserApiToken];
    
    if(imageDataArray.count <= 0){
        [manager POST:[BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
             [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
            completionBlock(responseObject);
            
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
                  [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
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
    
    [[ProgressIndicator alloc] showActivityIndicatorOnView:VC.view];
    
    //manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [self sendUserApiToken];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:[BASE_URL stringByAppendingString:appendString] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
        completionBlock(responseObject);
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self callCommonAlertWithError:error viewController:VC];
    }];
    
}
/*
 
 call API to edit post
 
 */

-(void) callApiToEditPost : (NSString *) appendString parameters:(NSDictionary *) params viewController :(UIViewController *) VC completion:(void (^)(NSDictionary * responseObjectDictionary))completionBlock{
    
    [[ProgressIndicator alloc] showActivityIndicatorOnView:VC.view];
    
    [self sendUserApiToken];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager PUT:[BASE_URL stringByAppendingString:appendString] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self callCommonAlertWithError:error viewController:VC];
    }];
    
}


/*
 call API to delete post
 */

-(void) callApiForDelete : (NSString *) appendString parameters:(NSDictionary *) params viewController :(UIViewController *) VC completion:(void (^)(NSDictionary * responseObjectDictionary))completionBlock{
    
    [[ProgressIndicator alloc] showActivityIndicatorOnView:VC.view];
    
    [self sendUserApiToken];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager DELETE:[BASE_URL stringByAppendingString:appendString] parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
        completionBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self callCommonAlertWithError:error viewController:VC];
    }];
    
}

/*
 API calls for receiving image
 
 */
- (void)callApiForReceivingImage:(NSString *)appendString viewController:(UIViewController *)VC completion:(void (^)(id))completionBlock{
    
    [self sendUserApiToken];
    
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    
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
    
    [[ProgressIndicator alloc] showActivityIndicatorOnView:VC.view];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[ProgressIndicator alloc] hideActivityIndicatorFromView:VC.view];
        completionBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self callCommonAlertWithError:error viewController:VC];
        
    }];
    
}

-(void) callApiToEditProfileImage : (NSString *) appendString imageData:(NSData *)imageData fileName:(NSString *)fileName viewController:(UIViewController *)VC completion:(void (^)(NSDictionary * responseObjectDictionary))completionBlock{
    
    [self sendUserApiToken];
    
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:appendString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imagedata name:@"profile_image" fileName:filename mimeType:@"image/jpeg"];
    } error:nil];
    
    NSURLSessionDataTask *task =  [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error){
            completionBlock(responseObject);
        }else{
            [self callCommonAlertWithError:error viewController:VC];
        }
    }];
    [task resume];
}
@end
