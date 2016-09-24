//
//  AttendWeddingTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/21.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "AttendWeddingViewController.h"

@interface AttendWeddingViewController ()

@property (nonatomic, strong) UIAlertController *processing;
@property (weak, nonatomic) GeneralTableViewCell *weddingNameCell;
@property (weak, nonatomic) GeneralTableViewCell *weddingPasswordCell;
@property (weak, nonatomic) GeneralTableViewCell *rememberInfoCell;
@property (weak, nonatomic) GeneralTableViewCell *mobileNumberCell;

@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic)NSInteger searchMode;
@end

@implementation AttendWeddingViewController

@synthesize attendTableView, processing, weddingNameCell, weddingPasswordCell, rememberInfoCell, userDefaults, advertisementBanner, searchMode, mobileNumberCell;

- (void)viewDidLoad {
    [super viewDidLoad];
    searchMode = 0;
    attendTableView.delegate = self;
    attendTableView.dataSource = self;
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    userDefaults = [NSUserDefaults standardUserDefaults];
    advertisementBanner.adUnitID = @"ca-app-pub-6991194125878512/9446351751";
    advertisementBanner.rootViewController = self;
    [advertisementBanner loadRequest:[GADRequest request]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == weddingNameCell.weddingName) {
        [textField resignFirstResponder];
        [weddingPasswordCell.weddingPassword becomeFirstResponder];
    }
    else if (textField == weddingPasswordCell.weddingPassword){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [attendTableView reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)modalViewControllerDidCancel{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (searchMode == 0) {
        return 3;
    }
    else if (searchMode == 1){
        return 4;
    }
    return 4;
}


- (GeneralTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GeneralTableViewCell *cell;
    NSString *weddingName = @"";
    NSString *weddingPassword = @"";
    NSString *mobileNumber = @"";
    BOOL remember;
    if (searchMode == 1 && [userDefaults boolForKey:@"rememberOfAccount"]) {
        weddingName=[userDefaults objectForKey:@"attendWeddingName"];
        weddingPassword =[userDefaults objectForKey:@"attendWeddingPassword"];
        remember = YES;
    }
    else if (searchMode == 0 && [userDefaults boolForKey:@"rememberOfMobile"]){
        mobileNumber = [userDefaults objectForKey:@"attendMobileNumber"];
        remember = YES;
    }
    else {
        remember = NO;
    }
    NSLog(@"mobile number = %@", [userDefaults objectForKey:@"attendMobileNumber"]);
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        [cell.searchMode addTarget:self action:@selector(changeSearchMode:) forControlEvents:UIControlEventValueChanged];
        weddingNameCell = cell;
    }
    if (searchMode == 0) {
        if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.mobileNumber.text = mobileNumber;
            mobileNumberCell = cell;
        }
        else if (indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            [cell.rememberInfoSwitch setOn:remember];
            rememberInfoCell = cell;
        }
    }
    else if (searchMode ==1){
        if (indexPath.row  == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
            cell.weddingName.delegate = self;
            cell.weddingName.text = weddingName;
            weddingNameCell = cell;
        }
        else if(indexPath.row == 2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.weddingPassword.delegate = self;
            cell.weddingPassword.text = weddingPassword;
            weddingPasswordCell = cell;
        }
        else if (indexPath.row == 3){
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            [cell.rememberInfoSwitch setOn:remember];
            rememberInfoCell = cell;
        }
    }
    return cell;
}

- (void)changeSearchMode:(UISegmentedControl *)sender{
    searchMode = sender.selectedSegmentIndex;
    [attendTableView reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueMainTab"]) {
        MainTabBarController *tabBarController = segue.destinationViewController;
        PFObject *tempObject = (PFObject *)sender;
        tabBarController.weddingObjectId = tempObject.objectId;
        tabBarController.weddingName = tempObject[@"weddingAccount"];
        tabBarController.manager = NO;
    }
    else if( [segue.identifier isEqualToString:@"segueWeddingList"]) {
        UINavigationController *nav = segue.destinationViewController;
        WeddingListTableViewController *weddingListTableViewController = (WeddingListTableViewController *)nav.topViewController;
        weddingListTableViewController.isAdmin = NO;
        weddingListTableViewController.weddingList = (NSMutableArray *) sender;
        
    }
    
}


- (IBAction)login:(id)sender {
    NSString *weddingName, *weddingPassword, *mobileNumber;
    BOOL rememberInfo = rememberInfoCell.rememberInfoSwitch.isOn;
    
    weddingName = weddingNameCell.weddingName.text;
    weddingPassword = weddingPasswordCell.weddingPassword.text;
    mobileNumber = mobileNumberCell.mobileNumber.text;
    NSLog(@"the weddingName, weddingPassword, mobileNumber = %@, %@, %@, %d", weddingName, weddingPassword, mobileNumber, rememberInfo);
    if (searchMode == 1 && ([weddingPassword isEqualToString:@""] || [weddingName isEqualToString:@""])) {
        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"請輸入婚宴名稱及通關密語！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [message addAction:okButton];
        [self presentViewController:message animated:YES completion:nil];
        return;
    }
    else if (searchMode == 0 && [mobileNumber isEqualToString:@""]){
        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"請輸入手機號碼！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [message addAction:okButton];
        [self presentViewController:message animated:YES completion:nil];
        return;
    }
    else{
        if (rememberInfoCell.rememberInfoSwitch.isOn) {
            if (searchMode == 0) {
                [userDefaults setObject:mobileNumber forKey:@"attendMobileNumber"];
                [userDefaults setBool:YES forKey:@"rememberOfMobile"];
            }
            else if (searchMode == 1){
                [userDefaults setObject:weddingName forKey:@"attendWeddingName"];
                [userDefaults setObject:weddingPassword forKey:@"attendWeddingPassword"];
                [userDefaults setBool:YES forKey:@"rememberOfAccount"];
            }
        }
        else{
            if (searchMode == 0) {
                [userDefaults setObject:@"" forKey:@"attendMobileNumber"];
                [userDefaults setBool:NO forKey:@"rememberOfMobile"];
            }
            else if (searchMode == 1){
                [userDefaults setObject:@"" forKey:@"attendWeddingName"];
                [userDefaults setObject:@"" forKey:@"attendWeddingPassword"];
                [userDefaults setBool:NO forKey:@"rememberOfAccount"];
            }
        }
        [userDefaults synchronize];
        [self.view endEditing:YES];
        dispatch_async(dispatch_get_main_queue(),^{
            [self presentViewController:processing animated:YES completion:nil];
        });
        if (searchMode == 0) {
            PFQuery *query = [PFQuery queryWithClassName:@"Information"];
            [query whereKey:@"MobileNumber" equalTo:mobileNumberCell.mobileNumber.text];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error) {
                    if ([error.userInfo[@"code"] isEqual:@100]) {
                        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"請連上網路！" preferredStyle:UIAlertControllerStyleAlert];
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
                        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"無法取得婚禮資訊，請稍候再試！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        }];
                        [message addAction:okButton];
                        dispatch_async(dispatch_get_main_queue(),^{
                            [processing dismissViewControllerAnimated:YES completion:^{
                                [self presentViewController:message animated:YES completion:nil];
                            }];
                        });
                    }
                }
                else{
                    if([objects count] == 0){
                        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"無法取得婚禮資訊，請確認手機號碼是否正確！" preferredStyle:UIAlertControllerStyleAlert];
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
                        dispatch_async(dispatch_get_main_queue(),^{
                            [processing dismissViewControllerAnimated:YES completion:^{
                                [self performSegueWithIdentifier:@"segueWeddingList" sender:[objects mutableCopy]];
                            }];
                        });
                    }
                }
            }];
        }
        else if (searchMode == 1){
            PFQuery *query = [PFQuery queryWithClassName:@"Information"];
            [query whereKey:@"weddingPassword" equalTo:weddingPassword];
            [query whereKey:@"weddingAccount" equalTo:weddingName];
            NSLog(@"%@     %@", weddingName, weddingPassword);
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                NSLog(@"objectid = %@", object.objectId);
                if (error) {
                    NSLog(@"error is = %@    %@", error.userInfo[@"error"], error.localizedFailureReason);
                    if ([error.userInfo[@"code"] isEqual:@100]) {
                        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"請連上網路！" preferredStyle:UIAlertControllerStyleAlert];
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
                        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"無法取得婚禮資訊，請與新郎/新娘確認婚宴名稱及通關密語！" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                        }];
                        [message addAction:okButton];
                        dispatch_async(dispatch_get_main_queue(),^{
                            [processing dismissViewControllerAnimated:YES completion:^{
                                [self presentViewController:message animated:YES completion:nil];
                            }];
                        });
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processing dismissViewControllerAnimated:YES completion:^{
                            [self performSegueWithIdentifier:@"segueMainTab" sender:object];
                        }];
                    });
                }
            }];
        }
    }
}


@end
