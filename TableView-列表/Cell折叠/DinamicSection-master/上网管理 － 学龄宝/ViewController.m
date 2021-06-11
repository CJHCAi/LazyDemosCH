//  ViewController.m
//  上网管理 － 学龄宝
//
//  Created by MAC on 15/2/3.
//  Copyright (c) 2015年 SaiHello. All rights reserved.

#import "ViewController.h"

@interface ViewController ()
{
    UIButton *_ScanInfo;
    UIButton *_BlackList;
    UIButton *_PreventInfo;
    
    UITableView *_tableView;
    UITableView *_tableView1;
    UITableView *_tableView2;
    UITableView *_tableView3;
    
    //记录每个分区的展开状态
    NSArray *_TableViewLists;
    NSMutableArray *_openArr;
    NSMutableArray *_dataArr;
    NSArray *_Cells;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init
- (void)initData{
    _tableView1 = [[UITableView alloc]init];
    _tableView2 = [[UITableView alloc]init];
    _tableView3 = [[UITableView alloc]init];
    _tableView1.rowHeight = 44;
    _tableView2.rowHeight = 44;
    _tableView3.rowHeight = 44;
    
    _TableViewLists = [[NSArray alloc]initWithObjects:_tableView1, _tableView2, _tableView3, nil];
    _openArr = [NSMutableArray arrayWithObjects:@NO,@NO,@NO,nil];
    _dataArr = [[NSMutableArray alloc]init];
    for (int i = 'A'; i<='D'; i++) {
        NSMutableArray *subArr = [NSMutableArray array];
        for (int j = 0; j<=20; j++) {
            NSString *str = [NSString stringWithFormat:@"%c%d",i,j];
            [subArr addObject:str];
        }
        [_dataArr addObject:subArr];
    }
    //NSLog(@"%@",_dataArr);
}

- (void)ResetOpenArray{
    _openArr = [NSMutableArray arrayWithObjects:@NO,@NO,@NO,nil];
}

- (void)initControls{
    _ScanInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _ScanInfo.frame = CGRectMake(0, 64, 320, 52);
    _ScanInfo.tag = 0;
    [_ScanInfo addTarget:self action:@selector(ScanInfo_OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ScanInfo setImage:[UIImage imageNamed:@"浏览内容"] forState:UIControlStateNormal];
    [self.view addSubview:_ScanInfo];
    
    _BlackList = [UIButton buttonWithType:UIButtonTypeCustom];
    _BlackList.frame = CGRectMake(0, 116, 320, 52);
    _BlackList.tag = 1;
    [_BlackList addTarget:self action:@selector(BlackList_OnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_BlackList setImage:[UIImage imageNamed:@"黑名单"] forState:UIControlStateNormal];
    [self.view addSubview:_BlackList];
    
    _PreventInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    _PreventInfo.frame = CGRectMake(0, 168, 320, 52);
    _PreventInfo.tag = 2;
    [_PreventInfo addTarget:self action:@selector(PreventInfo_OnClick:) forControlEvents:UIControlEventTouchUpInside ];
    [_PreventInfo setImage:[UIImage imageNamed:@"阻止内容"] forState:UIControlStateNormal];
    [self.view addSubview:_PreventInfo];
}

//==============================动作响应模块==============================//
//  1> 每次点击 先把其他的tableView移除
//  2> 将传入的tag 存起来 作为下标使用
//  3> 将tableView赋值为 tag所对应的表
//  4> 将dataSource委托对象设置为self
//  5> 判断当前section是否为打开状态
//     1) 若为打开，则：
//        ①: 将自己的位置复原
//        ②  将tableView显示出来 加入到subView;
//        ③: 重置开关数组 为全部关闭 仅点击的开关为打开
//     2)
//        ①: 移除tableView
//        ②: Button位置复原
//        ③: 重置开关数组
//==============================动作响应模块==============================//
//要去判断 文件列表中的条目个数，根据个数 显示Table的行数

#pragma mark - Actions
- (void)ScanInfo_OnClick:(UIButton *)sender{
    //[_tableView removeFromSuperview];   //每次点击 先把其他的tableView移除
    NSInteger tag = sender.tag;
    //_tableView = _TableViewLists[tag];
    //_tableView.dataSource = self;
    BOOL isOpen = [_openArr[tag] boolValue];
    if (!isOpen) {
        [_tableView removeFromSuperview];
        _tableView = _TableViewLists[tag];
        _tableView.dataSource = self;
        //此处由于是根级section所以不用复原
        _BlackList.frame = CGRectMake(0, 465, 320, 52);
        _PreventInfo.frame = CGRectMake(tag, 516, 320, 52);
        _tableView.frame = CGRectMake(20, 116, 300, 348);
        [self.view addSubview:_tableView];
        [self ResetOpenArray];   //重置开关数组 为全部关闭 仅点击的开关为打开
        [_openArr replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:YES]];
    }
    /*
    else {
        [_tableView removeFromSuperview];
        _BlackList.frame = CGRectMake(0, 116, 320, 52);
        _PreventInfo.frame = CGRectMake(0, 168, 320, 52);
        [_openArr replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:NO]];
    }*/
}

- (void)BlackList_OnClick:(UIButton *)sender{
    //[_tableView removeFromSuperview];   //每次点击 先把其他的tableView移除
    NSInteger tag = sender.tag;
    //_tableView = _TableViewLists[tag];
    //_tableView.dataSource = self;
    BOOL isOpen = [_openArr[tag] boolValue];
    if (!isOpen) {
        [_tableView removeFromSuperview];
        _tableView = _TableViewLists[tag];
        _tableView.dataSource = self;
        _BlackList.frame = CGRectMake(0, 116, 320, 52); //将自己的位置复原
        _PreventInfo.frame = CGRectMake(0, 516, 320, 52);
        _tableView.frame = CGRectMake(20, 168, 300, 348);
        [self.view addSubview:_tableView];
        [self ResetOpenArray];   //重置开关数组 为全部关闭 仅点击的开关为打开
        [_openArr replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:YES]];
    }
    /*
    else {
        [_tableView removeFromSuperview];
        _PreventInfo.frame = CGRectMake(0, 168, 320, 52);
        [_openArr replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:NO]];
    }*/
}

- (void)PreventInfo_OnClick:(UIButton *)sender{
    //[_tableView removeFromSuperview];  //每次点击 先把其他的tableView移除
    NSInteger tag = sender.tag;
    //_tableView = _TableViewLists[tag];
    //_tableView.dataSource = self;
    BOOL isOpen = [_openArr[2] boolValue];
    if (!isOpen) {
        [_tableView removeFromSuperview];
        _tableView = _TableViewLists[tag];
        _tableView.dataSource = self;
        _BlackList.frame = CGRectMake(0, 116, 320, 52); //将自己的位置复原
    	_PreventInfo.frame = CGRectMake(0, 168, 320, 52);  //将自己的位置复原
        _tableView.frame = CGRectMake(20, 220, 300, 348);
        [self.view addSubview:_tableView];
        [self ResetOpenArray];  //重置开关数组 为全部关闭 仅点击的开关为打开
        [_openArr replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:YES]];
    }
    /*
    else {
        [_tableView removeFromSuperview];
        [_openArr replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:NO]];
    }*/
}

#pragma mark - UITableViewDataSource @required
//回调次数为Section条目个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@",@"回调方法tableView:cellForRowAtIndexPath:被调用");
    CustomCell *cell = [CustomCell cellWithTableView:tableView];
    BrowseInfo *browseInfo = self.cells[indexPath.row];
    //设置模型数据给cell
    cell.browseInfo = browseInfo;
    //NSLog(@"%@",_dataArr);
    //cell.textLabel.text = [_dataArr[0] objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - 懒加载
- (NSArray *)cells
{
    if (_Cells == nil) {
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"NetInfo" ofType:@"plist"];
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:fullPath];
        NSMutableArray *models = [NSMutableArray arrayWithCapacity:dictArray.count];
        for (NSDictionary *dict in dictArray) {
            BrowseInfo *browseInfo = [BrowseInfo customCellWithDict:dict];//此处 略屌
            [models addObject:browseInfo];
        }
        _Cells = [models copy];
    }
    return _Cells;
}
@end

