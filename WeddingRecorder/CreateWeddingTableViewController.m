//
//  CreateWeddingTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/21.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "CreateWeddingTableViewController.h"

@interface CreateWeddingTableViewController ()

@property (strong, nonatomic) UIDatePicker *engageDatePicker;
@property (strong, nonatomic) UIDatePicker *marryDatePicker;
@property (nonatomic, strong) UIAlertController *processing;
@property (strong, nonatomic) NSString *weddingInfoObjectId;
@end

@implementation CreateWeddingTableViewController

@synthesize weddingName, weddingPassword, groomName, brideName, engageDate, engageRestaurantName, engageRestaurantAddress, engageRestaurantUrl, marryDate, marryRestaurantName, marryRestaurantAddress, marryRestaurantUrl, engageDatePicker, marryDatePicker, processing, weddingInfoObjectId;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    engageDatePicker = [[UIDatePicker alloc]init];
    engageDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    engageDatePicker.minuteInterval = 30;
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [toolBar sizeToFit];
    UIBarButtonItem *nilButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePicker:)];
    [toolBar setItems:@[nilButton, right]];
    [engageDate setInputView:engageDatePicker];
    [engageDate setInputAccessoryView:toolBar];
    
    marryDatePicker = [[UIDatePicker alloc]init];
    marryDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    marryDatePicker.minuteInterval = 30;
    UIToolbar *marryDatePickerToolBar = [[UIToolbar alloc]init];
    [marryDatePickerToolBar sizeToFit];
    UIBarButtonItem *marryDatePickerToolBarRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(marryDatePickerToolBarDonePicker:)];
    [marryDatePickerToolBar setItems:@[nilButton, marryDatePickerToolBarRight]];
    [marryDate setInputView:marryDatePicker];
    [marryDate setInputAccessoryView:marryDatePickerToolBar];
}


-(void) donePicker:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY / MM / dd  HH:mm"];
    [engageDate setText:[formatter stringFromDate:engageDatePicker.date]];
    [engageDate endEditing:YES];
}

-(void) marryDatePickerToolBarDonePicker:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY / MM / dd  HH:mm"];
    [marryDate setText:[formatter stringFromDate:marryDatePicker.date]];
    [marryDate endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueMainTab"]) {
        MainTabBarController *tabBarController = segue.destinationViewController;
        tabBarController.weddingObjectId = weddingInfoObjectId;
        tabBarController.manager = YES;
    }
}

- (IBAction)holdWedding:(id)sender {
    NSString *alertString = @"";
    if ([weddingName.text isEqualToString:@""]) {
        alertString = @"請輸入婚宴名稱。";
    }
    else if ([weddingPassword.text isEqualToString:@""]) {
        alertString = @"請輸入婚宴密碼。";
    }
    else if ([groomName.text isEqualToString:@""]) {
        alertString = @"請輸入新郎姓名。";
    }
    else if ([brideName.text isEqualToString:@""]) {
        alertString = @"請輸入新娘姓名。";
    }
    else if ([engageDate.text isEqualToString:@""]) {
        alertString = @"請輸入訂婚日期。";
    }
    else if ([engageRestaurantName.text isEqualToString:@""]) {
        alertString = @"請輸入訂婚餐廳名稱。";
    }
    else if ([engageRestaurantAddress.text isEqualToString:@""]) {
        alertString = @"請輸入訂婚餐廳地址。";
    }
    else if ([marryDate.text isEqualToString:@""]) {
        alertString = @"請輸入結婚日期。";
    }
    else if ([marryRestaurantName.text isEqualToString:@""]) {
        alertString = @"請輸入結婚餐廳名稱。";
    }
    else if ([marryRestaurantAddress.text isEqualToString:@""]) {
        alertString = @"請輸入結婚餐廳地址。";
    }
    if (![alertString isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        PFObject *object = [[PFObject alloc]initWithClassName:@"Information"];
        [object setObject:weddingName.text forKey:@"weddingAccount"];
        [object setObject:weddingPassword.text forKey:@"weddingPassword"];
        [object setObject:groomName.text forKey:@"groomName"];
        [object setObject:brideName.text forKey:@"brideName"];
        [object setObject:engageDate.text forKey:@"engageDate"];
        [object setObject:engageRestaurantName.text forKey:@"engagePlace"];
        [object setObject:engageRestaurantAddress.text forKey:@"engageAddress"];
        [object setObject:engageRestaurantUrl.text forKey:@"engagePlaceIntroduce"];
        [object setObject:marryDate.text forKey:@"marryDate"];
        [object setObject:marryRestaurantName.text forKey:@"marryPlace"];
        [object setObject:marryRestaurantAddress.text forKey:@"marryAddress"];
        [object setObject:marryRestaurantUrl.text forKey:@"marryPlaceIntroduce"];
        PFUser *user = [PFUser currentUser];
        [object setObject:user.username forKey:@"managerAccount"];
        
        PFQuery *checkWeddingExist = [PFQuery queryWithClassName:@"Information"];
        [checkWeddingExist whereKey:@"weddingAccount" equalTo:weddingName.text];
        [checkWeddingExist whereKey:@"weddingPassword" equalTo:weddingPassword.text];
        [checkWeddingExist countObjectsInBackgroundWithBlock:^(int number, NSError * error) {
            if (!error) {
                if (number == 0) {
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            weddingInfoObjectId = object.objectId;
                            dispatch_async(dispatch_get_main_queue(),^{
                                [self performSegueWithIdentifier:@"segueMainTab" sender:self];
                            });
                        }
                    }];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(),^{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"婚宴名稱與通關密語已被他人使用，請用其他婚宴名稱或通關密碼。" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                        [alert addAction:okAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    });
                }
            }
            
        }];
    }
    
}

- (IBAction)cancelCreate:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
