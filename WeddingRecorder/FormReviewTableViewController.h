//
//  FormReviewTableViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/5.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface FormReviewTableViewController : UITableViewController

@property (nonatomic, strong)PFObject *data;
@property (weak, nonatomic) IBOutlet UILabel *identity;
@property (weak, nonatomic) IBOutlet UILabel *attendWilling;
@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;
@property (weak, nonatomic) IBOutlet UILabel *diet;

@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextView *address;

- (IBAction)makePhone:(id)sender;

@property (weak, nonatomic) IBOutlet UITableViewCell *identityCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *phoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *attendWillingCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *peopleNumberCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dietCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *addressCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *commentCell;

@end
