//
//  OffersTableViewCell.h
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RoomPhotosCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

static NSString *collectionViewCellIdentifier = @"PhotosCell";

@interface OffersTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet RoomPhotosCollectionView *roomPhotosCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRoomsLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property int row;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forRow:(int)row;

@end
