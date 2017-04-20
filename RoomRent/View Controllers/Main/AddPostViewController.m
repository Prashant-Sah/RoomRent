//
//  AddPostViewController.m
//  RoomRent
//
//  Created by Prashant Sah on 4/17/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

#import "AddPostViewController.h"

@interface AddPostViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property  NSIndexPath *selectedIndexPath;
@property NSInteger lastRowIndex;
@end


@implementation AddPostViewController

NSMutableArray *photoMutableArray = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _photosCollectionView.delegate = self;
    _photosCollectionView.dataSource = self;
    
    photoMutableArray  = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"addPhotosIcon.png"], nil];
    
    _photosCollectionView.layer.borderWidth = 5.0f;
    _photosCollectionView.layer.borderColor = [UIColor grayColor].CGColor;
    _photosCollectionView.layer.cornerRadius = 5.0f;
    
    UICollectionViewFlowLayout *layout = self.photosCollectionView.collectionViewLayout;
    [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 5.0f;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    cancelButton.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.photosCollectionView addGestureRecognizer:lpgr];
}

-(void) onCancel{
    [self dismissViewControllerAnimated:true completion:nil];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(photoMutableArray.count == 6){
        [photoMutableArray removeLastObject];
    }
    return photoMutableArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 5;
    CGRect imageRect = CGRectMake(0, 0 , 100, 100);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    photosImageView.layer.cornerRadius = 5;
    [cell.contentView addSubview:[photosImageView initWithImage:photoMutableArray[indexPath.row]]];
    NSLog(@"%@", photoMutableArray);
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndexPath = indexPath;
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self ;
    pickerController.allowsEditing = true;
    
    NSInteger lastSectionIndex = [collectionView numberOfSections] - 1;
    _lastRowIndex = [collectionView numberOfItemsInSection:lastSectionIndex] - 1;
    
    [self presentViewController:pickerController animated:YES completion:nil];
    
}

- (void)setImageForCellwithImage:(UIImage *)selectedImage{
    
    CGSize destinationSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(destinationSize);
    [selectedImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *selectedResizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSArray *selectedIndexPathArray = [[NSArray alloc] initWithObjects:_selectedIndexPath, nil];
    
    if(_selectedIndexPath.row == _lastRowIndex){
        [photoMutableArray insertObject:selectedResizedImage atIndex:0];
        
    }else{
        [photoMutableArray replaceObjectAtIndex:_selectedIndexPath.row withObject:selectedResizedImage];
        [_photosCollectionView reloadItemsAtIndexPaths:selectedIndexPathArray];
    }
 
    [_photosCollectionView reloadData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:true completion:nil];
    [self setImageForCellwithImage:editedImage];
    
}
- (IBAction)gpsIconPressed:(UIButton *)sender {
    
    UIViewController *userLocationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLocationViewController"];
    
    [self presentViewController: userLocationViewController animated:true completion:nil];
}



-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.photosCollectionView];
    
    NSIndexPath *indexPath = [self.photosCollectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        UICollectionViewCell* cell = [self.photosCollectionView cellForItemAtIndexPath:indexPath];
        
        UIAlertController *aLertController = [UIAlertController alertControllerWithTitle:(@"Alert") message:@"Do you want to delete this image" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [photoMutableArray removeObjectAtIndex:_selectedIndexPath.row];
            NSLog(@"%@",photoMutableArray);
            [self.photosCollectionView reloadData];
            
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:true completion:nil];
            
        }];
        
        [aLertController addAction:yes];
        [aLertController addAction:no];
        
        [self presentViewController:aLertController animated:true completion:nil];

    }
}

@end
