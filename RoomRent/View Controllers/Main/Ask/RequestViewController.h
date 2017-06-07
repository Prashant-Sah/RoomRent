//
//  RequestViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 5/1/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomRevealViewController.h"
#import "APICaller.h"
#import "Post.h"
#import "RequestsTableViewCell.h"
#import "SinglePostViewController.h"
#import "Navigator.h"
#import "Constants.h"

@interface RequestViewController : CustomRevealViewController <UITableViewDelegate ,UITableViewDataSource, UIScrollViewDelegate, SinglePostVCDelegate>

-(void) refreshTable;
-(void)loadPostswithOffset:(int ) offset;


@end
