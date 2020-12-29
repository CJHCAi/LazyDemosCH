//
//  HKDetailDescViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetailDescViewController.h"
#import "HKDescTableViewCell.h"
@interface HKDetailDescViewController()<UIWebViewDelegate>
//@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIWebView *webView;
@end


@implementation HKDetailDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}
-(void)setUI{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
    }
    return _webView;
}
//-(UITableView *)tableView {
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]init];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        _tableView.estimatedRowHeight = 245;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
//    }
//    return _tableView;
//}
//
//#pragma tableView--delegate
//#pragma tableView
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    HKDescTableViewCell*cell = [HKDescTableViewCell baseCellWithTableView:tableView];
//    cell.htmlStr = self.htmlStr;
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}
-(void)setHtmlStr:(NSString *)htmlStr{
    _htmlStr = htmlStr;
    NSString *content = [htmlStr stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>",content];
    
    
    [self.webView loadHTMLString:htmls baseURL:nil];
}
@end
