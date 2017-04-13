//
//  User.h
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property NSString *fullname;
@property NSString *username;
@property NSString *password;
@property NSString *email;
@property NSString *mobile;


-(void) initUserFromJson : (NSDictionary *) userDict;

-(void)initUser:(NSString*) fullname username:(NSString *)username email:(NSString *)email mobile:(NSString *)mobile;
-(User*) getUser;
@end
