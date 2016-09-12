//
//  LoginOrCreateAWeddingViewController.m
//  WeddingRecorder
//
//  Created by 志豪 陳 on 2016/5/21.
//  Copyright © 2016年 ChihHaoChen. All rights reserved.
//

#import "LoginOrCreateAWeddingViewController.h"

@interface LoginOrCreateAWeddingViewController ()
@property (nonatomic, strong) UITableView *createWeddingTable;
@end

@implementation LoginOrCreateAWeddingViewController

@synthesize createWeddingTable, banner;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    CGRect tableFrame = CGRectMake(0, self.view.bounds.size.height-176, self.view.bounds.size.width, 176);
    createWeddingTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    createWeddingTable.delegate = self;
    createWeddingTable.dataSource = self;
    createWeddingTable.backgroundColor = [UIColor colorWithRed:247/255.0 green:238/255.0 blue:223/255.0 alpha:1.0];
    //createWeddingTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    createWeddingTable.bounces = NO;
    createWeddingTable.scrollEnabled = false;
    [self.view addSubview:createWeddingTable];
    [self.view bringSubviewToFront:createWeddingTable];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"舉行/管理婚宴";
    }
    else{
        cell.textLabel.text = @"參加婚宴";
    }
    NSLog(@"cell.height = %f", cell.frame.size.height);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor redColor];
    cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:238/255.0 blue:223/255.0 alpha:1.0];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self performSegueWithIdentifier:@"segueLogin" sender:self];
    }
    else{
        [self performSegueWithIdentifier:@"segueAttendWedding" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
