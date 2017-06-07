//
//  DBManager.h
//  RoomRent
//
//  Created by Prashant Sah on 6/5/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSMutableArray *arrResults;



-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;
@end
