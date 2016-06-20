//
//  SlideShowViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/18.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
@interface SlideShowViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) NSString *weddingInfoObjectId;

- (IBAction)endOfSlideShow:(id)sender;


@end
