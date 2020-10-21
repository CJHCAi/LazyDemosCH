//
//  ViewController.m
//  DemoImageBrowser
//
//  Created by zhangshaoyu on 16/11/17.
//  Copyright © 2016年 zhangshaoyu. All rights reserved.
//

#import "ViewController.h"
#import "ImageRunloopVC.h"
#import "ImageNormalVC.h"
#import "ImageRunloopTableVC.h"
#import "ImageBrowserVC.h"
#import "SYImageBrowser.h"
#import "AppDelegate.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, SYImageBrowserDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) SYImageBrowser *imageModalView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"图片浏览";
    
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

- (void)setUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    tableView.delegate = self;
    tableView.dataSource = self;

    [tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    NSString *text = nil;
    switch (indexPath.row)
    {
        case 0: text = @"非循环广告轮播"; break;
        case 1: text = @"循环广告轮播"; break;
        case 2: text = @"循环广告轮播结合table使用"; break;
        case 3: text = @"图片浏览"; break;
        case 4: text = @"图片浏览弹窗"; break;
            
        default: break;
    }
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.row)
    {
        ImageNormalVC *nextVC = [[ImageNormalVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (1 == indexPath.row)
    {
        ImageRunloopVC *nextVC = [[ImageRunloopVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (2 == indexPath.row)
    {
        ImageRunloopTableVC *nextVC = [[ImageRunloopTableVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (3 == indexPath.row)
    {
        ImageBrowserVC *nextVC = [[ImageBrowserVC alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else if (4 == indexPath.row)
    {
        self.imageModalView.images = self.images;
//        self.imageModalView.images = @[@"01.jpeg"];
        self.imageModalView.deletage = self;
        [self.imageModalView reloadData];
    }
}

- (NSArray *)images
{
    if (_images == nil)
    {
        _images = @[@"01.jpeg", @"02.jpeg", @"03.jpeg", @"04.jpeg", @"05.jpeg", @"06.jpeg"];
    }
    return _images;
}

- (SYImageBrowser *)imageModalView
{
    if (_imageModalView == nil)
    {
        UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
        
        _imageModalView = [[SYImageBrowser alloc] initWithFrame:CGRectMake(0.0, 0.0, window.frame.size.width, window.frame.size.height)];
        _imageModalView.backgroundColor = [UIColor whiteColor];
        _imageModalView.contentMode = UIViewContentModeScaleAspectFit;
        _imageModalView.pageControlType = UIImagePageLabel;
        _imageModalView.pageIndex = 3;
        _imageModalView.isBrowser = YES;
        _imageModalView.hiddenWhileSinglePage = YES;
        _imageModalView.imageBrowserDidScroll = ^(NSInteger index) {
            NSLog(@"block index = %@", @(index));
        };
        
        [window addSubview:_imageModalView];
    }
    return _imageModalView;
}

- (void)imageBrowserDidScroll:(NSInteger)index
{
    NSLog(@"delegate index = %@", @(index));
}

@end
