//
//  LocalDatabase.m
//  RoomRent
//
//  Created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "LocalDatabase.h"

@implementation LocalDatabase

NSString *databaseName = @"localDatabase.sqlite";
FMDatabase *database = nil;
BOOL queryFlag = 1;
BOOL updateFlag = 0;

static LocalDatabase *instance = nil;
+ (LocalDatabase *)sharedInstance{
    if(instance == nil){
        instance = [[LocalDatabase alloc] initLocalDatabase ];
    }
    return instance;
}


-(LocalDatabase *)initLocalDatabase{
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent: databaseName];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    //BOOL databaseExists = [filemgr fileExistsAtPath:databasePath];
    
    database.logsErrors = YES;
    
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        [database open];
        [database executeUpdate:@"CREATE TABLE IF  NOT EXISTS POST_TABLE ( Post_id INTEGER PRIMARY KEY, Title TEXT DEFAULT NULL , Description TEXT DEFAULT NULL , No_of_rooms INTEGER DEFAULT 0 , Price INTEGER DEFAULT 0 Latitude REAL DEFAULT 0 , LONGITUDE REAL DEFAULT 0 )"];
        [database executeUpdate:@"CREATE TABLE POST_PHOTOS_TABLE(Post_id INTEGER PRIMARY KEY, PHOTO BLOB )"];
    
    [database close];
    return self;
}

-(void) pushPostToDatabase : (Post *) post viewController :(UIViewController *) VC{
    
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent: databaseName];
    //self.imagesArray = [[NSMutableArray alloc] init];
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    [database open];
    
    NSInteger postid = post.postid;
    NSString *title = post.title;
    NSString *offerDescription = post.postDescription;
    NSInteger numberOfRooms = post.numberOfRooms;
    NSInteger price = post.price;
    double lat = post.latitude;
    double lon = post.longitude;
    //NSArray *imagesArray = post.imagesArray;
    
    //[self executeQueryOrUpdate:@"INSERT INTO POST_TABLE (Post_id , Title , Description, No_of_rooms , Price, Latitude, Longitude) VALUES (?,?,?,?,?,?,?) ", [] queryUpdateFlag:updateFlag]
    
    BOOL isSuccess = [database executeUpdate:@"INSERT INTO POST_TABLE (Post_id , Title , Description, No_of_rooms , Price, Latitude, Longitude) VALUES (?,?,?,?,?,?,?) ",[NSNumber numberWithInt:postid], [NSString stringWithFormat:@"%@", title], [NSString stringWithFormat:@"%@", offerDescription], [NSNumber numberWithInt:(int)numberOfRooms], [NSNumber numberWithInt:(int)price], [NSNumber numberWithDouble:lat] , [NSNumber numberWithDouble:lon] ];
    if(!isSuccess){
        NSLog(@"%@",[database lastError]);
    }
    NSString *message;
    if(isSuccess){
        message = @"Data added to database";
    }else{
        message = @"Data additon failed";
    }
    
    [database close];
    //[[Alerter sharedInstance] createAlert:@"Message" message:message viewController:VC  completion:^{ }];
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
