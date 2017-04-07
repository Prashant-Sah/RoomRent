//
//  User.h
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSString *fullname;
@property NSString *username;
@property NSString *password;
@property NSString *email;
@property NSString *mobile;

-(void) initUser : (NSString*)user  password:(NSString*)pass email:(NSString*)email mobile:(NSString*)mob ;
@end
