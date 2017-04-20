//
//  User.m
//  RoomRent
//
//  Created by Prashant Sah on 4/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "User.h"

@implementation User
static User* user = nil;

-(void)initUser:(NSString*) fullname username:(NSString *)username email:(NSString *)email mobile:(NSString *)mobile profileImageURL:(NSURL *) imageURL  {
    
    self.fullname = fullname;
    self.username = username;
    self.email = email;
    self.mobile = mobile;
    self.profileImageURL = imageURL;
}
-(User *)getUser{
    return user;
}

- (void)initUserFromJson:(NSDictionary *)userDict{
    
    user.fullname = [userDict valueForKey:@"name"];
    user.username = [userDict valueForKey:@"username"];
    user.email = [userDict valueForKey:@"email"];
    user.mobile = [userDict valueForKey:@"phone"];
    user.profileImageURL = [userDict valueForKey:@"profile_image"];
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_fullname forKey:@"fullname"];
    [aCoder encodeObject:_username forKey:@"username"];
    [aCoder encodeObject:_email forKey:@"email"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeObject:_profileImageURL forKey:@"profileImageURL"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        
        self.fullname = [aDecoder decodeObjectForKey:@"fullname"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.profileImageURL = [aDecoder decodeObjectForKey:@"profileImageURL"];
    }
    return self;
}

@end
