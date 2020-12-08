//
//  ARDetailViewController.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARDetailViewController.h"
#import "ARChaptersItem.h"
#import <MJExtension.h>
#import "MBProgressHUD.h"
#import "ARSqliteTool.h"

@interface ARDetailViewController ()<UIWebViewDelegate>
{
    __block NSMutableArray *chaptersArray;
}

@property (weak, nonatomic) IBOutlet UIWebView *detailWebView;
- (IBAction)attemptReadingForFree:(id)sender;
- (IBAction)addToShelf:(id)sender;
- (IBAction)buying:(id)sender;

@end

@implementation ARDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.bookName;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.detailWebView.scrollView.bounces = NO;
    self.detailWebView.delegate = self;
    
    [self detailWebViewRequest];
}

- (void)detailWebViewRequest{
    
    NSString *urlStr =  [NSString stringWithFormat:@"http://k.sogou.com/abs/ios/v3/detail?bkey=%@&s=&gender=0&cuuid=426dbaf97b0d3b1ed3791d4bb83b80c719be6300&ppid=80C5B623E2F3031DC4B1874096C54217@qq.sohu.com&versioncode=3.5.0&eid=1136",self.bkey];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.detailWebView loadRequest:request];
}

- (IBAction)attemptReadingForFree:(id)sender {
}

- (IBAction)addToShelf:(id)sender {
    //下载图片到缓存
//    [YTNetCommand downloadAndStoredImage:self.imageUrlStr imageKey:self.bookName];
//    //写入书本信息到数据库
//    [self insertBookInfoToSqlite];
//    //建立章节数据表
//    [self setupChapterTable:self.bookName];
//    //请求章节目录信息,除了bkey，其它参数和用户相关，目前先固定一个用户
//    NSString *chaptersUrlStr = [NSString stringWithFormat:@"http://k.sogou.com/s/api/ios/b/m?bkey=%@&v=0&uid=80C5B623E2F3031DC4B1874096C54217@qq.sohu.com&token=4244558c08b4ee4e9791b06cca4ec139&eid=1136",self.bkey];
//    //网络请求获取目录信息，并写入数据库
//    [self requestChapters:chaptersUrlStr];
    
}

- (IBAction)buying:(id)sender {
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


#pragma mark - 根据章节对象建立数据表，每本书一个数据表
- (void)setupChapterTable:(NSString *)bookname{
    
    NSString *sql = [NSString stringWithFormat:@"create table if not exists t_%@chapters (id integer primary key autoincrement,free text,gl text,buy text,rmb text,name text,md5 text,url text,cmd text);",self.bookName];
    
    [ARSqliteTool execWithSql:sql];
    
}
#pragma mark - 写入书本信息到数据库
- (void)insertBookInfoToSqlite{
    
    //存图片的key就是用书名，所以sql的两个参数都是bookName
    NSString *sql = [NSString stringWithFormat:@"insert into t_bookshelf (book,imagekey,bookid,md,count,author,loc,eid,bkey,token) values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",self.bookName,self.bookName,self.bookid,self.md,self.count,self.author,self.loc,self.eid,self.bkey,self.token];
    [ARSqliteTool execWithSql:sql];
}


#pragma mark -请求章节目录信息，因为返回的是非json形式，所以不能用AFN，并写入数据库
- (void)requestChapters:(NSString *)urlStr{
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 由session发起任务
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //异步解码
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //剪掉前10个数字，后面就是json了
        NSString *jsonStr = [str substringFromIndex:10];
        //json转模型 (先转Data,再转字典，然后字典转模型，)
        NSData *newData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableContainers error:nil];
        //获得所有章节对象，存入数组
        chaptersArray = [ARChaptersItem mj_objectArrayWithKeyValuesArray:[jsonDic valueForKey:@"chapter"]];
        
        for (ARChaptersItem *item in chaptersArray) {
            //写入数据库
            [self insertChaptersItemToSqlite:item.free gl:item.gl buy:item.buy rmb:item.rmb name:item.name md5:item.md5];
        }
        
    }] resume];
}

#pragma mark - 章节插入数据库
- (void)insertChaptersItemToSqlite:(NSString *)free
                                gl:(NSString *)gl
                               buy:(NSString *)buy
                               rmb:(NSString *)rmb
                              name:(NSString *)name
                               md5:(NSString *)md5

{
    
    NSString *table = [NSString stringWithFormat:@"t_%@chapters",self.bookName];
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (free,gl,buy,rmb,name,md5,url,cmd) values('%@','%@','%@','%@','%@','%@','','');",table,free,gl,buy,rmb,name,md5];
    
    [ARSqliteTool execWithSql:sql];
    
    
}
@end
