//
//  GalleryViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/6.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FullScreenPhotoViewController.h"
#import <Parse/Parse.h>

@interface GalleryViewController : UIViewController<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *stringList;
- (IBAction)dismissGallery:(id)sender;
@property (nonatomic)NSInteger currentIndex;
@property (strong, nonatomic) UIPageViewController *pageViewController;
- (IBAction)finish:(id)sender;

@property (nonatomic, strong) NSString *titleShooter;
@end
