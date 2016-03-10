//
//  FullScreenPhotoViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/6.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryViewController.h"
@interface FullScreenPhotoViewController : UIViewController<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property NSInteger pageIndex;
@end
