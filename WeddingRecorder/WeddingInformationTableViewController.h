//
//  WeddingInformationViewController.h
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/10.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeddingInformationTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *engageTime;
@property (weak, nonatomic) IBOutlet UIButton *engageAddress;
@property (weak, nonatomic) IBOutlet UIButton *marryTime;
@property (weak, nonatomic) IBOutlet UIButton *marryPlace;
@property (weak, nonatomic) IBOutlet UIButton *marryAddress;
@property (weak, nonatomic) IBOutlet UIButton *engagePlace;
- (IBAction)addEngageTimeToSchedule:(id)sender;
- (IBAction)addMarryTimeToSchedule:(id)sender;
- (IBAction)marryRestaurantIntroduce:(id)sender;
- (IBAction)engageRestaurantIntroduce:(id)sender;

- (IBAction)marryRestaurantMap:(id)sender;
- (IBAction)engageRestaurantMap:(id)sender;

@end
