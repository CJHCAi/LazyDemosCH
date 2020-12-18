//
//  AddressViewController.m
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressCell.h"


static NSString *directionIdentifier = @"AddressCell";

@interface AddressViewController ()<UITableViewDataSource,UITableViewDelegate, AddressCellClickDelegate>

@property(nonatomic, strong)UITableView *userTableView;

@property(nonatomic, copy)NSMutableArray *addressModels;

@property(nonatomic, copy)NSMutableArray *selectedUserArray;

@end

@implementation AddressViewController

-(NSMutableArray *)addressModels {
    
    if (!_addressModels) {
        _addressModels = [NSMutableArray array];
    }
    return _addressModels;
}

- (NSMutableArray *)selectedUserArray {
    
    if (!_selectedUserArray) {
        _selectedUserArray = [NSMutableArray array];
    }
    return _selectedUserArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)initUI {
    
    self.view.backgroundColor = RGB(239, 239, 244, 1);
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0, 0, 30, 30);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:RGB(21, 126, 251, 1) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = confirmButtonItem;
    
    self.userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    self.userTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.userTableView];
}

- (void)loadData{
    
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"AddressPlist" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:addressPath];
    for (NSDictionary *directionDic in array) {
        Address *address = [Address new];
        [address setValuesForKeysWithDictionary:directionDic];
        [self.addressModels addObject:address];
    }
    [self.userTableView reloadData];
}

// 添加用户
- (void)addUserDicToUsers:(NSDictionary *)userDic {
    [self.selectedUserArray addObject:userDic];
}

// 删除用户
- (void)deleteUserDicFromUsers:(NSDictionary *)userDic {
    [self.selectedUserArray removeObject:userDic];
}

// 确定按钮
- (void)confirmButtonClick:(UIButton *)sender {
    
    self.addressBlock(self.selectedUserArray);
    [self.navigationController popViewControllerAnimated:YES];
}

// 列表delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", indexPath.section, indexPath.row];//以indexPath来唯一确定cell
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier]; //出列可重用的cell
    if (cell == nil) {
        cell = [[AddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.addressDelegate = self;
    cell.address = self.addressModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Address *address = self.addressModels[indexPath.row];
    return address.cellHeight;
}

@end
