//
//  OffersTableViewCell.h
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
#import "Post.h"

@interface OffersTableViewCell : UITableViewCell <UICollectionViewDelegate ,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *offersCellCheckButton;

@property (strong, nonatomic) IBOutlet UICollectionView *roomPhotosCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRoomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *postIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property NSArray *collectionViewImagesArray;
@property (weak, nonatomic) IBOutlet UILabel *createdOnLabel;

@property BOOL isSelected;
@property id delegate;
-(void)configureCellWithPost :(Post *) post;

@end

@protocol CellSelectedProtocol <NSObject>

-(void) didSelectCell:(OffersTableViewCell *) selectedCell;

@end
