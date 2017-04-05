//
//  User.m
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "User.h"

@implementation User

-(void)initUser:(NSString *)user password:(NSString *)pass email:(NSString *)email mobile:(NSString *)mob {
    
    self.password = pass;
    self.email = email;
    self.username = user;
    self.mobile = mob;
    
}

@end
