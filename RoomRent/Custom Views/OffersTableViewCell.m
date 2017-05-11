//
//  OffersTableViewCell.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "OffersTableViewCell.h"

@implementation OffersTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.roomPhotosCollectionView.delegate = self;
    self.roomPhotosCollectionView.dataSource = self;
    [[self roomPhotosCollectionView] registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotosCell"];
}

-(void)drawRect:(CGRect)rect {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.roomPhotosCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 5.0;
    layout.minimumLineSpacing = 5.0;
    self.roomPhotosCollectionView.showsHorizontalScrollIndicator = false;
    self.roomPhotosCollectionView.userInteractionEnabled = true;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewImagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *singlePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosCell" forIndexPath:indexPath];
    
    CGRect imageRect = CGRectMake(0, 0 , 100, 100);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    NSURL *url = [NSURL URLWithString:[[PUSP_BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:self.collectionViewImagesArray[indexPath.row]]];
    [photosImageView  sd_setImageWithURL: url];
    
    [singlePhotoCell.contentView addSubview:photosImageView];
    return singlePhotoCell;
    
}
- (void)configureCellWithPost:(Post *)post{
    
    self.collectionViewImagesArray = post.imagesArray;
    self.titleLabel.text = post.title;
    self.descriptionLabel.text = post.offerDescription;
    self.priceLabel.text = [@"@Rs." stringByAppendingString:[NSString stringWithFormat:@"%d",(int) post.price]] ;
    self.numberOfRoomsLabel.text = [[NSString stringWithFormat:@"%ld",(long)post.numberOfRooms]  stringByAppendingString:@" Rooms"];
    self.userLabel.text = post.postUser.username;
    self.postIdLabel.text = [NSString stringWithFormat:@"%d", post.postid];
}
@end
