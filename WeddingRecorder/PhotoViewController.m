//
//  PhotoViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/1.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "PhotoViewController.h"
extern NSString *deviceName;
@interface PhotoViewController ()

@property (nonatomic, strong) NSMutableArray *photoData;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSMutableDictionary *photoDictionary;
@property (strong, nonatomic) NSMutableArray *photoDictionaryKey;
@property (nonatomic) BOOL selection;
@property (strong, nonatomic) UIAlertController *processing;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL usePullRefresh;
@property (nonatomic, strong) NSMutableArray *selectedIndexpath;
@property (nonatomic, strong) NSMutableArray *eachPhotoUploadProgress;
@property (nonatomic) NSInteger uploadingImageCount;
@property (nonatomic) NSInteger totalProgress;
@property (nonatomic) BOOL uploading;
@property (nonatomic) BOOL uploadFromAlbum;
@property (nonatomic) BOOL loadingPhoto;
@property (nonatomic) BOOL comeFromAnotherTab; // 是否是從別的tab進入此頁面，若是，則要check是否活動已開始。
@property (strong, nonatomic) NSString *weddingName;
@property (strong, nonatomic) NSString *weddingInfoObjectId;
@end

@implementation PhotoViewController

@synthesize photoCollectionView, photoData, imagePicker, userDefaults, selectButton, selection, photoDictionary, photoDictionaryKey, processing, refreshControl, usePullRefresh, selectedIndexpath, eachPhotoUploadProgress, uploadingImageCount, totalProgress, uploading, uploadFromAlbum, downloadButton, loadingPhoto, comeFromAnotherTab, weddingName, weddingInfoObjectId;

- (void)viewDidLoad {
    [super viewDidLoad];
    selection = NO;
    eachPhotoUploadProgress = [[NSMutableArray alloc]init];
    selectedIndexpath = [[NSMutableArray alloc]init];
    eachPhotoUploadProgress = [[NSMutableArray alloc]init];
    uploading = NO;
    uploadingImageCount = 0;
    totalProgress = 0;
    userDefaults = [NSUserDefaults standardUserDefaults];
    [photoCollectionView setDelegate:self];
    [photoCollectionView setDataSource:self];
    photoDictionary = [[NSMutableDictionary alloc]init];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [photoCollectionView addSubview:refreshControl];
    [photoCollectionView setAlwaysBounceVertical:YES];
    usePullRefresh = NO;
    photoData = [[NSMutableArray alloc]init];
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    comeFromAnotherTab = YES;
    MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
    weddingName = tabBarController.weddingName;
    weddingInfoObjectId = tabBarController.weddingObjectId;
    
    NSLog(@"installation object id = %@", [PFInstallation currentInstallation].objectId);
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    NSLog(@"viewdidappear");
    
    if (comeFromAnotherTab) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self presentViewController:processing animated:YES completion:nil];
        });
        [self performSelectorInBackground:@selector(checkActivityStart) withObject:nil];
    }
    comeFromAnotherTab = YES;
    
}

- (void) pullToRefresh{
    NSLog(@"pull to refresh uploading image count = %d", uploadingImageCount);
    if (uploadingImageCount == 0 && loadingPhoto != YES) {
        usePullRefresh = YES;
        [self loadPhotoData];
    }
    else{
        [refreshControl endRefreshing];
    }
    
}

- (void) checkActivityStart{
    PFQuery *queryStartDate = [PFQuery queryWithClassName:@"Information"];
    [queryStartDate getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
        }
        else {
            dispatch_async(dispatch_get_main_queue(),^{
                [processing dismissViewControllerAnimated:YES completion:nil];
                NSDate *uploadingPhotoStartDate = [object objectForKey:@"uploadingPhotoStartDate"];
                if ([uploadingPhotoStartDate compare:[NSDate date]] == NSOrderedDescending) {
                    UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"尚未開放！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        [self.tabBarController setSelectedIndex:0];
                    }];
                    [message addAction:okButton];
                    [self presentViewController:message animated:YES completion:nil];
                    //[self.tabBarController setSelectedIndex:0];
                    return;
                }
                else{
                    [self performSelectorInBackground:@selector(loadPhotoData) withObject:nil];
                }
            });
            
        }
    }];
}

- (void) loadPhotoData{
    loadingPhoto = YES;
    //[photoDictionary removeAllObjects];
    //[photoDictionaryKey removeAllObjects];
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"%@%@", weddingInfoObjectId, @"Photo"]];
    [query orderByAscending:@"Shooter"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"ddddddd  count = %d   %@", [objects count], error);
        if (!error) {
            NSMutableArray *objectsArray = [objects mutableCopy];
            NSLog(@"~~~~~~~~~~~~");
            if ([objects count] == 0) {
                NSLog(@"!!!!!!!!!!!!!!");
            }
            else{
                NSLog(@"jjjjjjjjjjjjjj %d", [objectsArray count]);
                NSString *sectionTitle = [objectsArray objectAtIndex:0][@"Shooter"];
                NSLog(@"jjjjjjjjjjjjjj %@", sectionTitle);
                NSMutableArray *photoTempArray = [[NSMutableArray alloc]init];
                for (int i = 0 ; i<[objectsArray count]; i++) {
                //for (PFObject *object in objects) {
                    PFObject *object = [objectsArray objectAtIndex:i];
                    NSLog(@"kkkkkkkkk, %d", i);
                    if ([sectionTitle isEqualToString:object[@"Shooter"]]) {
                        NSLog(@"aaaaaaaaaaaaaaaa");
                        [photoTempArray addObject:object];
                    }
                    else{
                        NSLog(@"bbbbbbbbbbbbbbbbb");
                        [photoDictionary setObject:[photoTempArray mutableCopy] forKey:sectionTitle];
                        sectionTitle = object[@"Shooter"];
                        [photoTempArray removeAllObjects];
                        [photoTempArray addObject:object];
                    }
                    NSLog(@"ccccccc");
                }
                [photoDictionary setObject:photoTempArray forKey:sectionTitle];
                photoDictionaryKey = [[photoDictionary allKeys] mutableCopy];
                NSLog(@"=============+++++++=");

            }
            dispatch_async(dispatch_get_main_queue(),^{
                NSLog(@"==============");
                [photoCollectionView reloadData];
                [refreshControl endRefreshing];
                loadingPhoto = NO;
                if (!usePullRefresh) {
                    [processing dismissViewControllerAnimated:YES completion:nil];
                }
            });
        }
        else {
            [refreshControl endRefreshing];
            usePullRefresh = NO;
            if (!usePullRefresh) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [processing dismissViewControllerAnimated:YES completion:nil];
                });
            }
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString *keyString = [photoDictionaryKey objectAtIndex:section];
    NSMutableArray *tempArray = [photoDictionary objectForKey:keyString];
    NSLog(@"tempArray count = %lu", (unsigned long)[tempArray count]);
    return [tempArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [photoDictionaryKey count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([deviceName isEqualToString:@"iPhone5"]) {
        return CGSizeMake(100, 100);
    }
    else if ([deviceName isEqualToString:@"iPhone6"]){
        return CGSizeMake(120, 120);
    }
    else if ([deviceName isEqualToString:@"iPhone6Plus"]){
        return CGSizeMake(125, 125);
    }
    /*
    else if ([deviceName isEqualToString:@"iPad9.7"]){
        return CGSizeMake(250, 250);
    }
     */
    else{
        return CGSizeMake(100,100);
    }
}

- (CGFloat)collectionView:(UICollectionView *) collectionView
                   layout:(UICollectionViewLayout *) collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger) section {
    return 5.0;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        NSString *keyString = [[photoDictionary allKeys] objectAtIndex:indexPath.section];
        
        NSString *title = [[NSString alloc]initWithFormat:@"攝影師：%@", keyString];
        headerView.shooter.text = title;
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

- (PhotoCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"Cell";
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PhotoCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 500, 500)];
    }
    
    NSString *keyString = [photoDictionaryKey objectAtIndex:indexPath.section];
    NSMutableArray *tempArray = [photoDictionary objectForKey:keyString];
    
    PFObject *object = [tempArray objectAtIndex:[indexPath row]];
    
    PFFile *thumbnail = object[@"microPhoto"];
    //cell.photo = [[PFImageView alloc]init];
    cell.photo.file = thumbnail;
    [cell.photo loadInBackground];
    if ([selectedIndexpath containsObject:indexPath]) {
        [cell.photoBackgroundView setBackgroundColor:[UIColor redColor]];
    }
    else{
        [cell.photoBackgroundView setBackgroundColor:[UIColor whiteColor]];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!selection) {
        if (![refreshControl isRefreshing]) {
            [collectionView deselectItemAtIndexPath:indexPath animated:nil];
            [self performSegueWithIdentifier:@"segueFullScreenPhoto" sender:indexPath];
        }
        
    }
    else{
        if (![selectedIndexpath containsObject:indexPath]){
            [selectedIndexpath addObject:indexPath];
            [collectionView reloadData];
        }
        else{
            [selectedIndexpath removeObject:indexPath];
            [collectionView reloadData];
        }
        if ( [selectedIndexpath count] != 0) {
            [downloadButton setEnabled:YES];
        }
        else{
            [downloadButton setEnabled:NO];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueFullScreenPhoto"]) {
        UINavigationController *nav = segue.destinationViewController;
        GalleryViewController *gallery = (GalleryViewController *)nav.topViewController;
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        NSString *keyString = [photoDictionaryKey objectAtIndex:indexPath.section];
        NSMutableArray *tempArray = [photoDictionary objectForKey:keyString];
        NSLog(@"temparray.count = %d", [tempArray count]);
        gallery.stringList = tempArray;
        gallery.titleShooter = keyString;
        gallery.currentIndex = indexPath.row;
    }
    else if([segue.identifier isEqualToString:@"seguePlayShow"]){
        UINavigationController *nav = segue.destinationViewController;
        SlideShowViewController *slideShowViewController = (SlideShowViewController *)nav.topViewController;
        slideShowViewController.weddingInfoObjectId = weddingInfoObjectId;
    }
    

    
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return  UIModalPresentationNone;
}

- (IBAction)playPhoto:(id)sender {
    [self performSegueWithIdentifier:@"seguePlayShow" sender:self];
}

- (IBAction)takePhoto:(id)sender {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)chooseFromAlbum:(id)sender {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
    uploadFromAlbum = YES;
}

- (IBAction)selectPhoto:(id)sender {
    if (!selection) {
        [selectButton setTitle:@"取消"];
        [photoCollectionView setAllowsMultipleSelection:NO];
    }
    else{
        [selectButton setTitle:@"選取"];
        [selectedIndexpath removeAllObjects];
        [photoCollectionView setAllowsMultipleSelection:NO];
        [photoCollectionView reloadData];
        [downloadButton setEnabled:NO];
    }
    selection = !selection;
    NSLog(@"selection = %d", selection);
}

- (IBAction)downloadPhoto:(id)sender {
    [self presentViewController:processing animated:YES completion:nil];
    //for (NSIndexPath *indexPath in selectedIndexpath) {
    for (int i = 0 ; i<[selectedIndexpath count] ; i++) {
        NSIndexPath *indexPath = [selectedIndexpath objectAtIndex:i];
        NSMutableArray *tempArray = [photoDictionary objectForKey:photoDictionaryKey[indexPath.section]];
        PFObject *object = [tempArray objectAtIndex:indexPath.row];
        NSString *originalPhotoObjectID = object[@"OriginalPhotoObjectID"];
        
        PFUser *currentUser = [PFUser currentUser];
        PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"%@%@", weddingInfoObjectId, @"OriginalPhoto"]];
        [query getObjectInBackgroundWithId:originalPhotoObjectID block:^(PFObject *object, NSError *error) {
            PFFile *originalPhoto = object[@"Photo"];
            [originalPhoto getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                    [selectedIndexpath removeObject:indexPath];
                    [photoCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    NSLog(@"i = %d",i);
                    if (i == [selectedIndexpath count] ) {
                        dispatch_async(dispatch_get_main_queue(),^{
                            [processing dismissViewControllerAnimated:YES completion:nil];
                        });
                    }
                    
                }
            }progressBlock:^(int percentDone){
                NSLog(@"download progress = %d, id = %@", percentDone, originalPhotoObjectID);
            }];
        }];
    }
    
    [self selectPhoto:self];
    
}
/*
- (IBAction)likePhoto:(id)sender {
    UIButton *theButton = (UIButton *)sender;
    theButton.selected = !theButton.selected;
    CGPoint hitPoint = [theButton convertPoint:CGPointZero toView:photoCollectionView];
    NSIndexPath *hitIndex = [photoCollectionView indexPathForItemAtPoint:hitPoint];
    NSLog(@"hitIndex = %@", hitIndex);
}
*/

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    comeFromAnotherTab = NO;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    comeFromAnotherTab = NO;
    //取得影像
    uploadingImageCount++;
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (!uploadFromAlbum) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    }
    NSData *imageData = [self scaleImage:image ToSize:10485760];
    NSData *smallImageData = UIImageJPEGRepresentation(image, 0.01);
    
    CGSize newSize;
    NSInteger cellWidth;
    if ([deviceName isEqualToString:@"iPhone5"]) {
        cellWidth = 100;
    }
    else if ([deviceName isEqualToString:@"iPhone6"]){
        cellWidth = 120;
    }
    else if ([deviceName isEqualToString:@"iPhone6Plus"]){
        cellWidth = 125;
    }
    else{
        cellWidth = 100;
    }
    if (image.size.width > image.size.height) {
        newSize = CGSizeMake(cellWidth, image.size.height*cellWidth/image.size.width);
    }
    else{
        newSize = CGSizeMake(image.size.width*cellWidth/image.size.height, cellWidth);
    }
    //NSLog(@"newSize = %@", newSize);
    UIImage *microImage = [self imageResize:image andResizeTo:newSize];
    NSData *microImageData = UIImageJPEGRepresentation(microImage, 1);
    
    PFFile *imageFile = [PFFile fileWithName:@"Name.jpg" data:imageData];
    
    PFFile *smallImageFile = [PFFile fileWithName:@"Name.png" data:smallImageData];
    
    PFFile *microImageFile = [PFFile fileWithName:@"Micro.jpg" data:microImageData];
    
    
    totalProgress = totalProgress + 100;
    
    NSLog(@"start save in background with block");
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        NSLog(@"save file succeededdddddddd object id ");
        PFUser *currentUser = [PFUser currentUser];
        PFObject *object = [[PFObject alloc]initWithClassName:[NSString stringWithFormat:@"%@%@", weddingInfoObjectId, @"OriginalPhoto"]];
        [object setObject:imageFile forKey:@"Photo"];
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                totalProgress = totalProgress-100;
                uploadingImageCount--;
                dispatch_async(dispatch_get_main_queue(),^{
                    if (uploadingImageCount == 0) {
                        [self.navigationItem setPrompt:[NSString stringWithFormat:@"上傳完成！"]];
                    }
                });
                 
                NSLog(@"object.id = %@", object.objectId);
                PFObject *tempObject = [[PFObject alloc]initWithClassName:[NSString stringWithFormat:@"%@Photo", weddingInfoObjectId]];
                [tempObject setObject:smallImageFile forKey:@"miniPhoto"];
                [tempObject setObject:microImageFile forKey:@"microPhoto"];
                if (![userDefaults objectForKey:@"NickName"]) {
                    [tempObject setObject:@"" forKey:@"Shooter"];
                }
                else{
                    [tempObject setObject:[userDefaults objectForKey:@"NickName"] forKey:@"Shooter"];
                }
                [tempObject setObject:object.objectId forKey:@"OriginalPhotoObjectID"];
                [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    NSLog(@"error = %@", error);
                    if (succeeded) {
                        [self loadPhotoData];
                        dispatch_async(dispatch_get_main_queue(),^{
                            if (uploadingImageCount == 0) {
                                NSLog(@"setprompt nillllllllll");
                                [self.navigationItem setPrompt:nil];
                            }
                            
                        });
                        
                    }
                    else{
                        NSLog(@"error = %@", error);
                        
                    }
                }];
                NSLog(@"is it succeeeee");
            }
        }];
    }
                           progressBlock:^(int percentDone) {
                               dispatch_async(dispatch_get_main_queue(),^{
                                   [self.navigationItem setPrompt:[NSString stringWithFormat:@"上傳中...還有%d張等待上傳！", uploadingImageCount]];
                               });
                           }];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSData *)scaleImage:(UIImage *)image ToSize:(CGFloat)destSize{
    CGFloat compress = 1.0;
    NSData *imgData = UIImageJPEGRepresentation(image, compress);
    NSLog(@"size: %lu", (unsigned long)[imgData length]);
    while ([imgData length] > destSize) {
        compress -= .05;
        imgData = UIImageJPEGRepresentation(image, compress);
        NSLog(@"new size: %lu",(unsigned long)[imgData length]);
    }
    
    return imgData;
}

@end
