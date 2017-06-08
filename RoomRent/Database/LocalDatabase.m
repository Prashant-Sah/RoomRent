//
//  LocalDatabase.m
//  RoomRent
//
//  Created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "LocalDatabase.h"

@implementation LocalDatabase

NSString *databaseName = @"LocalDatabase.db";

FMDatabase *database = nil;
BOOL queryFlag = 1;
BOOL updateFlag = 0;

static LocalDatabase *instance = nil;

+ (LocalDatabase *)sharedInstance{
    if(instance == nil){
        instance = [[LocalDatabase alloc] init ];
    }
    return instance;
}


-(void)initLocalDatabase{
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent: databaseName];
    
    database.logsErrors = YES;
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS POST_TABLE ( Post_id INTEGER PRIMARY KEY, Post_type INTEGER DEFAULT 1, Title TEXT DEFAULT NULL , Slug TEXT DEFAULT NULL, Description TEXT DEFAULT NULL , No_of_rooms INTEGER DEFAULT 0 , Price INTEGER DEFAULT 0, Latitude REAL DEFAULT 0 , Longitude REAL DEFAULT 0, Location TEXT DEFAULT NULL, User_id Integer DEFAULT 0 )"];
    [database executeUpdate:@"CREATE TABLE IF NOT EXISTS POST_PHOTOS_TABLE(Post_id INTEGER , PHOTO TEXT DEFAULT NULL)"];
    
    [database close];
}

-(void) pushPostToDatabase : (Post *) post viewController :(UIViewController *) VC{
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent: databaseName];
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    if (post.imagesArray.count >0){
        for (NSString *imageURL in post.imagesArray) {
            
            [database executeUpdate:@"INSERT INTO POST_PHOTOS_TABLE (Post_id, Photo) VALUES (?,?) ", [NSNumber numberWithInt:post.postid],[NSString stringWithFormat:@"%@", imageURL] ];
        }
    }
    
    BOOL isSuccess = [database executeUpdate:@"INSERT INTO POST_TABLE (Post_id ,  Post_type, Title , Slug, Description, No_of_rooms , Price, Latitude, Longitude, Location, User_id) VALUES (?,?,?,?,?,?,?,?,?,?,?) ",[NSNumber numberWithInt:post.postid], [NSNumber numberWithInt:post.postType], [NSString stringWithFormat:@"%@", post.title], [NSString stringWithFormat:@"%@", post.postSlug], [NSString stringWithFormat:@"%@", post.postDescription], [NSNumber numberWithInt:post.numberOfRooms], [NSNumber numberWithInt:post.price], [NSNumber numberWithDouble:post.latitude] , [NSNumber numberWithDouble:post.longitude],[NSString stringWithFormat:@"%@", post.location], [NSNumber numberWithInt: post.postUser.userId] ];
    
    if(!isSuccess){
        NSLog(@"%@",[database lastError]);
    }
    [database close];
}





-(void)executeQueryOrUpdate:(NSString *)statement queryUpdateFlag:(BOOL)queryUpdateFlag{
    
    [database open];
    
    if(queryUpdateFlag == queryFlag){
        FMResultSet *results = [database executeQuery:statement];
        [database close];
    }
    else{
        [database executeUpdate:statement];
        [database close];
    }
}
@end
