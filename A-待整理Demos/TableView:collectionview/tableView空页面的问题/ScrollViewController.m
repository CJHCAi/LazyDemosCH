//
//  ScrollViewController.m
//  demo
//
//  Created by 王刚 on 2018/9/28.
//  Copyright © 2018 王刚. All rights reserved.
//

#import "ScrollViewController.h"
#import "GGFont.h"
@interface ScrollViewController ()<UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic,strong)UITableView * tableView;
@end

@implementation ScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"关于scrollview的一些属性";
    self.view.backgroundColor=[UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView=[UIView new];
    /*iPad  cell不能到边缘的问题解决*/
    /*iPad  cell不能到边缘的问题解决*/
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    // Do any additional setup after loading the view.
}
#pragma mark - DZNEmptyDataSetSource
// 返回图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"moment_cover"];
}
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    
}
// 空白页已经出现
- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {
    
}
// 空白页将要消失
- (void)emptyDataSetWillDisappear:(UIScrollView *)scrollView {
    
}
// 空白页已经消失
- (void)emptyDataSetDidDisappear:(UIScrollView *)scrollView {
    
}
//添加可以点击的按钮上面带文字
-(NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f]};
    return [[NSAttributedString alloc] initWithString:@"点击刷新" attributes:attribute];
}

//#pragma mark - DZNEmptyDataSetDelegate
// 处理按钮的点击事件
- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.baidu.com"]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
//    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"one"];
//    if (cell==nil) {
//        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
//    }
//    cell.textLabel.text=@"1";
//    cell.textLabel.font=[GGFont ggFontWithSize:15];
//    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
    }
    return _dataArr;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
