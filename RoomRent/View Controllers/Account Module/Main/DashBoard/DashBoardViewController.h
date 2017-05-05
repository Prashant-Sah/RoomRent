//
//  DashBoardViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 5/1/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICaller.h"
#import "Navigator.h"
#import "OffersTableViewCell.h"
#import "CustomRevealViewController.h"
#import "Post.h"
#import "SinglePostViewController.h"


@interface DashBoardViewController : CustomRevealViewController <UITableViewDataSource , UITableViewDelegate,  UIScrollViewDelegate>

@end
