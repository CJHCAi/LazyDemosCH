//
//  TaskViewController.m
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import "TaskViewController.h"
#import "TaskCell.h"

static NSString *identifier = @"TaskCell";

@interface TaskViewController ()<UITableViewDelegate, UITableViewDataSource, TaskCellClickDelegate>{
    NSInteger rowStart;
}

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, copy)NSMutableArray *taskModels;

@property (nonatomic, copy)NSMutableArray *selectedTaskArray;

@end

@implementation TaskViewController

- (NSMutableArray *)taskModels {
    
    if(!_taskModels){
        _taskModels = [NSMutableArray array];
    }
    return _taskModels;
}

- (NSMutableArray *)selectedTaskArray {
    
    if(!_selectedTaskArray){
        _selectedTaskArray = [NSMutableArray array];
    }
    return _selectedTaskArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
    
    [self loadData];
}

- (void)initUI{
    
    self.view.backgroundColor = RGB(239, 239, 244, 1);
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(0, 0, 30, 30);
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitleColor:RGB(21, 126, 251, 1) forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirmButtonItem = [[UIBarButtonItem alloc]initWithCustomView:confirmButton];
    self.navigationItem.rightBarButtonItem = confirmButtonItem;
    // 列表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)loadData {
    
    NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"TaskPlist" ofType:@"plist"];
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:addressPath];
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *taskDic = array[i];
        Task *task = [Task new];
        [task setValuesForKeysWithDictionary:taskDic];
        task.indexPathRow = i;
        [self.taskModels addObject:task];
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.relateDelegate = self;
    cell.task = self.taskModels[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// 添加选择的任务
- (void)addTaskToRecord:(Task *)task {
    
    task.isSelected = YES;
    [self.taskModels replaceObjectAtIndex:task.indexPathRow withObject:task];
    [self.tableView reloadData];
    [self.selectedTaskArray addObject:task];
}

// 删除选择的任务
- (void)deleteTaskToRecord:(Task *)task {
    
    task.isSelected = NO;
    [self.tableView reloadData];
    [self.selectedTaskArray removeObject:task];
}

// 确定按钮
- (void)confirmButtonClick:(UIButton *)sender {
    
    self.taskBlock(self.selectedTaskArray);
    [self.navigationController popViewControllerAnimated:YES];
}

@end
