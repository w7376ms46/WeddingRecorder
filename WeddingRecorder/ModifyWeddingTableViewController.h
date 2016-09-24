//
//  ModifyWeddingTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/12.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ModifyWeddingTableViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *weddingName;
@property (weak, nonatomic) IBOutlet UITextField *weddingPassword;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *groomName;
@property (weak, nonatomic) IBOutlet UITextField *brideName;
@property (weak, nonatomic) IBOutlet UITextField *engageDate;
@property (weak, nonatomic) IBOutlet UITextField *engageRestaurantName;
@property (weak, nonatomic) IBOutlet UITextField *engageRestaurantAddress;
@property (weak, nonatomic) IBOutlet UITextField *engageRestaurantUrl;
@property (weak, nonatomic) IBOutlet UITextField *marryDate;
@property (weak, nonatomic) IBOutlet UITextField *marryRestaurantName;
@property (weak, nonatomic) IBOutlet UITextField *marryRestaurantAddress;
@property (weak, nonatomic) IBOutlet UITextField *marryRestaurantUrl;
@property (strong, nonatomic) NSString *weddingObjectId;
@property (weak, nonatomic) IBOutlet UITextField *modifyFormDeadLine;
@property (weak, nonatomic) IBOutlet UITableViewCell *marryDateCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *marryRestaurantNameCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *marryRestaurantAddressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *marryRestaurantUrlCell;
@property (weak, nonatomic) IBOutlet UILabel *engageDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *engageRestaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *engageRestaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *engageRestaurantUrlLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *weddingForm;
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)selectWeddingForm:(id)sender;

@end
