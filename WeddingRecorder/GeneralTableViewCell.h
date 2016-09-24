//
//  GeneralTableViewCell.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/9/11.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GeneralTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *weddingName;
@property (weak, nonatomic) IBOutlet UITextField *weddingPassword;
@property (weak, nonatomic) IBOutlet UISwitch *rememberInfoSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchMode;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UISegmentedControl *createOrLoginSelector;

@end
