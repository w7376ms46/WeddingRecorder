//
//  GuestListTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/29.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "GuestListTableViewController.h"

@interface GuestListTableViewController ()
//填單人數
@property (nonatomic) NSInteger formNumber;
//出席結婚or訂婚場次人數
@property (nonatomic) NSInteger attendMarryNumber;
@property (nonatomic) NSInteger attendEngageNumber;
//出席親友的攜友人數
@property (nonatomic) NSInteger attendMarryFriendNumber;
@property (nonatomic) NSInteger attendEngageFriendNumber;
//訂婚or結婚的葷食or素食人數
@property (nonatomic) NSInteger attendMarryMeatNumber;
@property (nonatomic) NSInteger attendMarryVagetableNumber;
@property (nonatomic) NSInteger attendEngageMeatNumber;
@property (nonatomic) NSInteger attendEngageVagetableNumber;

@property (nonatomic) NSArray *formData;

@end

@implementation GuestListTableViewController

@synthesize weddingObjectId, formNumber, attendMarryNumber, attendEngageNumber, attendMarryFriendNumber, attendEngageFriendNumber, attendMarryMeatNumber, attendMarryVagetableNumber, attendEngageMeatNumber, attendEngageVagetableNumber, formData;

- (void)viewDidLoad {
    [super viewDidLoad];
    PFQuery *query = [PFQuery queryWithClassName:@"AttendantList"];
    [query whereKey:@"weddingObjectId" equalTo:weddingObjectId];
    [query orderByAscending:@"AttendingWilling"];
    [query orderByAscending:@"Session"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
            NSLog(@"No object retrieved %@",error);
        }
        else {
            NSLog(@"getttttt object");
            formNumber = [objects count];
            formData = objects;
            for ( PFObject *object in formData) {
                NSLog(@"object session =   %@    %@", object[@"AttendingWilling"],   object[@"Session"] );
                if ( object[@"AttendingWilling"] == [NSNumber numberWithInteger:0] && object[@"Session"] == [NSNumber numberWithInteger:1]){
                    attendMarryNumber++;
                    attendMarryFriendNumber = attendMarryFriendNumber + [object[@"PeopleNumber"] integerValue]-1;
                    attendMarryMeatNumber = attendMarryMeatNumber + [object[@"MeatNumber"] integerValue];
                    attendMarryVagetableNumber = attendMarryVagetableNumber + [object[@"VagetableNumber"] integerValue];
                    
                }
                else if(object[@"AttendingWilling"] == [NSNumber numberWithInteger:0] && object[@"Session"] == [NSNumber numberWithInteger:0]){
                    attendEngageNumber++;
                    attendEngageFriendNumber = attendEngageFriendNumber + [object[@"PeopleNumber"]integerValue]-1;
                    attendEngageMeatNumber = attendEngageMeatNumber + [object[@"MeatNumber"] integerValue];
                    attendEngageVagetableNumber = attendEngageVagetableNumber + [object[@"VagetableNumber"] integerValue];
                }
                
            }
            dispatch_async(dispatch_get_main_queue(),^{
                [self.tableView reloadData];
            });
        }
    }];
    
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
        return  4;
    }
    else if (section == 1){
        return formNumber;
    }
    return 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"統計資料";
    }
    else{
        return @"詳細資料";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1 || indexPath.row == 2) {
            return 153;
        }
    }
    else if (indexPath.section == 1){
        return 62;
    }
    return 44;
    
}

- (GuestListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cellIdentifier = @"cell1";
        }
        else if (indexPath.row == 1){
            cellIdentifier = @"cell2";
        }
        else if (indexPath.row == 2){
            cellIdentifier = @"cell3";
        }
        else if (indexPath.row == 3){
            cellIdentifier = @"cell4";
        }
    }
    else{
        cellIdentifier = @"cell5";
    }
    
    GuestListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.totalForm.text = [NSString stringWithFormat:@"總填單數：%ld", (long)formNumber];
        
        cell.attendMarryNumber.text = [NSString stringWithFormat:@"出席結婚場次人數：%ld 人", (long)attendMarryNumber];
        cell.attendMarryFriendNumber.text = [NSString stringWithFormat:@"攜友人數：%ld 人 ", (long)attendMarryFriendNumber];
        cell.totalMarryNumber.text = [NSString stringWithFormat:@"總人數：%ld 人", (long)(attendMarryNumber+attendMarryFriendNumber)];
        
        
        cell.attendEngageNumber.text = [NSString stringWithFormat:@"出席訂婚場次人數：%ld 人", (long)attendEngageNumber];
        cell.attendEngageFriendNumber.text = [NSString stringWithFormat:@"攜友人數：%ld 人", (long)attendEngageFriendNumber];
        cell.totalEngageNumber.text = [NSString stringWithFormat:@"總人數：%ld 人", (long)(attendEngageNumber+attendEngageNumber)];
        
        cell.attendMarryMeat.text = [NSString stringWithFormat:@"葷食人數：%ld 人", (long)attendMarryMeatNumber];
        cell.attendMarryVagetable.text = [NSString stringWithFormat:@"葷食人數：%ld 人", (long)attendMarryVagetableNumber];
        
        cell.attendEngageMeat.text = [NSString stringWithFormat:@"葷食人數：%ld 人", (long)attendEngageMeatNumber];
        cell.attendEngageVagetable.text = [NSString stringWithFormat:@"葷食人數：%ld 人", (long)attendEngageVagetableNumber];
        
        cell.notAttendNumber.text = [NSString stringWithFormat:@"無法出席人數：%ld 人",(long)(formNumber-attendMarryNumber-attendEngageNumber)];
    }
    else{
        PFObject *object = formData[indexPath.row];
        cell.name.text = object[@"Name"];
        if ([object[@"AttendingWilling"] integerValue] == 1) {
            cell.attendSession.text = @"不出席";
            [cell.attendSession setBackgroundColor:[UIColor grayColor]];
            [cell.peopleNumber setHidden:YES];
            NSString *notation = object[@"Notation"];
            if (notation.length == 0) {
                cell.diet.text = @"(無備注)";
                [cell.diet setTextColor:[UIColor lightGrayColor]];
            }
            else{
                cell.diet.text = notation;
                [cell.diet setTextColor:[UIColor blackColor]];
            }
            
        }
        else{
            cell.peopleNumber.text = [NSString stringWithFormat:@"%ld 人出席", [object[@"PeopleNumber"] integerValue]];
            [cell.peopleNumber setBackgroundColor:(formData[indexPath.row][@"Session"] == [NSNumber numberWithInteger:0])? [UIColor colorWithRed:236.0/255.0 green:170.0/255.0 blue:176.0/255.0 alpha:1]:[UIColor redColor]];
            cell.attendSession.text = (formData[indexPath.row][@"Session"] == [NSNumber numberWithInteger:0])? @"訂婚場":@"結婚場";
            [cell.attendSession setBackgroundColor:(formData[indexPath.row][@"Session"] == [NSNumber numberWithInteger:0])? [UIColor colorWithRed:236.0/255.0 green:170.0/255.0 blue:176.0/255.0 alpha:1]:[UIColor redColor]];
            cell.diet.text = [NSString stringWithFormat:@"%ld 人葷食，%ld人素食",[object[@"MeatNumber"] integerValue], [object[@"VagetableNumber"] integerValue]];
            [cell.diet setTextColor:[UIColor blackColor]];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    else{
        [self performSegueWithIdentifier:@"segueDetail" sender:indexPath];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueDetail"]) {
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        FormReviewTableViewController *formReviewTableViewController = segue.destinationViewController;
        formReviewTableViewController.data = formData[indexPath.row];
    }
}


- (IBAction)doneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
