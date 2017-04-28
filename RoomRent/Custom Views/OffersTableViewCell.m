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
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 5.0f;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.roomPhotosCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 5.0f;
    layout.itemSize = CGSizeMake(100, 100);
    //layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.roomPhotosCollectionView.userInteractionEnabled = false;
    self.roomPhotosCollectionView = [[RoomPhotosCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    [self.roomPhotosCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentifier];
    
    self.roomPhotosCollectionView.backgroundColor = [UIColor grayColor];
    self.roomPhotosCollectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.roomPhotosCollectionView];
    
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.roomPhotosCollectionView.frame = self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate forRow:(int *)row
{
    self.roomPhotosCollectionView.dataSource = dataSourceDelegate;
    self.roomPhotosCollectionView.delegate = dataSourceDelegate;
    //self.roomPhotosCollectionView.indexPath = indexPath;
    self.roomPhotosCollectionView.tag = row;
    [self.roomPhotosCollectionView reloadData];
}

@end
