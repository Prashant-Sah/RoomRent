//
//  OffersViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/12/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "OffersViewController.h"

@interface OffersViewController ()
@property (weak, nonatomic) IBOutlet UITableView *offersTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPostButton;

@end

@implementation OffersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offersTableView.dataSource = self;
    _offersTableView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"OffersTableViewCell" bundle:nil];
    [self.offersTableView registerNib:cellNib forCellReuseIdentifier:@"OffersTableViewCell"];
    
    [self.revealViewController panGestureRecognizer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OffersTableViewCell *cell  = (OffersTableViewCell *)  [tableView dequeueReusableCellWithIdentifier:@"OffersTableViewCell"];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
    
}
- (IBAction)addPostButtonPressed:(UIBarButtonItem *)sender {
    
    UIAlertController *aLertController = [UIAlertController alertControllerWithTitle:(@"Alert") message:@"Select the type of Post" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *addOffer = [UIAlertAction actionWithTitle:@"Add Offer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[Navigator sharedInstance] presentWithNavigationController:self viewController:@"AddPostViewController"];
    }];
    
    
    UIAlertAction *addRequest = [UIAlertAction actionWithTitle:@"Add Request" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
        
    }];

    [aLertController addAction:addOffer];
    [aLertController addAction:addRequest];
    
    [self presentViewController:aLertController animated:true completion:nil];
}



@end
