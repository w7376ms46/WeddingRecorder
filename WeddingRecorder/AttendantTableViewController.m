//
//  AttendantTableViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/2/28.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "AttendantTableViewController.h"

@interface AttendantTableViewController ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation AttendantTableViewController

@synthesize name, phone, attendWilling, nickName, addressRegion, addressDetail, relation, peopleNumber, peopleCount, vagetableNumber, vagetableCount, meatNumber, meatCount, session, userDefaults;

- (void)viewDidLoad {
    [super viewDidLoad];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    PFQuery *query = [PFQuery queryWithClassName:@"AttendantList"];
    [query whereKey:@"InstallationID" equalTo:[PFInstallation currentInstallation].installationId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
            name.text = @"";
            phone.text = @"";
            attendWilling.selectedSegmentIndex = -1;
            nickName.text = @"";
            addressRegion.text = @"";
            addressDetail.text = @"";
            relation.selectedSegmentIndex = -1;
            peopleNumber.text = @"0";
            vagetableNumber.text = @"0";
            meatNumber.text = @"0";
            session.selectedSegmentIndex = -1;
            
            [peopleCount setValue:0];
            [vagetableCount setValue:0];
            [meatCount setValue:0];
        }
        else {
            // The find succeeded.
            NSLog(@"Successfully retrieved the object.");
            [name setText:object[@"Name"]];
            [phone setText:object[@"Phone"]];
            [attendWilling setSelectedSegmentIndex:[object[@"AttendingWilling"]integerValue]];
            [nickName setText:object[@"NickName"]];
            [addressRegion setText:object[@"AddressRegion"]];
            [addressDetail setText:object[@"AddressDetail"]];
            [relation setSelectedSegmentIndex:[object[@"Relation"]integerValue]];
            [peopleNumber setText:[NSString stringWithFormat:@"%ld",[object[@"PeopleNumber"] integerValue]]];
            [peopleCount setValue:[object[@"PeopleNumber"] integerValue]];
            [vagetableNumber setText:[NSString stringWithFormat:@"%ld",[object[@"VagetableNumber"] integerValue]]];
            [vagetableCount setValue:[object[@"VagetableNumber"] integerValue]];
            [meatNumber setText:[NSString stringWithFormat:@"%ld",[object[@"MeatNumber"] integerValue]]];
            [meatCount setValue:[object[@"MeatNumber"] integerValue]];
            [session setSelectedSegmentIndex:[object[@"Session"] integerValue]];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (IBAction)peopleNumberStepper:(id)sender {
    [peopleNumber setText:[NSString stringWithFormat:@"%.0f", peopleCount.value]];
    if ([peopleCount value] < [vagetableCount value]+[meatCount value]) {
        [vagetableCount setValue:0];
        [meatCount setValue:0];
        [vagetableNumber setText:@"0"];
        [meatNumber setText:@"0"];
    }
}

- (IBAction)vagetableNumberStepper:(id)sender {
    if ([vagetableCount value]+[meatNumber.text integerValue]>[peopleNumber.text integerValue]) {
        [vagetableCount setValue:[vagetableNumber.text integerValue]];
        return;
    }
    [vagetableNumber setText:[NSString stringWithFormat:@"%.0f", vagetableCount.value]];
}

- (IBAction)meatNumberStepper:(id)sender {
    if ([vagetableNumber.text integerValue]+[meatCount value]>[peopleNumber.text integerValue]) {
        [meatCount setValue:[meatNumber.text integerValue]];
        return;
    }
    [meatNumber setText:[NSString stringWithFormat:@"%.0f", meatCount.value]];
}

- (IBAction)saveData:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"AttendantList"];
    // Retrieve the object by id
    [query whereKey:@"InstallationID" equalTo:[PFInstallation currentInstallation].installationId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *registrationData, NSError *error) {
        if (!registrationData) {
            registrationData = [PFObject objectWithClassName:@"AttendantList"];
        }
        registrationData[@"Name"] = name.text;
        registrationData[@"Phone"] = phone.text;
        registrationData[@"AttendingWilling"] = @(attendWilling.selectedSegmentIndex);
        registrationData[@"NickName"] = nickName.text;
        registrationData[@"AddressRegion"] = addressRegion.text;
        registrationData[@"AddressDetail"] = addressDetail.text;
        registrationData[@"Relation"] = @(relation.selectedSegmentIndex);
        registrationData[@"PeopleNumber"] = @([peopleNumber.text integerValue]);
        registrationData[@"VagetableNumber"] = @([vagetableNumber.text integerValue]);
        registrationData[@"MeatNumber"] = @([meatNumber.text integerValue]);
        registrationData[@"Session"] = @(session.selectedSegmentIndex);
        registrationData[@"InstallationID"] = [PFInstallation currentInstallation].installationId;
        [registrationData saveInBackground];
    }];
    [userDefaults setObject:nickName.text forKey:@"NickName"];
    [userDefaults synchronize];
}

- (IBAction)clearData:(id)sender {
    name.text = @"";
    phone.text = @"";
    attendWilling.selectedSegmentIndex = -1;
    nickName.text = @"";
    addressRegion.text = @"";
    addressDetail.text = @"";
    relation.selectedSegmentIndex = -1;
    peopleNumber.text = @"0";
    vagetableNumber.text = @"0";
    meatNumber.text = @"0";
    session.selectedSegmentIndex = -1;
}
@end
