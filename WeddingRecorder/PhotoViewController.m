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
@property (nonatomic) BOOL selection;

@end

@implementation PhotoViewController

@synthesize photoCollectionView, photoData, imagePicker, userDefaults, selectButton, selection;

- (void)viewDidLoad {
    [super viewDidLoad];
    selection = NO;
    userDefaults = [NSUserDefaults standardUserDefaults];
    [photoCollectionView setDelegate:self];
    [photoCollectionView setDataSource:self];
    photoData = [[NSMutableArray alloc]init];
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    
    [self performSelectorInBackground:@selector(loadPhotoData) withObject:nil];
}

- (void) loadPhotoData{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
            photoData = [objects mutableCopy];
            [photoCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [photoData count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSString *searchTerm = self.searches[indexPath.section];
    //FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
    
    //CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
    //retval.height += 35;
    //retval.width += 35;
    return CGSizeMake(100, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 30, 0, 30);
}

- (PhotoCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"Cell";
    PhotoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        //cell = [[PhotoCollectionViewCell alloc] initWithStyle:UICollectionViewScroll reuseIdentifier:CellIdentifier];
        cell = [[PhotoCollectionViewCell alloc]initWithFrame:CGRectMake(0, 0, 500, 500)];
    }
    //PFCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *object = [photoData objectAtIndex:[indexPath row]];
    cell.shooter = object[@"Shooter"];
    
    PFFile *thumbnail = object[@"Photo"];
    //cell.photo = [[PFImageView alloc]init];
    cell.photo.file = thumbnail;
    [cell.photo loadInBackground];
    cell.tookDate.text = @"test";//object.createdAt;
    //cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PhotoFrame"]];
    //cell.backgroundView.contentMode = UIViewContentModeScaleToFill;
    if (selection) {
        cell.selected = NO;
    }
    cell.selectedBackgroundView = [[UIView alloc]init];
    [cell.selectedBackgroundView setBackgroundColor:[UIColor redColor]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
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
        [photoCollectionView setAllowsMultipleSelection:YES];
    }
    else{
        [selectButton setTitle:@"選取"];
        [photoCollectionView setAllowsMultipleSelection:NO];
        [photoCollectionView reloadData];
    }
    selection = !selection;
}

- (IBAction)downloadPhoto:(id)sender {
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
