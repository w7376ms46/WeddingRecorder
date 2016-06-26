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
@property (strong, nonatomic) UIDatePicker *modifyFormDeadlinePicker;
@property (nonatomic, strong) UIAlertController *processing;
@property (strong, nonatomic) NSString *weddingInfoObjectId;

@end

@implementation CreateWeddingTableViewController

@synthesize weddingName, weddingPassword, groomName, brideName, engageDate, engageRestaurantName, engageRestaurantAddress, engageRestaurantUrl, marryDate, marryRestaurantName, marryRestaurantAddress, marryRestaurantUrl, engageDatePicker, marryDatePicker, modifyFormDeadline, modifyFormDeadlinePicker, processing, weddingInfoObjectId, weddingForm, marryDateCell, marryRestaurantNameCell, marryRestaurantAddressCell, marryRestaurantUrlCell, engageDateLabel, engageRestaurantUrlLabel, engageRestaurantNameLabel, engageRestaurantAddressLabel;

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
    
    
    modifyFormDeadlinePicker = [[UIDatePicker alloc]init];
    modifyFormDeadlinePicker.datePickerMode = UIDatePickerModeDateAndTime;
    modifyFormDeadlinePicker.minuteInterval = 30;
    UIToolbar *modifyFormDeadlinePickerToolBar = [[UIToolbar alloc]init];
    [modifyFormDeadlinePickerToolBar sizeToFit];
    UIBarButtonItem *modifyFormDeadlinePickerToolBarRight = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(modifyFormDeadlinePickerToolBarDonePicker:)];
    [modifyFormDeadlinePickerToolBar setItems:@[nilButton, modifyFormDeadlinePickerToolBarRight]];
    [modifyFormDeadline setInputView:modifyFormDeadlinePicker];
    [modifyFormDeadline setInputAccessoryView:modifyFormDeadlinePickerToolBar];
    
    weddingName.delegate = self;
    weddingPassword.delegate = self;
    groomName.delegate = self;
    brideName.delegate = self;
    engageRestaurantName.delegate = self;
    engageRestaurantUrl.delegate = self;
    engageRestaurantAddress.delegate = self;
    marryRestaurantUrl.delegate = self;
    marryRestaurantName.delegate = self;
    marryRestaurantAddress.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == weddingName) {
        [textField resignFirstResponder];
        [weddingPassword becomeFirstResponder];
    }
    else if (textField == weddingPassword){
        [textField resignFirstResponder];
        [groomName becomeFirstResponder];
    }
    
    else if (textField == groomName){
        [textField resignFirstResponder];
        [brideName becomeFirstResponder];
    }
    else if (textField == brideName){
        [textField resignFirstResponder];
        [engageDate becomeFirstResponder];
    }
    else if (textField == engageRestaurantName){
        [textField resignFirstResponder];
        [engageRestaurantAddress becomeFirstResponder];
    }
    
    else if (textField == engageRestaurantAddress){
        [textField resignFirstResponder];
        [engageRestaurantUrl becomeFirstResponder];
    }
    if (weddingForm.selectedSegmentIndex == 0) {
        if (textField == engageRestaurantUrl){
            [textField resignFirstResponder];
            [modifyFormDeadline becomeFirstResponder];
        }
    }
    else{
        if (textField == engageRestaurantUrl){
            [textField resignFirstResponder];
            [marryDate becomeFirstResponder];
        }
        else if (textField == marryRestaurantName){
            [textField resignFirstResponder];
            [marryRestaurantAddress becomeFirstResponder];
        }
        else if (textField == marryRestaurantAddress){
            [textField resignFirstResponder];
            [marryRestaurantUrl becomeFirstResponder];
        }
        else if (textField == marryRestaurantUrl){
            [textField resignFirstResponder];
            [modifyFormDeadline becomeFirstResponder];
        }
    }
    
    return NO;
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

-(void) modifyFormDeadlinePickerToolBarDonePicker:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY / MM / dd  HH:mm"];
    [modifyFormDeadline setText:[formatter stringFromDate:modifyFormDeadlinePicker.date]];
    [modifyFormDeadline endEditing:YES];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    else{
        return 11;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (weddingForm.selectedSegmentIndex == 0) {
        if (indexPath.section == 2) {
            if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9) {
                NSLog(@"hiddenCell row == 0");
                return 0;
            }
        }
    }
    return 44;
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
        alertString = @"請輸入通關密語。";
    }
    else if ([groomName.text isEqualToString:@""]) {
        alertString = @"請輸入新郎姓名。";
    }
    else if ([brideName.text isEqualToString:@""]) {
        alertString = @"請輸入新娘姓名。";
    }
    else if ([engageDate.text isEqualToString:@""]) {
        if (weddingForm.selectedSegmentIndex == 1) {
            alertString = @"請輸入訂婚日期。";
        }
        else if (weddingForm.selectedSegmentIndex == 0) {
            alertString = @"請輸入婚宴日期。";
        }
    }
    else if ([engageRestaurantName.text isEqualToString:@""]) {
        if (weddingForm.selectedSegmentIndex == 1) {
            alertString = @"請輸入訂婚餐廳名稱。";
        }
        else if (weddingForm.selectedSegmentIndex == 0) {
            alertString = @"請輸入婚宴餐廳名稱。";
        }
    }
    else if ([engageRestaurantAddress.text isEqualToString:@""]) {
        if (weddingForm.selectedSegmentIndex == 1) {
            alertString = @"請輸入訂婚餐廳地址。";
        }
        else if (weddingForm.selectedSegmentIndex == 0) {
            alertString = @"請輸入婚宴餐廳地址。";
        }
    }
    else{
        if (weddingForm.selectedSegmentIndex == 1) {
            if ([marryDate.text isEqualToString:@""]) {
                alertString = @"請輸入結婚日期。";
            }
            else if ([marryRestaurantName.text isEqualToString:@""]) {
                alertString = @"請輸入結婚餐廳名稱。";
            }
            else if ([marryRestaurantAddress.text isEqualToString:@""]) {
                alertString = @"請輸入結婚餐廳地址。";
            }
            else if ([modifyFormDeadline.text isEqualToString:@""]) {
                alertString = @"請輸入填寫出席意願期限。";
            }
        }
        else{
            if ([modifyFormDeadline.text isEqualToString:@""]) {
                alertString = @"請輸入填寫出席意願期限。";
            }
        }
    }
    
    if (![alertString isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [self presentViewController:processing animated:YES completion:nil];
        PFObject *object = [[PFObject alloc]initWithClassName:@"Information"];
        [object setObject:weddingName.text forKey:@"weddingAccount"];
        [object setObject:weddingPassword.text forKey:@"weddingPassword"];
        [object setObject:groomName.text forKey:@"groomName"];
        [object setObject:brideName.text forKey:@"brideName"];
        [object setObject:engageDate.text forKey:@"engageDate"];
        [object setObject:engageRestaurantName.text forKey:@"engagePlace"];
        [object setObject:engageRestaurantAddress.text forKey:@"engageAddress"];
        [object setObject:engageRestaurantUrl.text forKey:@"engagePlaceIntroduce"];
        if (weddingForm.selectedSegmentIndex == 1) {
            [object setObject:marryDate.text forKey:@"marryDate"];
            [object setObject:marryRestaurantName.text forKey:@"marryPlace"];
            [object setObject:marryRestaurantAddress.text forKey:@"marryAddress"];
            [object setObject:marryRestaurantUrl.text forKey:@"marryPlaceIntroduce"];
        }
        [object setObject:(weddingForm.selectedSegmentIndex == 0 ? @YES:@NO) forKey:@"onlyOneSession"];
        [object setObject:modifyFormDeadline.text forKey:@"modifyFormDeadline"];
        
        PFUser *user = [PFUser currentUser];
        [object setObject:user.username forKey:@"managerAccount"];
        
        PFQuery *checkWeddingExist = [PFQuery queryWithClassName:@"Information"];
        [checkWeddingExist whereKey:@"weddingAccount" equalTo:weddingName.text];
        [checkWeddingExist whereKey:@"weddingPassword" equalTo:weddingPassword.text];
        [checkWeddingExist countObjectsInBackgroundWithBlock:^(int number, NSError * error) {
            if (!error) {
                NSLog(@"eeeeee = %@", error);
                if (number == 0) {
                    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            weddingInfoObjectId = object.objectId;
                            dispatch_async(dispatch_get_main_queue(),^{
                                [processing dismissViewControllerAnimated:YES completion:^{
                                    [self performSegueWithIdentifier:@"segueMainTab" sender:self];
                                }];
                                
                            });
                        }
                    }];
                }
                else {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processing dismissViewControllerAnimated:YES completion:^{
                            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"婚宴名稱與通關密語已被他人使用，請用其他婚宴名稱或通關密碼。" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                            [alert addAction:okAction];
                            [self presentViewController:alert animated:YES completion:nil];
                        }];
                    });
                }
            }
            NSLog(@"error = %@", error);
        }];
    }
    
}

- (IBAction)cancelCreate:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)selectWeddingForm:(id)sender {
    if (weddingForm.selectedSegmentIndex == 0) {
        [marryDateCell setHidden:YES];
        [marryRestaurantNameCell setHidden:YES];
        [marryRestaurantAddressCell setHidden:YES];
        [marryRestaurantUrlCell setHidden: YES];
        [engageDateLabel setText:@"婚宴日期"];
        [engageRestaurantNameLabel setText:@"婚宴餐廳名稱"];
        [engageRestaurantAddressLabel setText:@"婚宴餐廳地址"];
        [engageRestaurantUrlLabel setText:@"婚宴餐廳網址"];
        [self.tableView reloadData];
    }
    else{
        [marryDateCell setHidden:NO];
        [marryRestaurantNameCell setHidden:NO];
        [marryRestaurantAddressCell setHidden:NO];
        [marryRestaurantUrlCell setHidden: NO];
        [engageDateLabel setText:@"訂婚日期"];
        [engageRestaurantNameLabel setText:@"訂婚餐廳名稱"];
        [engageRestaurantAddressLabel setText:@"訂婚餐廳地址"];
        [engageRestaurantUrlLabel setText:@"訂婚餐廳網址"];
        [self.tableView reloadData];
    }
    
    
}
@end
