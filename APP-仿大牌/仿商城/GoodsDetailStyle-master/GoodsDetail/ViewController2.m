//
//  ViewController2.m
//  GoodsDetail
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController2.h"
#import <WebKit/WebKit.h>
#import <MJRefresh.h>

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self
@interface ViewController2 ()
{
    UIScrollView *detailScrollBaseView;
    UITableView *detailTableView;
    UIWebView *detailWebView;
    
}
@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"无分页效果";
    
    
}

#pragma mark - creatDetailTableView
- (void)creatDetailTableView
{
    detailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, 667 - 64) style:UITableViewStylePlain];
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    [self.view addSubview:detailTableView];
    
    [self creatWebViewForGoodsdetail];

}

#pragma mark - creatWebViewForGoodsdetail
- (void)creatWebViewForGoodsdetail
{
    detailWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, 375, 667 - 64)];
    detailWebView.backgroundColor = [UIColor whiteColor];
    detailWebView.scrollView.contentInset = UIEdgeInsetsMake(detailTableView.contentSize.height, 0, 0, 0);
    detailWebView.backgroundColor = [UIColor clearColor];
    detailWebView.opaque = NO;
    [self.view addSubview:detailWebView];

    
    
    detailTableView.frame = CGRectMake(0, -detailTableView.contentSize.height,375, detailTableView.contentSize.height);
    [detailWebView.scrollView addSubview:detailTableView];
    
    
    
    NSURLRequest *webRequest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http:www.baidu.com"]];
    //使用同步方法后去MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:webRequest returningResponse:&response error:nil];
    [detailWebView loadRequest:webRequest];
    
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


- (void)viewDidAppear:(BOOL)animated
{
    [self creatDetailTableView];

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
