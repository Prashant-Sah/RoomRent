//
//  MyPostViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 5/22/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "MyPostViewController.h"

@interface MyPostViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *offerOrRequestSegmentedControl;
@property UIRefreshControl *refresher;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deletePostButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;


@property NSMutableIndexSet *selectedRequestsIndices;
@property NSMutableArray *offersPostsArray;
@property NSMutableArray *requestsPostsArray;
@property NSMutableIndexSet *selectedOffersIndices;

@property NSString *userApiToken;
@property BOOL isLastPageforOffers;
@property BOOL isLastPageforRequests;
@property int offsetValueforOffers;
@property int offsetValueforRequests;

@end

NSString *postType;
BOOL offers = 0;
BOOL asks = 1;
BOOL offersIsRefreshing = false;
BOOL requestsIsRefreshing = false;


@implementation MyPostViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.userApiToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userApiToken"];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    //register offers and requests cell
    UINib *offersCellNib = [UINib nibWithNibName:@"OffersTableViewCell" bundle:nil];
    UINib *requestsCellNib = [UINib nibWithNibName:@"RequestsTableViewCell" bundle:nil];
    [self.tableView registerNib:offersCellNib forCellReuseIdentifier:@"OffersTableViewCell"];
    [self.tableView registerNib:requestsCellNib forCellReuseIdentifier:@"RequestsTableViewCell"];
    
    [self.revealViewController panGestureRecognizer];
    
    //Add refresher control
    self.refresher = [[UIRefreshControl alloc] init];
    self.refresher.attributedTitle = [[NSMutableAttributedString alloc] initWithString:@"Pull to refresh!!"];
    [self.tableView addSubview:self.refresher];
    [self.refresher addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    // ADD longpress gesture
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    
    lpgr.delaysTouchesBegan = YES;
    lpgr.minimumPressDuration = 0.3;
    [self.tableView addGestureRecognizer:lpgr];
    
    //Initialize arrays
    self.offersPostsArray = [[NSMutableArray alloc] init];
    self.requestsPostsArray = [[NSMutableArray alloc] init];
    self.selectedOffersIndices = [[NSMutableIndexSet alloc] init];
    self.selectedRequestsIndices = [[NSMutableIndexSet alloc] init];
    
    self.offsetValueforOffers = 0;
    self.offsetValueforRequests = 0;
    
    self.offerOrRequestSegmentedControl.selectedSegmentIndex = offers;
    [self offerOrRequestSelected:self.offerOrRequestSegmentedControl];
    
}

-(void) refreshTable{
    
    switch (self.offerOrRequestSegmentedControl.selectedSegmentIndex) {
        case 0:
            [self.offersPostsArray removeAllObjects];
            self.offsetValueforOffers = 0;
            [self offerOrRequestSelected:self.offerOrRequestSegmentedControl];
            
            break;
        case 1:
            [self.requestsPostsArray removeAllObjects];
            self.offsetValueforRequests = 0;
            [self offerOrRequestSelected:self.offerOrRequestSegmentedControl];
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];
    [self.refresher endRefreshing];
}


- (IBAction)offerOrRequestSelected:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex) {
            
        case 0:
            
            postType = OFFER;
            self.tableView.estimatedRowHeight = 320;
            [self loadPostsWithType:self.offerOrRequestSegmentedControl.selectedSegmentIndex andOffset: [NSNumber numberWithInt:self.offsetValueforOffers] ];
            [self.tableView reloadData];
            if(self.selectedOffersIndices.count > 0){
                [self whenSomePostsMarked];
            }else{
                [self whenNoPostsMarked];
            }
            break;
            
            
        case 1:
            
            postType = REQUEST;
            self.tableView.estimatedRowHeight = 190;
            [self loadPostsWithType:self.offerOrRequestSegmentedControl.selectedSegmentIndex andOffset:[NSNumber numberWithInt:self.offsetValueforRequests]];
            [self.tableView reloadData];
            if(self.selectedRequestsIndices.count > 0){
                [self whenSomePostsMarked];
            }else{
                [self whenNoPostsMarked];
            }
            
            break;
            
        default:
            break;
    }
}

-(void) loadPostsWithType: (BOOL) type andOffset:(nullable NSNumber*) offset{
    
    NSDictionary *params = @{
                             @"api_token" : self.userApiToken,
                             @"offset" : offset
                             };
    
    NSMutableDictionary *parameters;
    parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    
    if(type == offers){
        
        [parameters setObject:@"offers" forKey:@"type"];
        //[parameters setObject:[NSNumber numberWithInt:self.offsetValueforOffers] forKey:@"offset"];
        
        if(!(self.offersPostsArray.count > 0)){
            [[APICaller sharedInstance] callAPiToGetPost:@"myposts/" parameters:parameters viewController:self completion:^(NSDictionary *responseObjectDictionary) {
                
                NSLog(@"%@",responseObjectDictionary);
                NSString *code = [responseObjectDictionary valueForKey:@"code"];
                if ([code isEqualToString:POSTS_FOUND]){
                    [self addData:responseObjectDictionary withType:offers];
                    
                }
                
            }];
        }
    }else if(type == asks){
        
        [parameters setObject:@"asks" forKey:@"type"];
        //[parameters setObject:[NSNumber numberWithInt:self.offsetValueforRequests] forKey:@"offset"];
        if(!(self.requestsPostsArray.count > 0)){
            
            [[APICaller sharedInstance] callAPiToGetPost:@"myposts/" parameters:parameters viewController:self completion:^(NSDictionary *responseObjectDictionary) {
                
                NSLog(@"%@",responseObjectDictionary);
                NSString *code = [responseObjectDictionary valueForKey:@"code"];
                if ([code isEqualToString:POSTS_FOUND]){
                    [self addData:responseObjectDictionary withType:asks];
                }
            }];
        }
    }
}

-(void) addData :(NSDictionary *) postDict withType:(BOOL) type{
    
    NSDictionary *postData = [postDict valueForKey:@"data"];
    
    for (NSDictionary *singlePost in postData) {
        
        Post *post = [[Post alloc] initPostFromJson:singlePost];
        if(postType == OFFER){
            [self.offersPostsArray addObject:post];
            self.isLastPageforOffers = [[postDict valueForKey:@"is_last_page"] boolValue];
            self.offsetValueforOffers = [[postDict valueForKey:@"offset"] intValue];
        }else{
            [self.requestsPostsArray addObject:post];
            self.isLastPageforRequests = [[postDict valueForKey:@"is_last_page"] boolValue];
            self.offsetValueforRequests = [[postDict valueForKey:@"offset"] intValue];
        }
    }
    
    [self.tableView reloadData];
    
   
}

///MARK: TableView DataSource and Delegate Functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(postType == OFFER){
        return self.offersPostsArray.count;
    }else{
        return self.requestsPostsArray.count;
    }
}

// configure required cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([postType isEqualToString:OFFER]){
        
        OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell" forIndexPath:indexPath];
        [cell configureCellWithPost:self.offersPostsArray[indexPath.row]];
        if([self.selectedOffersIndices containsIndex:indexPath.row]){
            cell.offersCellCheckButton.hidden = false;
        }else{
            cell.offersCellCheckButton.hidden = true;
        }
        [cell.roomPhotosCollectionView reloadData];
        return cell;
    }else{
        
        RequestsTableViewCell *cell = (RequestsTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"RequestsTableViewCell" forIndexPath:indexPath];
        [cell configureCellWithPost:self.requestsPostsArray[indexPath.row]];
        
        if (indexPath.row % 2) {
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.82 green:0.93 blue:0.99 alpha:1.0];
        } else {
            cell.contentView.backgroundColor =[UIColor colorWithRed:0.84 green:0.81 blue:0.76 alpha:1.0];
        }

        if([self.selectedRequestsIndices containsIndex:indexPath.row]){
            cell.requestsCellCheckButton.hidden = false;
        }else{
            cell.requestsCellCheckButton.hidden = true;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SinglePostViewController *singlePostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePostViewController"];
    
    if(postType == OFFER){
        singlePostVC.slug = [self.offersPostsArray[indexPath.row] postSlug];
    }else{
        singlePostVC.slug = [self.requestsPostsArray[indexPath.row] postSlug];
    }
    
    singlePostVC.postType = postType;
    singlePostVC.singlePostVCDelegate = self;
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
                [self.selectedOffersIndices addIndex:indexPath.row];
                cell.offersCellCheckButton.hidden = false;
            }else{
                cell.offersCellCheckButton.hidden = true;
                [self.selectedOffersIndices removeIndex:indexPath.row];
                if(self.selectedOffersIndices.count == 0){
                    
                    [self whenNoPostsMarked];
                    
                }
            }
            
        }else{
            
            RequestsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.isSelected ^= true;
            if(cell.isSelected == true){
                [self.selectedRequestsIndices addIndex:indexPath.row];
                cell.requestsCellCheckButton.hidden = false;
            }else{
                cell.requestsCellCheckButton.hidden = true;
                [self.selectedRequestsIndices removeIndex:indexPath.row];
                if(self.selectedRequestsIndices.count == 0){
                    
                    [self whenNoPostsMarked];
                }
            }
            
        }
    }
    
}


- (IBAction)addPostButtonPressed:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:(@"Alert") message:@"Select the type of Post" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *addOffer = [UIAlertAction actionWithTitle:@"Add Offer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AddPostViewController *addPostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPostViewController"];
        addPostVC.postType = OFFER;
        addPostVC.addPostVCDelegate = self;
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:addPostVC];
        [self presentViewController:navVC animated:true completion:nil];    }];
    
    
    UIAlertAction *addRequest = [UIAlertAction actionWithTitle:@"Add Request" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AddPostViewController *addPostVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddPostViewController"];
        addPostVC.postType = REQUEST;
        addPostVC.addPostVCDelegate = self;
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
    
    NSDictionary *parameters;
    
    if(self.offerOrRequestSegmentedControl.selectedSegmentIndex == offers){
        
        NSMutableArray *selectedOffersSlug = [[NSMutableArray alloc] init];
        
        NSUInteger index = [self.selectedOffersIndices firstIndex];
        while (index != NSNotFound) {
            [selectedOffersSlug addObject:[self.offersPostsArray[index] postSlug]];
            index = [self.selectedOffersIndices indexGreaterThanIndex:index];
        }
        
        parameters =@{
                      @"slugs" :selectedOffersSlug
                      };
        
    }else if(self.offerOrRequestSegmentedControl.selectedSegmentIndex == asks){
        
        NSMutableArray *selectedRequestsSlug = [[NSMutableArray alloc] init];
        NSUInteger index = [self.selectedRequestsIndices firstIndex];
        
        while (index != NSNotFound) {
            [selectedRequestsSlug addObject:[self.requestsPostsArray[index] postSlug]];
            index = [self.selectedRequestsIndices indexGreaterThanIndex:index];
        }
        
        parameters =@{
                      @"slugs" : selectedRequestsSlug
                      };
        
    }
    
    [[APICaller sharedInstance] callApiForDelete:@"posts/bulkdelete" parameters:parameters viewController:self completion:^(NSDictionary *responseObjectDictionary) {
        
        if( [[responseObjectDictionary valueForKey:@"code"] isEqualToString: SUCCESS]){
            if(self.offerOrRequestSegmentedControl.selectedSegmentIndex == offers){
                [self.selectedOffersIndices removeAllIndexes];
            }else{
                [self.selectedRequestsIndices removeAllIndexes];
            }
            [self refreshTable];
            
        }
    }];
    
}

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender {
    [self whenNoPostsMarked];
    
    if(self.offerOrRequestSegmentedControl.selectedSegmentIndex == 0){
        [self.selectedOffersIndices removeAllIndexes];
    }else{
        [self.selectedRequestsIndices removeAllIndexes];
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


- (void)didFinishAddingPost{
    [self refreshTable];
}

- (void)didFinishDeleting{
    [self refreshTable];
}

- (void)didFinishEditingPost{
    [self refreshTable];
}

@end
