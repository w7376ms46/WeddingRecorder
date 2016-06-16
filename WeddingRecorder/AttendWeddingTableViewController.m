//
//  AttendWeddingTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/21.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "AttendWeddingTableViewController.h"

@interface AttendWeddingTableViewController ()
@property (nonatomic, strong) UIAlertController *processing;
@end

@implementation AttendWeddingTableViewController

@synthesize weddingAccount, weddingPassword, processing;

- (void)viewDidLoad {
    [super viewDidLoad];
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    weddingAccount.delegate = self;
    weddingPassword.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == weddingAccount) {
        [textField resignFirstResponder];
        [weddingPassword becomeFirstResponder];
    }
    else if (textField == weddingPassword){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    return 2;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MainTabBarController *tabBarController = segue.destinationViewController;
    PFObject *tempObject = (PFObject *)sender;
    tabBarController.weddingObjectId = tempObject.objectId;
    tabBarController.weddingName = tempObject[@"weddingAccount"];
    tabBarController.manager = NO;
}


- (IBAction)login:(id)sender {
    if ([weddingPassword.text isEqualToString:@""] || [weddingAccount.text isEqualToString:@""]) {
        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"請輸入婚宴名稱及通關密語！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        }];
        [message addAction:okButton];
        [self presentViewController:message animated:YES completion:nil];
        return;
    }
    else{
        [self.view endEditing:YES];
        dispatch_async(dispatch_get_main_queue(),^{
            [self presentViewController:processing animated:YES completion:nil];
        });
        PFQuery *query = [PFQuery queryWithClassName:@"Information"];
        [query whereKey:@"weddingPassword" equalTo:weddingPassword.text];
        [query whereKey:@"weddingAccount" equalTo:weddingAccount.text];
        NSLog(@"%@     %@", weddingPassword.text, weddingAccount.text);
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
@end
