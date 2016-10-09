//
//  WeddingListTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/26.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "WeddingListTableViewController.h"

@interface WeddingListTableViewController ()

@property (strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) UIAlertController *processing;

@end

@implementation WeddingListTableViewController

@synthesize weddingList, editingTableButton, processing, isAdmin, logutButton, databaseRef;

- (void)viewDidLoad {
    [super viewDidLoad];
    databaseRef = [[FIRDatabase database]reference];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    if (isAdmin) {
        FIRUser *user = [FIRAuth auth].currentUser;
        [[[[databaseRef child:@"weddingInformation"] queryOrderedByChild:@"userEmail"] queryEqualToValue:user.email] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (![snapshot hasChildren]){
                
            }
            else {
                weddingList = [[NSMutableArray alloc] init];
                for (NSString *keyString in [snapshot.value allKeys]) {
                    NSMutableDictionary *weddingInformationPackage = [[NSMutableDictionary alloc] init];
                    [weddingInformationPackage setValue: [snapshot.value objectForKey:keyString] forKey:keyString];
                    
                    [weddingList addObject:weddingInformationPackage];
                }
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.tableView reloadData];
                });
            }
        }];
    }
    else{
        NSLog(@"objects count = %d in weddingList", [weddingList count]);
        [self.navigationItem setRightBarButtonItem:nil];
        [logutButton setTitle:@"離開"];
        NSMutableArray *leftButtonArray = [self.navigationItem.leftBarButtonItems mutableCopy];
        for (UINavigationItem *button in leftButtonArray) {
            if (![button.title isEqualToString:@"離開"]) {
                [leftButtonArray removeObject:button];
                break;
            }
        }
        [self.navigationItem setLeftBarButtonItems:leftButtonArray];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [weddingList count];
}


- (WeddingListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    WeddingListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WeddingListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDictionary *weddingInfo = weddingList[indexPath.row];
    NSDictionary *weddingDetail = [weddingInfo objectForKey:[[weddingInfo allKeys]firstObject]];
    cell.weddingName.text = weddingDetail[@"weddingName"];
    if ([weddingDetail[@"onlyOneSession"]boolValue]) {
        cell.marryDate.text = weddingDetail[@"engageDate"];
    }
    else{
        cell.marryDate.text = weddingDetail[@"marryDate"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isAdmin) {
        [self performSegueWithIdentifier:@"segueMainTab" sender:indexPath];
    }
    else{
        [self performSegueWithIdentifier:@"segueAttendMainTab" sender:indexPath];
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self presentViewController:processing animated:YES completion:^{
            //TODO: change to firebase
            PFObject *deletedObject = weddingList[indexPath.row];
            [deletedObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                [weddingList removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [processing dismissViewControllerAnimated:YES completion:nil];
            }];
        }];
    }
}


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


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *index = (NSIndexPath *) sender;
    if ([segue.identifier isEqualToString:@"segueMainTab"]) {
        MainTabBarController *tabBarController = (MainTabBarController *)segue.destinationViewController;
        NSString *keyString = [[weddingList[index.row] allKeys] firstObject];
        NSDictionary *weddingInformation = [weddingList[index.row] objectForKey:keyString];
        NSLog(@"key and information = %@, %@", keyString, weddingInformation);
        tabBarController.weddingName = weddingInformation[@"weddingName"];
        tabBarController.weddingObjectId = keyString;
        tabBarController.manager = YES;
        //UINavigationController *navController = tabBarController.viewControllers[0];
        //WeddingInformationTableViewController *informationTableViewController = (WeddingInformationTableViewController *)navController.topViewController;
        //informationTableViewController.weddingName = weddingList[index.row][@"weddingAccount"];
        //NSLog(@"selectedindex = %d", index.row);
    }
    else if ([segue.identifier isEqualToString:@"segueAttendMainTab"]){
        MainTabBarController *tabBarController = (MainTabBarController *)segue.destinationViewController;
        PFObject *weddingInformation = weddingList[index.row];
        tabBarController.weddingName = weddingInformation[@"weddingAccount"];
        tabBarController.weddingObjectId = weddingInformation.objectId;
        tabBarController.manager = NO;
    }
    
}

- (IBAction)logout:(id)sender {
    NSLog(@"current User =  %@ is logging out", [PFUser currentUser] );
    if (isAdmin) {
        [PFUser logOut];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    //PFUser *currentUser = [PFUser currentUser];
}

- (IBAction)createWedding:(id)sender {
    [self performSegueWithIdentifier:@"segueCreateWedding" sender:self];
}

- (IBAction)editTable:(id)sender {
    if (self.tableView.editing) {
        [self.tableView setEditing:NO animated: YES];
        [editingTableButton setTitle:@"編輯"];
        
    }
    else{
        [self.tableView setEditing:YES animated: YES];
        [editingTableButton setTitle:@"完成"];

    }
    

}
@end
