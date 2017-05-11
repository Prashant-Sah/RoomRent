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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(void) configureCellWithPost:(Post *) post{
    self.titleLabel.text = post.title;
    self.descriptionLabel.text = post.offerDescription;
    self.numberofRoomsLabel.text = [NSString stringWithFormat:@"%d", post.numberOfRooms];
    self.priceLabel.text = self.priceLabel.text = [@"@Rs." stringByAppendingString:[NSString stringWithFormat:@"%d",(int) post.price]] ;
    self.locationLabel.text = post.location;
    
    NSString *userProfileImageURL = post.postUser.profileImageURL;
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    NSURL *url = [NSURL URLWithString:[[PUSP_BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:userProfileImageURL]];
    [self.userImageView  sd_setImageWithURL: url];
    self.userImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.usernameLabel.text = post.postUser.username;
    self.postIdLabel.text = [NSString stringWithFormat:@"%d", post.postid];
}
@end
