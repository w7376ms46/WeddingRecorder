//
//  WeddingListTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/26.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "WeddingListTableViewCell.h"
#import "WeddingInformationTableViewController.h"
#import "MainTabBarController.h"
@interface WeddingListTableViewController : UITableViewController
- (IBAction)logout:(id)sender;
- (IBAction)createWedding:(id)sender;
- (IBAction)editTable:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editingTableButton;

@end
