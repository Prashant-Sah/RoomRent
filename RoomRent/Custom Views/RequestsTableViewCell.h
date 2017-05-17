//
//  RequestsTableViewCell.h
//  RoomRent
//
//  Created by Prashant Sah on 5/8/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Post.h"
#import "Constants.h"

@interface RequestsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberofRoomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *requestsCellCheckButton;
@property (weak, nonatomic) IBOutlet UILabel *postCreatedOnLabel;

@property BOOL isSelected;

-(void) configureCellWithPost:(Post *) post;
@end
