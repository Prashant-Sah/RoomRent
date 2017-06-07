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
#import "ProgressIndicator.h"

@interface APICaller : NSObject

@property NSString *userApiToken;
// return shared instance for APICaller
+(APICaller *) sharedInstance;

// initialize AFHTTPSessionManager
-(APICaller *) initAPICaller;


/*
General calls to the api 
 method type = POST
 
 @param appendString        the string to be added to the baseurl
 @param useToken            use authentication or not
 @param params              parameters accepted as a dictionary
 @param imageData           single image NSData
 @param fileName            single filename
 @param VC                  the view controller calling this function
*/
-(void)callApi :  (NSString *) appendString useToken : (BOOL) useToken parameters:(NSDictionary *)params imageData : (NSData *) imageData fileName : (NSString *) fileName viewController:(UIViewController *) VC completion :(void (^) (NSDictionary * responseObjectDictionary)) completionBlock ;


/*
 call API to create a post / offer or request
 method type = POST
 
 @param appendString        the string to be added to the baseurl
 @param params              parameters accepted as a dictionary
 @param imageDataArray      Array of images NSData
 @param fileNameArray       Array of filename
 @param VC                  the view controller calling this function
 */
-(void)callApiToCreatePost:(NSString *)appendString parameters:(NSDictionary *)params imageDataArray:(NSArray *)imageDataArray fileNameArray:(NSArray *)fileNameArray viewController:(UIViewController *)VC completion:(void (^)(NSDictionary *responseObjectDictionary))completionBlock;


/*
 call API to get post/s
 method type = GET
 
 @param appendString        the string to be added to the baseurl
 @param params              parameters accepted as a dictionary
 @param VC                  the view controller calling this function
 */
-(void) callAPiToGetPost : (NSString *) appendString parameters :(NSDictionary *) params viewController :(UIViewController *) VC completion:(void (^)(NSDictionary *responseObjectDictionary))completionBlock;

/*
 call API to edit post
 */
-(void) callApiToEditPost : (NSString *) appendString parameters:(NSDictionary *) params viewController :(UIViewController *) VC completion:(void (^)(NSDictionary * responseObjectDictionary))completionBlock;

/*
 call API to delete post
 method type = DELETE
 
 @param appendString        the string to be added to the baseurl
 @param VC                  the view controller calling this function
 */
-(void) callApiForDelete : (NSString *) appendString parameters:(NSDictionary *) params viewController :(UIViewController *) VC completion:(void (^)(NSDictionary * responseObjectDictionary))completionBlock;

/*
 call API to get image
 method type = GET
 
 @param appendString        the string to be added to the baseurl
 @param VC                  the view controller calling this function
 
 */
-(void) callApiForReceivingImage : (NSString *) appendString viewController :(UIViewController *) VC completion : (void (^) (id responseObjectFromApi)) completionBlock;

/*
 Perform API get call for any raw URL
 */

-(void)callApiForGETRawUrl:(NSString*)url parameters:(NSDictionary*)params viewController :(UIViewController *) VC completion:(void (^)(id responseObject))completionBlock;
/*
 Error hnadler for all the above methods
 
 @param error       NSError sent by APICall methods
 @param VC          the view controller calling this function
 */

-(void) callCommonAlertWithError:(NSError *) error viewController:(UIViewController *) VC;

/*
 Perform API GET call for any valid URL

 @param params      paramters
 @param VC          the view controller calling this function
 */

-(void) sendUserApiToken;

-(void) callApiToEditProfileImage : (NSString *) appendString imageData:(NSData *)imageData fileName:(NSString *)fileName viewController:(UIViewController *)VC completion:(void (^)(NSDictionary * responseObjectDictionary))completionBlock;

@end
