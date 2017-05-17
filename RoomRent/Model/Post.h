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
@property NSString *offerDescription;
@property int numberOfRooms;
@property double price;
@property NSString *location;
@property double latitude;
@property double longitude;
@property NSArray *imagesArray;
@property NSString *postCreatedOn;
@property User *postUser;

- (Post*) initPostFromJson : (NSDictionary *) postDict;

@end

