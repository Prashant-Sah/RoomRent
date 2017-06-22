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
    
    self.offersCellCheckButton.hidden = true;
    self.roomPhotosCollectionView.delegate = self;
    self.roomPhotosCollectionView.dataSource = self;
    [[self roomPhotosCollectionView] registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotosCell"];
}

-(void)drawRect:(CGRect)rect {
    
    self.isSelected = false;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.roomPhotosCollectionView.collectionViewLayout;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;
    layout.itemSize = CGSizeMake(self.superview.frame.size.width, 200);
    self.roomPhotosCollectionView.showsHorizontalScrollIndicator = false;
    self.roomPhotosCollectionView.userInteractionEnabled = true;
    self.roomPhotosCollectionView.pagingEnabled = true;
   
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewImagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *singlePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosCell" forIndexPath:indexPath];
    
    CGRect imageRect = CGRectMake(0, 0 , self.superview.frame.size.width , 200);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    photosImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // using caching with authorization
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    NSURL *url = [NSURL URLWithString:[[[BASE_URL stringByAppendingString:GETFILE_PATH] stringByAppendingString:@"/"] stringByAppendingString:self.collectionViewImagesArray[indexPath.row]]];
    
    [photosImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noPhotos"]];
    [singlePhotoCell.contentView addSubview:photosImageView];
    return singlePhotoCell;
        
}
- (void)configureCellWithPost:(Post *)post{
    
    self.collectionViewImagesArray = post.imagesArray;
    self.titleLabel.text = post.title;
    self.descriptionLabel.text = post.postDescription;
    self.priceLabel.text = [@"@Rs." stringByAppendingString:[NSString stringWithFormat:@"%d",(int) post.price]] ;
    self.numberOfRoomsLabel.text = [[NSString stringWithFormat:@"%ld",(long)post.numberOfRooms]  stringByAppendingString:@" Rooms"];
    self.userLabel.text = post.postUser.username;
    self.postIdLabel.text = [NSString stringWithFormat:@"%d", post.postid];
    self.createdOnLabel.text = [@"on  " stringByAppendingString:post.postCreatedOn];
    
    self.slug = post.postSlug;
    
}

// delegate method 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.offersTableVCDelegate didSelectCellWithPost:self.slug];
    
}


@end
