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
@end

@implementation RequestViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.requestTableView.dataSource = self;
    self.requestTableView.delegate = self;
    self.requestTableView.rowHeight = UITableViewAutomaticDimension;
    self.requestTableView.estimatedRowHeight = 200;
    
    //register nib
    UINib *cellNib = [UINib nibWithNibName:@"RequestsTableViewCell" bundle:nil];
    [self.requestTableView registerNib:cellNib forCellReuseIdentifier:@"RequestsTableViewCell"];
    
    [self.revealViewController panGestureRecognizer];
    
    self.refresher = [[UIRefreshControl alloc] init];
    self.refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.requestTableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    self.requestsPostArray = [[NSMutableArray alloc] init];
    self.isLastPage = false;
    [self loadPostswithOffset:0];
}

-(void) refreshTable{
    
    [self loadPostswithOffset:0];
    [self.refresher endRefreshing];
    self.isLastPage = false;
}

-(void)loadPostswithOffset:(int ) offset {
    
    if(!self.isLastPage){
        if(offset == 0){
            [self.requestsPostArray removeAllObjects];
        }
        
        NSNumber *offsetParam = [NSNumber numberWithInt:offset];
        NSDictionary *params = @{
                                 @"type" : @"asks",
                                 @"offset": offsetParam
                                 };
        [[APICaller sharedInstance] callAPiToGetPost:@"posts" parameters:params viewController:self completion:^(NSDictionary *responseObjectDictionary) {
            
            NSLog(@"%@",responseObjectDictionary);
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if ([code isEqualToString:POSTS_FOUND]){
                
                NSDictionary *postData = [responseObjectDictionary valueForKey:@"data"];
                
                for (NSDictionary *singlePost in postData) {
                    
                    Post *post = [[Post alloc] initPostFromJson:singlePost];
                    [self.requestsPostArray addObject:post];
                    
                }
                self.isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
                self.offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
                
                [self.requestTableView reloadData];
            }
            else if ([code isEqualToString:NO_POSTS_FOUND]){
                // code to show something 
            }
        }];
    }
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
    if (indexPath.row % 2) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.82 green:0.93 blue:0.99 alpha:1.0];
    } else {
        cell.contentView.backgroundColor =[UIColor colorWithRed:0.84 green:0.81 blue:0.76 alpha:1.0];
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    singlePostVC.postType = REQUEST;
    singlePostVC.slug = [self.requestsPostArray[indexPath.row] postSlug];
    singlePostVC.singlePostVCDelegate = self;
    [self.navigationController pushViewController:singlePostVC animated:true];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    
    if (endScrolling >= scrollView.contentSize.height){
        
        [self loadPostswithOffset:self.offsetValue];
    }
    
}

- (void)didFinishDeleting{
    [self loadPostswithOffset:0];
}

@end

