//
//  User.h
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property int userId;
@property NSString *fullname;
@property NSString *username;
@property NSString *password;
@property NSString *email;
@property NSString *mobile;
@property NSString *profileImageURL;

-(User*) initUserFromJson : (NSDictionary *) userDict;

@end
