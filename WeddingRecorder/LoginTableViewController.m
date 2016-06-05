//
//  LoginTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/22.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "LoginTableViewController.h"

@interface LoginTableViewController ()
@property (nonatomic, strong) UIAlertController *processing;
@end

@implementation LoginTableViewController

@synthesize account, password, email, createOrLoginButton, createOrLoginSelector, processing;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
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
    return 4;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)selectAccountStatus:(id)sender {
    UISegmentedControl *selector = (UISegmentedControl *)sender;
    if (selector.selectedSegmentIndex == 0) {
        [createOrLoginButton setTitle:@"建立帳號"];
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] setHidden:NO];
    }
    else{
        [createOrLoginButton setTitle:@"登入"];
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]] setHidden:YES];
    }
    
}

- (IBAction)createOrLogin:(id)sender {
    [self.view endEditing:YES];
    if (createOrLoginSelector.selectedSegmentIndex == 0) {
        PFUser *user = [PFUser user];
        user.username = account.text;
        user.password = password.text;
        user.email = email.text;
        if ([account.text isEqualToString:@""] || [password.text isEqualToString:@""] || [email.text isEqualToString:@""]) {
            UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"請輸入帳號、密碼、及E-Mail！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            [message addAction:okButton];
            [self presentViewController:message animated:YES completion:nil];
            return;
        }
        else{
            [self presentViewController:processing animated:YES completion:nil];
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processing dismissViewControllerAnimated:YES completion:^{
                            [self performSegueWithIdentifier:@"segueWeddingList" sender:self];
                        }];
                    });
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"errorrrrrrrrrrr: %@", errorString);
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
                    else if ([error.userInfo[@"code"] isEqual:@125]){
                        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"E-Mail格式錯誤！" preferredStyle:UIAlertControllerStyleAlert];
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
            }];
        }
    }
    else{
        if ([account.text isEqualToString:@""] || [password.text isEqualToString:@""]) {
            UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"請輸入帳號、密碼！" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            }];
            [message addAction:okButton];
            [self presentViewController:message animated:YES completion:nil];
            return;
        }
        else{
            dispatch_async(dispatch_get_main_queue(),^{
                [self presentViewController:processing animated:YES completion:nil];
            });
            [PFUser logInWithUsernameInBackground:account.text password:password.text
                                            block:^(PFUser *user, NSError *error) {
                                                //dispatch_async(dispatch_get_main_queue(),^{
                                                    
                                                //});
                                                if (user) {
                                                    dispatch_async(dispatch_get_main_queue(),^{
                                                        [processing dismissViewControllerAnimated:YES completion:^{
                                                            [self performSegueWithIdentifier:@"segueWeddingList" sender:self];
                                                        }];
                                                        
                                                    });
                                                } else {
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
                                                    else if ([error.userInfo[@"code"] isEqual:@101]) {
                                                        UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"帳號或密碼輸入錯誤！" preferredStyle:UIAlertControllerStyleAlert];
                                                        UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                                                        }];
                                                        [message addAction:okButton];
                                                        dispatch_async(dispatch_get_main_queue(),^{
                                                            [processing dismissViewControllerAnimated:YES completion:^{
                                                                [self presentViewController:message animated:YES completion:nil];
                                                            }];
                                                            
                                                        });
                                                    }
                                                    NSString *errorString = [error userInfo][@"error"];
                                                    NSLog(@"error: %@   %@", errorString, error);
                                                }
                                            }];
        }
    
    }
    
}
@end
