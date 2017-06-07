//
//  MyPostViewController.h
//  RoomRent
//
//  Created by Prashant Sah on 5/22/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APICaller.h"
#import "Navigator.h"
#import "OffersTableViewCell.h"
#import "RequestsTableViewCell.h"
#import "CustomRevealViewController.h"
#import "Post.h"
#import "SinglePostViewController.h"
#import "AddPostViewController.h"

@interface MyPostViewController :CustomRevealViewController <UITableViewDataSource , UITableViewDelegate,  UIScrollViewDelegate , AddPostVCDelegate, SinglePostVCDelegate>

-(void) refreshTable;

-(void) loadPostsWithType: (BOOL) type andOffset:(nullable NSNumber*) offset;

@end
