//
//  ZHLrcView.m
//  QQMusic
//
//  Created by niugaohang on 15/9/11.
//  Copyright (c) 2015年 niu. All rights reserved.
//

#import "ZHLrcView.h"
#import "Masonry.h"
#import "ZHLrcTool.h"
#import "ZHLrcline.h"
#import "ZHLrcCell.h"
#import "ZHLrcLabel.h"

@interface ZHLrcView() <UITableViewDataSource>

/** 显示歌词View */
@property (nonatomic, weak) UITableView *tableView;

/** 歌词的数据 */
@property (nonatomic, strong) NSArray *lrclist;

/** 当前正在播放的歌词的下标 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ZHLrcView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupTableView];
    }
    return self;
}


- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight = 44;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(self.bounds.size.width);
        make.width.equalTo(self.mas_width);
        make.right.equalTo(self.mas_right);
    }];
    
    // 设置多余的滑动区域
    self.tableView.contentInset = UIEdgeInsetsMake(self.bounds.size.height * 0.5, 0, self.bounds.size.height * 0.5, 0);
     _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 重写setLrcname的方法
- (void)setLrcname:(NSString *)lrcname
{
    _lrcname = [lrcname copy];
    
    // 解析歌词
    self.lrclist = [ZHLrcTool lrcToolWithLrcname:lrcname];
    
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark - 实现tableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrclist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0.创建Cell
    ZHLrcCell *cell = [ZHLrcCell lrcCellWithTableView:tableView];
    
    if (indexPath.row == self.currentIndex) {
        cell.lrcLabel.font = [UIFont systemFontOfSize:18];
    } else {
        cell.lrcLabel.font = [UIFont systemFontOfSize:16.0];
        cell.lrcLabel.progress = 0;
    }
    
    // 1.取出歌词
    ZHLrcline *lrcline = self.lrclist[indexPath.row];
    
    // 2.给cell设置数据
    cell.lrcLabel.text = lrcline.text;
    
    return cell;
}

#pragma mark - 重写setCurrentTime方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    _currentTime = currentTime;
    
    // 1.和数组中歌词的时间对比,找出应该显示的歌词
    NSInteger count = self.lrclist.count;
    for (int i = 0; i < count; i++) {
        // 2.取出当前句的歌词
        ZHLrcline *lrcline = self.lrclist[i];
        
        // 3.取出下一句歌词
        NSInteger nextIndex = i + 1;
        if (nextIndex > count - 1) return;
        ZHLrcline *nextLrcline = self.lrclist[nextIndex];
        
        // 4.让当前播放时间和当前句歌词的时间和下一句歌词的时间对比,如果当前时间大于等于当前句歌词的时间,并且小于下一句歌词的时间,显示该句歌词
        // 03:25.84
        /*
         [00:48.15]你是我的小呀小苹果儿
         [00:51.92]怎么爱你都不嫌多
         
         [00:48.15]-->[00:51.92]
         [00:51.92] - [00:48.15] / [00:51.92] - [00:48.15]
         */
        if (currentTime >= lrcline.time && currentTime < nextLrcline.time && self.currentIndex != i) {
            // 4.1.获取前一句播放歌词的NSIndexPath
            NSMutableArray *indexs = [NSMutableArray array];
            if (self.currentIndex < count - 1) {
                NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
                [indexs addObject:previousIndexPath];
            }
            
            // 4.2.记录当前播放句的下标值
            self.currentIndex = i;
            
            // 4.3.获取当前句的NSIndexPath
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexs addObject:indexPath];
            
            // 4.4.刷新歌词
            [self.tableView reloadRowsAtIndexPaths:indexs withRowAnimation:UITableViewRowAnimationNone];
            
            // 4.5.让tableView的当前播放的句,滚动中间位置
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
            // 4.6.改变外面歌词Label显示的文字
            self.lrcLabel.text = lrcline.text;
        }
        
        // 如果正在更新某一句歌词
        if (self.currentIndex == i) {
            // 1.取出i位置的cell
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ZHLrcCell *cell = (ZHLrcCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            // 2.更新cell中的lrcLabel的进度
            cell.lrcLabel.progress = (currentTime - lrcline.time) / (nextLrcline.time - lrcline.time);
            
            // 3.改变外面歌词Label显示的进度
            self.lrcLabel.progress = (currentTime - lrcline.time) / (nextLrcline.time - lrcline.time);
        }
    }
}

@end

