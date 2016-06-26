//
//  FormReviewTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/6/5.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "FormReviewTableViewController.h"

@interface FormReviewTableViewController ()

@end

@implementation FormReviewTableViewController

@synthesize data, identity, attendWilling, peopleNumber, diet, address, identityCell, phoneCell, attendWillingCell, peopleNumberCell, dietCell, addressCell, commentCell, phone, commentTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.title = data[@"Name"];
    self.navigationItem.title= data[@"Name"];
    NSLog(@"Name = %@", data[@"Name"]);
    identity.text = ([data[@"Relation"] integerValue]== 0 ? @"新郎的親朋好友":@"新娘的親朋好友");
    
    if ([data[@"AttendingWilling"] integerValue] == 0) {
        attendWilling.text = @"參加";
        if ([data[@"Session"] integerValue] == 1) {
            attendWilling.text = [attendWilling.text stringByAppendingString:@"結婚宴"];
        }
        else if ([data[@"Session"] integerValue] == 0) {
            attendWilling.text = [attendWilling.text stringByAppendingString:@"訂婚宴"];
        }
        
        peopleNumber.text = [NSString stringWithFormat:@"%ld人出席", [data[@"PeopleNumber"] integerValue]];
        diet.text = [NSString stringWithFormat:@"%ld人葷食，%ld人素食", [data[@"MeatNumber"] integerValue], [data[@"VagetableNumber"] integerValue]];
        
        
        address.text = [NSString stringWithFormat:@"%@\n%@",data[@"AddressRegion"], data[@"AddressDetail"]];
        //detailAddress.text = data[@"AddressDetail"];
        /*
        NSLog(@"address.length = %lu", detailAddress.text.length);
        if (detailAddress.text.length>=21 && detailAddress.text.length <=22) {
            [address setFont:[address.font fontWithSize:15]];
        }
        else if (detailAddress.text.length>=23) {
            [address setFont:[address.font fontWithSize:11]];
        }
        else{
            [address setFont:[address.font fontWithSize:17]];
        }
        */
        
    }
    else{
        attendWilling.text = @"不克參加";
        [addressCell setHidden:YES];
        [peopleNumberCell setHidden:YES];
        [dietCell setHidden:YES];
    }
    [phone setTitle:data[@"Phone"] forState:UIControlStateNormal];
    NSString *notation = data[@"Notation"];
    if (notation.length == 0) {
        commentTextView.text = @"無備注";
    }
    else{
        commentTextView.text = notation;
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
    return 7;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (peopleNumberCell.hidden) {
        if (indexPath.row == 3) {
            return 0;
        }
    }
    if (addressCell.hidden) {
        if (indexPath.row == 5) {
            return 0;
        }
    }
    if (dietCell.hidden) {
        if (indexPath.row == 4) {
            return 0;
        }
    }
    if (indexPath.row == 6 || indexPath.row == 5) {
        return 88;
    }
    return 44;
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

- (IBAction)makePhone:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel:" stringByAppendingString:phone.currentTitle]]];
}
@end
