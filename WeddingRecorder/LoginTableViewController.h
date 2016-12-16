//
//  LoginTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/22.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeddingListTableViewController.h"

@import Firebase;
@import FirebaseDatabase;
@interface LoginTableViewController : UITableViewController<UITextFieldDelegate>
- (IBAction)selectAccountStatus:(id)sender;
- (IBAction)createOrLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *createOrLoginSelector;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *createOrLoginButton;

@end
