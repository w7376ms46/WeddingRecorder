//
//  AttendantTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/2/28.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "AttendantTableViewController.h"

@interface AttendantTableViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) UIAlertController *processing;
@property (strong, nonatomic)UIPickerView *pickRegion;
@property (nonatomic, strong) NSString *marryAddress;
@property (nonatomic, strong) NSString *engageAddress;
@property (strong, nonatomic)NSMutableArray *cityAndRegionArray;
@property (strong, nonatomic)NSMutableArray *regionArray;
@property (strong, nonatomic)NSString *marryPlace;
@property (strong, nonatomic)NSString *engagePlace;
@property (strong, nonatomic)NSDate *modifyFormDeadline;
@property (strong, nonatomic)FIRDatabaseReference *databaseRef;
@property (nonatomic) BOOL onlyOneSession;

@end

@implementation AttendantTableViewController

@synthesize name, phone, attendWilling, nickName, addressRegion, addressDetail, relation, peopleNumber, peopleCount, vagetableNumber, vagetableCount, meatNumber, meatCount, session, userDefaults, modifyButton, cleanButton, saveDataButton, processing, notation, pickRegion, cityAndRegionArray, regionArray, engagePlace, marryPlace, sessionPlace, modifyFormDeadline, onlyOneSession, chooseSessionCell, databaseRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    name.delegate = self;
    phone.delegate = self;
    phone.keyboardType = UIKeyboardTypePhonePad;
    
    NSLog(@"attendantTableViewController viewdidload");
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem *nilButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(phonTextFiledAccessoryViewDoneClicked)];
    [keyboardDoneButtonView setItems:@[nilButton, doneButton]];
    phone.inputAccessoryView = keyboardDoneButtonView;
    
    [self loadData];
    pickRegion = [[UIPickerView alloc]init];
    
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    [toolBar sizeToFit];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker:)];
    [toolBar setItems:@[nilButton, right]];
    [pickRegion setDelegate:self];
    [pickRegion setDataSource:self];
    [addressRegion setInputView:pickRegion];
    [addressRegion setInputAccessoryView:toolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnteredForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    nickName.delegate = self;
    addressRegion.delegate = self;
    addressDetail.delegate = self;
    notation.delegate = self;
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    databaseRef = [[FIRDatabase database]reference];
    
    dispatch_async(dispatch_get_main_queue(),^{
        [self presentViewController:processing animated:YES completion:^{
            MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
            NSString *weddingObjectId = tabBarController.weddingObjectId;
            NSString *theInstallationId = [userDefaults objectForKey:@"InstallationId"];
            //[[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
                [[databaseRef child:[NSString stringWithFormat:@"AttendantList/%@/%@",weddingObjectId, theInstallationId]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                    if ([snapshot hasChildren]) {
                        NSDictionary *attendantInfomation = snapshot.value;
                        [name setText:attendantInfomation[@"name"]];
                        [phone setText:attendantInfomation[@"phone"]];
                        [attendWilling setSelectedSegmentIndex:[attendantInfomation[@"attendingWilling"]integerValue]];
                        [nickName setText:attendantInfomation[@"name"]];
                        [addressRegion setText:attendantInfomation[@"addressRegion"]];
                        [addressDetail setText:attendantInfomation[@"addressDetail"]];
                        [relation setSelectedSegmentIndex:[attendantInfomation[@"relation"]integerValue]];
                        [peopleNumber setText:[NSString stringWithFormat:@"%ld",[attendantInfomation[@"peopleNumber"] integerValue]]];
                        [peopleCount setValue:[attendantInfomation[@"peopleNumber"] integerValue]];
                        [vagetableNumber setText:[NSString stringWithFormat:@"%ld",[attendantInfomation[@"vagetableNumber"] integerValue]]];
                        [vagetableCount setValue:[attendantInfomation[@"vagetableNumber"] integerValue]];
                        [meatNumber setText:[NSString stringWithFormat:@"%ld",[attendantInfomation[@"meatNumber"] integerValue]]];
                        [meatCount setValue:[attendantInfomation[@"meatNumber"] integerValue]];
                        [session setSelectedSegmentIndex:[attendantInfomation[@"session"] integerValue]];
                        [notation setText:attendantInfomation[@"notation"]];
                        [saveDataButton setEnabled:NO];
                        [self disableAllObjects];
                    }
                    else{
                        NSLog(@"First fill the form");
                        name.text = @"";
                        phone.text = @"";
                        attendWilling.selectedSegmentIndex = -1;
                        nickName.text = @"";
                        addressRegion.text = @"";
                        addressDetail.text = @"";
                        relation.selectedSegmentIndex = -1;
                        peopleNumber.text = @"0";
                        vagetableNumber.text = @"0";
                        meatNumber.text = @"0";
                        session.selectedSegmentIndex = -1;
                        [peopleCount setValue:0];
                        [vagetableCount setValue:0];
                        [meatCount setValue:0];
                        [notation setText:@""];
                        [userDefaults setObject:@"" forKey:@"NickName"];
                    }
                    [self checkDeadLine];
                }];
            //}];
        }];
    });
    
}

- (void) checkDeadLine{
    MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
    NSString *weddingObjectId = tabBarController.weddingObjectId;
    [[databaseRef child:[NSString stringWithFormat:@"weddingInformation/%@",weddingObjectId]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot hasChildren]) {
            NSDictionary *weddingInformation = snapshot.value;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy / MM / dd HH:mm"];
            modifyFormDeadline = [dateFormatter dateFromString:[weddingInformation objectForKey:@"modifyFormDeadline"]];
            marryPlace = weddingInformation[@"marryPlace"];
            engagePlace = weddingInformation[@"engagePlace"];
            onlyOneSession = [weddingInformation[@"onlyOneSession"] boolValue];
            if (onlyOneSession) {
                dispatch_async(dispatch_get_main_queue(),^{
                    [chooseSessionCell setHidden:YES];
                    NSRange range = NSMakeRange(0, 0);
                    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
                    [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(),^{
                    [chooseSessionCell setHidden:NO];
                });
            }
            if (session.selectedSegmentIndex == 0) {
                sessionPlace.text = engagePlace;
            }
            else if (session.selectedSegmentIndex == 1){
                sessionPlace.text = marryPlace;
            }
            else{
                sessionPlace.text = @"";
            }
            if ([modifyFormDeadline compare:[NSDate date]] == NSOrderedAscending) {
                [cleanButton setEnabled:NO];
                [modifyButton setEnabled:NO];
                [saveDataButton setEnabled:NO];
                [self disableAllObjects];
                UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"目前無法在修改資料囉，請直接與新郎/新娘聯絡！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                }];
                [message addAction:okButton];
                NSLog(@"dismissviewcontrollerrrrr");
                dispatch_async(dispatch_get_main_queue(),^{
                    [processing dismissViewControllerAnimated:YES completion:^{
                        [self presentViewController:message animated:YES completion:nil];
                    }];
                });
                
            }
            else{
                dispatch_async(dispatch_get_main_queue(),^{
                    [processing dismissViewControllerAnimated:YES completion:nil];
                });
            }
            dispatch_async(dispatch_get_main_queue(),^{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
        dispatch_async(dispatch_get_main_queue(),^{
            [processing dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    [self checkDeadLine];
}


- (void)disableAllObjects{
    [name setEnabled:NO];
    [phone setEnabled:NO];
    [attendWilling setEnabled:NO];
    [attendWilling setTintColor:[UIColor lightGrayColor]];
    [nickName setEnabled:NO];
    [addressRegion setEnabled:NO];
    [addressDetail setEnabled:NO];
    [relation setEnabled:NO];
    [relation setTintColor:[UIColor lightGrayColor]];
    [peopleCount setEnabled:NO];
    [peopleCount setTintColor:[UIColor lightGrayColor]];
    [vagetableCount setEnabled:NO];
    [vagetableCount setTintColor:[UIColor lightGrayColor]];
    [meatCount setEnabled:NO];
    [meatCount setTintColor:[UIColor lightGrayColor]];
    [session setEnabled:NO];
    [session setTintColor:[UIColor lightGrayColor]];
    [notation setEnabled:NO];
}

- (void)enableSpeceficObjects{
    [name setEnabled:YES];
    [phone setEnabled:YES];
    [attendWilling setEnabled:YES];
    [attendWilling setTintColor:nil];
    [nickName setEnabled:YES];
    [addressRegion setEnabled:YES];
    [addressDetail setEnabled:YES];
    [relation setEnabled:YES];
    [relation setTintColor:nil];
    [notation setEnabled:YES];
    if (attendWilling.selectedSegmentIndex != 1) {
        [addressRegion setEnabled:YES];
        [addressDetail setEnabled:YES];
        [peopleCount setEnabled:YES];
        [peopleCount setTintColor:nil];
        [vagetableCount setEnabled:YES];
        [vagetableCount setTintColor:nil];
        [meatCount setEnabled:YES];
        [meatCount setTintColor:nil];
        [session setEnabled:YES];
        [session setTintColor:nil];
    }
    else{
        [addressRegion setEnabled:NO];
        [addressDetail setEnabled:NO];
        [peopleCount setEnabled:NO];
        [peopleCount setTintColor:[UIColor lightGrayColor]];
        [vagetableCount setEnabled:NO];
        [vagetableCount setTintColor:[UIColor lightGrayColor]];
        [meatCount setEnabled:NO];
        [meatCount setTintColor:[UIColor lightGrayColor]];
        [session setEnabled:NO];
        [session setTintColor:[UIColor lightGrayColor]];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == name) {
        [textField resignFirstResponder];
        [phone becomeFirstResponder];
    }
    else if (textField == phone){
        [textField resignFirstResponder];
        [addressRegion becomeFirstResponder];
    }

    else if (textField == addressRegion){
        [textField resignFirstResponder];
        [addressDetail becomeFirstResponder];
    }
    else if (textField == addressDetail){
        [textField resignFirstResponder];
        [notation becomeFirstResponder];
    }
    else if (textField == notation){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)phonTextFiledAccessoryViewDoneClicked{
    [phone resignFirstResponder];
    [addressRegion becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (IBAction)chooseWilling:(id)sender {
    [self.view endEditing:YES];
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    if (segmentedControl.selectedSegmentIndex == 1) {
        [addressRegion setEnabled:NO];
        [addressRegion setText:@""];
        [addressDetail setEnabled:NO];
        [addressDetail setText:@""];
        [peopleCount setEnabled:NO];
        [peopleCount setTintColor:[UIColor lightGrayColor]];
        [peopleCount setValue:0];
        [peopleNumber setText:[NSString stringWithFormat:@"%.0f", peopleCount.value]];
        [vagetableCount setEnabled:NO];
        [vagetableCount setTintColor:[UIColor lightGrayColor]];
        [vagetableCount setValue:0];
        [vagetableNumber setText:[NSString stringWithFormat:@"%.0f", vagetableCount.value]];
        [meatCount setEnabled:NO];
        [meatCount setTintColor:[UIColor lightGrayColor]];
        [meatCount setValue:0];
        [meatNumber setText:[NSString stringWithFormat:@"%.0f", meatCount.value]];
        [session setEnabled:NO];
        [session setTintColor:[UIColor lightGrayColor]];
        [session setSelectedSegmentIndex:-1];
        sessionPlace.text = @"";
    }
    else{
        [addressRegion setEnabled:YES];
        [addressDetail setEnabled:YES];
        [peopleCount setEnabled:YES];
        [peopleCount setTintColor:segmentedControl.tintColor];
        [peopleCount setValue:1];
        [peopleNumber setText:[NSString stringWithFormat:@"%.0f", peopleCount.value]];
        [vagetableCount setEnabled:YES];
        [vagetableCount setTintColor:segmentedControl.tintColor];
        [meatCount setEnabled:YES];
        [meatCount setTintColor:segmentedControl.tintColor];
        [session setEnabled:YES];
        [session setTintColor:segmentedControl.tintColor];
        
    }
}

- (IBAction)modify:(id)sender {
    [saveDataButton setEnabled:YES];
    [self enableSpeceficObjects];
}

- (IBAction)peopleNumberStepper:(id)sender {
    [self.view endEditing:YES];
    [peopleNumber setText:[NSString stringWithFormat:@"%.0f", peopleCount.value]];
    if ([peopleCount value] < [vagetableCount value]+[meatCount value]) {
        [vagetableCount setValue:0];
        [meatCount setValue:0];
        [vagetableNumber setText:@"0"];
        [meatNumber setText:@"0"];
    }
}

- (IBAction)vagetableNumberStepper:(id)sender {
    [self.view endEditing:YES];
    if ([vagetableCount value]+[meatNumber.text integerValue]>[peopleNumber.text integerValue]) {
        [vagetableCount setValue:[vagetableNumber.text integerValue]];
        return;
    }
    [vagetableNumber setText:[NSString stringWithFormat:@"%.0f", vagetableCount.value]];
}

- (IBAction)meatNumberStepper:(id)sender {
    [self.view endEditing:YES];
    if ([vagetableNumber.text integerValue]+[meatCount value]>[peopleNumber.text integerValue]) {
        [meatCount setValue:[meatNumber.text integerValue]];
        return;
    }
    [meatNumber setText:[NSString stringWithFormat:@"%.0f", meatCount.value]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy / MM / dd HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:modifyFormDeadline];
    if (modifyFormDeadline) {
        return [NSString stringWithFormat:@"請於 %@ 前填寫出席意願喔！", strDate];
    }
    else{
        return nil;
    }
    
}

- (IBAction)saveData:(id)sender {
    if ([modifyFormDeadline compare:[NSDate date]] == NSOrderedAscending) {
        [cleanButton setEnabled:NO];
        [modifyButton setEnabled:NO];
        [saveDataButton setEnabled:NO];
        [self disableAllObjects];
        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"目前無法在修改資料囉，請直接與新郎/新娘聯絡！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [message addAction:okButton];
        dispatch_async(dispatch_get_main_queue(),^{
            [self presentViewController:message animated:YES completion:nil];
        });
        return;
    }
    BOOL uploadingData = NO;
    NSString *alertString = @"";
    
    if ([name.text isEqualToString:@""]) {
        alertString = @"請輸入姓名。";
    }
    else if ([phone.text isEqualToString:@""]) {
        alertString = @"請輸入聯絡電話。";
    }
    else if ( attendWilling.selectedSegmentIndex == -1) {
        alertString = @"請選擇參與意願。";
    }
    else if ( attendWilling.selectedSegmentIndex == 0 ){
        if ([addressRegion.text isEqualToString:@""] ) {
            alertString = @"請選擇喜帖寄送地址的縣市及區域。";
        }
        else if ([addressDetail.text isEqualToString:@""]) {
            alertString = @"請輸入喜帖的寄送地址。";
        }
        else if ( relation.selectedSegmentIndex == -1) {
            alertString = @"請選擇身份(新郎/新娘的親朋好友)。";
        }
        else if ( session.selectedSegmentIndex == -1) {
            if (!onlyOneSession) {
                alertString = @"請選擇參加場次。";
            }
        }
        else if ( [peopleNumber.text isEqualToString:@"0"]){
            alertString = @"請輸入參加人次。";
        }
        else if ( [vagetableNumber.text integerValue] + [meatNumber.text integerValue] != [peopleNumber.text integerValue]){
            alertString = @"請確認個別飲食習慣的人數。";
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
        MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
        NSString *weddingObjectId = tabBarController.weddingObjectId;
        NSMutableDictionary *registrationData = [[NSMutableDictionary alloc] init];
        registrationData[@"name"] = name.text;
        registrationData[@"phone"] = phone.text;
        registrationData[@"relation"] = @(relation.selectedSegmentIndex);
        registrationData[@"attendingWilling"] = @(attendWilling.selectedSegmentIndex);
        registrationData[@"shooter"] = @"";
        if (attendWilling.selectedSegmentIndex == 0) {
            registrationData[@"addressRegion"] = addressRegion.text;
            registrationData[@"addressDetail"] = addressDetail.text;
            registrationData[@"peopleNumber"] = @([peopleNumber.text integerValue]);
            registrationData[@"vagetableNumber"] = @([vagetableNumber.text integerValue]);
            registrationData[@"meatNumber"] = @([meatNumber.text integerValue]);
            if (onlyOneSession) {
                registrationData[@"session"] = @(-1);
            }
            else{
                registrationData[@"session"] = @(session.selectedSegmentIndex);
            }
        }
        registrationData[@"notation"] = notation.text;
        NSString *theInstallationId = [userDefaults objectForKey:@"InstallationId"];
        NSLog(@"the Installation id = %@", theInstallationId);
        if (theInstallationId) {
            [[databaseRef child:[NSString stringWithFormat:@"AttendantList/%@/%@",weddingObjectId, theInstallationId]] setValue:registrationData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                [processing dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        else{
            [[[databaseRef child:[NSString stringWithFormat:@"AttendantList/%@",weddingObjectId]] childByAutoId] setValue:registrationData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                NSLog(@"the ref.key = %@", ref.key);
                [userDefaults setObject:ref.key forKey:@"InstallationId"];
                [processing dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        [saveDataButton setEnabled:NO];
        [self disableAllObjects];
        [userDefaults setObject:name.text forKey:@"NickName"];
        BOOL synchronizeResult = [userDefaults synchronize];
        NSLog(@"synchronizeResult = %d", synchronizeResult);
        [modifyButton setEnabled:YES];
    }
}

- (IBAction)clearData:(id)sender {
    name.text = @"";
    phone.text = @"";
    attendWilling.selectedSegmentIndex = -1;
    nickName.text = @"";
    addressRegion.text = @"";
    addressDetail.text = @"";
    relation.selectedSegmentIndex = -1;
    peopleNumber.text = @"0";
    vagetableNumber.text = @"0";
    meatNumber.text = @"0";
    session.selectedSegmentIndex = -1;
    notation.text = @"";
    [saveDataButton setEnabled:YES];
    
    [self enableSpeceficObjects];
}


- (void)loadData {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"CityAndRegion" ofType:@"plist"];
    
    cityAndRegionArray = [NSMutableArray arrayWithContentsOfFile:path];
    
    regionArray = cityAndRegionArray[0][@"regions"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [cityAndRegionArray count];
    }
    else {
        return [regionArray count];
    }
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return cityAndRegionArray[row][@"city"];
    }else {
        return regionArray[row];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        return 75;
    }
    else if (indexPath.row == 8) {
        if (onlyOneSession) {
            return 0;
        }
        else{
            return 75;
        }
    }
    else{
        return 44;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        regionArray = cityAndRegionArray[row][@"regions"];
        [pickRegion reloadComponent:1];
    }
    NSInteger cityRow = [pickRegion selectedRowInComponent:0];
    NSInteger regionRow = [pickRegion selectedRowInComponent:1];
    [addressRegion setText:[NSString stringWithFormat:@"%@%@",cityAndRegionArray[cityRow][@"city"],regionArray[regionRow]]];
}


-(void) cancelPicker:(id)sender {
    NSInteger cityRow = [pickRegion selectedRowInComponent:0];
    NSInteger regionRow = [pickRegion selectedRowInComponent:1];
    [addressRegion setText:[NSString stringWithFormat:@"%@%@",cityAndRegionArray[cityRow][@"city"],regionArray[regionRow]]];
    [addressRegion endEditing:YES];
}



- (IBAction)chooseSession:(id)sender {
    [self.view endEditing:YES];
    if (session.selectedSegmentIndex == 0) {
        sessionPlace.text = engagePlace;
    }
    else if (session.selectedSegmentIndex){
        sessionPlace.text = marryPlace;
    }
}

- (IBAction)chooseRelation:(id)sender {
    [self.view endEditing:YES];
}
@end
