//
//  FullScreenPhotoViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/6.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "FullScreenPhotoViewController.h"

@interface FullScreenPhotoViewController ()

@end

@implementation FullScreenPhotoViewController

@synthesize photo, scrollview;

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollview.delegate = self;
    scrollview.minimumZoomScale = 1.0;
    scrollview.maximumZoomScale = 6.0;
    //[photo setFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
    //photo.image = [UIImage imageNamed:self.imageFile];
}

- (void) viewDidDisappear:(BOOL)animated{
    NSLog(@"viewdiddisappear");
    scrollview.zoomScale = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return photo;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
