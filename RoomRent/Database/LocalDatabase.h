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

@interface LocalDatabase : NSObject

+(LocalDatabase*) sharedInstance;
-(LocalDatabase *) initLocalDatabase;

- (void) executeQueryOrUpdate :(NSString *) statement queryUpdateFlag:(BOOL) queryUpdateFlag;

-(void) pushPostToDatabase : (NSDictionary *) postDict viewController :(UIViewController *) VC;
@end
