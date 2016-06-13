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
- (IBAction)cancel:(id)sender;
- (IBAction)save:(id)sender;

@end
