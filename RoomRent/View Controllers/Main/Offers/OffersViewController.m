//
//  OffersViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "OffersViewController.h"

@interface OffersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *offersTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPostButton;
@end

@implementation OffersViewController

NSMutableArray *postArray = nil;
NSArray *imagesForASinglePost = nil;
UIRefreshControl *refresher;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadPosts];
    _offersTableView.dataSource = self;
    _offersTableView.delegate = self;
    self.offersTableView.rowHeight = UITableViewAutomaticDimension;
    self.offersTableView.estimatedRowHeight = 320;
    
    UINib *cellNib = [UINib nibWithNibName:@"OffersTableViewCell" bundle:nil];
    [self.offersTableView registerNib:cellNib forCellReuseIdentifier:@"OffersTableViewCell"];
    
    [self.revealViewController panGestureRecognizer];
    
    refresher = [[UIRefreshControl alloc] init];
    refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.offersTableView addSubview:refresher];
    [refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}


-(void) refreshTable{
    [self loadPosts];
    [refresher endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    
    //[self loadPosts];
}

-(void)loadPosts{
    postArray = [[NSMutableArray alloc] init];
    
    NSDictionary *params = @{
                             @"post_type" : OFFER,
                             @"offset" : @0
                             };
    
    [[APICaller sharedInstance] callApi:@"post/all" headerFlag:true parameters:params imageData:nil fileName:nil viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@",responseObjectDictionary);
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if ([code isEqualToString:POSTS_FOUND]){
            
            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
            for (NSDictionary *singlePost in postData) {
                
                Post *post = [[Post alloc] initPostFromJson:singlePost];
                [postArray addObject:post];
                
            }
            [self.offersTableView reloadData];
        }
    }];
    
}

//MARK- CollectionView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInCollectionView:(RoomPhotosCollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return imagesForASinglePost.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *singlePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    
    for (NSString *singleImageURL in imagesForASinglePost) {
        
        [[APICaller sharedInstance] callApiForReceivingImage:[@"getfile/" stringByAppendingString:singleImageURL] viewController:self completion:^(id responseObjectFromApi) {
            
            CGSize destinationSize = CGSizeMake(100, 100);
            UIGraphicsBeginImageContext(destinationSize);
            [responseObjectFromApi drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            CGRect imageRect = CGRectMake(0, 0 , 100, 100);
            UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
            
            [singlePhotoCell.contentView addSubview:[photosImageView initWithImage:resizedImage]];

        }];
    }
    return singlePhotoCell;
}



//MARK- TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return postArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OffersTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setCollectionViewDataSourceDelegate:self forRow:(int)indexPath.row];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell"];
    [[cell roomPhotosCollectionView] registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentifier];
    cell.roomPhotosCollectionView.contentSize = CGSizeMake(self.view.frame.size.width, 100) ;
    cell.titleLabel.text = [postArray[indexPath.row] title];
    cell.descriptionLabel.text = [postArray[indexPath.row] offerDescription];
    cell.priceLabel.text = [@"@Rs." stringByAppendingString:[NSString stringWithFormat:@"%d",(int) [postArray[indexPath.row] price]]] ;
    cell.numberOfRoomsLabel.text = [[NSString stringWithFormat:@"%ld",(long)[postArray[indexPath.row] numberOfRooms]]  stringByAppendingString:@" Rooms"];
    cell.userLabel.text = [postArray[indexPath.row] user];
    imagesForASinglePost = [postArray[indexPath.row] imagesArray];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.postId = [postArray[indexPath.row] postid];
    NSLog(@"%d", [postArray[indexPath.row] postid]);
    [self.navigationController pushViewController:singlePostVC animated:true];
}

- (IBAction)addPostButtonPressed:(UIBarButtonItem *)sender {
    
    UIAlertController *aLertController = [UIAlertController alertControllerWithTitle:(@"Alert") message:@"Select the type of Post" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *addOffer = [UIAlertAction actionWithTitle:@"Add Offer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Navigator sharedInstance] presentWithNavigationController:self viewController:@"AddPostViewController"];
    }];
    
    
    UIAlertAction *addRequest = [UIAlertAction actionWithTitle:@"Add Request" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel??" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    [aLertController addAction:addOffer];
    [aLertController addAction:addRequest];
    [aLertController addAction:cancel];
    
    [self presentViewController:aLertController animated:true completion:nil];
}

@end
