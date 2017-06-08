//
//  User.m
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "User.h"

@implementation User

- (User*)initUserFromJson:(NSDictionary *)userDict{
    
    self.userId = [[userDict valueForKey:@"id"] intValue];
    self.fullname = [userDict valueForKey:@"name"];
    self.username = [userDict valueForKey:@"username"];
    self.email = [userDict valueForKey:@"email"];
    self.mobile = [userDict valueForKey:@"phone"];
    self.profileImageURL = [userDict valueForKey:@"profile_image"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%d", self.userId] forKey:@"userId"];
    [aCoder encodeObject:self.fullname forKey:@"fullname"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.profileImageURL forKey:@"profileImageURL"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
    
        self.userId = [[aDecoder decodeObjectForKey:@"userId"] intValue];
        self.fullname = [aDecoder decodeObjectForKey:@"fullname"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.profileImageURL = [aDecoder decodeObjectForKey:@"profileImageURL"];
    }
    return self;
}

@end
