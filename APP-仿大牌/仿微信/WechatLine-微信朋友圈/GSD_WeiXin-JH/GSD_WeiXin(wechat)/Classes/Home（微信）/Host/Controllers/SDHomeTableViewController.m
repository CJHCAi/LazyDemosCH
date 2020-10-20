//
//  SDHomeTableViewController.m
//  GSD_WeiXin(wechat)
//
//  Created by aier on 16/2/10.
//  Copyright © 2016年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 362419100(2群) 459274049（1群已满）
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import "SDHomeTableViewController.h"

#import "SDAnalogDataGenerator.h"

#import "UIView+SDAutoLayout.h"

#import "SDHomeTableViewCell.h"
#import "SDEyeAnimationView.h"
#import "SDShortVideoController.h"
#import "SDChatTableViewController.h"

#define kHomeTableViewControllerCellId @"HomeTableViewController"

#define kHomeObserveKeyPath @"contentOffset"

const CGFloat kHomeTableViewAnimationDuration = 0.25;

#define kCraticalProgressHeight 80

@interface SDHomeTableViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) SDEyeAnimationView *eyeAnimationView;

@property (nonatomic, strong) SDShortVideoController *shortVideoController;

@property (nonatomic, assign) BOOL tableViewIsHidden;

@property (nonatomic, assign) CGFloat tabBarOriginalY;
@property (nonatomic, assign) CGFloat tableViewOriginalY;


@end

@implementation SDHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = [SDHomeTableViewCell fixedHeight];
    
    [self setupDataWithCount:10];
    
    [self.tableView registerClass:[SDHomeTableViewCell class] forCellReuseIdentifier:kHomeTableViewControllerCellId];
    
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.eyeAnimationView) {
        [self setupEyeAnimationView];
        
        self.tabBarOriginalY = self.navigationController.tabBarController.tabBar.top;
        self.tableViewOriginalY = self.tableView.top;
    }
    
    if (!self.shortVideoController) {
        self.shortVideoController = [SDShortVideoController new];
        [self.tableView.superview insertSubview:self.shortVideoController.view atIndex:0];
        __weak typeof(self) weakSelf = self;
        [self.shortVideoController setCancelOperratonBlock:^{
            [weakSelf startTableViewAnimationWithHidden:NO];
        }];
    }
    
}
/**眼睛View*/
- (void)setupEyeAnimationView
{
    SDEyeAnimationView *view = [SDEyeAnimationView new];
    view.bounds = CGRectMake(0, 0, 65, 44);
    view.center = CGPointMake(self.view.bounds.size.width * 0.5, 70);
    [self.tableView.superview insertSubview:view atIndex:0];
    self.eyeAnimationView = view;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    pan.delegate = self;
    [self.tableView.superview addGestureRecognizer:pan];
    
}
/**开启眼睛动画*/
- (void)performEyeViewAnimation
{
    CGFloat height = kCraticalProgressHeight;
    CGFloat progress = -(self.tableView.contentOffset.y + 64) / height;
    if (progress > 0) {
        self.eyeAnimationView.progress = progress;
    }
    
}


- (void)panView:(UIPanGestureRecognizer *)pan
{
    
    if (self.tableView.contentOffset.y < -64) {
        [self performEyeViewAnimation];
    }
    
    CGPoint point = [pan translationInView:pan.view];
    [pan setTranslation:CGPointZero inView:pan.view];
    
    if (self.tableViewIsHidden && ![self.shortVideoController isRecordingVideo]) {
        CGFloat tabBarTop = self.navigationController.tabBarController.tabBar.top;
        CGFloat maxTabBarY = [UIScreen mainScreen].bounds.size.height + self.tableView.height;
        if (!(tabBarTop > maxTabBarY && point.y > 0)) {
            self.tableView.top += point.y;
            self.navigationController.tabBarController.tabBar.top += point.y;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.tableView.contentOffset.y < - (64 + kCraticalProgressHeight) && !self.tableViewIsHidden) {
            [self startTableViewAnimationWithHidden:YES];
        } else if (self.tableViewIsHidden) {
            BOOL shouldHidde = NO;
            if (self.tableView.top > [UIScreen mainScreen].bounds.size.height - 150) {
                shouldHidde = YES;
            }
            [self startTableViewAnimationWithHidden:shouldHidde];
        }
        
    }
}



#pragma mark-获取数据
- (void)setupDataWithCount:(NSInteger)count
{
    for (int i = 0; i < count; i++) {
        SDHomeTableViewCellModel *model = [SDHomeTableViewCellModel new];
        model.imageName = [SDAnalogDataGenerator randomIconImageName];
        model.name = [SDAnalogDataGenerator randomName];
        model.message = [SDAnalogDataGenerator randomMessage];
        [self.dataArray addObject:model];
    }
}



#pragma mark - tableview delegate and datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHomeTableViewControllerCellId];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [SDChatTableViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView的显示与隐藏
- (void)startTableViewAnimationWithHidden:(BOOL)hidden
{
    CGFloat tableViewH = self.tableView.height;
    CGFloat tabBarY = 0;
    CGFloat tableViewY = 0;
    if (hidden) {
        tabBarY = tableViewH + self.tabBarOriginalY;
        tableViewY = tableViewH + self.tableViewOriginalY;
    } else {
        tabBarY = self.tabBarOriginalY;
        tableViewY = self.tableViewOriginalY;
    }
    [UIView animateWithDuration:kHomeTableViewAnimationDuration animations:^{
        self.tableView.top = tableViewY;
        self.navigationController.tabBarController.tabBar.top = tabBarY;
        self.navigationController.navigationBar.alpha = (hidden ? 0 : 1);
    } completion:^(BOOL finished) {
        self.eyeAnimationView.hidden = hidden;

    }];
    if (!hidden) {
        [self.shortVideoController hidde];
    } else {
        [self.shortVideoController show];
    }
    self.tableViewIsHidden = hidden;
}


#pragma mark-UIGestureRecognizerDelegate,
/**是否允许同时识别*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
    
    if (!self.tableView.isDragging) return;
    if (![keyPath isEqualToString:kHomeObserveKeyPath] || self.tableView.contentOffset.y > 0) return;
    
    CGFloat height = 80.0;
    CGFloat progress = -(self.tableView.contentOffset.y + 64) / height;
    if (progress > 0) {
        self.eyeAnimationView.progress = progress;
    }
}

@end
