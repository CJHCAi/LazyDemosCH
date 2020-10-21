//
//  ViewController.m
//  06-掌握-多图片下载
//
//  Created by xiaomage on 15/7/9.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGApp.h"

@interface ViewController ()
/** 所有数据 */
@property (nonatomic, strong) NSArray *apps;

/** 内存缓存的图片 */
@property (nonatomic, strong) NSMutableDictionary *images;

/** 所有的操作对象 */
@property (nonatomic, strong) NSMutableDictionary *operations;

/** 队列对象 */
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation ViewController

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (NSMutableDictionary *)operations
{
    if (!_operations) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableDictionary *)images
{
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSArray *)apps
{
    if (!_apps) {
        NSArray *dictArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil]];
        
        NSMutableArray *appArray = [NSMutableArray array];
        for (NSDictionary *dict in dictArray) {
            [appArray addObject:[XMGApp appWithDict:dict]];
        }
        _apps = appArray;
    }
    return _apps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    self.images = nil;
    self.operations = nil;
    [self.queue cancelAllOperations];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.apps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"app";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    XMGApp *app = self.apps[indexPath.row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.download;
    
    // 先从内存缓存中取出图片
    UIImage *image = self.images[app.icon];
    if (image) { // 内存中有图片
        cell.imageView.image = image;
    } else {  // 内存中没有图片
        // 获得Library/Caches文件夹
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        // 获得文件名
        NSString *filename = [app.icon lastPathComponent];
        // 计算出文件的全路径
        NSString *file = [cachesPath stringByAppendingPathComponent:filename];
        // 加载沙盒的文件数据
        NSData *data = [NSData dataWithContentsOfFile:file];
        
        if (data) { // 直接利用沙盒中图片
            UIImage *image = [UIImage imageWithData:data];
            cell.imageView.image = image;
            // 存到字典中
            self.images[app.icon] = image;
        } else { // 下载图片
            cell.imageView.image = [UIImage imageNamed:@"placeholder"];
            
            NSOperation *operation = self.operations[app.icon];
            if (operation == nil) { // 这张图片暂时没有下载任务
                operation = [NSBlockOperation blockOperationWithBlock:^{
                    // 下载图片
                    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:app.icon]];
                    // 数据加载失败
                    if (data == nil) {
                        // 移除操作
                        [self.operations removeObjectForKey:app.icon];
                        return;
                    }
                    
                    UIImage *image = [UIImage imageWithData:data];
                    
                    // 存到字典中
                    self.images[app.icon] = image;
                    
                    // 回到主线程显示图片
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    // 将图片文件数据写入沙盒中
                    [data writeToFile:file atomically:YES];
                    // 移除操作
                    [self.operations removeObjectForKey:app.icon];
                }];
                
                // 添加到队列中
                [self.queue addOperation:operation];
                
                // 存放到字典中
                self.operations[app.icon] = operation;
            }
        }
    }
    
    return cell;
}


//    [NSDate date];
//    获得文件属性
//    [[NSFileManager defaultManager] attributesOfItemAtPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>];
//    删除文件
//    [[NSFileManager defaultManager] removeItemAtPath:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>];

/*
 Documents
 Library
    - Caches
    - Preference
 tmp
 */
@end
