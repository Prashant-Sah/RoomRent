//
//  LocalDatabase.m
//  RoomRent
//
//  created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "LocalDatabase.h"

@implementation LocalDatabase

NSString *databaseName = @"LocalDatabase.db";


BOOL queryFlag = 1;
BOOL updateFlag = 0;

NSArray *docPaths;
static NSString *documentsDir;
NSString *databasePath;
FMDatabase *database;
LocalDatabase *instance = nil;
FMDatabaseQueue *queue;

+ (LocalDatabase *)sharedInstance{
    if(instance == nil){
        instance = [[LocalDatabase alloc] initLocalDatabase];
    }
    return instance;
}


-(LocalDatabase*)initLocalDatabase{
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    databasePath = [documentsDir stringByAppendingPathComponent: databaseName];
    NSLog(@"Path = %@",databasePath);
    database = [FMDatabase databaseWithPath:databasePath];
    queue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
    
    [queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate: @"create table if not exists Users_table (id integer primary key not null, name text not null, email text not null, username text not null,phone text not null, profile_image text not null)"];
        
        [db executeUpdate:@"create table if not exists Posts_table ( id integer primary key , post_type integer not null, title text not null , slug text not null, description text not null , no_of_rooms integer not null , price integer not null, latitude real not null , longitude real not null, address text not null, created_at text not null, updated_at text not null, deleted_at text default null,  user_id integer, foreign key (user_id) references Users_table (id))"];
        
        [db executeUpdate:@"create table if not exists Posts_photos_table( id integer,photoURL text not null,  foreign key (id) references  Posts_table (id), primary key (id, photoURL)) "];
        
    }];
    
    return self;
}

-(NSString *) pushPostToDatabase : (NSDictionary *) postsDict{
    
    for (NSDictionary *singlePostDict in postsDict) {
        Post *post = [[Post alloc] initPostFromJson:singlePostDict];
        
        [self pushSinglePostToDatabase:post];
    }
    [database open];
    FMResultSet *result = [database executeQuery:@"select updated_at from Posts_table order by updated_at desc limit 1"];
    [result next];
    NSString *updatedDateOfLastPost = [result stringForColumn:@"updated_at"];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:PostPostedSuccessKey object:self];
    return updatedDateOfLastPost;
}

-(void) pushSinglePostToDatabase:(Post*) post{
    
    if (post.imagesArray.count >0){
        for (NSString *imageURL in post.imagesArray) {
            [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                [db executeUpdate:@"insert into Posts_photos_table (id, photoURL) values (?,?) ", [NSNumber numberWithInt:post.postid],[NSString stringWithFormat:@"%@", imageURL] ];
            }];
        }
    }
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:@"insert into Posts_table (id ,  post_type, title , slug, description, no_of_rooms , price, latitude, longitude, address, created_at, updated_at, deleted_at, user_id) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?) ",[NSNumber numberWithInt:post.postid], [NSNumber numberWithInt:post.postType], [NSString stringWithString: post.title], [NSString stringWithString: post.postSlug], [NSString stringWithString: post.postDescription], [NSNumber numberWithInt:post.numberOfRooms], [NSNumber numberWithInt:post.price], [NSNumber numberWithDouble:post.latitude] , [NSNumber numberWithDouble:post.longitude],[NSString stringWithString: post.location], [NSString stringWithString:post.postCreatedOn], [NSString stringWithString:post.postUpdatedOn], [post.postDeletedOn isEqual:[NSNull null]]?  @"" : [NSString stringWithString:post.postDeletedOn], [NSNumber numberWithInt: post.postUser.userId] ];
        
        
        if (![self existsInTable:@"Users_table" withId:post.postUser.userId inDatabase:db]){
            [db executeUpdate:@"insert into Users_table (id, name , email , username, phone, profile_image) values (?,?,?,?,?,?)",[NSNumber numberWithInt:post.postUser.userId], [NSString stringWithFormat:@"%@", post.postUser.fullname], [NSString stringWithString:post.postUser.email], [NSString stringWithString:post.postUser.username], [NSString stringWithString:post.postUser.mobile], [NSString stringWithString:post.postUser.profileImageURL] ];
        }
        
    }];
}

-(BOOL)existsInTable:(NSString *) tableName withId:(int) id inDatabase:(FMDatabase *) db{
    
    NSString *query = [NSString stringWithFormat:@"select * from %@ where id = %d", tableName,id];
    FMResultSet *result = [db executeQuery:query];
    [result next];
    NSUInteger count = [[result resultDictionary] count];
    if(count > 0){
        return true;
    }else{
        return  false;
    }
}

-(void) pushUpdatedPostToDatabase:(Post *) updatedPost{
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"Update Posts_table set title = '%@', description = '%@', no_of_rooms = %d, price = %f, latitude = %f , longitude = %f, address= '%@', updated_at = '%@' where id = '%d' ", updatedPost.title, updatedPost.postDescription, updatedPost.numberOfRooms, updatedPost.price, updatedPost.latitude, updatedPost.longitude, updatedPost.location, updatedPost.postUpdatedOn, updatedPost.postid];
        
        [db executeUpdate:sql];
    }];
}

-(void) pushUpdatedPostsToDatabase:(NSDictionary *) postsDict{
    
    for (NSDictionary *singlePostDict in postsDict) {
        Post *post = [[Post alloc] initPostFromJson:singlePostDict];
        [self pushUpdatedPostToDatabase:post];
    }
}

-(void)deleteSinglePostFromDatabase :(int) postid{
    
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = [NSString stringWithFormat:@"Delete from Posts_table where id = %d", postid];
        
        [db executeUpdate:sql];
    }];
}

-(void)deletePostsFromDatabase:(NSDictionary *) postsDict{
    for (NSDictionary *singlePostDict in postsDict) {
        Post *post = [[Post alloc] initPostFromJson:singlePostDict];
        [self deleteSinglePostFromDatabase:post.postid];
    }
}

- (NSMutableArray *)getPostsFromDatabaseWithQuery:(NSString *)query {
    
    NSMutableArray *postsArray = [[NSMutableArray alloc] init];
    // NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *results1 = [db executeQuery:query];
        
        while([results1 next]){
            
            NSMutableDictionary *postDictionary = [[NSMutableDictionary alloc] initWithDictionary:[results1 resultDictionary] ];
            
        //            NSString *sql2 = [NSString stringWithFormat:@"Select * from Users_table where userid = %@", [postDictionary valueForKey:@"userid"] ];
            
            FMResultSet *results3 = [db executeQuery:@"Select * from Users_table where id = ?", [postDictionary valueForKey:@"userid"]];
            ;
            
            if([results3 next]) {
                NSDictionary *dict = [results3 resultDictionary];
                [postDictionary setObject:dict forKey: @"user"];
            }
        
            NSString *sql = [NSString stringWithFormat:@"Select photoURL from Posts_photos_table where id = %@", [postDictionary valueForKey:@"id"]];
            FMResultSet *results2 = [db executeQuery:sql];
            NSMutableArray *images = [[NSMutableArray alloc] init];
            while([results2 next]){
                [images addObject:[results2 stringForColumn:@"photoURL"]];
            }
            if (images != nil){
                [postDictionary setObject:images forKey:@"images"];
            }
            [postsArray addObject:[[Post alloc] initPostFromJson:postDictionary]];
        }
    }];
    return postsArray;
}

@end
