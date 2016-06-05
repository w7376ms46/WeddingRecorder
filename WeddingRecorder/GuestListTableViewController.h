//
//  GuestListTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/29.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GuestListTableViewCell.h"
#import "FormReviewTableViewController.h"
@interface GuestListTableViewController : UITableViewController

@property (strong, nonatomic) NSString *weddingObjectId;
- (IBAction)doneButton:(id)sender;

@end
