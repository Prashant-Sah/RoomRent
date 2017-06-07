//
//  Post.h
//  RoomRent
//
//  Created by Prashant Sah on 4/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Post : NSObject

@property int postid;
@property NSString *title;
@property NSString *postDescription;
@property int numberOfRooms;
@property double price;
@property NSString *location;
@property double latitude;
@property double longitude;
@property NSArray *imagesArray;
@property NSString *postCreatedOn;
@property int postType;
@property User *postUser;

@property NSString *postSlug;

- (Post*) initPostFromJson : (NSDictionary *) postDict;

@end
