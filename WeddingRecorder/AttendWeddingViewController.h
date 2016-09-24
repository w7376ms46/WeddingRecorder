//
//  AttendWeddingViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/21.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "MainTabBarController.h"
#import "GeneralTableViewCell.h"
#import "WeddingListTableViewController.h"
@import GoogleMobileAds;
@interface AttendWeddingViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

- (IBAction)login:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *attendTableView;

@property (weak, nonatomic) IBOutlet GADBannerView *advertisementBanner;

@end
