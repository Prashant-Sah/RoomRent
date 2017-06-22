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
@property NSString *postSlug;
@property int postType;

@property NSString *title;
@property NSString *postDescription;
@property int numberOfRooms;
@property double price;
@property NSString *location;
@property double latitude;
@property double longitude;
@property NSMutableArray *imagesArray;

@property NSString *postCreatedOn;
@property NSString *postUpdatedOn;
@property NSString *postDeletedOn;

@property User *postUser;
@property int userid;



- (Post*) initPostFromJson : (NSDictionary *) postDict;

@end
