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

@end

CLLocationDegrees latitude = 0;
CLLocationDegrees longitude = 0;
NSArray *imagesArray;

@implementation SinglePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
-(void)viewWillAppear:(BOOL)animated{
    
    [[APICaller sharedInstance] callApiToGetSinglePost:[@"post/" stringByAppendingString: [NSString stringWithFormat:@"%d", self.postId]] headerFlag:true viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@", responseObjectDictionary);
        self.titleLabel.text = [responseObjectDictionary valueForKey:@"title"];
        self.descriptionLabel.text = [responseObjectDictionary valueForKey:@"description"];
        self.numberOfRoomsLabel.text = [NSString stringWithFormat:@"%@",[responseObjectDictionary valueForKey:@"no_of_rooms"] ] ;
        self.priceLabel.text = [NSString stringWithFormat:@"%@", [responseObjectDictionary valueForKey:@"price"]];
        self.locationLabel.text
        = [responseObjectDictionary valueForKey:@"address"];
        
        imagesArray = [responseObjectDictionary valueForKey:@"images"];
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self.roomPhotosCollectionView reloadData];
        });
        
        
        NSDictionary *userDict = [responseObjectDictionary valueForKey:@"user"];
        self.userLabel.text = [userDict valueForKey:@"username"];
        
        latitude = [[responseObjectDictionary valueForKey:@"latitude"] doubleValue] ;
        longitude = [[responseObjectDictionary valueForKey:@"longitude"] doubleValue];
        
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
    
    int i =0;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"roomPhotosCell" forIndexPath:indexPath];
    
    for (NSString *singleImageURL in imagesArray) {
        
        NSLog(@"%d",i);
        i=i+1;
        [[APICaller sharedInstance] callApiForReceivingImage:[@"getfile/" stringByAppendingString:singleImageURL] viewController:self completion:^(id responseObjectFromApi) {
            
            CGSize destinationSize = CGSizeMake(self.view.frame.size.width , 200);
            UIGraphicsBeginImageContext(destinationSize);
            [responseObjectFromApi drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            CGRect imageRect = CGRectMake(0, 0 , self.view.frame.size.width, 200);
            UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
            
            [cell.contentView addSubview:[photosImageView initWithImage:resizedImage]];
            
        }];
    }
    return cell;
}

@end
