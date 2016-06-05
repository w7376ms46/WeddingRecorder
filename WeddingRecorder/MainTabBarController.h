//
//  MainTabBarController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/28.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController

@property (strong, nonatomic) NSString* weddingName;
@property (strong, nonatomic) NSString *weddingObjectId;
@property (nonatomic) BOOL manager;
@end
