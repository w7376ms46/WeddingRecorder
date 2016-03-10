//
//  PhotoViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/1.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (nonatomic, strong) NSMutableArray *photoData;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) NSUserDefaults *userDefaults;
@property (strong, nonatomic) NSMutableDictionary *photoDictionary;
@property (strong, nonatomic) NSArray *photoDictionaryKey;
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
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullToRefresh)
             forControlEvents:UIControlEventValueChanged];
    [photoCollectionView addSubview:refreshControl];
    [photoCollectionView setAlwaysBounceVertical:YES];
    
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
    [refreshControl endRefreshing];
}

- (void) loadPhotoData{
    if (!usePullRefresh) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self presentViewController:processing animated:YES completion:nil];
        });
    }
    
    photoDictionary = [[NSMutableDictionary alloc]init];
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query orderByAscending:@"Shooter"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
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
            photoDictionaryKey = [photoDictionary allKeys];
            [photoCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        if (!usePullRefresh) {
            dispatch_async(dispatch_get_main_queue(),^{
                [processing dismissViewControllerAnimated:YES completion:nil];
            });
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
    //NSString *searchTerm = self.searches[indexPath.section];
    //FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
    
    //CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    //retval.height += 35;
    //retval.width += 35;
    return CGSizeMake(120, 120);
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
    
    PFFile *thumbnail = object[@"Photo"];
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
        [collectionView deselectItemAtIndexPath:indexPath animated:nil];
        [self performSegueWithIdentifier:@"segueFullScreenPhoto" sender:indexPath];
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
    for (NSIndexPath *indexPath in selectedIndexpath) {
        NSMutableArray *tempArray = [photoDictionary objectForKey:photoDictionaryKey[indexPath.section]];
        
        PFObject *object = [tempArray objectAtIndex:indexPath.row];
        
        PFFile *thumbnail = object[@"Photo"];
        [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                [selectedIndexpath removeObject:indexPath];
                [photoCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }];
    }
    [processing dismissViewControllerAnimated:YES completion:nil];
    /*
    if (selection) {
        for (NSIndexPath *i in selectedIndexpaths) {
            NSLog(@"selectedItem path = %d", i.row);
            [self presentViewController:processing animated:YES completion:nil];
            NSMutableArray *tempArray = [photoDictionary objectForKey:photoDictionaryKey[i.section]];
            
            PFObject *object = [tempArray objectAtIndex:i.row];
            
            PFFile *thumbnail = object[@"Photo"];
            [thumbnail getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                    [photoCollectionView deselectItemAtIndexPath:i animated:YES];
                }
            }];
            [processing dismissViewControllerAnimated:YES completion:nil];
        }
    }
    */
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //取得影像
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

    NSData *imageData = [self scaleImage:image ToSize:10485760];
    
    PFFile *imageFile = [PFFile fileWithName:@"Name.jpg" data:imageData];
    
    PFObject *object = [[PFObject alloc]initWithClassName:@"Photo"];
    [object setObject:imageFile forKey:@"Photo"];
    [object setObject:[userDefaults objectForKey:@"NickName"] forKey:@"Shooter"];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self loadPhotoData];
        }];
    } progressBlock:^(int percentDone) {
        NSLog(@"upload percenttage = %d", percentDone);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
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
