//
//  SinglePostViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/27/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "SinglePostViewController.h"

@interface SinglePostViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *roomPhotosCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRoomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet MKMapView *singlePostMapView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

CLLocationDegrees latitude = 0;
CLLocationDegrees longitude = 0;
NSArray *imagesArray = nil;

@implementation SinglePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([self.postType isEqualToString:OFFER]){
        
        self.roomPhotosCollectionView.dataSource = self;
        self.roomPhotosCollectionView.delegate = self;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.roomPhotosCollectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(self.view.frame.size.width, 200);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        self.roomPhotosCollectionView.showsHorizontalScrollIndicator = false;
        self.roomPhotosCollectionView.pagingEnabled = true;
    }
    else{
        //[self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:true];
        //NSLayoutConstraint *verticalSpace =[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:50];
        //NSArray *array = [[NSArray alloc] initWithObjects:verticalSpace, nil];
        //[NSLayoutConstraint activateConstraints:array];
        //[self.view addConstraint:verticalSpace];
        //[self.titleLabel.topAnchor constraintEqualToAnchor:self.topLayoutGuide constant:30];
        CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.roomPhotosCollectionView.frame.size.height) ;
        [self.roomPhotosCollectionView removeFromSuperview];
        self.view.frame = newFrame;
        self.scrollContentView.frame = newFrame;
//        NSLayoutConstraint *xconstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.roomPhotosCollectionView attribute:NSLayoutAttributeBottom multiplier:1 constant:40];
//        NSArray *xarray = [[NSArray alloc] initWithObjects:xconstraint, nil];
//        [NSLayoutConstraint deactivateConstraints:xarray];
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:90];
        NSArray *narray = [[NSArray alloc] initWithObjects:newConstraint, nil];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
        [NSLayoutConstraint activateConstraints:narray];
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [[APICaller sharedInstance] callApiToGetSinglePost:[@"post/" stringByAppendingString: [NSString stringWithFormat:@"%d", self.postId]] viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@", responseObjectDictionary);
        Post *singlePost = [[Post alloc] initPostFromJson:responseObjectDictionary];
        imagesArray = singlePost.imagesArray;
        [self.roomPhotosCollectionView reloadData];
        self.titleLabel.text = singlePost.title;
        self.descriptionLabel.text = singlePost.offerDescription;
        self.numberOfRoomsLabel.text = [NSString stringWithFormat:@"%d", singlePost.numberOfRooms];
        self.priceLabel.text = [NSString stringWithFormat:@"%d", (int) singlePost.price];
        self.locationLabel.text = singlePost.location ;
        
        self.userLabel.text = singlePost.postUser.username;
        
        NSDictionary *userDict = [responseObjectDictionary valueForKey:@"user"];
        self.userLabel.text = [userDict valueForKey:@"username"];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self.roomPhotosCollectionView reloadData];
        });
        latitude = singlePost.latitude;
        longitude = singlePost.longitude;
        
        MKCoordinateRegion region;
        CLLocationCoordinate2D roomLocation = CLLocationCoordinate2DMake(latitude , longitude);
        region.center = roomLocation;
        region.span = MKCoordinateSpanMake(0.01, 0.01);
        
        region = [self.singlePostMapView regionThatFits:region];
        [self.singlePostMapView setRegion:region animated:YES];
        MKPointAnnotation *annotationPoint= [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = roomLocation;
        [self.singlePostMapView addAnnotation: annotationPoint];
        
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imagesArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"roomPhotosCell" forIndexPath:indexPath];
    CGRect imageRect = CGRectMake(0, 0 , self.view.frame.size.width, 200);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    
    if(imagesArray.count>0){
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        NSURL *url = [NSURL URLWithString:[[PUSP_BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:imagesArray[indexPath.row] ]];
        [photosImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noPhotos.jpeg"] options:SDWebImageScaleDownLargeImages];
    }else{
        [photosImageView setImage:[UIImage imageNamed:@"noPhotos"]];
    }
    [cell.contentView addSubview:photosImageView ];
    return cell;
}

@end
