//
//  DLMineViewController.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/23.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLMineViewController.h"
#import "DLAboutTableViewController.h"

@interface DLMineViewController ()

@end

@implementation DLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 #pragma mark - TableViewDelegate
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 1;
 }
 
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *cellIdentifier = @"cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (!cell) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
     }
     cell.textLabel.text = @"关于";
     
     return cell;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DLAboutTableViewController *controller = [[DLAboutTableViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
