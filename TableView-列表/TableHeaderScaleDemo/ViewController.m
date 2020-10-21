//
//  ViewController.m
//  TableHeaderScaleDemo
//
//  Created by nieyongsheng on 2018/12/3.
//  Copyright © 2018年 nieyongsheng. All rights reserved.
//

#import "ViewController.h"
#import "headerScaleView.h"
#import <MJRefresh.h>



#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define HeaderH  123


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView * listTable;
    
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

#pragma mark - 初始化视图
-(void)initView
{
    
    listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
    listTable.backgroundColor = [UIColor whiteColor];
    listTable.delegate = self;
    listTable.dataSource = self;
    listTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshListEvent)];
    

    [self.view addSubview:listTable];
    
    if (@available(iOS 11.0, *))
    {
        listTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }


    headerScaleView * headerView= [[headerScaleView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, HeaderH) title:@"悬赏" subTitle:@"用户可通过做任务获得收益"];
    headerView.scrollView = listTable;
    [self.view addSubview:headerView];
    
    //listtable头部缩放视图
    
    
    
    
}

-(void)refreshListEvent
{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        [self->listTable.mj_header endRefreshing];
        
    });

}

#pragma mark - UIScrollViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc]init];
    
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]init];
    
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",(long)indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
