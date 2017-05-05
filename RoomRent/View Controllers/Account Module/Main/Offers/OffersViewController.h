//
//  OffersViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICaller.h"
#import "Navigator.h"
#import "OffersTableViewCell.h"
#import "CustomRevealViewController.h"
#import "Post.h"
#import "OffersTableViewCell.h"
#import "SinglePostViewController.h"
#import "MasterViewController.h"

@interface OffersViewController : CustomRevealViewController <UITableViewDataSource , UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@end
