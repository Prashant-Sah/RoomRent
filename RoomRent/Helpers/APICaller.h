//
//  APICaller.h
//  RoomRent
//
//  Created by Prashant Sah on 4/6/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import"Constants.h"
#import "Alerter.h"

@interface APICaller : NSObject

+(APICaller *) sharedInstance;

-(APICaller *) initAPICaller;

-(void)callApi :  (NSString *) appendString headerFlag : (BOOL) headerFlag parameters:(NSDictionary *)params imageData : (NSData *) imageData fileName : (NSString *) fileName viewController:(UIViewController *) VC completion :(void (^) (NSDictionary * responseObjectDictionary)) completionBlock ;

-(void) callApiForReceivingImage : (NSString *) appendString viewController :(UIViewController *) VC completion : (void (^) (id responseObjectFromApi)) completionBlock;

-(void)callApiToCreatePost:(NSString *)appendString parameters:(NSDictionary *)params imageDataArray:(NSArray *)imageDataArray fileNameArray:(NSArray *)fileNameArray viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *responseObjectDictionary))completionBlock;

-(void) callAPiToGetAllPosts : (NSString *) appendString parameters :(NSDictionary *) params viewController :(UIViewController *) VC completion:(void (^)(NSDictionary *responseObjectDictionary))completionBlock;

-(void) callApiToGetSinglePost :(NSString *) appendString viewController :(UIViewController *) VC completion :(void (^) (NSDictionary * responseObjectDictionary)) completionBlock ;

-(void) getImageForURL : (NSString *) appendString requiredImageSize : (CGSize) destinationSize viewController :(UIViewController *) VC completion:(void (^)(UIImage *resizedImage))completionBlock;


-(void) callCommonAlertWithError:(NSError *) error viewController:(UIViewController *) VC;

@end
