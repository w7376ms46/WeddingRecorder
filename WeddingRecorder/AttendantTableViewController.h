//
//  AttendantTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/2/28.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AttendantTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *attendWilling;
@property (weak, nonatomic) IBOutlet UITextField *addressRegion;
@property (weak, nonatomic) IBOutlet UITextField *addressDetail;
@property (weak, nonatomic) IBOutlet UISegmentedControl *relation;
@property (weak, nonatomic) IBOutlet UIStepper *peopleCount;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;
@property (weak, nonatomic) IBOutlet UIStepper *vagetableCount;
@property (weak, nonatomic) IBOutlet UIStepper *meatCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *session;
@property (weak, nonatomic) IBOutlet UILabel *vagetableNumber;
@property (weak, nonatomic) IBOutlet UILabel *meatNumber;
- (IBAction)peopleNumberStepper:(id)sender;
- (IBAction)vagetableNumberStepper:(id)sender;
- (IBAction)meatNumberStepper:(id)sender;
- (IBAction)saveData:(id)sender;
- (IBAction)clearData:(id)sender;

@end
