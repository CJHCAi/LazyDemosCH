//
//  YCCollectViewController.m
//  YClub
//
//  Created by yuepengfei on 17/5/17.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCCollectViewController.h"
#import "YCEditCollectionController.h"
#import "UIViewController+WXSTransition.h"
#import "YCCollectionViewCell.h"

@interface YCCollectViewController ()<YCCollectionViewCellDelegate>
{
    BOOL _deleteFlag;
    BOOL _firstLoad;
}
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@end
@implementation YCCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    [self setLeftBackNavItem];
    [self registerCell];
    [self setUpFlag];
    [self setUpTapGes];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)registerCell
{
    [self.myCollectionView registerClass:[YCCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}
#pragma mark - 初始化标记
- (void)setUpFlag
{
    _firstLoad  = NO;
    _deleteFlag = NO;
}
#pragma mark - 配置手势
- (void)setUpTapGes
{
    _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTapAction)];
    _tapGes.enabled = NO;
    [self.view addGestureRecognizer:_tapGes];
}
- (void)requestData
{
    [self.dataSource addObjectsFromArray:[[YCDBManager shareInstance] getAllPics]];
    if (kArrayIsEmpty(self.dataSource)) {
        [self addNoResultView];
        self.noResultImaV.image = [UIImage imageNamed:@"nf_noLiked"];
    }
}
#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCCollectionViewCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [baseCell setModel:self.dataSource[indexPath.item]];
    [baseCell setUpLongGes];
    [self setVisibleCell:baseCell indexPath:indexPath];
    return baseCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_deleteFlag) {
        [self exitDeleteState];
        return;
    }
    YCEditCollectionController *editVC = [[YCEditCollectionController alloc] init];
    editVC.presentVC  = self;
    editVC.dataSource = self.dataSource;
    editVC.bSearch    = YES;
    editVC.pageNum    = self.pageNum+30;
    editVC.dataSource = self.dataSource;
    editVC.indexPath  = indexPath;
    [self wxs_presentViewController:editVC  animationType:WXSTransitionAnimationTypeSysRippleEffect completion:nil];
}
- (void)tapAction
{
    return;
}
- (void)removeTapAction
{
    [self exitDeleteState];
}
#pragma mark -  添加动画
- (void)setVisibleCell:(YCCollectionViewCell *)cell
             indexPath:(NSIndexPath *)indexPath
{
    cell.delegate  = self;
    cell.indexPath = indexPath;
    cell.deleteBtn.hidden = _deleteFlag?NO:YES;
    if (_deleteFlag) {
        [self addAnimationForCell:cell];
    }else{
        [cell.layer removeAnimationForKey:@"shake"];
    }
}
- (void)addAnimationForCell:(YCCollectionViewCell *)cell
{
    CAKeyframeAnimation *rvibrateAni = [CAKeyframeAnimation animation];
    rvibrateAni.keyPath = @"transform.rotation";
    CGFloat angle = M_PI_4/18;
    rvibrateAni.values = @[@(-angle),@(angle),@(-angle)];
    rvibrateAni.repeatCount = MAXFLOAT;
    [cell.layer addAnimation:rvibrateAni forKey:@"shake"];
}
#pragma mark - 退出删除模式
- (void)exitDeleteState
{
    _deleteFlag = NO;
    _tapGes.enabled = NO;
    [self.myCollectionView reloadData];
}
#pragma mark - 进入删除模式
- (void)beginDeleteState
{
    _deleteFlag = YES;
    _tapGes.enabled = YES;
    [self.myCollectionView reloadData];
}
#pragma mark - 删除菜谱
- (void)deletePic:(YCBaseModel *)pic
       atIndexpath:(NSIndexPath *)indexPath
{
    [YCDBManager runBlockInBackground:^{
        [[YCDBManager shareInstance] deletePic:pic];
    }];
    [self.myCollectionView performBatchUpdates:^{
        [self.dataSource removeObject:pic];
        [self.myCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (self.dataSource.count == 0) {
            _deleteFlag = NO;
            _tapGes.enabled = NO;
            [self addNoResultView];
            self.noResultImaV.image = [UIImage imageNamed:@"nf_noLiked"];
            [YCHudManager showMessage:@"取消收藏成功" InView:self.view];
        }
        [self.myCollectionView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
