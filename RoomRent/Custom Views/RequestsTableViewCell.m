//
//  RequestsTableViewCell.m
//  RoomRent
//
//  Created by Prashant Sah on 5/8/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "RequestsTableViewCell.h"

@implementation RequestsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isSelected = false;
    
}

-(void) configureCellWithPost:(Post *) post{
    
    self.titleLabel.text = post.title;
    self.descriptionLabel.text = post.postDescription;
    self.numberofRoomsLabel.text = [NSString stringWithFormat:@"%d", post.numberOfRooms];
    self.priceLabel.text = self.priceLabel.text = [@"@Rs." stringByAppendingString:[NSString stringWithFormat:@"%d",(int) post.price]] ;
    self.locationLabel.text = post.location;
    self.postCreatedOnLabel.text = post.postCreatedOn;
    self.usernameLabel.text = post.postUser.username;
    self.postCreatedOnLabel.text = post.postCreatedOn;
}


@end
