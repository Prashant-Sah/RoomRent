//
//  Post.m
//  RoomRent
//
//  Created by Prashant Sah on 4/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "Post.h"

@implementation Post

-(Post*)initPostFromJson:(NSDictionary *)postDict{
    
    self.imagesArray = [[NSMutableArray alloc] init];
    
    self.postid = [[postDict valueForKey:@"id"] intValue];
    self.postSlug = [postDict valueForKey:@"slug"];
    self.postType = [[postDict valueForKey:@"post_type"] intValue];
    
    self.title = [postDict valueForKey:@"title"];
    self.postDescription = [postDict valueForKey:@"description"];
    self.numberOfRooms = [[postDict valueForKey:@"no_of_rooms"] intValue];
    self.price = [[postDict valueForKey:@"price"] doubleValue];
    self.latitude = [[postDict valueForKey:@"latitude"] doubleValue];
    self.longitude = [[postDict valueForKey:@"longitude"] doubleValue];
    self.location = [postDict valueForKey:@"address"];
    
    self.postCreatedOn = [postDict valueForKey:@"created_at"];
    self.postUpdatedOn = [postDict valueForKey:@"updated_at"];
    self.postDeletedOn = [postDict valueForKey:@"deleted_at"];
    
    self.imagesArray = [postDict valueForKey:@"images"];
    
    self.userid = [[postDict valueForKey:@"userid"] intValue];
    self.postUser = [[User alloc] initUserFromJson:[postDict valueForKey:@"user"]];
    
    return self;
}

@end
