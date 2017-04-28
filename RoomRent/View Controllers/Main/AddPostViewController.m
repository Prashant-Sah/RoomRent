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
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomsTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property  NSIndexPath *selectedIndexPath;
@property NSInteger lastRowIndex;

@end

@implementation AddPostViewController

CLLocationCoordinate2D userAnnotationCoordinate;
NSMutableArray *photoMutableArray = nil;
NSMutableArray *photoDataArray = nil;
NSMutableArray *photoNameArray = nil;
NSString *imageName;
NSData *imageData;

int selectedItemIndex;

- (void)viewDidLoad {
    [super viewDidLoad];

    _photosCollectionView.delegate = self;
    _photosCollectionView.dataSource = self;
    
    photoMutableArray  = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"addPhotosIcon.png"], nil];
    photoNameArray = [[NSMutableArray alloc] init];
    photoDataArray = [[NSMutableArray alloc] init];
    
    _photosCollectionView.layer.borderWidth = 5.0f;
    _photosCollectionView.layer.borderColor = [UIColor grayColor].CGColor;
    _photosCollectionView.layer.cornerRadius = 5.0f;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
    layout.minimumLineSpacing = 5.0f;
    layout.minimumInteritemSpacing = 5.0f;
    
    
    //Cancel Button with background clear
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    cancelButton.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    //LongPressGesture for deleting photo
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.photosCollectionView addGestureRecognizer:lpgr];
    
    _roomsTextField.tag = ROOMS_TEXTFIELD;
    _priceTextField.tag = PRICE_TEXTFIELD;
    
    //[_contentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap)]];
    
    _titleTextField.text =@"room at narayantar";
    _descriptionTextField.text = @"free of cost for one special person";
    _roomsTextField.text =@"1";
    _priceTextField.text = @"Rs.1000";
}

//MARK - Button Handlers
-(void) onCancel{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)gpsIconPressed:(UIButton *)sender {
    
    UserLocationViewController *userLocationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserLocationViewController"];
    userLocationViewController.userLocationdelegate = self;
    [self presentViewController: userLocationViewController animated:true completion:nil];
}

- (IBAction)postButtonPressed:(UIButton *)sender {
    NSArray *required = @[
                          self.titleTextField,
                          self.descriptionTextField,
                          self.roomsTextField,
                          self.priceTextField,
                          self.addressLabel
                          ];

    if([[required valueForKeyPath:@"text.@min.length"] intValue] == 0){
        [[Alerter sharedInstance] createAlert:@"Error" message:@"One or more input fields are empty" viewController:self completion:^{}
         ];
    }else{
        
        NSString *lat = [NSString stringWithFormat:@"%.8f",userAnnotationCoordinate.latitude];
        NSString *lon =[NSString stringWithFormat:@"%.8f", userAnnotationCoordinate.longitude];
        NSDictionary *params = @{
                                 @"post_type" : OFFER,
                                 @"title" : _titleTextField.text,
                                 @"description" : _descriptionTextField.text,
                                 @"no_of_rooms" : self.roomsTextField.text,
                                 @"price" : [self.priceTextField.text substringFromIndex:3],
                                 @"address" : self.addressLabel.text,
                                 @"latitude" :  lat,
                                 @"longitude" : lon
                                 };
        
        [[APICaller sharedInstance] callApiforPost:@"post/create" headerFlag:true parameters:params imageDataArray:photoDataArray fileNameArray:photoNameArray viewController:self completion:^(NSDictionary *responseObjectDictionary)  {
            
            NSLog(@"%@", responseObjectDictionary);
            
            NSString *code = [responseObjectDictionary valueForKey:@"code"];
            if([code isEqualToString:OFFER_POSTED_SUCCESSFULLY]){
                
                //[[Alerter sharedInstance] createAlert:@"Success" message:@"Offer Posted Successfully" viewController:self completion:^{}];
                
                NSDictionary *postDict = [responseObjectDictionary valueForKey:@"post"];
                [[LocalDatabase alloc] pushPostToDatabase:postDict viewController:self];
               
            }
        }];
    }

}
//Collection View DataSource and Delegate Funct ions
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedIndexPath = indexPath;
    
    selectedItemIndex = indexPath.row;
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc]
                                                 init];
    pickerController.delegate = self ;
    pickerController.allowsEditing = true;
    
    NSInteger lastSectionIndex = [collectionView numberOfSections] - 1;
    _lastRowIndex = [collectionView numberOfItemsInSection:lastSectionIndex] - 1;
    
    [self presentViewController:pickerController animated:YES completion:nil];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(photoMutableArray.count == 6){
        [photoMutableArray removeLastObject];
    }
    return photoMutableArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    CGRect imageRect = CGRectMake(0, 0 , 100, 100);
    UIImageView *photosImageView = [[UIImageView alloc] initWithFrame:imageRect];
    [cell.contentView addSubview:[photosImageView initWithImage:photoMutableArray[indexPath.row]]];
    
    return cell;
    
}

//MARK - Image Handling and Setting to Cell
- (void)setImageForCellwithImage:(UIImage *)selectedImage{
    
    //resizing image to 100*100
    CGSize destinationSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(destinationSize);
    [selectedImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *selectedResizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //NSArray *selectedIndexPathArray = [[NSArray alloc] initWithObjects:_selectedIndexPath, nil];
    
    if(_selectedIndexPath.row == _lastRowIndex){
        [photoMutableArray insertObject:selectedResizedImage atIndex:0];
        [photoDataArray insertObject:imageData atIndex:0];
        [photoNameArray insertObject:imageName atIndex:0];
        
    }else{
        [photoMutableArray replaceObjectAtIndex:_selectedIndexPath.row withObject:selectedResizedImage];
        [photoDataArray replaceObjectAtIndex:_selectedIndexPath.row withObject:imageData];
        [photoNameArray replaceObjectAtIndex:_selectedIndexPath.row withObject:imageName];
        //[_photosCollectionView reloadItemsAtIndexPaths:selectedIndexPathArray];
    }
    
    [_photosCollectionView reloadData];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    imageData = UIImageJPEGRepresentation(editedImage, 0.5);
    
    NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageFileURL] options:nil];
    imageName = [[result firstObject] filename];
    [self setImageForCellwithImage:editedImage];
    
    [self dismissViewControllerAnimated:true completion:nil];
    
}

//MARK - Long Press Gesture
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
        
        UIAlertController *aLertController = [UIAlertController alertControllerWithTitle:(@"Alert") message:@"Do you want to delete this image" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [photoMutableArray removeObjectAtIndex:selectedItemIndex];
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

-(void) onTap{
    [self.view endEditing:true];
}

//MARK - UserLocationDelegate Functions
- (void)didSelectLocation:(CLLocationCoordinate2D)annotationCoordinate{
    
    userAnnotationCoordinate = annotationCoordinate;
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *annotationLocation =  [[CLLocation alloc] initWithLatitude:annotationCoordinate.latitude longitude:annotationCoordinate.longitude];
    
    [geocoder reverseGeocodeLocation:annotationLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
        NSLog(@"placemark.country %@",placemark.country);
        NSLog(@"placemark.locality %@",placemark.locality );
        NSLog(@"placemark.postalCode %@",placemark.postalCode);
        NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
        NSLog(@"placemark.locality %@",placemark.locality);
        NSLog(@"placemark.subLocality %@",placemark.subLocality);
        NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
        
        _addressLabel.hidden = false;
        self.addressLabel.text = placemark.country;
    }];
    
}


//TEXT Field delegate functions
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self resignFirstResponder];
    return true;
}

// gets rectangle of textfield and passes it to keyboardavoidingviewcontroller
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    CGRect textfieldrect = [self.view convertRect:textField.frame toView:[[[UIApplication sharedApplication] delegate ] window ]];
    [KeyboardAvoidingViewController setActiveTextFieldPosition:textfieldrect.origin];
    
    return true;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    if(textField.tag ){
        [[Validator sharedInstance] startValidation:textField];
    }
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag == PRICE_TEXTFIELD){
        _priceTextField.text = @"Rs.";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == PRICE_TEXTFIELD && [_priceTextField.text isEqualToString:@"Rs."] ){
        _priceTextField.text = @"";
    }
}

@end
