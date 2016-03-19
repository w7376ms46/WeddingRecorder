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

@end

@implementation PhotoViewController

@synthesize photoCollectionView, photoData, imagePicker, userDefaults, selectButton, selection, photoDictionary, photoDictionaryKey, processing, refreshControl, usePullRefresh, selectedIndexpath;

- (void)viewDidLoad {
    [super viewDidLoad];
    selection = NO;
    selectedIndexpath = [[NSMutableArray alloc]init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    [photoCollectionView setDelegate:self];
    [photoCollectionView setDataSource:self];
    photoDictionary = [[NSMutableDictionary alloc]init];
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullToRefresh)
             forControlEvents:UIControlEventValueChanged];
    [photoCollectionView addSubview:refreshControl];
    [photoCollectionView setAlwaysBounceVertical:YES];
    usePullRefresh = NO;
    photoData = [[NSMutableArray alloc]init];
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    [self performSelectorInBackground:@selector(loadPhotoData) withObject:nil];
}

- (void) pullToRefresh{
    usePullRefresh = YES;
    [self loadPhotoData];
}

- (void) loadPhotoData{
    if (!usePullRefresh) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self presentViewController:processing animated:YES completion:nil];
        });
    }
    
    [photoDictionary removeAllObjects];
    [photoDictionaryKey removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query orderByAscending:@"Shooter"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"ddddddd  count = %d   %@", [objects count], error);
        if (!error) {
            if ([objects count] == 0) {
                if (!usePullRefresh) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processing dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }
            else{
                NSString *sectionTitle = [objects objectAtIndex:0][@"Shooter"];
                NSMutableArray *photoTempArray = [[NSMutableArray alloc]init];
                for (PFObject *object in objects) {
                    if ([sectionTitle isEqualToString:object[@"Shooter"]]) {
                        [photoTempArray addObject:object];
                    }
                    else{
                        [photoDictionary setObject:[photoTempArray mutableCopy] forKey:sectionTitle];
                        sectionTitle = object[@"Shooter"];
                        [photoTempArray removeAllObjects];
                        [photoTempArray addObject:object];
                    }
                }
                [photoDictionary setObject:photoTempArray forKey:sectionTitle];
                photoDictionaryKey = [[photoDictionary allKeys] mutableCopy];
                
                if (!usePullRefresh) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processing dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }
            [photoCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            [refreshControl endRefreshing];
            
        }
        else {
            [refreshControl endRefreshing];
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
    
    PFFile *thumbnail = object[@"miniPhoto"];
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
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
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

- (IBAction)takePhoto:(id)sender {
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)chooseFromAlbum:(id)sender {
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
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
        PFQuery *query = [PFQuery queryWithClassName:@"OriginalPhoto"];
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //取得影像
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    NSData *imageData = [self scaleImage:image ToSize:10485760];
    NSData *smallImageData = UIImageJPEGRepresentation(image, 0.01);
    
    PFFile *imageFile = [PFFile fileWithName:@"Name.jpg" data:imageData];
    
    PFFile *smallImageFile = [PFFile fileWithName:@"Name.jpg" data:smallImageData];

    
    PFObject *object = [[PFObject alloc]initWithClassName:@"OriginalPhoto"];
    [object setObject:imageFile forKey:@"Photo"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"object.id = %@", object.objectId);
            PFObject *tempObject = [[PFObject alloc]initWithClassName:@"Photo"];
            [tempObject setObject:smallImageFile forKey:@"miniPhoto"];
            [tempObject setObject:[userDefaults objectForKey:@"NickName"] forKey:@"Shooter"];
            [tempObject setObject:object.objectId forKey:@"OriginalPhotoObjectID"];
            [tempObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                NSLog(@"error = %@", error);
                if (succeeded) {
                    [self loadPhotoData];
                }
                else{
                    NSLog(@"error = %@", error);
                }
            }];
        }
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
