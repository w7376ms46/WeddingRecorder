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
@property (nonatomic, strong) FIRDatabaseReference *databaseRef;
@end

@implementation LoginTableViewController

@synthesize account, password, email, createOrLoginButton, createOrLoginSelector, processing, databaseRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    account.delegate = self;
    password.delegate = self;
    email.delegate = self;
    //FIRDatabaseReference *ref;
    //FIRDatabaseReference
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    databaseRef = [[FIRDatabase database] reference];
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == account) {
        [textField resignFirstResponder];
        [password becomeFirstResponder];
    }
    if (createOrLoginSelector.selectedSegmentIndex == 0) {
        if (textField == password){
            [textField resignFirstResponder];
            [email becomeFirstResponder];
        }
        else if (textField == email){
            [textField resignFirstResponder];
        }
    }
    else if (textField == password){
        [textField resignFirstResponder];
    }
    return NO;
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueWeddingList"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        WeddingListTableViewController *weddingListTableViewController = (WeddingListTableViewController *)nav.topViewController;
        weddingListTableViewController.isAdmin = YES;
    }
}


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
            [[[[databaseRef child:@"user"] queryOrderedByChild:@"account"] queryEqualToValue:account.text] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                if([snapshot hasChildren]){
                    NSLog(@"result = %@", snapshot.value);
                    UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"此帳號已被使用！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    }];
                    [message addAction:okButton];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processing dismissViewControllerAnimated:YES completion:^{
                            [self presentViewController:message animated:YES completion:nil];
                        }];
                    });
                }
                else {
                    NSDictionary *accountData = @{@"email":email.text, @"account":account.text};
                    [[[databaseRef child:@"user"] childByAutoId]setValue:accountData withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
                        [[FIRAuth auth]createUserWithEmail:email.text password:password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                            if (!error) {
                                dispatch_async(dispatch_get_main_queue(),^{
                                    [processing dismissViewControllerAnimated:YES completion:^{
                                        [self performSegueWithIdentifier:@"segueWeddingList" sender:self];
                                    }];
                                });
                            }
                        }];
                    }];
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
            
            [[[[databaseRef child:@"user"] queryOrderedByChild:@"account"] queryEqualToValue:account.text] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                if([snapshot hasChildren]){
                    NSDictionary *accountData = [snapshot.value objectForKey:[snapshot.value allKeys][0]];
                    [[FIRAuth auth]signInWithEmail:accountData[@"email"] password:password.text completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                        if (error) {
                            if (error.code == 17009) {
                                UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"密碼輸入錯誤！" preferredStyle:UIAlertControllerStyleAlert];
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
                                    [self performSegueWithIdentifier:@"segueWeddingList" sender:self];
                                }];
                            });
                        }
                        
                    }];
                }
                //帳號不存在
                else {
                    UIAlertController *message = [UIAlertController alertControllerWithTitle:nil message:@"此帳號不存在！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"好！" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                    }];
                    [message addAction:okButton];
                    dispatch_async(dispatch_get_main_queue(),^{
                        [processing dismissViewControllerAnimated:YES completion:^{
                            [self presentViewController:message animated:YES completion:nil];
                        }];
                    });
                }
            }];
        }
    
    }
    
}
@end
