//
//  WeddingInformationViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/10.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "WeddingInformationTableViewController.h"
#import <Parse/Parse.h>

@interface WeddingInformationTableViewController ()
@property (nonatomic, strong) UIAlertController *processing;
@property (nonatomic, strong) PFObject *weddingInformation;
@end

@implementation WeddingInformationTableViewController

@synthesize engageAddress, marryAddress, engageTime, marryTime, engagePlace, marryPlace, processing, weddingInformation;

- (void)viewDidLoad {
    [super viewDidLoad];
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:processing animated:YES completion:nil];
    PFQuery *query = [PFQuery queryWithClassName:@"Information"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            
        }
        else {
            [engageTime setTitle:object[@"engageDate"] forState:UIControlStateNormal];
            [marryTime setTitle:object[@"marryDate"] forState:UIControlStateNormal];
            [engagePlace setTitle:object[@"engagePlace"] forState:UIControlStateNormal];
            [marryPlace setTitle:object[@"marryPlace"] forState:UIControlStateNormal];
            [engageAddress setTitle:object[@"engageAddress"] forState:UIControlStateNormal];
            [marryAddress setTitle:object[@"marryAddress"] forState:UIControlStateNormal];
            weddingInformation = object;
        }
        [processing dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
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
- (IBAction)addEngageTimeToSchedule:(id)sender {
}

- (IBAction)addMarryTimeToSchedule:(id)sender {
}

- (IBAction)marryRestaurantIntroduce:(id)sender {
    NSString *weddingInformationAddress = weddingInformation[@"marryPlaceIntroduce"];
    NSURL *urlFromString = [NSURL URLWithString:weddingInformationAddress];
    [[UIApplication sharedApplication] openURL:urlFromString];
    
}

- (IBAction)engageRestaurantIntroduce:(id)sender {
}

- (IBAction)marryRestaurantMap:(id)sender {
}

- (IBAction)engageRestaurantMap:(id)sender {
}
@end
