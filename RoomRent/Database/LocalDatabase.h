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

@interface LocalDatabase : NSObject

+(LocalDatabase*) sharedInstance;
-(void) initLocalDatabase;

- (void) executeQueryOrUpdate :(NSString *) statement queryUpdateFlag:(BOOL) queryUpdateFlag;

-(void) pushPostToDatabase : (Post *) post viewController :(UIViewController *) VC;
@end
