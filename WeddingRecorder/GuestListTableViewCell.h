//
//  GuestListTableViewCell.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/30.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *totalForm;
@property (weak, nonatomic) IBOutlet UILabel *attendMarryNumber;
@property (weak, nonatomic) IBOutlet UILabel *attendMarryFriendNumber;
@property (weak, nonatomic) IBOutlet UILabel *totalMarryNumber;
@property (weak, nonatomic) IBOutlet UILabel *attendMarryMeat;
@property (weak, nonatomic) IBOutlet UILabel *attendMarryVagetable;
@property (weak, nonatomic) IBOutlet UILabel *attendEngageNumber;
@property (weak, nonatomic) IBOutlet UILabel *attendEngageFriendNumber;
@property (weak, nonatomic) IBOutlet UILabel *totalEngageNumber;
@property (weak, nonatomic) IBOutlet UILabel *attendEngageMeat;
@property (weak, nonatomic) IBOutlet UILabel *attendEngageVagetable;
@property (weak, nonatomic) IBOutlet UILabel *notAttendNumber;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;
@property (weak, nonatomic) IBOutlet UILabel *attendSession;
@property (weak, nonatomic) IBOutlet UILabel *diet;

@end
