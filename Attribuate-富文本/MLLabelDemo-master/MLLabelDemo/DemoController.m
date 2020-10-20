//
//  DemoController.m
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/28.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import "DemoController.h"
#import "UITableViewCell+Common.h"


static NSArray *kvccclassnames(){
    static NSArray *_vccclassnames = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _vccclassnames = @[@"Normal",@"Link",@"Expression",
                           @"Html",@"List",@"ListNoNib",@"ClipExpression"];
        
    });
    return _vccclassnames;
}

@interface DemoController ()

@end

@implementation DemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"SQQ";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell cellReuseIdentifier]];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return kvccclassnames().count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell cellReuseIdentifier]   forIndexPath:indexPath];
    
    cell.textLabel.text = kvccclassnames()[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class cls = NSClassFromString([NSString stringWithFormat:@"%@ViewController",kvccclassnames()[indexPath.row]]);
    UIViewController *vc = [cls new];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
