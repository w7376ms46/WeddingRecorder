//
//  ModifyWeddingTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/12.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "ModifyWeddingTableViewController.h"

@interface ModifyWeddingTableViewController ()

@property (strong, nonatomic) UIDatePicker *engageDatePicker;
@property (strong, nonatomic) UIDatePicker *marryDatePicker;
@property (nonatomic, strong) UIAlertController *processing;
@property (strong, nonatomic) UIDatePicker *modifyFormDeadlinePicker;

@end

@implementation ModifyWeddingTableViewController

@synthesize weddingObjectId, weddingName, weddingPassword, groomName, brideName, engageDate, engageRestaurantName, engageRestaurantAddress, engageRestaurantUrl, marryDate, marryRestaurantName, marryRestaurantAddress, marryRestaurantUrl, engageDatePicker, marryDatePicker, processing, modifyFormDeadlinePicker, modifyFormDeadLine;

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [modifyFormDeadLine setInputView:modifyFormDeadlinePicker];
    [modifyFormDeadLine setInputAccessoryView:modifyFormDeadlinePickerToolBar];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Information"];
    [query getObjectInBackgroundWithId:weddingObjectId block:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            weddingName.text = @"";
            weddingPassword.text = @"";
            groomName.text = @"";
            brideName.text = @"";
            engageDate.text = @"";
            engageRestaurantName.text = @"";
            engageRestaurantAddress.text = @"";
            engageRestaurantUrl.text = @"";
            marryDate.text = @"";
            marryRestaurantName.text = @"";
            marryRestaurantAddress.text = @"";
            marryRestaurantUrl.text = @"";
            modifyFormDeadLine.text = @"";
        }
        else {
            NSLog(@"The getObjectInBackgroundWithId succeed.");
            weddingName.text = object[@"weddingAccount"];
            weddingPassword.text = object[@"weddingPassword"];
            groomName.text = object[@"groomName"];
            brideName.text = object[@"brideName"];
            engageDate.text = object[@"engageDate"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY / MM / dd  HH:mm"];
            [engageDatePicker setDate:[dateFormatter dateFromString:object[@"engageDate"]]];
            
            engageRestaurantName.text = object[@"engagePlace"];
            engageRestaurantAddress.text = object[@"engageAddress"];
            engageRestaurantUrl.text = object[@"engagePlaceIntroduce"];
            
            marryDate.text = object[@"marryDate"];
            [marryDatePicker setDate:[dateFormatter dateFromString:object[@"marryDate"]]];
            
            marryRestaurantName.text = object[@"marryPlace"];
            marryRestaurantAddress.text = object[@"marryAddress"];
            marryRestaurantUrl.text = object[@"marryPlaceIntroduce"];
            
            modifyFormDeadLine.text = object[@"modifyFormDeadline"];
            [modifyFormDeadlinePicker setDate:[dateFormatter dateFromString:object[@"modifyFormDeadline"]]];
        }
    }];
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

-(void) modifyFormDeadlinePickerToolBarDonePicker:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY / MM / dd  HH:mm"];
    [modifyFormDeadLine setText:[formatter stringFromDate:modifyFormDeadlinePicker.date]];
    [modifyFormDeadLine endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else{
        return 11;
    }
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Information"];
    [self presentViewController:processing animated:YES completion:nil];
    [query getObjectInBackgroundWithId:weddingObjectId block:^(PFObject *object, NSError *error) {
        if (!object) {
            UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"更新失敗，請檢查網路狀態。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            [message addAction:okButton];
            dispatch_async(dispatch_get_main_queue(),^{
                [processing dismissViewControllerAnimated:YES completion:^{
                    [self presentViewController:message animated:YES completion:nil];
                }];
            });
        }
        else{
            NSLog(@"The getObjectInBackgroundWithId succeed.");
            object[@"weddingAccount"] = weddingName.text;
            object[@"weddingPassword"] = weddingPassword.text;
            object[@"groomName"] = groomName.text;
            object[@"brideName"] = brideName.text;
            object[@"engageDate"] = engageDate.text;
            
            
            object[@"engagePlace"] = engageRestaurantName.text;
            object[@"engageAddress"] = engageRestaurantAddress.text;
            object[@"engagePlaceIntroduce"] = engageRestaurantUrl.text;
            
            object[@"marryDate"] = marryDate.text;
            
            object[@"marryPlace"] = marryRestaurantName.text;
            object[@"marryAddress"] = marryRestaurantAddress.text;
            object[@"marryPlaceIntroduce"] = marryRestaurantUrl.text;
            
            object[@"modifyFormDeadline"] = modifyFormDeadLine.text;
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"修改完成！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [message addAction:okButton];
                NSLog(@"dismissviewcontrollerrrrr");
                dispatch_async(dispatch_get_main_queue(),^{
                    [processing dismissViewControllerAnimated:YES completion:^{
                        [self presentViewController:message animated:YES completion:nil];
                    }];
                });
                
            }];
        }
    }];
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
    else if (textField == engageRestaurantUrl){
        [textField resignFirstResponder];
        [marryDate becomeFirstResponder];
    }else if (textField == marryRestaurantName){
        [textField resignFirstResponder];
        [marryRestaurantAddress becomeFirstResponder];
    }
    else if (textField == marryRestaurantAddress){
        [textField resignFirstResponder];
        [marryRestaurantUrl becomeFirstResponder];
    }
    else if (textField == marryRestaurantUrl){
        [textField resignFirstResponder];
        [modifyFormDeadLine becomeFirstResponder];
    }
    return NO;
}
@end
