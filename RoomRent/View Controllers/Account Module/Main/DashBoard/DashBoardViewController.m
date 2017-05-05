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
@property (weak, nonatomic) IBOutlet UITableView *offersTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPostButton;
@property NSMutableArray *postArray;
@property BOOL isLastPage;
@property int offsetValue;
@property UIRefreshControl *refresher;
@property (weak, nonatomic) IBOutlet UISegmentedControl *offerOrRequestSegmentedControl;

@end
NSString *username;
NSDictionary *responseObjectDict;
BOOL offers = 0;
BOOL asks = 1;

@implementation DashBoardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
    username = [userDict valueForKey:@"username"];

    [self loadPosts:offers];
    UINib *cellNib = [UINib nibWithNibName:@"OffersTableViewCell" bundle:nil];
    [self.offersTableView registerNib:cellNib forCellReuseIdentifier:@"OffersTableViewCell"];
    self.offersTableView.dataSource = self;
    self.offersTableView.delegate = self;
    self.offersTableView.rowHeight = UITableViewAutomaticDimension;
    self.offersTableView.estimatedRowHeight = 320;
    
    [self.revealViewController panGestureRecognizer];
    
    self.refresher = [[UIRefreshControl alloc] init];
    self.refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.offersTableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
        self.isLastPage = false;
}

- (IBAction)offerOrRequestSelected:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:
            [self loadPosts:offers];
            break;
            
        case 1:
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
    [self.offersTableView reloadData];
    
    NSDictionary *params = @{
                             };
    
    if(!offersOrAsks){
        [[APICaller sharedInstance] callAPiToGetAllPosts:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/offers"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if ([code isEqualToString:POSTS_FOUND]){
                [self addData:responseObjectDictionary];
            }
        }];
    }else{
        [[APICaller sharedInstance] callAPiToGetAllPosts:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/asks"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if ([code isEqualToString:POSTS_FOUND]){
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
    [self.offersTableView reloadData];
}




//-(void)loadPosts{
//    self.postArray = [[NSMutableArray alloc] init];
//    
//    NSDictionary *params = @{
//                             };
//    
//    [[APICaller sharedInstance] callAPiToGetAllPosts:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/offers"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
//        
//        NSLog(@"%@",responseObjectDictionary);
//        
//        NSString *code = [responseObjectDictionary valueForKey:@"code"];
//        if ([code isEqualToString:POSTS_FOUND]){
//            
//            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
//            
//            for (NSDictionary *singlePost in postData) {
//                
//                Post *post = [[Post alloc] initPostFromJson:singlePost];
//                [self.postArray addObject:post];
//                
//            }
//            self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
//            self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
//            
//            [self.offersTableView reloadData];
//        }
//    }];
//}

//MARK: TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.postArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell"];
    [cell configureCellWithPost:self.postArray[indexPath.row]];
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    float bottom = scrollView.contentSize.height - scrollView.frame.size.height;
//    float buffer = 600.0f;
//    float scrollPosition = scrollView.contentOffset.y;
//
//    //NSLog(@"%lu",(unsigned long)postArray.count);
//
//    //Reached bottom of list
//    if (scrollPosition > (bottom - buffer) && !self.isLastPage) {
//
//        //Add more posts
//
//        NSDictionary *params = @{
//                                 @"offset":[NSNumber numberWithInt:self.offsetValue]
//                                 };
//
//        [[APICaller sharedInstance] callAPiToGetAllPosts:[[@"user/" stringByAppendingString:username]stringByAppendingString:@"/posts/offers"] parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
//
//            NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
//            self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
//            self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
//
//            for (NSDictionary *singlePost in postData) {
//
//                Post *post = [[Post alloc] initPostFromJson:singlePost];
//                [self.postArray addObject:post];
//
//            }
//            [self.offersTableView reloadData];
//
//            self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
//            self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
//
//            //[refresher endRefreshing];
//        }];
//    }
//}

@end
