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
@property UIRefreshControl *refresher;

@property  NSMutableArray *offersPostArray;
@property  NSMutableArray *postsLocation;
@property  BOOL isLastPage;
@property  int offsetValue;

@property NSString *firstPostDate;
@property NSString *lastPostDate;

@end

@implementation OffersViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadPostsFromDatabase];
    //[self loadPostswithOffset:0];
    self.offersTableView.dataSource = self;
    self.offersTableView.delegate = self;
    self.offersTableView.rowHeight = UITableViewAutomaticDimension;
    self.offersTableView.estimatedRowHeight = 320;
    
    // register nibfile
    UINib *cellNib = [UINib nibWithNibName:@"OffersTableViewCell" bundle:nil];
    [self.offersTableView registerNib:cellNib forCellReuseIdentifier:@"OffersTableViewCell"];
    
    [self.revealViewController panGestureRecognizer];
    
    //Add refresher control
    self.refresher = [[UIRefreshControl alloc] init];
    self.refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.offersTableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.isLastPage = false;
    //    self.offersPostArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPostsFromDatabase) name:PostPostedSuccessKey object:nil];
}

-(void) loadPostsFromDatabase{
    
    NSString *sql = @"Select * from Posts_table where post_type = 1 order by updated_at desc ";
    self.offersPostArray = [[LocalDatabase sharedInstance] getPostsFromDatabaseWithQuery:sql];
    self.lastPostDate = [[self.offersPostArray firstObject] postUpdatedOn];
    self.firstPostDate = [[self.offersPostArray lastObject] postUpdatedOn];
    [self.offersTableView reloadData];
}


-(void) refreshTable{
    
    //[self loadPostswithOffset:0];
    [[DatabaseLoader sharedInstance] loadPostsToDatabaseWithTimeStamp:self.lastPostDate andOlder:@"false" andType:OFFER];
    [self.refresher endRefreshing];
    [self loadPostsFromDatabase];
    self.isLastPage = false;
}

-(void)loadPostswithOffset:(int ) offset{
    
    if(!self.isLastPage){
        if(offset == 0){
            [self.offersPostArray removeAllObjects];
        }
        
        NSNumber *offsetParam = [NSNumber numberWithInt:offset];
        NSDictionary *params = @{
                                 @"type" : @"offers",
                                 @"offset": offsetParam
                                 };
        [[APICaller sharedInstance] callAPiToGetPost:@"posts" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if ([code isEqualToString:POSTS_FOUND]){
                
                NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
                
                for (NSDictionary *singlePost in postData) {
                    
                    Post *post = [[Post alloc] initPostFromJson:singlePost];
                    [self.offersPostArray addObject:post];
                    CLLocation *postLocation = [[CLLocation alloc] initWithLatitude:post.latitude longitude:post.longitude];
                }
                self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
                self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
                
                [self.offersTableView reloadData];
            }
        }];
    }
}


//MARK: TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.offersPostArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell"];
    cell.offersTableVCDelegate = self;
    [cell configureCellWithPost:self.offersPostArray[indexPath.row]];
    [cell.roomPhotosCollectionView reloadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    //singlePostVC.postId = [postArray[indexPath.row] postid];
    singlePostVC.slug = [self.offersPostArray[indexPath.row] postSlug];
    singlePostVC.postType = OFFER;
    [self.navigationController pushViewController:singlePostVC animated:true];
}

// Delegate function of OffersCellSelectedProtocol
-(void)didSelectCellWithPost:(NSString *)postSlug{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.slug = postSlug;
    singlePostVC.postType = OFFER;
    [self.navigationController pushViewController:singlePostVC animated:true];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (endScrolling >= scrollView.contentSize.height){
        //[self loadPostswithOffset:self.offsetValue];
        [[DatabaseLoader sharedInstance] loadPostsToDatabaseWithTimeStamp:self.firstPostDate andOlder:@"true" andType:OFFER];

        [self loadPostsFromDatabase];
    }
    
}

- (IBAction)allOffersLocationButtonPressed:(UIButton*)sender {
    
    PostsOnMapViewController *postsOnMapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostsOnMapViewController"];
    postsOnMapVC.postsLocationArray = self.postsLocation;
    [self.navigationController pushViewController:postsOnMapVC animated:true];
}

@end
