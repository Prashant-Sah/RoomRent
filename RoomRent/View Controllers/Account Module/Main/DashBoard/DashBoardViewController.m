//
//  DashBoardViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 5/1/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "DashBoardViewController.h"

@interface DashBoardViewController ()
//@property UITableView *offersTableView;
@end
@implementation DashBoardViewController

- (void)viewDidLoad {
    
//    self.offersTableView = [self.offersTableView initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) style:UITableViewStylePlain];
//    [self.view addSubview:self.offersTableView];

    [super viewDidLoad];
    
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:true];
}

//-(void) refreshTable{
//    MasterViewController *masterVC = (MasterViewController *) self.parentViewController;
//    [masterVC refreshTable];
//}
//
//-(void) loadPosts{
//    NSMutableArray *postArray = [[NSMutableArray alloc] init];
//    
//    NSDictionary *params = @{
//                             };
//    NSData *userDataDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"userDataKey"];
//    NSDictionary *userDict = [NSKeyedUnarchiver unarchiveObjectWithData:userDataDict];
//    NSString *username = [userDict valueForKey:@"username"];
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
//                [postArray addObject:post];
//                
//            }
//            BOOL isLastPage = [[responseObjectDictionary valueForKey:@"is_last_page"] boolValue];
//            int offsetValue = [[responseObjectDictionary valueForKey:@"offset"] intValue];
//            
//            [self.offersTableView reloadData];
//        }
//    }];
//
//}
//
//

@end
