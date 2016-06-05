//
//  WeddingInformationViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/3/10.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "WeddingInformationTableViewController.h"


@interface WeddingInformationTableViewController ()
@property (nonatomic, strong) UIAlertController *processing;
@property (nonatomic, strong) PFObject *weddingInformation;
@end

@implementation WeddingInformationTableViewController

@synthesize engageAddress, marryAddress, engageTime, marryTime, engagePlace, marryPlace, processing, weddingInformation, weddingName;

- (void)viewDidLoad {
    [super viewDidLoad];
    processing = [UIAlertController alertControllerWithTitle:nil message:@"處理中..." preferredStyle:UIAlertControllerStyleAlert];

    MainTabBarController *tabBarController = (MainTabBarController *)self.tabBarController;
    NSLog(@"tab bar weddingName = %@   %@", tabBarController.weddingName, tabBarController.weddingObjectId);
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Information"];
    //[query whereKey:@"managerAccount" equalTo:currentUser.username];
    //[query whereKey:@"weddingAccount" equalTo:tabBarController.weddingName];
    
    //[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
    [query getObjectInBackgroundWithId:tabBarController.weddingObjectId block:^(PFObject *object, NSError * error) {
        if (!object) {
            NSLog(@"No object retrieved");
        }
        else {
            NSLog(@"getttttt object");
            [engageTime setTitle:object[@"engageDate"] forState:UIControlStateNormal];
            [marryTime setTitle:object[@"marryDate"] forState:UIControlStateNormal];
            [engagePlace setTitle:object[@"engagePlace"] forState:UIControlStateNormal];
            [marryPlace setTitle:object[@"marryPlace"] forState:UIControlStateNormal];
            [engageAddress setTitle:object[@"engageAddress"] forState:UIControlStateNormal];
            [marryAddress setTitle:object[@"marryAddress"] forState:UIControlStateNormal];
            weddingInformation = object;
        }
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
    EKEventStore *store = [EKEventStore new];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *startDate = [weddingInformation[@"engageDateInDate"] dateByAddingTimeInterval:-timeZoneSeconds];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"志豪＆麗熒訂婚午宴";
        event.startDate = startDate;
        event.endDate = [event.startDate dateByAddingTimeInterval:3*60*60];  //set 3 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        dispatch_async(dispatch_get_main_queue(),^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"已加入至%@的\"%@\"行事曆！",[[store defaultCalendarForNewEvents] source].title, [[store defaultCalendarForNewEvents] title]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

- (IBAction)addMarryTimeToSchedule:(id)sender {
    EKEventStore *store = [EKEventStore new];
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *startDate = [weddingInformation[@"marryDateInDate"] dateByAddingTimeInterval:-timeZoneSeconds];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"志豪＆麗熒結婚午宴";
        event.startDate = startDate;
        event.endDate = [event.startDate dateByAddingTimeInterval:3*60*60];  //set 3 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        dispatch_async(dispatch_get_main_queue(),^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"已加入至%@的\"%@\"行事曆！",[[store defaultCalendarForNewEvents] source].title, [[store defaultCalendarForNewEvents] title]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    }];
}

- (IBAction)marryRestaurantIntroduce:(id)sender {
    NSString *weddingInformationAddress = weddingInformation[@"marryPlaceIntroduce"];
    NSLog(@"%@", weddingInformationAddress);
    NSURL *urlFromString = [NSURL URLWithString:weddingInformationAddress];
    [[UIApplication sharedApplication] openURL:urlFromString];
    
}

- (IBAction)engageRestaurantIntroduce:(id)sender {
    NSString *weddingInformationAddress = weddingInformation[@"engagePlaceIntroduce"];
    NSLog(@"%@", weddingInformationAddress);
    NSURL *urlFromString = [NSURL URLWithString:weddingInformationAddress];
    [[UIApplication sharedApplication] openURL:urlFromString];
}

- (IBAction)marryRestaurantMap:(id)sender {
    NSString *marryAddressString = [weddingInformation[@"marryAddress"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlFromString;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        urlFromString = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@", marryAddressString]];
    }
    else{
        urlFromString = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",marryAddressString]];
    }
    [[UIApplication sharedApplication] openURL:urlFromString];
}

- (IBAction)engageRestaurantMap:(id)sender {
    NSString *engageAddressString = [weddingInformation[@"engageAddress"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *urlFromString;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        urlFromString = [NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?q=%@", engageAddressString]];
    }
    else{
        urlFromString = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",engageAddressString]];
    }
    [[UIApplication sharedApplication] openURL:urlFromString];
}
@end
