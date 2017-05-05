//
//  LocalDatabase.m
//  RoomRent
//
//  Created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "LocalDatabase.h"

@implementation LocalDatabase

FMDatabase *database = nil;
BOOL queryFlag = 1;
BOOL updateFlag = 0;

static LocalDatabase *instance = nil;
+ (LocalDatabase *)sharedInstance{
    if(instance == nil){
        instance = [[LocalDatabase alloc] initLocalDatabase ];
        return instance;
    }
    return instance;
}


-(LocalDatabase *)initLocalDatabase{
    
    NSString *databaseName = @"localDatabase";
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *databasePath = [documentsDir stringByAppendingPathComponent: databaseName];
    
    database.logsErrors = YES;
    
    if (!database){
        FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
        
        [database executeUpdate:@"CREATE TABLE POST_TABLE ( Post_id INTEGER PRIMARY KEY, Title TEXT DEFAULT NULL , Description TEXT DEFAULT NULL , No_of_rooms INTEGER DEFAULT 0 , Price INTEGER DEFAULT 0 Latitude REAL DEFAULT 0 , LONGITUDE REAL DEFAULT 0 )"];
        [database executeUpdate:@"CREATE TABLE POST_PHOTOS_TABLE(Post_id INTEGER PRIMARY KEY, PHOTO BLOB )"];
        [database close];
    }
    
    return self;
}

-(void) pushPostToDatabase : (NSDictionary *) postDict viewController :(UIViewController *) VC{
    
    //self.imagesArray = [[NSMutableArray alloc] init];
    [database open];
    
    NSInteger postid = [[postDict valueForKey:@"id"] intValue];
    NSString *title = [postDict valueForKey:@"title"];
    NSString *offerDescription = [postDict valueForKey:@"description"];
    NSInteger numberOfRooms = [[postDict valueForKey:@"no_of_rooms"] intValue];
    NSInteger price = [[postDict valueForKey:@"price"] intValue];
    double lat = [[postDict valueForKey:@"latitude"] doubleValue];
    double lon = [[postDict valueForKey:@"longitude"] doubleValue];
    //NSArray *imagesArray = [postDict valueForKey:@"images"];
    
    //[self executeQueryOrUpdate:@"INSERT INTO POST_TABLE (Post_id , Title , Description, No_of_rooms , Price, Latitude, Longitude) VALUES (?,?,?,?,?,?,?) ", [] queryUpdateFlag:updateFlag]
    
    BOOL isSuccess = [database executeUpdate:@"INSERT INTO POST_TABLE (Post_id , Title , Description, No_of_rooms , Price, Latitude, Longitude) VALUES (?,?,?,?,?,?,?) ",[NSNumber numberWithInt:postid], [NSString stringWithFormat:@"%@", title], [NSString stringWithFormat:@"%@", offerDescription], [NSNumber numberWithInt:numberOfRooms], [NSNumber numberWithInt:price], [NSNumber numberWithDouble:lat] , [NSNumber numberWithDouble:lon] ];
    
    NSString *message;
    if(isSuccess){
        message = @"Data added to database";
    }else{
        message = @"Data additon failed";
    }
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
