//
//  User.m
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "User.h"

@implementation User

-(void)initUser:(NSString*) fullname username:(NSString *)username email:(NSString *)email mobile:(NSString *)mobile {
    
    self.fullname = fullname;
    self.username = username;
    self.email = email;
    self.mobile = mobile;
    
}

@end
