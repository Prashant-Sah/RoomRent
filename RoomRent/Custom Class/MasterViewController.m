//
//  MasterViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 5/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()
@property UITableView *offersTableView;
@property NSMutableArray *postArray;
@property BOOL isLastPage;
@property int offsetValue;
@property NSIndexPath *postIndex;
@property UIRefreshControl *refresher;
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.revealViewController panGestureRecognizer];
    
    self.offersTableView = [self.offersTableView initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) style:UITableViewStylePlain];
    [self.view addSubview:self.offersTableView];
    
    self.refresher = [[UIRefreshControl alloc] init];
    self.refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.offersTableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.isLastPage = false;
}

-(void) refreshTable{
    [self loadPosts];
    [self.refresher endRefreshing];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self loadPosts];
}

-(void)loadPosts{
    self.postArray = [[NSMutableArray alloc] init];
    
    NSDictionary *params = @{
                             };
    [[APICaller sharedInstance] callAPiToGetAllPosts:@"posts/offers" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@",responseObjectDictionary);
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if ([code isEqualToString:POSTS_FOUND]){
            
            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
            
            for (NSDictionary *singlePost in postData) {
                
                Post *post = [[Post alloc] initPostFromJson:singlePost];
                [self.postArray addObject:post];
                
            }
            self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
            self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
            
            [self.offersTableView reloadData];
        }
    }];
}

//MARK: CollectionView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInCollectionView:(RoomPhotosCollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.postArray[self.postIndex.row] imagesArray]count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *singlePhotoCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotosCell" forIndexPath:indexPath];
    CGRect imageRect = CGRectMake(0, 0 , 100, 100);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    if([[self.postArray[self.postIndex.row] imagesArray]count] > 0){
        
        NSString *userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
        
        SDWebImageDownloader *manager = [SDWebImageManager sharedManager].imageDownloader;
        [manager setValue:[@"Bearer " stringByAppendingString:userApiToken] forHTTPHeaderField:@"Authorization"];
        
        NSURL *url = [NSURL URLWithString:[[PUSP_BASE_URL stringByAppendingString:@"getfile/"] stringByAppendingString:[[self.postArray[self.postIndex.row] imagesArray] objectAtIndex:indexPath.row]]];
        [photosImageView  sd_setImageWithURL: url];
        
    }else{
        [photosImageView setImage:[UIImage imageNamed:@"noPhotos.jpeg"]];
    }
    [singlePhotoCell.contentView addSubview:photosImageView];
    return singlePhotoCell;
}



//MARK: TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(OffersTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [cell setCollectionViewDataSourceDelegate:self forRow:(int)indexPath.row];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.postIndex = indexPath;
    OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell"];
    
    [[cell roomPhotosCollectionView] registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"PhotosCell"];
    [[cell roomPhotosCollectionView] setFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    cell.titleLabel.text = [self.postArray[indexPath.row] title];
    cell.descriptionLabel.text = [self.postArray[indexPath.row] offerDescription];
    cell.priceLabel.text = [@"@Rs." stringByAppendingString:[NSString stringWithFormat:@"%d",(int) [self.postArray[indexPath.row] price]]] ;
    cell.numberOfRoomsLabel.text = [[NSString stringWithFormat:@"%ld",(long)[self.postArray[indexPath.row] numberOfRooms]]  stringByAppendingString:@" Rooms"];
    cell.userLabel.text = [[self.postArray[indexPath.row] postUser] username];
    
    [cell.roomPhotosCollectionView reloadData];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.postId = [self.postArray[indexPath.row] postid];
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
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel?" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    [aLertController addAction:addOffer];
    [aLertController addAction:addRequest];
    [aLertController addAction:cancel];
    
    [self presentViewController:aLertController animated:true completion:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float bottom = scrollView.contentSize.height - scrollView.frame.size.height;
    float buffer = 600.0f;
    float scrollPosition = scrollView.contentOffset.y;
    
    //NSLog(@"%lu",(unsigned long)postArray.count);
    
    //Reached bottom of list
    if (scrollPosition > (bottom - buffer) && !self.isLastPage) {
        
        //Add more posts
        
        NSDictionary *params = @{
                                 @"offset":[NSNumber numberWithInt:self.offsetValue]
                                 };
        
        [[APICaller sharedInstance] callApiToCreatePost:@"post/offers" parameters:params imageDataArray:nil fileNameArray:nil viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
            self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
            self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
            
            for (NSDictionary *singlePost in postData) {
                
                Post *post = [[Post alloc] initPostFromJson:singlePost];
                [self.postArray addObject:post];
                
            }
            [self.offersTableView reloadData];
            
            self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
            self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
            
            //[refresher endRefreshing];
        }];
    }
    
    
}


@end
