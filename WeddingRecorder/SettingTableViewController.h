//
//  SettingTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/21.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateWeddingTableViewController.h"
#import "WeddingListTableViewController.h"
#import "AttendWeddingViewController.h"
#import "MainTabBarController.h"
#import "GuestListTableViewController.h"
#import "ModifyWeddingTableViewController.h"
@interface SettingTableViewController : UITableViewController

- (IBAction)logOut:(id)sender;
@property (weak, nonatomic) IBOutlet UITableViewCell *logoutCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *guestCell;

@end
