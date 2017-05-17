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
@property (weak, nonatomic) IBOutlet UISegmentedControl *offerOrRequestSegmentedControl;
@property NSMutableArray *postArray;
@property BOOL isLastPage;
@property int offsetValue;
@property UIRefreshControl *refresher;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deletePostButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

NSString *username;
NSDictionary *responseObjectDict;
NSString *postType;
BOOL offers = 0;
BOOL asks = 1;
NSIndexPath *selectedIndexPath;
NSMutableArray *selectedOffersArray;
NSMutableArray *selectedRequestsArray;

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
    
    [self whenNoPostsMarked];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    
    lpgr.delaysTouchesBegan = YES;
    lpgr.minimumPressDuration = 0.3;
    [self.tableView addGestureRecognizer:lpgr];
    
    selectedOffersArray = [[NSMutableArray alloc] init];
    selectedRequestsArray = [[NSMutableArray alloc] init];
}

- (IBAction)offerOrRequestSelected:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:
            self.tableView.estimatedRowHeight = 320;
            [self loadPosts:offers];
            if(selectedOffersArray.count > 0){
                [self whenSomePostsMarked];
            }
            break;
            
        case 1:
            self.tableView.estimatedRowHeight = 190;
            if(selectedRequestsArray.count > 0){
                [self whenSomePostsMarked];
            }
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
        [[APICaller sharedInstance] callAPiToGetPost:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/offers"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if ([code isEqualToString:POSTS_FOUND]){
                postType = OFFER;
                [self addData:responseObjectDictionary];
            }
        }];
    }else{
        [[APICaller sharedInstance] callAPiToGetPost:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/asks"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
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
        if([selectedOffersArray containsObject:[NSString stringWithFormat:@"%ld", indexPath.row]]){
            cell.offersCellCheckButton.hidden = false;
        }else{
            cell.offersCellCheckButton.hidden = true;
        }
        [cell.roomPhotosCollectionView reloadData];
        return cell;
    }else{
        
        RequestsTableViewCell *cell = (RequestsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RequestsTableViewCell" forIndexPath:indexPath];
        [cell configureCellWithPost:self.postArray[indexPath.row]];
        if([selectedRequestsArray containsObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]]){
            cell.requestsCellCheckButton.hidden = false;
        }else{
            cell.requestsCellCheckButton.hidden = true;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.postId = [self.postArray[indexPath.row] postid];
    singlePostVC.postType = postType;
    [self.navigationController pushViewController:singlePostVC animated:true];
}

-(void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    [self whenSomePostsMarked];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
        if([postType isEqualToString:OFFER]){
            
            OffersTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.isSelected ^= true;
            if(cell.isSelected == true){
                [selectedOffersArray addObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                cell.offersCellCheckButton.hidden = false;
            }else{
                cell.offersCellCheckButton.hidden = true;
                [selectedOffersArray removeObject:[NSString stringWithFormat:@"%ld", (long) indexPath.row]];
                if(selectedOffersArray.count == 0){
                    
                    [self whenNoPostsMarked];
                    
                }
            }
            
        }else{
            
            RequestsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.isSelected ^= true;
            if(cell.isSelected == true){
                [selectedRequestsArray addObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                cell.requestsCellCheckButton.hidden = false;
            }else{
                cell.requestsCellCheckButton.hidden = true;
                [selectedRequestsArray removeObject:[NSString stringWithFormat:@"%ld", (long) indexPath.row]];
                if(selectedRequestsArray.count == 0){
                    
                    [self whenNoPostsMarked];
                }
            }
            
        }
    }
    
}

- (void)didSelectCell:(OffersTableViewCell *)selectedCell{
    
}
- (IBAction)addPostButtonPressed:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:(@"Alert") message:@"Select the type of Post" preferredStyle:UIAlertControllerStyleAlert];
    
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
    
    [alertController addAction:addOffer];
    [alertController addAction:addRequest];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (IBAction)deletePostButtonPressed:(UIBarButtonItem *)sender {
    
    
}
- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self whenNoPostsMarked];
    
    if(self.offerOrRequestSegmentedControl.selectedSegmentIndex == 0){
        [selectedOffersArray removeAllObjects];
    }else{
        [selectedRequestsArray removeAllObjects];
    }
    [self.tableView reloadData];
}

-(void) whenNoPostsMarked{
    self.deletePostButton.enabled = false;
    self.deletePostButton.tintColor = [UIColor clearColor];
    
    self.cancelButton.enabled = false;
    self.cancelButton.tintColor = [UIColor clearColor];
}

-(void) whenSomePostsMarked{
    self.deletePostButton.enabled = true;
    self.deletePostButton.tintColor = [UIColor blackColor];
    
    self.cancelButton.enabled = true;
    self.cancelButton.tintColor = [UIColor blackColor];
    
}


@end
