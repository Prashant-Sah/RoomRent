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
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UILabel *postedOnLabel;

@property (weak, nonatomic) IBOutlet MKMapView *singlePostMapView;
@property (weak, nonatomic) IBOutlet UIView *scrollContentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property Post *singlePost;
@property NSArray *imagesArray;
@end

@implementation SinglePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Bar Buttons with background clear
    
    UIViewController *parentVC = self.navigationController.viewControllers.firstObject ;
    if(([NSStringFromClass([parentVC class] ) isEqualToString:@"MyPostViewController"])){
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit-icon"] style:UIBarButtonItemStylePlain target:self action:@selector(editPostButtonPressed)];
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deletePostButtonPressed)];
        NSArray *tempButtonArray = [[NSArray alloc] initWithObjects:editButton,deleteButton, nil];
        self.navigationItem.rightBarButtonItems = tempButtonArray;
        
    }
    
    
    // configure view for displaying offers only
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
        // configure cellf for displaying requests
        
        CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.roomPhotosCollectionView.frame.size.height) ;
        [self.roomPhotosCollectionView removeFromSuperview];
        self.view.frame = newFrame;
        self.scrollContentView.frame = newFrame;
        
        NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:90];
        NSArray *constraintArray = [[NSArray alloc] initWithObjects:newConstraint, nil];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:false];
        [NSLayoutConstraint activateConstraints:constraintArray];
        
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:false];
    
    [[APICaller sharedInstance] callAPiToGetPost:[@"posts/" stringByAppendingString: [NSString stringWithFormat:@"%@", self.slug]] parameters:nil viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        if( [[responseObjectDictionary valueForKey:@"code"] isEqualToString:SUCCESS]){
            
            NSLog(@"%@", [responseObjectDictionary valueForKey:@"data"]);
            
            self.singlePost = [[Post alloc] initPostFromJson:[responseObjectDictionary valueForKey:@"data"]];
            [self initWithPost:self.singlePost];
            
        }
        
    }];
    
}

// cofigure view with post details
-(void) initWithPost :(Post*) singlePost{
    
    self.imagesArray = singlePost.imagesArray;
    [self.roomPhotosCollectionView reloadData];
    self.titleLabel.text = singlePost.title;
    self.descriptionLabel.text = singlePost.postDescription;
    self.numberOfRoomsLabel.text = [NSString stringWithFormat:@"%d", singlePost.numberOfRooms];
    self.priceLabel.text = [NSString stringWithFormat:@"%d", (int) singlePost.price];
    self.locationLabel.text = singlePost.location ;
    self.userLabel.text = singlePost.postUser.username;
    self.postedOnLabel.text = singlePost.postCreatedOn;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.roomPhotosCollectionView reloadData];
    });
    
    CLLocationDegrees latitude = singlePost.latitude;
    CLLocationDegrees longitude = singlePost.longitude;
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D roomLocation = CLLocationCoordinate2DMake(latitude , longitude);
    region.center = roomLocation;
    region.span = MKCoordinateSpanMake(0.01, 0.01);
    
    region = [self.singlePostMapView regionThatFits:region];
    
    MKPointAnnotation *annotationPoint= [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = roomLocation;
    annotationPoint.title = singlePost.title;
    annotationPoint.subtitle = [NSString stringWithFormat:@"%d rooms available @Rs. %d", singlePost.numberOfRooms , (int)singlePost.price];
    [self.singlePostMapView addAnnotation: annotationPoint];
    
    if (region.center.latitude > -89 && region.center.latitude < 89 && region.center.longitude > -179 && region.center.longitude < 179) {
        [self.singlePostMapView setRegion:region animated:YES];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"roomPhotosCell" forIndexPath:indexPath];
    CGRect imageRect = CGRectMake(0, 0 , self.view.frame.size.width, 200);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:self.imagesArray[indexPath.row] ]];
    photosImageView.contentMode = UIViewContentModeScaleAspectFill;
    [photosImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noPhotos.jpeg"] options:SDWebImageScaleDownLargeImages];
    
    [cell.contentView addSubview:photosImageView ];
    return cell;
}

//MARK-  button handlers

- (IBAction)infoButtonPressed:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User Info" message:[NSString stringWithFormat:@"FullName  %@ \n Mobile %@ \n Email %@ ", self.singlePost.postUser.username, self.singlePost.postUser.mobile , self.singlePost.postUser.email ] preferredStyle:UIAlertControllerStyleAlert];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 10, 40, 40)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    
    SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
    [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
    
    NSURL *url = [NSURL URLWithString:[[BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:[NSString stringWithFormat:@"%@", self.singlePost.postUser.profileImageURL]]];
    
    [imageView sd_setImageWithURL:url];
    [alert.view addSubview:imageView];

    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
  
    [imageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        //UIImage *image = image;//[UIImage imageNamed:@"avatar.png"];
        [actionOk setValue:[image imageWithRenderingMode:UIImageRenderingModeAutomatic] forKey:@"image"];
        [alert addAction:actionOk];
        [self presentViewController:alert animated:true completion:nil];
    }];
    
    //[[Alerter sharedInstance] createAlert:@"User Info" message:[NSString stringWithFormat:@"FullName  %@ \n Mobile %@ \n Email %@ ", self.singlePost.postUser.username, self.singlePost.postUser.mobile , self.singlePost.postUser.email ] useCancelButton:false viewController:self completion:^{}];
}

-(void) editPostButtonPressed{
    
    AddPostViewController *addPostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPostViewController"];
    addPostVC.postType = self.postType;
    addPostVC.passedPost = self.singlePost;
    addPostVC.addPostVCDelegate = self;
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addPostVC];
    [self presentViewController:navVC animated:true completion:nil];
    
}

-(void) deletePostButtonPressed{
    [[Alerter sharedInstance] createAlert:@"Confirmation Needed" message:@"Do you really want to delete this post?" useCancelButton:true viewController:self completion:^{
        
        
        [[APICaller sharedInstance] callApiForDelete:[@"posts/" stringByAppendingString:[NSString stringWithFormat:@"%@", self.slug]] parameters:nil viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            NSLog(@"%@",responseObjectDictionary);
            
            if( [[responseObjectDictionary valueForKey:@"code"] isEqualToString:ITEM_DELETED_SUCCESSFULLY]){
                [self.singlePostVCDelegate didFinishDeleting];
                [self.navigationController popViewControllerAnimated:true ];
            }else{
                [[Alerter sharedInstance] createAlert:@"Error" message:@"The post could not be deleted." useCancelButton:false viewController:self completion:^{}];
            }
        }];
    }];
}

-(void)didFinishEditingPost{
    
}
-(void)dealloc{
    NSLog(@"single post vc deallocated");
    
}

@end
