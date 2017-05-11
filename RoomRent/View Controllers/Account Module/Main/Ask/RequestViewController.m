//
//  RequestViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 5/1/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "RequestViewController.h"

@interface RequestViewController ()
@property (weak, nonatomic) IBOutlet UITableView *requestTableView;
@property NSMutableArray *requestsPostArray;
@property BOOL isLastPage;
@property int offsetValue;
@property UIRefreshControl *refresher;
@property UIActivityIndicatorView *activityIndicator;
@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadPostswithOffset:0];
    self.requestTableView.dataSource = self;
    self.requestTableView.delegate = self;
    self.requestTableView.rowHeight = UITableViewAutomaticDimension;
    self.requestTableView.estimatedRowHeight = 190;
    
    UINib *cellNib = [UINib nibWithNibName:@"RequestsTableViewCell" bundle:nil];
    [self.requestTableView registerNib:cellNib forCellReuseIdentifier:@"RequestsTableViewCell"];
    
    [self.revealViewController panGestureRecognizer];
    
    self.self.refresher = [[UIRefreshControl alloc] init];
    self.refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.requestTableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    self.requestsPostArray = [[NSMutableArray alloc] init];

    self.isLastPage = false;
}

-(void) refreshTable{
    [self loadPostswithOffset:0];
    [self.refresher endRefreshing];
}

-(void) showActivityIndicator{
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.hidesWhenStopped = true;
    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:self.activityIndicator];
}

-(void)loadPostswithOffset:(int ) offset {
    
    NSNumber *offsetParam = [NSNumber numberWithInt:offset];
    NSDictionary *params = @{
                             @"offset": offsetParam
                             };
    [[APICaller sharedInstance] callAPiToGetAllPosts:@"posts/asks" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        NSString *code = [responseObjectDictionary valueForKey:@"code"];
        if ([code isEqualToString:POSTS_FOUND]){
            
            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
            
            for (NSDictionary *singlePost in postData) {
                
                Post *post = [[Post alloc] initPostFromJson:singlePost];
                [self.requestsPostArray addObject:post];
                
            }
            self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
            self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
            NSLog(@"%d", self.offsetValue);
            
            [self.requestTableView reloadData];
            [self.activityIndicator stopAnimating];
        }
    }];
}

//MARK: TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.requestsPostArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RequestsTableViewCell *cell  = (RequestsTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"RequestsTableViewCell"];
    [cell configureCellWithPost:self.requestsPostArray[indexPath.row]];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.postId = [self.requestsPostArray[indexPath.row] postid];
    singlePostVC.postType = REQUEST;
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (endScrolling >= scrollView.contentSize.height){
        
        [self loadPostswithOffset:self.offsetValue];
    }

}

@end

