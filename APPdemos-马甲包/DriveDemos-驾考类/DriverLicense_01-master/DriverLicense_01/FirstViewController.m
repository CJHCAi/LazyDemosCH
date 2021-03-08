//
//  FirstViewController.m
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/3.
//  Copyright © 2016年 Maizi. All rights reserved.
//
#import "FirstViewController.h"
#import "FirstTableViewCell.h"
#import "TestSelectViewController.h"
#import "MyDataManage.h"

@interface FirstViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"科目一考试";
    [self creatTableView];
    [self creatView];
    _dataArray = @[@"章节练习",@"顺序练习",@"随机练习",@"专项练习",@"仿真模拟考试"];
  
}
//初始化tableView
-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250) style:UITableViewStylePlain];
    _tableView.dataSource= self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    
    
}

//界面设计

-(void)creatView{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -150, self.view.frame.size.height - 64 -150, 300, 30) ];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"...................我的考试分析...................";
    [self.view addSubview:label];
    NSArray *arr = @[@"我的错题",@"我的收藏",@"我的成绩",@"练习统计"];
    for (int i= 0; i<4 ; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom ];
        btn.frame = CGRectMake(self.view.frame.size.width/4 *i +self.view.frame.size.width/4/2 -30, self.view.frame.size.height - 100-64, 60, 60);
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.png",12+i]] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/4*i + self.view.frame.size.width/4/2-30, self.view.frame.size.height-64-35, 60, 20) ];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = arr[i];
        lab.font = [UIFont boldSystemFontOfSize:13];
        [self.view addSubview:lab];
    }
    
}
#pragma mark -tableVIew delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"FirstTableViewCell";
    FirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellID owner:self options:nil]lastObject];
        
    }
 
    cell.myImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png",indexPath.row +7]];
    cell.myLabel.text = _dataArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0://章节练习
        {
        TestSelectViewController *con = [[TestSelectViewController alloc]init];
            con.dataArray =[MyDataManage getData:chapter];
            con.myTitle = @"章节练习";
            UIBarButtonItem*item = [[UIBarButtonItem alloc]init];
            item.title = @"";
            self.navigationItem.backBarButtonItem = item;
            [self.navigationController pushViewController:con animated:YES];
            
        }
      
            
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
