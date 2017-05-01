//
//  Post.h
//  RoomRent
//
//  Created by Prashant Sah on 4/20/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property int postid;
@property NSString *title;
@property NSString *offerDescription;
@property NSInteger numberOfRooms;
@property double price;
//@property NSString *location;
@property NSString *lat;
@property NSString *lon;
@property NSString *user;
@property NSMutableArray *imagesArray;

- (Post*) initPostFromJson : (NSDictionary *) postDict;

@end

