//
//  DashBoardViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 5/1/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//
//
//  OffersViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "DashBoardViewController.h"

@interface DashBoardViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPostButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *offerOrRequestSegmentedControl;
@property NSMutableArray *postArray;
@property BOOL isLastPage;
@property int offsetValue;
@property UIRefreshControl *refresher;

@end

NSString *username;
NSDictionary *responseObjectDict;
NSString *postType;
BOOL offers = 0;
BOOL asks = 1;

@implementation DashBoardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    username = [userDict valueForKey:@"username"];
    
    self.tableView.estimatedRowHeight = 320;
    [self loadPosts:offers];
   
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UINib *offersCellNib = [UINib nibWithNibName:@"OffersTableViewCell" bundle:nil];
    UINib *requestsCellNib = [UINib nibWithNibName:@"RequestsTableViewCell" bundle:nil];
    [self.tableView registerNib:offersCellNib forCellReuseIdentifier:@"OffersTableViewCell"];
    [self.tableView registerNib:requestsCellNib forCellReuseIdentifier:@"RequestsTableViewCell"];
    
    [self.revealViewController panGestureRecognizer];
    
    self.refresher = [[UIRefreshControl alloc] init];
    self.refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.tableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.isLastPage = false;
}

- (IBAction)offerOrRequestSelected:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:
            self.tableView.estimatedRowHeight = 320;
            [self loadPosts:offers];
            break;
            
        case 1:
            self.tableView.estimatedRowHeight = 190;
            [self loadPosts:asks];
            break;
            
        default:
            break;
    }
}

-(void) refreshTable{
    [self loadPosts:self.offerOrRequestSegmentedControl.selectedSegmentIndex];
    [self.refresher endRefreshing];
}

-(void)loadPosts:(BOOL) offersOrAsks{
    self.postArray = [[NSMutableArray alloc] init];
    [self.postArray removeAllObjects];
    [self.tableView reloadData];
    
    NSDictionary *params = @{
                             };
    
    if(!offersOrAsks){
        [[APICaller sharedInstance] callAPiToGetAllPosts:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/offers"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if ([code isEqualToString:POSTS_FOUND]){
                postType = OFFER;
                [self addData:responseObjectDictionary];
            }
        }];
    }else{
        [[APICaller sharedInstance] callAPiToGetAllPosts:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/asks"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if ([code isEqualToString:POSTS_FOUND]){
                postType = REQUEST;
                [self addData:responseObjectDictionary];
            }
        }];
    }
}

-(void) addData :(NSDictionary *) postDict{
    NSDictionary *postData = [postDict valueForKey:@"data"];
    
    for (NSDictionary *singlePost in postData) {
        
        Post *post = [[Post alloc] initPostFromJson:singlePost];
        [self.postArray addObject:post];
        
    }
    self.isLastPage = [[responseObjectDict valueForKey:@"is_last_page"] boolValue];
    self.offsetValue = [[responseObjectDict valueForKey:@"offset"] intValue];
    [self.tableView reloadData];
}


///MARK: TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([postType isEqualToString:OFFER]){
        OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell" forIndexPath:indexPath];
        [cell configureCellWithPost:self.postArray[indexPath.row]];
        [cell.roomPhotosCollectionView reloadData];
        return cell;
    }else{
        RequestsTableViewCell *cell = (RequestsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RequestsTableViewCell" forIndexPath:indexPath];
        [cell configureCellWithPost:self.postArray[indexPath.row]];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.postId = [self.postArray[indexPath.row] postid];
    singlePostVC.postType = postType;
    [self.navigationController pushViewController:singlePostVC animated:true];
}

- (IBAction)addPostButtonPressed:(UIBarButtonItem *)sender {
    
    UIAlertController *aLertController = [UIAlertController alertControllerWithTitle:(@"Alert") message:@"Select the type of Post" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *addOffer = [UIAlertAction actionWithTitle:@"Add Offer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AddPostViewController *addPostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPostViewController"];
        addPostVC.postType = OFFER;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addPostVC];
        [self presentViewController:navVC animated:true completion:nil];    }];
    
    
    UIAlertAction *addRequest = [UIAlertAction actionWithTitle:@"Add Request" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        AddPostViewController *addPostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPostViewController"];
        addPostVC.postType = REQUEST;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addPostVC];
        [self presentViewController:navVC animated:true completion:nil];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel?" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    [aLertController addAction:addOffer];
    [aLertController addAction:addRequest];
    [aLertController addAction:cancel];
    
    [self presentViewController:aLertController animated:true completion:nil];
}

@end
