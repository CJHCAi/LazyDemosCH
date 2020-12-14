//
//  ARDetailNobkeyViewController.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARDetailNobkeyViewController.h"
#import "ARChaptersItem.h"
#import <MJExtension.h>
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "ARSqliteTool.h"

@interface ARDetailNobkeyViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *detailNobekyWebView;
- (IBAction)addToShelf:(id)sender;
- (IBAction)startReading:(id)sender;

@end

@implementation ARDetailNobkeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.bookName;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.detailNobekyWebView.scrollView.bounces = NO;
    self.detailNobekyWebView.delegate = self;
    
    [self detailNobekyWebViewRequest];
    
}

- (void)detailNobekyWebViewRequest{
    NSString *urlStr =  [NSString stringWithFormat:@"http://k.sogou.com/abs/ios/v3/pirated?md=%@&shelfmd=&cuuid=426dbaf97b0d3b1ed3791d4bb83b80c719be6300&ppid=80C5B623E2F3031DC4B1874096C54217@qq.sohu.com&versioncode=3.5.0&eid=1136",self.md];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.detailNobekyWebView loadRequest:request];
    
}

- (IBAction)addToShelf:(id)sender {
    //下载图片到缓存
//    [YTNetCommand downloadAndStoredImage:self.imageUrlStr imageKey:self.bookName];
//    //写入书本信息，用于collectionView的显示
//    [self insertBookInfoToSqlite];
//
//    //要先建表，再请求数据，写入表,目录数据，用于请求小说具体内容
//    [self setupChapterTable:self.bookName];
//
//    [self menuRequest];
    
}

- (IBAction)startReading:(id)sender {
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - 请求目录数据，并写入数据库
- (void)menuRequest{
    NSDictionary *param = @{@"id":self.bookid,
                            @"md":self.md,
                            @"b.a":self.author,
                            @"b.n":self.bookName,
                            @"uid":@"80C5B623E2F3031DC4B1874096C54217@qq.sohu.com",
                            @"token":@"4244558c08b4ee4e9791b06cca4ec139",
                            @"eid":@"1136"
                            };
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET  :menuNobkeyUrl
//        parameters:param
//           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//               NSArray *tempArr = [YTChaptersItem mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"chapter"]];
//               //写入数据库
//               for (YTChaptersItem *itm in tempArr) {
//                   [self insertChaptersItemToSqlite:itm.name url:itm.url cmd:itm.cmd];
//               }
//               
//           }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//               NSLog(@"%@",error);
//               
//           }];
    
}


- (void)insertBookInfoToSqlite{
    //存图片的key就是用书名，所以sql的两个参数都是bookName
    
    NSString *sql = [NSString stringWithFormat:@"insert into t_bookshelf (book,imagekey,bookid,md,count,author,loc,eid,bkey,token) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",self.bookName,self.bookName,self.bookid,self.md,self.count,self.author,self.loc,self.eid,self.bkey,self.token];
    
    [ARSqliteTool execWithSql:sql];
}

- (void)setupChapterTable:(NSString *)bookname{
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists t_%@chapters (id integer primary key autoincrement,free text,gl text,buy text,rmb text,name text,md5 text,url text,cmd text);",self.bookName];
    
    [ARSqliteTool execWithSql:sql];
    
}
#pragma mark - 章节插入数据库
- (void)insertChaptersItemToSqlite:(NSString *)chapterName  url:(NSString *)url cmd:(NSString *)cmd{
    
    NSString *table = [NSString stringWithFormat:@"t_%@chapters",self.bookName];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (name,url,cmd,free,gl,buy,rmb,md5) values('%@','%@','%@','','','','','');",table,chapterName,url,cmd];
    
    [ARSqliteTool execWithSql:sql];
    
    
}
@end
