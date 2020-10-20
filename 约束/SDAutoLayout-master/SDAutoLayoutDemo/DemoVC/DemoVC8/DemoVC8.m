//
//  DemoVC8.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/22.
//  Copyright © 2015年 gsd. All rights reserved.
//

#import "DemoVC8.h"

#import "DemoVC7Model.h"

#import "DemoVC7Cell.h"
#import "DemoVC7Cell2.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "UIView+SDAutoLayout.h"

#import "SDRefresh.h"

@interface DemoVC8 ()

@property (nonatomic, strong) NSMutableArray *modelsArray;

@end

@implementation DemoVC8
{
    SDRefreshFooterView *_refreshFooter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.estimatedRowHeight = 100;
    
    [self creatModelsWithCount:18];
    
    [self.tableView registerClass:[DemoVC7Cell class] forCellReuseIdentifier:NSStringFromClass([DemoVC7Cell class])];
    [self.tableView registerClass:[DemoVC7Cell2 class] forCellReuseIdentifier:NSStringFromClass([DemoVC7Cell2 class])];
    
    __weak typeof(self) weakSelf = self;
    
    // 上拉加载
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    __weak typeof(_refreshFooter) weakRefreshFooter = _refreshFooter;
    _refreshFooter.beginRefreshingOperation = ^() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf creatModelsWithCount:10];
            [weakSelf.tableView reloadData];
            [weakRefreshFooter endRefreshing];
        });
    };
    
}

- (void)creatModelsWithCount:(NSInteger)count
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray new];
    }
    
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的LaunchImage 时。然后等比例拉伸",
                           @"然后等比例拉伸到大屏。屏幕宽度返回 320否则在大屏上会显得字大",
                           @"长期处于这种模式下，否则在大屏上会显得字大，内容少这种情况下对界面不会",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任小。"
                           ];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        
        DemoVC7Model *model = [DemoVC7Model new];
        model.title = textArray[nameRandomIndex];
        
        
        // 模拟“有或者无图片”
        int random = arc4random_uniform(100);
        if (random <= 30) {
            NSMutableArray *temp = [NSMutableArray new];
            
            for (int i = 0; i < 3; i++) {
                int randomIndex = arc4random_uniform(5);
                NSString *text = iconImageNamesArray[randomIndex];
                [temp addObject:text];
            }
            
            model.imagePathsArray = [temp copy];
        } else {
            model.imagePathsArray = @[iconImageNamesArray[iconRandomIndex]];
        }
        
        [self.modelsArray addObject:model];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Class currentClass = [DemoVC7Cell class];
    DemoVC7Cell *cell = nil;
    
    DemoVC7Model *model = self.modelsArray[indexPath.row];
    
    if (model.imagePathsArray.count > 1) {
        currentClass = [DemoVC7Cell2 class];
    }
    cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(currentClass)];
    
    cell.model = model;
    
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    ///////////////////////////////////////////////////////////////////////
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应设置 * >>>>>>>>>>>>>>>>>>>>>>>>
    // 只需一行代码即可实现单cell以及多cell的tableview高度自适应
    
    // 此升级版方法适用于cell的model有多个的情况下,性能比普通版稍微差一些,不建议在数据量大的tableview中使用,推荐使用“cellHeightForIndexPath:model:keyPath:cellClass:contentViewWidth:”方法同样是一步设置即可完成
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[self cellContentViewWith]];
}




- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}


@end
