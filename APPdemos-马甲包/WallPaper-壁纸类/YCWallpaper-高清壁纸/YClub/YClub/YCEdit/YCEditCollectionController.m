//
//  YCEditCollectionController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/1.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCEditCollectionController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "YCEditCollectionViewCell.h"
#import "YCEditBackView.h"
#import "YCEditDownView.h"
#import "YCLockView.h"
#import "DXPopover.h"
#import "UIScrollView+PSRefresh.h"

@interface YCEditCollectionController ()<UICollectionViewDelegate, UICollectionViewDataSource, YCEditBackViewDelegate, YCEditDownViewDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL bShow;
@property (nonatomic, assign) BOOL bRead;
@property (nonatomic, strong) YCBaseModel    *currentModel;
@property (nonatomic, strong) YCEditBackView *backView;
@property (nonatomic, strong) YCEditDownView *downView;
@property (nonatomic, strong) DXPopover      *popover;
@property (nonatomic, strong) UITableView    *popTableView;
@property (nonatomic, strong) UIImageView    *homeView;
@property (nonatomic, strong) YCLockView     *lockView;
@property (nonatomic, strong) NSMutableArray *colllectPics;
@end

@implementation YCEditCollectionController

#pragma mark - Popver
- (DXPopover *)popover
{
    if (!_popover) {
        _popover = [DXPopover new];
        _popover.backgroundColor = [UIColor clearColor];
        _popover.maskType = DXPopoverMaskTypeNone;
        _popover.animationIn  = 0.3;
        _popover.animationOut = 0.2;
        _popover.contentInset = UIEdgeInsetsZero;
    }
    return _popover;
}
- (UITableView *)popTableView
{
    if (!_popTableView) {
        _popTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 130, 130) style:UITableViewStylePlain];
        _popTableView.rowHeight = 40;
        _popTableView.tableFooterView = [[UIView alloc] init];
        _popTableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _popTableView.separatorColor = RGB(255, 178, 30);
        _popTableView.delegate = self;
        _popTableView.dataSource = self;
        if ([_popTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            
            [_popTableView setSeparatorInset:UIEdgeInsetsMake(0,10,0,10)];
        }
        if ([_popTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            
            [_popTableView setLayoutMargins:UIEdgeInsetsMake(0,10,0,10)];
        }
    }
    return _popTableView;
}
- (UIImageView *)homeView
{
    if (!_homeView) {
        
        UIImage *image = nil;
        if (IS_IPHONE_4_OR_LESS) {
            image = [UIImage imageNamed:@"yc_home_480h"];
        }else if (IS_IPHONE_5) {
            image = [UIImage imageNamed:@"yc_home_568h"];
        }else if(IS_IPHONE_6) {
            image = [UIImage imageNamed:@"yc_home_667h"];
        } else {
            image = [UIImage imageNamed:@"yc_home_736h"];
        }
        _homeView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _homeView.image = image;
    }
    return _homeView;
}
- (YCLockView *)lockView
{
    if (!_lockView) {
        _lockView = [[YCLockView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _lockView.layer.zPosition = 1;
    }
    return _lockView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpLayOut];
    [self setUpCollectionView];
    [self registerCell];
    [self setUpMenuView];
    [self setUpCurrentModel];
    [self addRefreshNewHeader];
    [self addLoadMoreFooter];
    [self addCollectPics];
}
- (void)addCollectPics
{
    _colllectPics = [[NSMutableArray alloc] init];
    [_colllectPics addObjectsFromArray:[[YCDBManager shareInstance] getAllPics]];
    [self scrollViewDidEndDecelerating:self.myCollectionView];
}
- (void)setUpBLove
{
    NSInteger index = 0;
    for (YCBaseModel *model in _colllectPics) {
        if ([model.thumb isEqualToString:_currentModel.thumb]) {
            index++;
            break;
        }
    }
    if (index) {
        [_backView setLoveBtnSelete:YES];
    } else {
        [_backView setLoveBtnSelete:NO];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)setUpLayOut
{
    self.layOut = [[UICollectionViewFlowLayout alloc] init];
    self.layOut.itemSize = [UIScreen mainScreen].bounds.size;
    self.layOut.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layOut.minimumLineSpacing = 0;
    self.layOut.minimumInteritemSpacing = 0;
    self.layOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}
- (void)setUpCollectionView
{
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.layOut];
    self.myCollectionView.backgroundColor = YC_Base_BgGrayColor;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    self.myCollectionView.pagingEnabled = YES;
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}
- (void)setUpCurrentModel
{
    if (!kArrayIsEmpty(self.dataSource)) {
        _currentModel = self.dataSource[self.indexPath.section];
    }
}
- (void)registerCell
{
    [self.myCollectionView registerClass:[YCEditCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
}
#pragma mark - menuView
- (void)setUpMenuView
{
    _bShow = YES;
    _bRead = NO;
    _backView = [[YCEditBackView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 64)];
    _downView = [[YCEditDownView alloc] initWithFrame:CGRectMake(0, KSCREEN_HEIGHT-49, KSCREEN_WIDTH, 49)];
    _backView.delegate = self;
    _downView.delegate = self;
    [self.view addSubview:_backView];
    [self.view addSubview:_downView];
}
- (void)menuViewAnima
{
    if (_bShow) {
        [self hidenMenuView];
    } else {
        [self showMenuView];
    }
}
- (void)showMenuView
{
    [UIView animateWithDuration:0.2 animations:^{
        _backView.top = 0;
        _downView.bottom = KSCREEN_HEIGHT;
        _bShow = YES;
    }];
}
- (void)hidenMenuView
{
    [UIView animateWithDuration:0.2 animations:^{
        _backView.top = -64;
        _downView.bottom = KSCREEN_HEIGHT+49;
        _bShow = NO;
    }];
}
#pragma mark - addLoadMoreFooter
- (void)addRefreshNewHeader
{
    WeakSelf(weakSelf);
    [self.myCollectionView addRefreshHeaderWithClosure:^{
        [weakSelf loadNewData];
    }];
    self.myCollectionView.refreshHeaderFont = YC_Base_TitleFont;
    self.myCollectionView.refreshHeaderTextColor = YC_TabBar_SeleteColor;
}
- (void)addLoadMoreFooter
{
    if (self.dataSource.count>0) {
        WeakSelf(weakSelf);
        [self.myCollectionView addRefreshFooterWithClosure:^{
            
            [weakSelf loadMoreData];
        }];
        self.myCollectionView.refreshFooterFont = YC_Base_TitleFont;
        self.myCollectionView.refreshFooterTextColor = YC_TabBar_SeleteColor;
        if (_bSearch) {
            self.myCollectionView.isLastPage = YES;
        }
    }
}
- (void)endRefresh
{
    [self.myCollectionView endRefreshing];
}
#pragma mark - request
- (void)loadNewData
{
    if (!kArrayIsEmpty(self.dataSource)) {
        [self endRefresh];
        return;
    }
    self.pageNum = 0;
    [self requestData];
}
- (void)loadMoreData
{
    if (self.loading) {
        [self.myCollectionView.mj_footer endRefreshing];
        return;
    }
    self.loading = YES;
    self.pageNum+=30;
    [self requestData];
}
- (void)requestData
{
    if (_bSearch) {
        [self requestSearchListData];
    } else {
        if (!_category) {
            [self requestNewListData];
        } else {
            [self requestCaListData];
        }
    }
}
- (void)requestNewListData
{
    [YCNetManager getListPicsWithOrder:_order skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        [self endRefresh];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
        } else {
            [self addNoResultView];
        }
        self.loading = NO;
    }];
}
- (void)requestCaListData
{
    [YCNetManager getCategoryListWithTId:_order skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        [self endRefresh];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
        } else {
            [self addNoResultView];
        }
        self.loading = NO;
    }];
}
- (void)requestSearchListData
{
    [YCNetManager getSearchListWithKey:_order skip:@(self.pageNum) callBack:^(NSError *error, NSArray *pics) {
        
        [self endRefresh];
        if (!kArrayIsEmpty(pics)) {
            [self.dataSource addObjectsFromArray:pics];
            [self.myCollectionView reloadData];
            if (pics.count < 30) {
                [self.myCollectionView endRefreshing];
                self.myCollectionView.isLastPage = YES;
            }
        } else {
            [self.myCollectionView endRefreshing];
            self.myCollectionView.isLastPage = YES;
        }
        self.loading = NO;
    }];
}
#pragma mark - collection
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCEditCollectionViewCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [baseCell setModel:self.dataSource[indexPath.item]];
    _currentModel     = self.dataSource[indexPath.item];
    return baseCell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item > self.dataSource.count-6 && self.scrollBottom && !self.loading)
    {
        [self loadMoreData];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_bRead) {
        _bRead = NO;
        [self.homeView removeFromSuperview];
        [self.lockView removeFromSuperview];
        [self showMenuView];
    } else {
        [self menuViewAnima];
    }
}
#pragma mark - table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"cellId"];
    }
    cell.textLabel.font = YC_Base_TitleFont;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"主屏预览";
            break;
        case 1:
            cell.textLabel.text = @"锁屏预览";
            break;
        default:
            cell.textLabel.text = @"取消";
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.popover dismiss];
    switch (indexPath.row) {
        case 0: {
            [self hidenMenuView];
            _bRead = YES;
            self.homeView.left = KSCREEN_HEIGHT;
            [self.view addSubview:self.homeView];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.homeView.left = 0;
            } completion:nil];
          
        }
            break;
        case 1: {
            [self hidenMenuView];
            _bRead = YES;
            self.lockView.left = KSCREEN_HEIGHT;
            [self.view insertSubview:self.lockView belowSubview:self.myCollectionView];
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.lockView.left = 0;
            } completion:nil];
        }
            break;
        default:
            [self.popover dismiss];
            break;
    }
}

#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.lastOffSetX < scrollView.contentOffset.x) {
        self.scrollBottom = YES;
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.lastOffSetX = scrollView.contentOffset.x;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - YCEditBackViewDelegate
- (void)clickBackBtn
{
    _presentVC.pageNum = self.pageNum;
    _presentVC.indexPath = self.indexPath;
    _presentVC.bEdit = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)clickLoveBtn
{
    YCBaseModel *picModel = nil;
    for (YCBaseModel *model in _colllectPics) {
        if ([model.thumb isEqualToString:_currentModel.thumb]) {
            picModel = model;
            break;
        }
    }
    if (picModel) {
        [_backView setLoveBtnSelete:NO];
        [_colllectPics removeObject:picModel];
        [[YCDBManager shareInstance] deletePic:_currentModel];
        [YCHudManager showMessage:@"取消成功" InView:self.view];
    } else {
        [_backView setLoveBtnSelete:YES];
        [_colllectPics addObject:_currentModel];
        [[YCDBManager shareInstance] savePic:_currentModel];
        [YCHudManager showMessage:@"收藏成功" InView:self.view];
    }
}
#pragma mark - YCEditDownViewDelegate
- (void)clickDownBtn
{
    //根据相册权限做出动作
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if(author == ALAuthorizationStatusAuthorized)
    {
        [self downLoadImage];
        
    } else if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示:无权限" message:@"请您设置允许APP访问您的相片->设置->隐私->相片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else {
        [self downLoadImage];
    }
}
- (void)downLoadImage
{
    YCEditCollectionViewCell *cell = (YCEditCollectionViewCell *)[self.myCollectionView cellForItemAtIndexPath:self.indexPath];
    UIImage *img = [cell getShowImg];
    if (!img) {
        [YCHudManager showHudMessage:@"下载中..." InView:self.view];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_currentModel.img]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YCHudManager hideHudInView:self.view];
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
                    } else  {
                         [YCHudManager showMessage:@"下载失败,请稍后再试!" InView:self.view];
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [YCHudManager hideHudInView:self.view];
                     [YCHudManager showMessage:@"下载失败,请稍后再试!" InView:self.view];
                });
            }
        });
    } else {
         UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [YCHudManager showMessage:@"保存到相册" InView:self.view];
    }
}
#pragma mark - 预览
- (void)clickReadBtn:(UIButton *)sender
{
    [self.popover showAtPoint:CGPointMake(KSCREEN_WIDTH/4.f*3, KSCREEN_HEIGHT-64) popoverPostion:DXPopoverPositionUp withContentView:self.popTableView inView:self.view];
    WS(ws);
    self.popover.didDismissHandler = ^{
        [ws bounceTargetView:sender];
        sender.selected = !sender.selected;
    };
}
- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}
#pragma mark - alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.myCollectionView) {
        return;
    }
    self.indexPath = [self.myCollectionView indexPathForItemAtPoint:[self.view convertPoint:self.myCollectionView.center toView:self.myCollectionView]];
    _currentModel = self.dataSource[self.indexPath.item];
    [self setUpBLove];
}
@end
