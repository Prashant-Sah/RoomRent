//
//  MasterViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 5/4/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <SWRevealViewController.h>
#import "CustomRevealViewController.h"
#import "APICaller.h"
#import "Post.h"
#import "OffersTableViewCell.h"
#import "SinglePostViewController.h"
#import "Navigator.h"

@interface MasterViewController : CustomRevealViewController <UITableViewDataSource , UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

-(void) refreshTable;
-(void)loadPosts;

@end
