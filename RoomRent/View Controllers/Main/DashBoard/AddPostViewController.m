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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (weak, nonatomic) IBOutlet UITextField *roomsTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfRoomsLabel;
@property (weak, nonatomic) IBOutlet UILabel *addPhotosLabel;
@property (weak, nonatomic) IBOutlet UIStackView *addPhotosStackView;
@property (weak, nonatomic) IBOutlet UIButton *addPostButton;

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
    
    self.roomsTextField.tag = ROOMS_TEXTFIELD;
    self.priceTextField.tag = PRICE_TEXTFIELD;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.contentView addGestureRecognizer: tapGesture];
    
    self.titleTextField.text =@"Room needed around baneshwor for a family of 4";
    self.descriptionTextField.text = @"Water abundance and clean rooms";
    self.roomsTextField.text =@"1";
    self.priceTextField.text = @"5500";
    
    if([self.postType isEqualToString:OFFER] && self.passedPost==nil){
        
        self.photosCollectionView.delegate = self;
        self.photosCollectionView.dataSource = self;
        
        photoMutableArray  = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"addPhotosIcon.png"], nil];
        photoNameArray = [[NSMutableArray alloc] init];
        photoDataArray = [[NSMutableArray alloc] init];
        
        self.photosCollectionView.layer.borderWidth = 5.0f;
        self.photosCollectionView.layer.borderColor = [UIColor grayColor].CGColor;
        self.photosCollectionView.layer.cornerRadius = 5.0f;
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.photosCollectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(100, 100);
        [layout setScrollDirection: UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        
        self.photosCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        
    } else if([self.postType isEqualToString:REQUEST] && self.passedPost==nil) {
        
        self.titleLabel.text = @"ADD REQUEST";
        self.numberOfRoomsLabel.text = @"Number of Rooms Needed";
        [self removePhotosViewFromSuperView];
    }
    
    if(self.passedPost!=nil){
        
        self.titleLabel.text = @"Edit Post";
        if([self.postType isEqualToString:REQUEST]){
            self.numberOfRoomsLabel.text = @"Number of rooms Needed";
        }
        [self.addPostButton setTitle:@"Add Edited Post" forState:UIControlStateNormal];
        self.addressLabel.hidden = false;
        self.titleTextField.text = self.passedPost.title;
        self.descriptionTextField.text = self.passedPost.postDescription;
        self.roomsTextField.text = [NSString stringWithFormat:@"%d",self.passedPost.numberOfRooms];
        self.priceTextField.text =[@"Rs." stringByAppendingString: [NSString stringWithFormat:@"%d",(int)self.passedPost.price]];
        self.addressLabel.text = self.passedPost.location;
        [self removePhotosViewFromSuperView];
    }
}

-(void) removePhotosViewFromSuperView {
    
    CGRect newFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.photosCollectionView.frame.size.height - self.addPhotosLabel.frame.size.height) ;
    [self.photosCollectionView removeFromSuperview];
    [self.addPhotosLabel removeFromSuperview];
    self.view.frame = newFrame;
    self.contentView.frame = newFrame;
    
    NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:self.addPostButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.addressLabel   attribute:NSLayoutAttributeBottom multiplier:1 constant:30];
    NSArray *narray = [[NSArray alloc] initWithObjects:newConstraint, nil];
    [self.addPostButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [NSLayoutConstraint activateConstraints:narray];
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
        [[Alerter sharedInstance] createAlert:@"Error" message:@"One or more input fields are empty" useCancelButton:false viewController:self completion:^{}
         ];
    }else{
        
        NSString *lat = [NSString stringWithFormat:@"%.8f",userAnnotationCoordinate.latitude];
        NSString *lon =[NSString stringWithFormat:@"%.8f", userAnnotationCoordinate.longitude];
        
        if(lat == nil){
            lat = [ NSString stringWithFormat:@"%.8f",self.passedPost.latitude];
            lon = [ NSString stringWithFormat:@"%.8f",self.passedPost.longitude];
        }
        NSDictionary *params = @{
                                 @"title" : self.titleTextField.text,
                                 @"description" : self.descriptionTextField.text,
                                 @"no_of_rooms" : self.roomsTextField.text,
                                 @"price" : [self.priceTextField.text substringFromIndex:3],
                                 @"address" : self.addressLabel.text,
                                 @"latitude" :  lat,
                                 @"longitude" : lon
                                 };
        NSMutableDictionary *parameters;
        parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
        if(self.postType == OFFER){
            [parameters setObject:OFFER forKey:@"post_type"];
        }else{
            [parameters setObject:REQUEST forKey:@"post_type"];
        }
        
        if(self.passedPost == nil){
            
            [[APICaller sharedInstance] callApiToCreatePost:POST_PATH parameters:parameters imageDataArray:photoDataArray fileNameArray:photoNameArray viewController:self completion:^(NSDictionary *responseObjectDictionary) {
                
                NSLog(@"%@", responseObjectDictionary);
                
                NSString *code = [responseObjectDictionary valueForKey:@"code"];
                if([code isEqualToString:ITEM_POSTED_SUCCESSFULLY]){
                    
                    Post *addedPost = [[Post alloc] initPostFromJson:[responseObjectDictionary valueForKey:@"data"]];
                    [[LocalDatabase sharedInstance] pushSinglePostToDatabase:addedPost];
                    
                    [[Alerter sharedInstance] createAlert:@"Success" message:@"Post Uploaded Successfully" useCancelButton:false viewController:self completion:^{
                        [self dismissViewControllerAnimated:true completion:nil];
                    }];
                    [self.addPostVCDelegate didFinishAddingPost];
                    //[self dismissViewControllerAnimated:true completion:nil];
                }
            }];
        }else{
            
            [[APICaller sharedInstance] callApiToEditPost:[[POST_PATH stringByAppendingString:@"/"] stringByAppendingString:self.passedPost.postSlug] parameters:parameters viewController:self completion:^(NSDictionary *responseObjectDictionary) {
                
                NSLog(@"%@", responseObjectDictionary);
                
                if([[responseObjectDictionary valueForKey:@"code"] isEqualToString:ITEM_UPDATED_SUCCESSFULLY]){
                    Post *post = [responseObjectDictionary valueForKey:@"data"];
                    [[LocalDatabase sharedInstance] pushSinglePostToDatabase:post];
                    [self.addPostVCDelegate didFinishEditingPost];
                    [self dismissViewControllerAnimated:true completion:nil];
                }
            }];
        }
    }
}


//MARK- Collection View DataSource and Delegate Functions

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedIndexPath = indexPath;
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self ;
    pickerController.allowsEditing = true;
    
    NSInteger lastSectionIndex = [collectionView numberOfSections] - 1;
    self.lastRowIndex = [collectionView numberOfItemsInSection:lastSectionIndex] - 1;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
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
    
    if(self.selectedIndexPath.row == self.lastRowIndex){
        [photoMutableArray insertObject:selectedResizedImage atIndex:0];
        [photoDataArray insertObject:imageData atIndex:0];
        [photoNameArray insertObject:imageName atIndex:0];
        
    }else{
        
        NSArray *selectedIndexPathArray = [[NSArray alloc] initWithObjects:self.selectedIndexPath, nil];
        [photoMutableArray replaceObjectAtIndex:_selectedIndexPath.row withObject:selectedResizedImage];
        [photoDataArray replaceObjectAtIndex:_selectedIndexPath.row withObject:imageData];
        [photoNameArray replaceObjectAtIndex:_selectedIndexPath.row withObject:imageName];
        [self.photosCollectionView reloadItemsAtIndexPaths:selectedIndexPathArray];
    }
    
    [self.photosCollectionView reloadData];
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
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
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
            //[self dismissViewControllerAnimated:true completion:nil];
            
        }];
        
        [aLertController addAction:yes];
        [aLertController addAction:no];
        
        [self presentViewController:aLertController animated:true completion:nil];
        
    }
}

//MARK- resign first responder on tap actions
-(void) onTap:(UITapGestureRecognizer *)  recognizer{
    
    CGPoint tapPoint = [recognizer locationInView:self.view];
    
    CGRect photosCollectionViewInSuperview = self.photosCollectionView.frame;
    if(!(CGRectContainsPoint(photosCollectionViewInSuperview, tapPoint))){
        [self.view endEditing:true];
    }
    
}


//MARK - UserLocationDelegate Functions
- (void)didSelectLocation:(CLLocationCoordinate2D)annotationCoordinate{
    
    userAnnotationCoordinate = annotationCoordinate;
    //CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //CLLocation *annotationLocation =  [[CLLocation alloc] initWithLatitude:annotationCoordinate.latitude longitude:annotationCoordinate.longitude];
    
    NSString *latlon = [[[NSString stringWithFormat:@"%f", annotationCoordinate.latitude] stringByAppendingString:@","] stringByAppendingString:[NSString stringWithFormat:@"%f", annotationCoordinate.longitude]];
    
    NSDictionary *params = @{
                             @"latlng" : latlon
                             };
    
    [[APICaller sharedInstance] callApiForGETRawUrl:@"http://maps.googleapis.com/maps/api/geocode/json" parameters:params viewController:self completion:^(id responseObject) {
        
        NSString *resultsDict = [responseObject valueForKey:@"results"];
        NSArray *place = [resultsDict valueForKey:@"formatted_address"];
        self.addressLabel.hidden = false;
        self.addressLabel.text = place.firstObject;
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
// gets rectangle of textview and passes it to keyboardavoidingviewcontroller
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect textviewRect = [self.view convertRect:textView.frame toView:[[[UIApplication sharedApplication] delegate ] window ]];
    [KeyboardAvoidingViewController setActiveTextFieldPosition:textviewRect.origin];
    
    return true;
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField{
    if(textField.tag ){
        [[Validator sharedInstance] startValidation:textField];
    }
    return true;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == PRICE_TEXTFIELD){
        if(range.location <3){
            return false;
        }
    }
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag == PRICE_TEXTFIELD){
        self.priceTextField.text = @"Rs.";
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag == PRICE_TEXTFIELD && [self.priceTextField.text isEqualToString:@"Rs."] ){
        self.priceTextField.text = @"";
    }
}

@end
