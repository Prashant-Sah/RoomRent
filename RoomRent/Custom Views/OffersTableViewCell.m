//
//  OffersTableViewCell.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "OffersTableViewCell.h"

@implementation RoomPhotosCollectionView

@end

@implementation OffersTableViewCell

-(void)drawRect:(CGRect)rect {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.roomPhotosCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 5.0;
    layout.minimumLineSpacing = 5.0;
    self.roomPhotosCollectionView.showsHorizontalScrollIndicator = false;
    self.roomPhotosCollectionView.userInteractionEnabled = true;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forRow:(int)row
{
    self.roomPhotosCollectionView.dataSource = dataSourceDelegate;
    self.roomPhotosCollectionView.delegate = dataSourceDelegate;
    self.roomPhotosCollectionView.tag = row;
    [self.roomPhotosCollectionView reloadData];
}

@end
