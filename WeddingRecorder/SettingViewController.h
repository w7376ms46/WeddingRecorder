//
//  SettingViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/14.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWeddingTableViewController.h"
#import "WeddingListTableViewController.h"
#import "AttendWeddingTableViewController.h"
#import "MainTabBarController.h"
#import "GuestListTableViewController.h"
#import "ModifyWeddingTableViewController.h"
@import GoogleMobileAds;

@interface SettingViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
- (IBAction)leaveWedding:(id)sender;
@property (weak, nonatomic) IBOutlet GADBannerView *advertisementBanner;

@end
