//
//  DatabaseLoader.h
//  RoomRent
//
//  Created by Prashant Sah on 6/22/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalDatabase.h"
#import "APICaller.h"

@interface DatabaseLoader : NSObject

+(DatabaseLoader *) sharedInstance;
-(void) loadPostsToDatabaseWithTimeStamp:(NSString *) timeStamp andOlder :(NSString *) older andType : (NSString *) type;

@end
