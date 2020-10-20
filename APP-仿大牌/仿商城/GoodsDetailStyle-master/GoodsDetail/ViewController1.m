//
//  ViewController1.m
//  GoodsDetail
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController1.h"
#import <MJRefresh.h>
#import <WebKit/WebKit.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

@interface ViewController1 ()
{
    UIScrollView *detailScrollBaseView;
    UITableView *detailTableView;
    WKWebView *detailWebView;

}
@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分页效果";
    
    
    [self creatDetailScrollView];
}
#pragma mark - creatDetailScrollView
- (void)creatDetailScrollView
{
    detailScrollBaseView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 375, 667)];
    detailScrollBaseView.showsVerticalScrollIndicator = NO;
    detailScrollBaseView.showsHorizontalScrollIndicator = NO;
    detailScrollBaseView.bounces = NO;
    [detailScrollBaseView setContentSize:CGSizeMake(375, 667 * 2)];
    detailScrollBaseView.pagingEnabled = YES;
    detailScrollBaseView.scrollEnabled = NO;
    [self.view addSubview:detailScrollBaseView];
    [self creatDetailTableView];
    [self creatWebViewForGoodsdetail];
    
}
#pragma mark - creatDetailTableView
- (void)creatDetailTableView
{
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 375, 667 - 64) style:UITableViewStylePlain];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    [detailScrollBaseView addSubview:detailTableView];
    [self detail_addRefreshAndMore];
}

#pragma mark - creatWebViewForGoodsdetail
- (void)creatWebViewForGoodsdetail
{
    detailWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 667 - 64, 375, 667)];
    detailWebView.backgroundColor = [UIColor whiteColor];
    NSURLRequest *webRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://blog.csdn.net/codingfire"]];
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:webRequest returningResponse:&response error:nil];
    [detailWebView loadRequest:webRequest];
    
    [detailScrollBaseView addSubview:detailWebView];
    [self webDetail_addRefreshAndMore];
    
    
}

#pragma mark - detail_addRefreshAndMore
- (void)detail_addRefreshAndMore
{
    WS(ws);
    
    detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [detailScrollBaseView setContentOffset:CGPointMake(0, 667 - 64) animated:YES];

        [ws detail_endRefresh];
    }];
    
    MJRefreshBackStateFooter *footer = (MJRefreshBackNormalFooter *)detailTableView.mj_footer;
    [footer setTitle:@"放开加载..." forState:MJRefreshStatePulling];
    [footer setTitle:@"上拉加载更多..." forState:MJRefreshStateIdle];
    [footer setTitle:@"放开加载..." forState:MJRefreshStateRefreshing];
}

- (void)detail_endRefresh
{
    [detailTableView.mj_footer endRefreshing];
}

#pragma mark - webDetail_addRefreshAndMore
- (void)webDetail_addRefreshAndMore
{
    WS(ws);
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        [detailScrollBaseView setContentOffset:CGPointMake(0, 0) animated:YES];

        [ws webdetail_endRequestMore];
    }];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置文字
    [header setTitle:@"下拉返回..." forState:MJRefreshStateIdle];
    [header setTitle:@"放开返回..." forState:MJRefreshStatePulling];
    [header setTitle:@"放开返回..." forState:MJRefreshStateRefreshing];
    detailWebView.scrollView.mj_header = header;
}
- (void)webdetail_endRequestMore
{
    [detailWebView.scrollView.mj_header endRefreshing];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 419;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 70;
            break;
        case 3:
        {
            return 52;
        }
            break;
        case 4:
            return 118;
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"你的UI布局";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
