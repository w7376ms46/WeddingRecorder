//
//  AttendWeddingTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/21.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "MainTabBarController.h"
@interface AttendWeddingTableViewController : UITableViewController
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *weddingAccount;
@property (weak, nonatomic) IBOutlet UITextField *weddingPassword;

@end
