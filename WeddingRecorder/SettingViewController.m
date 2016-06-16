//
//  SettingViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/14.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (nonatomic, strong) UIAlertController *processing;
@property (nonatomic) BOOL isManagerSettingView;
@end

@implementation SettingViewController

@synthesize settingTableView, processing, isManagerSettingView, advertisementBanner;

- (void)viewDidLoad {
    [super viewDidLoad];
    [settingTableView setDelegate:self];
    [settingTableView setDataSource:self];
    
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    
    MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
    isManagerSettingView = tabBarController.manager;
    //[guestCell setHidden:!tabBarController.manager];
    NSLog(@"tabbar %@", tabBarController.weddingName);
    
    advertisementBanner.adUnitID = @"ca-app-pub-6991194125878512/9446351751";
    advertisementBanner.rootViewController = self;
    [advertisementBanner loadRequest:[GADRequest request]];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (isManagerSettingView) {
        return 2;
    }
    else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isManagerSettingView) {
        if (section == 0) {
            return 2;
        }
        return 1;
    }
    else{
        return 1;
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    if (isManagerSettingView) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cellIdentifier = @"cell1";
            }
            else if (indexPath.row == 1){
                cellIdentifier = @"cell2";
            }
        }
        else{
            cellIdentifier = @"cell3";
        }
    }
    else{
        cellIdentifier = @"cell3";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isManagerSettingView) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            [self performSegueWithIdentifier:@"segueGuestList" sender:self];
        }
        else if (indexPath.section == 0 && indexPath.row == 1) {
            [self performSegueWithIdentifier:@"segueModifyWeddingInfo" sender:self];
        }
    }
    
    /*
    else if (indexPath.section == 1){
        UINavigationController *nav = (UINavigationController *)self.presentingViewController;
        [self dismissViewControllerAnimated:NO completion:^{
            NSLog(@"class = %@", [nav.topViewController class]);
            if ([nav.topViewController class] == [CreateWeddingTableViewController class]) {
                [nav dismissViewControllerAnimated:YES completion:nil];
            }
            else if ([nav.topViewController class] == [WeddingListTableViewController class]){
                [nav popViewControllerAnimated:NO];
            }
            else if ([nav.topViewController class] == [AttendWeddingTableViewController class]){
                [nav dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueGuestList"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        GuestListTableViewController *guestListTableViewController = (GuestListTableViewController *)nav.topViewController;
        MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
        guestListTableViewController.weddingObjectId = tabBarController.weddingObjectId;
    }
    else if ([segue.identifier isEqualToString:@"segueModifyWeddingInfo"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        ModifyWeddingTableViewController *modifyWeddingTableViewController = (ModifyWeddingTableViewController *)nav.topViewController;
        MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
        modifyWeddingTableViewController.weddingObjectId = tabBarController.weddingObjectId;
    }
}

- (IBAction)leaveWedding:(id)sender {
    UINavigationController *nav = (UINavigationController *)self.presentingViewController;
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"class = %@", [nav.topViewController class]);
        if ([nav.topViewController class] == [CreateWeddingTableViewController class]) {
            [nav dismissViewControllerAnimated:YES completion:nil];
        }
        else if ([nav.topViewController class] == [WeddingListTableViewController class]){
            [nav popViewControllerAnimated:NO];
        }
        else if ([nav.topViewController class] == [AttendWeddingTableViewController class]){
            [nav dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
@end
