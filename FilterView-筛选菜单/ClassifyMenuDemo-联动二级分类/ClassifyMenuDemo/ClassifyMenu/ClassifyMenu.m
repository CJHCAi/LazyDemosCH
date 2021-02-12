//
//  ClassifyMenu.m
//  明医智
//
//  Created by LiuLi on 2019/1/28.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "ClassifyMenu.h"
#import "CMTableView.h"
#import "CMEdgeListHeadView.h"
#import "CMEdgeListCell.h"
#import "CMSubListHeadView.h"
#import "CMSubListCell.h"

/* 第一级是否被点击*/
static BOOL isHeaderViewSelected = NO;

/* 第二级是否被点击*/
static BOOL isSubSelected = NO;

@interface ClassifyMenu() <UITableViewDelegate, UITableViewDataSource, CMTableViewDelegate, CMEdgeListHeadViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,copy) ChooseResult chooseResult;
@property (nonatomic,copy) CloseMenuAction closeMenuAction;

@property (nonatomic, strong) CMTableView *tableView;
/* 一级标题*/
@property (nonatomic, strong) CMEdgeListHeadView *headerView;
/* 二三级的cell*/
@property (nonatomic, strong) CMEdgeListCell *childCell;

@property (nonatomic, strong) UICollectionView *collectionView;
/**  总结点包含一级 二级三级  */
@property (nonatomic,strong) CMNode *rootNode;
/** 当前展示的一级（用于右侧展示）  */
@property (nonatomic,strong) CMNode *currentFirstNode;

@end

@implementation ClassifyMenu

- (instancetype)initWithFrame:(CGRect)frame
                     rootNode:(CMNode *)rootNode
                 chooseResult:(ChooseResult)chooseResult
              closeMenuAction:(CloseMenuAction)closeMenuAction {
    if (self = [super initWithFrame:frame]) {
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.backgroundColor = [UIColor whiteColor];
        self.hidden = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(kNavHeight);
            make.height.mas_equalTo(0);
        }];
        self.chooseResult = chooseResult;
        self.closeMenuAction = closeMenuAction;
        self.rootNode = rootNode;
        self.currentFirstNode = [self getCurrentFirstNode:rootNode];
        [self.tableView reloadData];
        [self.collectionView performBatchUpdates:^{
            //刷新操作
        } completion:^(BOOL finished) {
            //刷新完成，其他操作
            for (int i=0; i<self.rootNode.subNodes.count; i++) {
                CMNode *firstNode = self.rootNode.subNodes[i];
                if (firstNode.isChoosed) {
                    for (int j=0; j<firstNode.subNodes.count; j++) {
                        CMNode *secondNode = firstNode.subNodes[j];
                        if (secondNode.isChoosed) {
                            // 左侧选中默认选中的位置
                            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i] animated:YES scrollPosition:UITableViewScrollPositionNone];
                            // 右侧滚动到之前选中的位置
                            CMSubListHeadView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CMSubListHeadView" forIndexPath:[NSIndexPath indexPathForRow:0 inSection:j]];
                            [self.collectionView setContentOffset:headerView.frame.origin];
                            break;
                        }
                    }
                    break;
                }
            }
        }];
    }
    return self;
}

- (void)show {
    self.hidden = NO;
    self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    [UIView animateWithDuration:0.3 animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(SCREEN_H-kNavHeight-TabBarH);
        }];
    }];
}

- (void)close {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    } completion:^(BOOL finished) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (CMNode *)getCurrentFirstNode:(CMNode *)rootNode {
    __block CMNode *cFirstNode;
    [rootNode.subNodes enumerateObjectsUsingBlock:^(CMNode *firstNode, NSUInteger idx, BOOL * _Nonnull stop) {
        if (firstNode.isChoosed) {
            cFirstNode = firstNode;
            *stop = YES;
        }
    }];
    return cFirstNode==nil ? rootNode.subNodes.firstObject : cFirstNode;
}

#pragma mark UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableView numberOfSectionsInTreeView:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableView treeView:self.tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50*Rate;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[CMEdgeListHeadView alloc] initWithFrame:CGRectMake(0, 0, 125*Rate, 50*Rate)];
    self.headerView.delegate = self;
    self.headerView.tag = 1000+section;
    
    CMNode *subNode = self.tableView.rootNode.subNodes[section];
    self.headerView.node = subNode;
    return self.headerView;
}

#pragma mark 一级标题的点击事件
- (void)tapHeadView:(CMEdgeListHeadView *)headView {
    NSUInteger tag = headView.tag - 1000;
    [self firstInSectionHead:headView];
    [self.tableView expandNodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
    CMNode *node = self.tableView.rootNode.subNodes[tag];

    // 点击哪一个一级 当前展开哪一个（已展开的合并 未展开则展开） 右侧currentFirstNode对应变化刷新
    [self resetFirstNodes:tag];
    [self.tableView reloadData];
    if (node.subNodes.count > 0) {
        // 左侧选中默认选中的位置
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:tag] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    // 右侧菜单的展示
    self.currentFirstNode = node;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0, 0)];
}

// 第一级点击事件UI的处理
- (void)firstInSectionHead:(CMEdgeListHeadView *)headView {
    //        NSLog(@"一级标题点击第%ld个", headView.tag-1000);
    CMNode *subNode = self.tableView.rootNode.subNodes[headView.tag - 1000];
    if (subNode.subNodes.count < 1) {
        // 无二级 不可展开 事件终止
        self.chooseResult(subNode);
        [self close];
    }else {
        // 点击左侧 切换右侧展示对应的数据
        self.currentFirstNode = subNode;
        [self.collectionView reloadData];
        
        [UIView animateWithDuration:0.2 animations:^{
            // 是否展开
            isHeaderViewSelected = !isHeaderViewSelected;
            CMNode *subNode = self.tableView.rootNode.subNodes[headView.tag - 1000];
            headView.node = subNode;
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50*Rate;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CMNode *subNode = [self.tableView nodeAtIndexPath:indexPath];
    self.childCell = [CMEdgeListCell cellWithTableView:tableView];
    self.childCell.node = subNode;
    // 二级标题
    if (subNode.depth == 1) {
        isSubSelected = NO;
        self.childCell.tag = indexPath.section + 200;
    }else if (subNode.depth == 2) { // 第三级的标题
    }// ...第4、5、5、5...级
    return self.childCell;
}

#pragma mark 二级标题的点击事件
// 如果只是多级列表 哪怕无数个级别 此处就是二级+的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView expandNodeAtIndexPath:indexPath];
    CMNode *subNode = [self.tableView nodeAtIndexPath:indexPath]; // 二三级对象
    // 点击左侧 切换右侧展示对应的数据
    self.currentFirstNode = subNode.parentNode;
    [self.collectionView reloadData];
    [self.collectionView performBatchUpdates:^{
    } completion:^(BOOL finished) {
        //刷新完成，执行后续代码
        if (subNode.depth == 1) {
            if (subNode.threeNodes.count < 1) {
                // 无三级 不可展开 事件终止 (需求变更：一定有三级 不考虑二级截止情况 不用删除此处代码不影响)
                self.chooseResult(subNode);
                [self close];
            }else {
                // 左侧菜单点击变色 选中了
                [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                // 有三级
                // 右侧滚动
                CMSubListHeadView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CMSubListHeadView" forIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]];
                [self.collectionView setContentOffset:headerView.frame.origin];
            }
        }else if (subNode.depth == 2) {
            // 到三级 不可展开 事件终止 （三级在右侧collectionview中点击选择 ttableview没有三级展示 不用删除此处代码不影响）
            self.chooseResult(subNode);
            [self close];
        }
    }];
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.currentFirstNode.subNodes.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CMNode *sectionNode = self.currentFirstNode.subNodes[section];
    return sectionNode.threeNodes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMSubListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CMSubListCell" forIndexPath:indexPath];
    CMNode *sectionNode = self.currentFirstNode.subNodes[indexPath.section];
    cell.node = sectionNode.threeNodes[indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CMSubListHeadView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CMSubListHeadView" forIndexPath:indexPath];
        CMNode *sectionNode = self.currentFirstNode.subNodes[indexPath.section];
        headerView.titleLabel.text = sectionNode.name;
        return headerView;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableViewfooter" forIndexPath:indexPath];
        if(footerView == nil)
        {
            footerView = [[UICollectionReusableView alloc] init];
        }
        footerView.backgroundColor = [UIColor whiteColor];
        return footerView;
    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_W, 45*Rate);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == self.currentFirstNode.subNodes.count-1) {
        /**
             最后一个分区的高度组成：
             items个数:[[self.currentFirstNode.subNodes.lastObject threeNodes] count]
             头：45*Rate
             一个的高：30*Rate
             行距：10*Rate
             底部边距：5*Rate
         */
        int linesCount = ceil([[self.currentFirstNode.subNodes.lastObject threeNodes] count]*0.5);
        CGFloat contentH = (45+linesCount*30+(linesCount-1)*10+5)*Rate;
        return (CGSize){SCREEN_W, SCREEN_H-kNavHeight-TabBarH-contentH};
    }else {
        return (CGSize){SCREEN_W, 5};
    }
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 25*Rate, 5*Rate, 10*Rate);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(0.5*(SCREEN_W-125*Rate-40*Rate-10*Rate), 30*Rate);
}

//设置列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*Rate;
}

//设置行间距
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10*Rate;
}

#pragma mark 三级菜单的点击事件
// 点击收起菜单 可以改写
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMNode *node = [self.currentFirstNode.subNodes[indexPath.section] threeNodes][indexPath.row];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    self.chooseResult(node);
    [self close];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    CGPoint point = [view convertPoint:CGPointZero toView:self];
    if (point.y < 100 && [elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:[self.tableView.rootNode.subNodes indexOfObject:self.currentFirstNode]] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    CGPoint point = [view convertPoint:CGPointZero toView:self];
    if (point.y < 100 && [elementKind isEqualToString:UICollectionElementKindSectionFooter]) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section+1 inSection:[self.tableView.rootNode.subNodes indexOfObject:self.currentFirstNode]] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

// 保留当前点击的一级样式并选中第一个二级，对应的三级和其他的全部复位
- (void)resetFirstNodes:(NSInteger)section {
    // 当前点击的一级 self.tableView.rootNode.subNodes[section]
    // 一级
    for (int i=0; i<self.tableView.rootNode.subNodes.count; i++) {
        CMNode *node = self.tableView.rootNode.subNodes[i];
        node.expand = section == i;
        node.isChoosed = section == i;
        // 二级
        for (int j=0; j<node.subNodes.count; j++) {
            CMNode *subNode = node.subNodes[j];
            if (section == i && j == 0) {
                subNode.isChoosed = YES;
                subNode.expand = YES;
            }else {
                subNode.isChoosed = NO;
                subNode.expand = NO;
            }
            // 三级
            for (int k=0; k<subNode.threeNodes.count; k++) {
                CMNode *threeNode = subNode.threeNodes[k];
                threeNode.expand = NO;
                threeNode.isChoosed = NO;
            }
        }
    }
}


- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_W, SCREEN_H)];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_bgView addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
    }
    return _bgView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[CMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rootNode = self.rootNode;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(125*Rate);
        }];
    }
    return _tableView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        if (@available(iOS 9.0, *)) {
            flowLayout.sectionHeadersPinToVisibleBounds = NO;
        } else {
            // Fallback on earlier versions
        }
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        // 注册item Cell
        [_collectionView registerClass:[CMSubListCell class] forCellWithReuseIdentifier:@"CMSubListCell"];
        [_collectionView registerClass:[CMSubListHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CMSubListHeadView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionReusableViewfooter"];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.tableView.mas_right).offset(0);
        }];
    }
    return _collectionView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
