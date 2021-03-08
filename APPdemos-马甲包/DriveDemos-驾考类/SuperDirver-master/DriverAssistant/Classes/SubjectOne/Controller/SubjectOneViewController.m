//
//  SubjectOneViewController.m
//  DriverAssistant
//
//  Created by C on 16/3/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "SubjectOneViewController.h"
#import "SubjectOneCell.h"
#import "TestSelectViewController.h"
#import "DataManger.h"
#import "AnswerViewController.h"
#import "MainTestViewController.h"
#import "QuestionCollectManager.h"


@interface SubjectOneViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation SubjectOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    self.navigationItem.title = _myTitle;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    [self creatView];

}

- (void)createTableView
{
    _dataArray = @[@"章节练习",@"顺序练习",@"随机练习",@"专项练习",@"仿真模拟考试"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (void)creatView
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height-64-150, 300, 30)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"···················我的考试分析···················";
    lable.textColor = [UIColor grayColor];
    [self.view addSubview:lable];
    
    NSArray *arr = @[@"我的错题",@"我的收藏",@"我的成绩",@"练习统计"];
    for (int i = 0; i<4 ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/4/2-30, self.view.frame.size.height-64-100, 60, 60);
        btn.tag = 201+i;
        [btn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",12+i]] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4*i+self.view.frame.size.width/4/2-33, self.view.frame.size.height-64-35, 66, 20)];
        lab.text = arr[i];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont boldSystemFontOfSize:13];
        [self.view addSubview:lab];
    }
}
- (void)onClickBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 201://我的错题集
        {
            if ([QuestionCollectManager getWrongQuestion].count > 0) {
                AnswerViewController *ctl = [[AnswerViewController alloc] init];
                ctl.type = 7;
                ctl.myTitle = @"我的错题集";
                [self.navigationController pushViewController:ctl animated:YES];
            }else
            {
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前没有错题！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertCtl addAction:action];
                [self presentViewController:alertCtl animated:YES completion:nil];
            }
        }
            break;
        case 202://我的收藏
        {
            if ([QuestionCollectManager getCollectQuestion].count > 0) {
                AnswerViewController *ctl = [[AnswerViewController alloc] init];
                ctl.type = 8;
                ctl.myTitle = @"我的收藏";
                [self.navigationController pushViewController:ctl animated:YES];
            }else
            {
                UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前没有收藏题目！" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertCtl addAction:action];
                [self presentViewController:alertCtl animated:YES completion:nil];
            }
        
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SubjectOneCell";
    SubjectOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:self options:nil]firstObject];
    }
    cell.myImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png",indexPath.row+7]];
    cell.myLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://章节练习
        {
            TestSelectViewController *ctl = [[TestSelectViewController alloc] init];
            ctl.type = 1;
            ctl.myTitle = @"章节练习";
            ctl.dataArr = [DataManger getData:chapter];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 1://顺序练习
        {
            AnswerViewController *ctl = [[AnswerViewController alloc] init];
            ctl.type = 2;
            ctl.myTitle = @"顺序练习";
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 2://随机练习
        {
            AnswerViewController *ctl = [[AnswerViewController alloc] init];
            ctl.type = 3;
            ctl.myTitle = @"随机练习";
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 3://专项练习
        {
            TestSelectViewController *ctl = [[TestSelectViewController alloc] init];
            ctl.myTitle = @"专项练习";
            ctl.type = 2;
            ctl.dataArr = [DataManger getData:subChapter];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 4://仿真模拟考试
        {
            MainTestViewController *ctl = [[MainTestViewController alloc] init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
