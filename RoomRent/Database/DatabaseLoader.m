//
//  DatabaseLoader.m
//  RoomRent
//
//  Created by Prashant Sah on 6/22/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "DatabaseLoader.h"

@implementation DatabaseLoader
static DatabaseLoader *instance = nil;

+(DatabaseLoader *) sharedInstance{
    if(instance == nil){
        return [[DatabaseLoader alloc]  init];
    }
    return instance;
}

-(void) loadPostsToDatabaseWithTimeStamp:(NSString *) timeStamp andOlder :(NSString *) older andType : (NSString *) type{
    
    NSDictionary *params =@{
                            @"type" : type
                            };
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if(timeStamp != nil){
        
        [parameters setObject:older forKey:@"older"];
        [parameters setObject:timeStamp forKey:@"timestamp"];
        
        [[APICaller sharedInstance] callAPiToGetPost:@"posts" parameters:parameters viewController:nil completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@", responseObjectDictionary);
            if ([[responseObjectDictionary valueForKey:@"code" ] isEqualToString:POSTS_FOUND]){
                
                NSDictionary *updatedPostDictionary = [responseObjectDictionary valueForKey:@"updated"];
                NSDictionary *updatedpostData = [updatedPostDictionary valueForKey:@"data"];
                if(updatedpostData != nil){
                    [[LocalDatabase sharedInstance] pushUpdatedPostsToDatabase:updatedpostData];
                }
                
                NSDictionary *createdPostsDictionary = [responseObjectDictionary valueForKey:@"created"];
                
                NSDictionary *createdpostData = [createdPostsDictionary valueForKey:@"data"];
                if(createdpostData != nil){
                    [[LocalDatabase sharedInstance] pushPostToDatabase:createdpostData];
                }
                
                NSDictionary *deletedPostDictionary = [responseObjectDictionary valueForKey:@"deleted"];
                NSDictionary *deletedPostData = [deletedPostDictionary valueForKey:@"data"];
                if(deletedPostData != nil){
                    [[LocalDatabase sharedInstance] deletePostsFromDatabase:deletedPostData];
                }
            }
        }];
        
    }else{
        [[APICaller sharedInstance] callAPiToGetPost:@"posts" parameters:params viewController:nil completion:^(NSDictionary *responseObjectDictionary) {
            
            if ([[responseObjectDictionary valueForKey:@"code" ] isEqualToString:POSTS_FOUND]){
                
                NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
                
                [[LocalDatabase sharedInstance] pushPostToDatabase:postData];
            }
        }];
    }
    
}
@end
