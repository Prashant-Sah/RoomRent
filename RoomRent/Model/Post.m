//
//  Post.m
//  RoomRent
//
//  Created by Prashant Sah on 4/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "Post.h"

static Post* post = nil;
static NSMutableArray *postArray = nil;

@implementation Post



-(Post*)initPostFromJson:(NSDictionary *)postDict{
    
    self.imagesArray = [[NSMutableArray alloc] init];
    
    self.postid = [[postDict valueForKey:@"id"] intValue];
    self.title = [postDict valueForKey:@"title"];
    self.offerDescription = [postDict valueForKey:@"description"];
    self.numberOfRooms = [[postDict valueForKey:@"no_of_rooms"] intValue];
    self.price = [[postDict valueForKey:@"price"] doubleValue];
    self.lat = [postDict valueForKey:@"latitude"];
    self.lon = [postDict valueForKey:@"longitude"];
    self.imagesArray = [postDict valueForKey:@"images"];
    
//    NSArray *imageURLArray = [postDict valueForKey:@"images"];
//    for (NSString *imageURL in imageURLArray) {
//        [post.imagesArray addObject:imageURL ];
//    }
    
    return self;
}

@end
