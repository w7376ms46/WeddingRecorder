//
//  PhotoViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/1.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "PhotoCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "GalleryViewController.h"
#import "MainTabBarController.h"
#import "SlideShowViewController.h"


@import Firebase;

@interface PhotoViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *downloadButton;
- (IBAction)playPhoto:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)chooseFromAlbum:(id)sender;
- (IBAction)selectPhoto:(id)sender;
- (IBAction)downloadPhoto:(id)sender;
//- (IBAction)likePhoto:(id)sender;

@end
