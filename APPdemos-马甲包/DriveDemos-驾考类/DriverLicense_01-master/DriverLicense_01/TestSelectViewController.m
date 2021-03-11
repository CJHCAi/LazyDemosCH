
//
//  TestSelectViewController.m
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/10.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import "TestSelectViewController.h"
#import "TestSelectTableViewCell.h"
#include "TestSelectModel.h"
#import "AnswerViewController.h"

@interface TestSelectViewController ()<UITabBarControllerDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
}
@end

@implementation TestSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.title = _myTitle;
    [self creatTableView];
}
-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
}
#pragma mark -tableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@ "TestSelectTableViewCell";
    TestSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:cellID  owner:self options:nil ]lastObject ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置圆角
        cell.numberLabel.layer.masksToBounds = YES;
        cell.numberLabel.layer.cornerRadius = 8;
        
    }
    TestSelectModel *model = _dataArray[indexPath.row];
    cell.numberLabel.text = model.pid;
    cell.titleLable.text=model.pname;

    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[AnswerViewController alloc]init] animated:YES];
}

@end
