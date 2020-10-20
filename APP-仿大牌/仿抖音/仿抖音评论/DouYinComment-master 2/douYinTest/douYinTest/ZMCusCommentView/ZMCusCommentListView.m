//
//  ZMCusCommentListView.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import "ZMCusCommentListView.h"
#import "ZMCusCommentBottomView.h"
#import "ZMCusCommentListTableHeaderView.h"
#import "ZMCusCommentListContentCell.h"
#import "ZMCusCommentListReplyContentCell.h"
#import "LKCommentListContentCell.h"
#import "LKCommentListReplyContentCell.h"
#import "LKMoreReplyContentTableViewCell.h"
#import "ZMColorDefine.h"
#import "UITableViewCell+FSAutoCountHeight.h"
#import "LKContentModel.h"
#import <Masonry.h>

@interface ZMCusCommentListView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ZMCusCommentBottomView *bottomView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZMCusCommentListTableHeaderView *headerView;
/** 模型数组 */
@property (nonatomic, strong) NSMutableArray *modelArr;
@end


@implementation ZMCusCommentListView

- (NSMutableArray *)modelArr
{
    if (_modelArr == nil)
    {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBHexColor(0xffffff, 1);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15;
        
        // 接收通知数据 PUSHCONTENTDATA
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataClick:) name:@"PUSHCONTENTDATA" object:nil];
        
        [self layoutUI];
        
    }
    return self;
}
- (void)layoutUI{
    
    // 创建头视图
    if (!_headerView) {
        _headerView = [[ZMCusCommentListTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 70)];
        @weakify(self)
        _headerView.closeBtnBlock = ^{
            @strongify(self)
            if (self.closeBtnBlock) {
                self.closeBtnBlock();
            }
        };
        [self addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.and.right.mas_equalTo(0);
            make.height.mas_offset(70);
        }];
    }


    
    // 创建表格
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 10000;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(70,0, ZMCusComentBottomViewHeight+ZMCusCommentViewTopHeight+SAFE_AREA_BOTTOM, 0));
        }];
    }
    
    
    if (!_bottomView) {
        _bottomView = [[ZMCusCommentBottomView alloc] init];
        @weakify(self)
        _bottomView.tapBtnBlock = ^{
            @strongify(self)
            if (self.tapBtnBlock) {
                self.tapBtnBlock();
            }
        };
        [self addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(ZMCusCommentViewTopHeight+SAFE_AREA_BOTTOM));
            make.left.and.right.mas_equalTo(0);
            make.height.mas_offset(ZMCusComentBottomViewHeight);
        }];
    }
    
}

// 通知方法 刷新数据
- (void)dataClick:(NSNotification *)notification
{
    NSArray *arr = notification.userInfo[@"data"];
    [self.modelArr addObjectsFromArray:arr];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UITableViewDataSource, UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 返回有多少组 就是返回有多少主回复
    
    //NSLog(@"返回%d组", self.modelArr.count);
    return self.modelArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    // 返回每组多少行 就是返回主回复+子回复+点击更多
    
    NSInteger count = 1; // 主要回复一个
    LKContentModel *model = self.modelArr[section]; // 这里取出每组第一个数据
    NSLog(@"当前主回复需要展示的子回复行数 %ld 最大子回复数 %ld", (long)model.nowReplayCount, (long)model.maxReplayCount);
    if (model.maxReplayCount == 0) // || model.nowReplayCount == model.maxReplayCount
    {
        // 没有子回复 或者当前已显示回复数量和最大回复数量一致 不显示更多按钮
        
        // 设置是否为 点击展示更多 行
        //model.isMoreCell = NO;
        // 更新数据
        //[self.modelArr replaceObjectAtIndex:section withObject:model];
        
        // 返回一个主回复
        //NSLog(@"返回一个主回复");
        return count;
    }
    if (model.maxReplayCount == 1)
    {
        // 只有一条子回复 不显示更多按钮 更新已显示回复数量
        model.nowReplayCount = 1;
        // 设置是否为 点击展示更多 行
        //model.isMoreCell = NO;
        // 更新数据
        [self.modelArr replaceObjectAtIndex:section withObject:model];
        // 返回主回复和一个子回复
        //NSLog(@"返回主回复和一个子回复");
        return count + model.maxReplayCount;
    }
    if (model.maxReplayCount > 1)
    {
        
        // 如果当前实现行不是0  那么在当前显示行后面+1 为点击展示更多行
        if (model.nowReplayCount != 0)
        {
            NSMutableArray *arr = [NSMutableArray array];
            [arr addObjectsFromArray:model.replay];
            NSInteger rePlayCount = arr.count; // 获得子回复的总个数
            
            if (model.nowReplayCount < rePlayCount)
            {
                // 如果当前显示行数比总子回复个数要少 取出当前显示行数 将其标志变为展示更多
                NSInteger indexP = model.nowReplayCount;
                LKContentModel *modelReplay = arr[indexP]; // 这里取出要变身的子回复
                // 设置 点击展示更多 行
                modelReplay.isMoreCell = YES;
                // 更新数据
                [arr replaceObjectAtIndex:indexP withObject:modelReplay];
                model.replay = arr;
                [self.modelArr replaceObjectAtIndex:section withObject:model];
            }
            
            // 如果当前展示行要比总展示行打 说明点击了查看更多 但是更多不足5个 所以要隐藏查看更多行
            if (model.nowReplayCount > rePlayCount || model.nowReplayCount == model.maxReplayCount)
            {
                // NSLog(@"如果当前展示行要比总展示行打 说明点击了查看更多 但是更多不足5个 所以要隐藏查看更多行");
                // 返回主回复 + 所有子回复 (子回复会多一个导致数组越界)
                return count + rePlayCount - 1;
            }
        }
        
        // 有多条子回复 并且当前已显示的回复数量和最大回复数量不一致 显示更多按钮 更新已显示回复数量(这里只有已显示回复数量为0时才更新 之后更新需要通过点击显示更多来更新)
        if (model.nowReplayCount == 0)
        {
            model.nowReplayCount = 1;
            // 设置是否为 点击展示更多 行
            //model.isMoreCell = NO;
            // 更新数据
            [self.modelArr replaceObjectAtIndex:section withObject:model];
        }
        // 返回主回复 和 当前回复数 和 一个查看更多按钮
        //NSLog(@"返回主回复 和 当前回复数 和 一个查看更多按钮");
        return count + model.nowReplayCount + 1;
    }
    //NSLog(@"返回0主回复");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // 每个第一行都是主回复 其他为子回复 只有有更多标志的为点击查看更多
    
    LKContentModel *model = self.modelArr[indexPath.section];// 取出主回复
    
    if (indexPath.row == 0) {
        // 主回复
        
        // 通过不同标识创建cell实例
        LKCommentListContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LKCommentListContentCell" owner:self options:nil] lastObject];
        }
        [cell configData:model];
        
        return cell;
    } else {
        // 子回复
        
        // 获取子回复数据
        NSArray *arr = model.replay;
        LKContentModel *rePlayModel = arr[indexPath.row - 1]; // 减去多出来的主回复
        
        if (!rePlayModel.isMoreCell)
        {
            // 二级回复
            
            LKCommentListReplyContentCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
            if (!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LKCommentListReplyContentCell" owner:self options:nil] lastObject];
            }
            [cell configData:rePlayModel];
            
            
            return cell;
            
        } else {
            // 点击展开更多
            
            // 通过不同标识创建cell实例
            LKMoreReplyContentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            // 判断为空进行初始化  --（当拉动页面显示超过主页面内容的时候就会重用之前的cell，而不会再次初始化）
            if (!cell)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"LKMoreReplyContentTableViewCell" owner:self options:nil] lastObject];
            }
            
            return cell;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [LKCommentListContentCell FSCellHeightForTableView:tableView indexPath:indexPath cellContentViewWidth:0 bottomOffset:0];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 点击事件
    
    // 拦截点击 展开更多回复
    if (indexPath.row > 1)
    {
        // 大于2表明有可能是 点击查看更多
        LKContentModel *model = self.modelArr[indexPath.section]; // 取出主回复数据
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObjectsFromArray:model.replay];
        LKContentModel *rePlayModel = arr[indexPath.row - 1]; // 取出子回复数据
        if (rePlayModel.isMoreCell)
        {
            // 点击展开更多
            NSLog(@"点击展开更多");
            // 上面已经拿到了当前数据
            // 先移除当前cell的更多标志
            rePlayModel.isMoreCell = NO;
            // 在当前展开行数上+5
            model.nowReplayCount = model.nowReplayCount + 5;
            // 如果还有未展开
            if (model.nowReplayCount < model.maxReplayCount)
            {
                // 则在后面一行再加上更多标志
                LKContentModel *rePlayMoreModel = arr[model.nowReplayCount]; // 取出子回复数据
                rePlayMoreModel.isMoreCell = YES;
                [arr replaceObjectAtIndex:model.nowReplayCount withObject:rePlayMoreModel];
            }
            // 更新数据
            [arr replaceObjectAtIndex:indexPath.row - 1 withObject:rePlayModel];
            model.replay = arr;
            [self.modelArr replaceObjectAtIndex:indexPath.section withObject:model];
            // 刷新cell
            [self.tableView reloadData];
        }
    }
    
}

@end
