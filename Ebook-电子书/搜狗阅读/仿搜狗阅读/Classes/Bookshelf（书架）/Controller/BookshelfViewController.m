//
//  BookshelfViewController.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/2.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "BookshelfViewController.h"
#import "AppDelegate.h"
#import "XTPopView.h"
#import "YTBookItem.h"
#import "YTBookCollectionViewCell.h"
#import <UIImageView+WebCache.h>
#import "YTSqliteTool.h"
#import "YTBookstoreViewController.h"
#import "YTRegularExpression.h"
#import "YTChaptersItem.h"
#import "YTNovelContentController.h"
#import "YTDetailNobkeyViewController.h"
@interface BookshelfViewController ()<selectIndexPathDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *booksArr;
    
    NSInteger indexRow;
    BOOL deleteBtnFlag;
   __block NSString *globalMD5;
 //   __block NSString *realContent;
    
}
- (IBAction)searchBtnClick:(id)sender;
- (IBAction)iconBtnClick:(id)sender;
- (IBAction)addBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation BookshelfViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deleteBtnFlag = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self addDoubleTapGesture];
  
    [self setupDataBase];


}

- (void)viewWillAppear:(BOOL)animated{
    booksArr = [YTBookItem readDatabase];
    //添加最后一项，是一个带加号的图片
    YTBookItem *itm = [[YTBookItem alloc]init];
    itm.imageKey = @"addbtnInshelf";
    [booksArr addObject:itm];
    
    
    [self.collectionView reloadData];
    
}

#pragma mark <UICollectionViewDataSource>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(13,8,10,8);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return booksArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YTBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    YTBookItem *item = booksArr[indexPath.row];
    cell.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:item.imageKey];
    cell.bookNameView.text = item.name;
    //如果小说没有封面，就使用默认图
    if (cell.imageView.image == nil) {
        cell.imageView.image = [UIImage imageNamed:@"default_cover_blue"];
    }
    //如果是最后一项，则显示加号图
    if ([item.imageKey isEqualToString:@"addbtnInshelf"]) {
        cell.imageView.image = [UIImage imageNamed:@"addbtnInshelf"];
        
    }
    
    cell.indexPath = indexPath;
    cell.deleteBtn.hidden = deleteBtnFlag?YES:NO;
    cell.delegate =  self;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    //如果点击最后一项，就跳转到书城界面
    if (indexPath.row == booksArr.count -1 ) {
         self.tabBarController.selectedIndex = 1;
    }else{
 
        // 需要参数 id   url  md  b.a（authoer）  cmd   b.n(name)  loc  eid
        // 1.由indexPath，从数组取bookitem对象
        YTBookItem *bookitem = booksArr[indexPath.row];

        //2.根据name拼接表名，便于查询章节数据表
        NSString *tableStr = [NSString stringWithFormat:@"t_%@chapters",bookitem.name];
        //目前只读取第一章
        NSInteger pageIndex = 1;
        NSMutableArray *chaptersArray = [NSMutableArray arrayWithArray: [YTChaptersItem readOneChapterFromTable:tableStr Index:pageIndex]];
        YTChaptersItem *chapterItem = [[YTChaptersItem alloc]init];
        for (YTChaptersItem *chapter in chaptersArray) {
            chapterItem = chapter;
        }
        globalMD5 = chapterItem.md5;
      
        //有了 bookitem, chapteritem 就可以拼接url来请求数据了
        if (bookitem.bkey.length > 8) { //没有bkey的，值为"(null)" 所以长度至少要大于6 才能判断
        //有bkey
        //有bkey和没bkey请求的url不同，要分开
        // 3.从bookitem里拿 id md b.a b.m loc，这一步不用写，用在拼接url字符串里
  
            NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            //txt文件绝对路径
            NSString *TxtfilePath = [NSString stringWithFormat:@"%@/%@.txt",cacheDir,chapterItem.md5];
            NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *txt = [NSString stringWithContentsOfFile:TxtfilePath encoding:strEncode error:nil];
            YTNovelContentController *NCVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"NovelContentVC"];
            if (txt) {
                //如果有文件，则直接推送到阅读器打开
                [NCVC loadText:txt];
                [self.navigationController pushViewController:NCVC animated:YES];
            }else{
                //如果没有文件，则执行下载操作，然后打开
                NSString *urlStr = [NSString stringWithFormat:@"http://k.sogou.com/s/api/ios/b/d?v=2&count=1&bkey=%@&md5=%@&uid=80C5B623E2F3031DC4B1874096C54217@qq.sohu.com&token=4244558c08b4ee4e9791b06cca4ec139&eid=1136",bookitem.bkey,chapterItem.md5];
                [self downloadZip:urlStr];
                
            }
            

            
        }else{
         //没bkey
            NSLog(@"nobkey");
            //中文作为请求参数，需要转义
            bookitem.author = [bookitem.author stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            bookitem.name = [bookitem.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *nobkeyUrlStr = [NSString stringWithFormat:@"http://api.apt.k.sogou.com/apt/app/chapter?&id=%@&url=%@&md=%@&b.a=%@&cmd=%@&b.n=%@&loc=%@&eid=1136",bookitem.bookid,chapterItem.url,bookitem.md,bookitem.author,chapterItem.cmd,bookitem.name,bookitem.loc];
            
        [self NobkeyChapterContentRequest:nobkeyUrlStr];
            
            
            
        }

        
    }
                                            
}




- (IBAction)searchBtnClick:(id)sender {
    [YTNavAnimation NavPushAnimation:self.navigationController.view];
    UISearchController *searchVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"searchVC"];
    [[self navigationController]pushViewController:searchVC animated:NO];
}

- (IBAction)iconBtnClick:(id)sender {
    [[AppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

- (IBAction)addBtnClick:(id)sender {
    
    [self setupPopView];
    
}

- (void)selectIndexPathRow:(NSInteger)index{
    switch (index) {
        case 0:
        {
            NSLog(@"编辑");
        }
            break;
        case 1:
        {
            NSLog(@"列表模式");
        }
            break;
        case 2:
        {
            NSLog(@"本地传书");
        }
            break;

        default:
            break;
    }
}
- (void)setupPopView{
    
    CGPoint point = CGPointMake(_addBtn.center.x,_addBtn.center.y + 45);
    XTPopView *view1 = [[XTPopView alloc] initWithOrigin:point Width:130 Height:40 * 3 Type:XTTypeOfUpRight Color:[UIColor whiteColor] superView:self.view];
    view1.dataArray = @[@"编辑",@"列表模式", @"本地传书"];
    view1.images = @[@"bookShelfPopMenuedit",@"bookShelfPopMenulist", @"bookShelfPopMenuImport"];
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor blackColor];
    view1.delegate = self;
    [view1 popView];
}
- (void)hideAllDeleteBtn{
    if (!deleteBtnFlag) {
        deleteBtnFlag = YES;
        [self.collectionView reloadData];
    }
    
}
- (void)showAllDeleteBtn{
    deleteBtnFlag = NO;
    [self.collectionView reloadData];
}
- (void)handleDoubleTap:(UITapGestureRecognizer *) gestureRecognizer{
    [self hideAllDeleteBtn];
    
}
- (void)addDoubleTapGesture{
    UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubletap setNumberOfTapsRequired:2];
    [self.view addGestureRecognizer:doubletap];
}
- (void)setupDataBase{
    //    //创建表
    
    
    NSString *sql = @"create table if not exists t_bookshelf (id integer primary key autoincrement,book text,imagekey text,bookid text,md text,count text,author text,loc text,eid text,bkey text,token text);";
    [YTSqliteTool execWithSql:sql];
    
}
#pragma mark - 有bkey的书，下载zip文件并解压
- (void)downloadZip:(NSString *)urlStr{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    // 1. url
   // NSString *urlStr = @"http://k.sogou.com/s/api/ios/b/d?v=2&count=4&bkey=61A4274B5F148B7FA2A2BDA286E26587&md5=FC42F0A7EBCF5ADD2928E2AA1ED27327&uid=80C5B623E2F3031DC4B1874096C54217@qq.sohu.com&token=4244558c08b4ee4e9791b06cca4ec139&eid=1136";
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    // 2. 下载
    [[[NSURLSession sharedSession] downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        //  NSLog(@"文件的路径%@", location.path);
        
        NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //   NSLog(@"%@", cacheDir);
        /**
         FileAtPath：要解压缩的文件
         Destination: 要解压缩到的路径
         */
        [SSZipArchive unzipFileAtPath:location.path toDestination:cacheDir];
        

         NSString *downloadedTxtfilePath = [NSString stringWithFormat:@"%@/%@.txt",cacheDir,globalMD5];
         NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
         NSString *downloadedTxt = [NSString stringWithContentsOfFile:downloadedTxtfilePath encoding:strEncode error:nil];
          YTNovelContentController *NCV = [[self storyboard]instantiateViewControllerWithIdentifier:@"NovelContentVC"];
          dispatch_async(dispatch_get_main_queue(), ^{
              
        [NCV loadText:downloadedTxt];
        [self.navigationController pushViewController:NCV animated:YES];
              
        });
    }] resume];

}
#pragma mark - 针对没bkey的书，需要从两个数据表获取数据，然后拼接url。获取chapters数据表数据，使用异步方式
#pragma mark - 请求成功后，直接把内容推送到阅读器界面
- (void)NobkeyChapterContentRequest:(NSString *)urlStr{

    NSURL *url = [NSURL URLWithString:urlStr];
    // 2. 由session发起任务
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //解决中文乱码
        NSStringEncoding strEncode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //异步解码
        NSString *str = [[NSString alloc]initWithData:data encoding:strEncode];
        NSString * realContent = [YTRegularExpression getChapter:str pattern:@"(\\{).*?\\}.*?(\\})"];
       //跳转到阅读器界面,必须在主线程里执行
        dispatch_async(dispatch_get_main_queue(), ^{
            
              YTNovelContentController *NCVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"NovelContentVC"];
              [NCVC loadText:realContent];
            
              [self.navigationController pushViewController:NCVC animated:YES];
        });

    }] resume];
}


@end
