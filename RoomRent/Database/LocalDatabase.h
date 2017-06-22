//
//  LocalDatabase.h
//  RoomRent
//
//  Created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

#import "Alerter.h"
#import "Post.h"
#import "Constants.h"

@interface LocalDatabase : NSObject

+(LocalDatabase*) sharedInstance;
-(LocalDatabase*) initLocalDatabase;

-(void) pushSinglePostToDatabase:(Post*) post;
-(NSString *) pushPostToDatabase : (NSDictionary *) postsDict;

-(void) pushUpdatedPostToDatabase:(Post *) updatedPost;
-(void) pushUpdatedPostsToDatabase:(NSDictionary *) postsDict;

-(void)deleteSinglePostFromDatabase :(int) postid;
-(void)deletePostsFromDatabase:(NSDictionary *) postsDict;

- (NSMutableArray *)getPostsFromDatabaseWithQuery:(NSString *)query;

@end
