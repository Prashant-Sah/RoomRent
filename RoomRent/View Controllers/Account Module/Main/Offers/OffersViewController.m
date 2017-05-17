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
@end

@implementation OffersViewController

NSMutableArray *postArray = nil;
BOOL isLastPage;
int offsetValue = 0;
UIRefreshControl *refresher;
UIActivityIndicatorView *activityIndicator;

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
    
    isLastPage = false;
    
    }

-(void) refreshTable{
    [self loadPosts];
    [refresher endRefreshing];
}

-(void) showActivityIndicator{
    activityIndicator.center = self.view.center;
    activityIndicator.hidesWhenStopped = true;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
}

-(void)loadPosts{
    [self showActivityIndicator];
    postArray = [[NSMutableArray alloc] init];
    
    NSDictionary *params = @{
                             };
    [[APICaller sharedInstance] callAPiToGetPost:@"posts/offers" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSLog(@"%@",responseObjectDictionary);
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if ([code isEqualToString:POSTS_FOUND]){
            
            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
            
            for (NSDictionary *singlePost in postData) {
                
                Post *post = [[Post alloc] initPostFromJson:singlePost];
                [postArray addObject:post];
                
            }
            isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
            offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
            
            [self.offersTableView reloadData];
            [activityIndicator stopAnimating];
        }
    }];
}


//MARK: TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell"];
    [cell configureCellWithPost:postArray[indexPath.row]];
    [cell.roomPhotosCollectionView reloadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.postId = [postArray[indexPath.row] postid];
    singlePostVC.postType = OFFER;
    [self.navigationController pushViewController:singlePostVC animated:true];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float bottom = scrollView.contentSize.height - scrollView.frame.size.height;
    float buffer = 600.0f;
    float scrollPosition = scrollView.contentOffset.y;
    
    //NSLog(@"%lu",(unsigned long)postArray.count);
    
    //Reached bottom of list
    if (scrollPosition > (bottom - buffer) && !isLastPage) {
        
        //Add more posts
        
        NSDictionary *params = @{
                                 @"offset":[NSNumber numberWithInt:offsetValue]
                                 };
        
        [[APICaller sharedInstance] callAPiToGetPost:@"posts/offers" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {

            
            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
            isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
            offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
            
            for (NSDictionary *singlePost in postData) {
                
                Post *post = [[Post alloc] initPostFromJson:singlePost];
                [postArray addObject:post];
                
            }
            [self.offersTableView reloadData];
            
            isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
            offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
            
            //[refresher endRefreshing];
        }];
    }
    
    
}


@end
