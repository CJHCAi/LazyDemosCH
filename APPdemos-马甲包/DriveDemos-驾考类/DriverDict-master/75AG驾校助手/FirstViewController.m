//
//  FirstViewController.m
//  75AG驾校助手
//
//  Created by again on 16/3/27.
//  Copyright © 2016年 again. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstTableViewCell.h"
#import "TestSelectViewController.h"
#import "Mymanager.h"
#import "AnswerViewController.h"
#import "MainTestViewController.h"

@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong,nonatomic) NSArray *arr;
@property (strong,nonatomic) UITableView *tableView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"科目一 理论考试";
    self.arr = @[@"章节练习", @"顺序练习",@"随机练习",@"专项练习",@"模拟考试"];
    [self createTableView];
    [self createView];
    
}

- (void)createView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 150, self.view.frame.size.height -64-100, 300, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"..................我的考试分析.................";
    [self.view addSubview:label];
    
    NSArray *arr = @[@"我的错题",@"我的收藏",@"我的成绩",@"练习统计"];
    
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/4/2-30, self.view.frame.size.height-64-40, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png", i + 12]] forState:UIControlStateNormal];
        btn.tag = 201+i;
        [btn addTarget:self action:@selector(clickToolBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/4/2-30, self.view.frame.size.height-44, 60, 20)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = arr[i];
        lab.font = [UIFont boldSystemFontOfSize:13];
        [self.view addSubview:lab];
    }
}

- (void)clickToolBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 201:
        {
            AnswerViewController *myworn = [[AnswerViewController alloc] init];
            myworn.type = 7;
            [self.navigationController pushViewController:myworn animated:YES];
        }
            break;
        case 202:
        {
            AnswerViewController *answer = [[AnswerViewController alloc] init];
            answer.type = 8;
            [self.navigationController pushViewController:answer animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 350) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

#pragma matk - 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"FirstTableViewCell";
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.myImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", indexPath.row + 7]];
    cell.myLabel.text = _arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:// 章节练习
        {
            TestSelectViewController *vc = [[TestSelectViewController alloc] init];
            vc.dataArray = [Mymanager getData:chapter];
            vc.myTitle = @"章节练习";
            UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
            item.title = @"";
            vc.type = 1;
            self.navigationItem.backBarButtonItem = item;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1://顺序练习
        {
            AnswerViewController *answer = [[AnswerViewController alloc] init];
            answer.type = 2;
            [self.navigationController pushViewController:answer animated:YES];
        }
            break;
        case 2:// 随机练习
        {
            
            AnswerViewController *answer = [[AnswerViewController alloc] init];
            answer.type = 2;
            [self.navigationController pushViewController:answer animated:YES];
//            AnswerViewController *answer = [[AnswerViewController alloc] init];
//            answer.type = 3;
//            [self.navigationController pushViewController:answer animated:YES];
        }
            break;
        case 3:// 专项练习
        {
            TestSelectViewController *con = [[TestSelectViewController alloc] init];
            con.dataArray = [Mymanager getData:subChapter];
            con.myTitle = @"专项练习";
            UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
            item.title = @"";
            con.type = 2;
            self.navigationItem.backBarButtonItem = item;
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
        case 4:
        {
            MainTestViewController *con = [[MainTestViewController alloc] init];
            UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
            item.title = @"返回";
            self.navigationItem.backBarButtonItem = item;
            [self.navigationController pushViewController:con animated:YES];
        }
        default:
            break;
    }
}



@end
