//
//  ViewController.m
//  demo
//
//  Created by zhong on 17/1/16.
//  Copyright © 2017年 Xz Studio. All rights reserved.
//

#import "ViewController.h"
#import "ItemCell.h"
#import "ItemCellHeaderView.h"

#import "ItemGroup.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];

static NSString *reuseID = @"itemCell";
static NSString *sectionHeaderID = @"sectionHeader";

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, ItemCellDelegate> {
    NSIndexPath *_originalIndexPath;
    NSIndexPath *_moveIndexPath;
    UIView *_snapshotView;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *itemGroups;
@property (nonatomic, strong) NSArray *allItemModel;
@property (nonatomic, assign) BOOL isEditing;
@end

@implementation ViewController

- (void)setIsEditing:(BOOL)isEditing {
    _isEditing = isEditing;
    UIBarButtonItem *managerItem = self.navigationItem.rightBarButtonItem;
    UIButton *managerButton = managerItem.customView;
    managerButton.selected = isEditing;
}

- (NSArray *)itemGroups {
    if (!_itemGroups) {
        
        NSArray *datas = @[
                           @{
                               @"type" : @"首页快捷入口",
                               @"items" :[NSMutableArray array]
                               },
                           @{
                               @"type" : @"我的",
                               @"items" : @[@{@"imageName" : @"我的订阅",@"itemTitle" : @"我的订阅"},
                                            @{@"imageName" : @"球爆",@"itemTitle" : @"球爆"},]
                               },
                           @{
                               @"type" : @"基础服务",
                               @"items" : @[@{@"imageName" : @"名人名单",@"itemTitle" : @"名人名单"},
                                            @{@"imageName" : @"竞彩足球",@"itemTitle" : @"竞彩足球"},
                                            @{@"imageName" : @"竞彩篮球",@"itemTitle" : @"竞彩篮球"},
                                            @{@"imageName" : @"足彩",@"itemTitle" : @"足彩"},]
                               },
                           @{
                               @"type" : @"发现新鲜事",
                               @"items" : @[@{@"imageName" : @"爆单",@"itemTitle" : @"爆单"},
                                            @{@"imageName" : @"专业分析",@"itemTitle" : @"专业分析"},
                                            @{@"imageName" : @"最新话题",@"itemTitle" : @"最新话题"},
                                            @{@"imageName" : @"热门话题",@"itemTitle" : @"热门话题"},]
                             },
                           @{
                               @"type":@"新闻资讯",
                               @"items" : @[@{@"imageName" : @"热点资讯",@"itemTitle" : @"热点资讯"},
                                            @{@"imageName" : @"我不是头条",@"itemTitle" : @"我不是头条"},
                                            @{@"imageName" : @"名人专访",@"itemTitle" : @"名人专访"},
                                            @{@"imageName" : @"焦点赛事",@"itemTitle" : @"焦点赛事"},
                                            @{@"imageName" : @"活动专栏",@"itemTitle" : @"活动专栏"},]
                               },
                            ];
        
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:datas.count];
        NSMutableArray *allItemModels = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in datas) {
            ItemGroup *group = [[ItemGroup alloc] initWithDict:dict];
            if ([group.type isEqualToString:@"首页快捷入口"]) {
                for (ItemModel *model in group.items) {
                    model.status = StatusMinusSign;
                }
            }else {
                [allItemModels addObjectsFromArray:group.items];
            }
            [array addObject:group];
        }
        _itemGroups = [array copy];
        _allItemModel = [allItemModels copy];
    }
    
    return _itemGroups;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0];
    [self setupNavigationBar];
    [self setupCollectionView];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"全部";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"管理" forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateSelected];
    [button sizeToFit];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(managerAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *managerItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = managerItem;
    
}

- (void)managerAction:(UIButton *)managerButton {
    managerButton.selected = !managerButton.selected;
    self.isEditing = managerButton.selected;
    [self.collectionView reloadData];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth / 4, kScreenWidth / 4);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 35);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ItemCell class] forCellWithReuseIdentifier:reuseID];
    [_collectionView registerClass:[ItemCellHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [_collectionView addGestureRecognizer:longPress];
   
}


#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.itemGroups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ItemGroup *group = self.itemGroups[section];
    return group.items.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    cell.delegate = self;
//    cell.backgroundColor = kRandomColor;
    ItemGroup *group = self.itemGroups[indexPath.section];
    ItemModel *itemModel = group.items[indexPath.row];
    if (indexPath.section != 0) {
        BOOL isAdded = NO;
        ItemGroup *homeGroup = self.itemGroups[0];
        for (ItemModel *homeItemModel in homeGroup.items) {
            
            if ([homeItemModel.itemTitle isEqualToString:itemModel.itemTitle]) {
                isAdded = YES;
                break;
            }
        }
        
        if (isAdded) {
            itemModel.status = StatusCheck;
        }else {
            itemModel.status = StatusPlusSign;
        }
    }
    cell.isEditing = _isEditing;
    cell.itemModel = group.items[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        ItemCellHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeaderID forIndexPath:indexPath];
        
        ItemGroup *group = self.itemGroups[indexPath.section];
        headerView.title = group.type;

        return headerView;
    }else {
        return nil;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }else {
        return UIEdgeInsetsMake(0, 0, 1 / [UIScreen mainScreen].scale, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    static BOOL hiden = NO;
    hiden = !hiden;
    [self setNavBarHidden:hiden];
}

- (void)setNavBarHidden:(BOOL)hiden {
    if (hiden) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.navigationController.navigationBar.frame;
            frame.origin.y = -64;
            self.navigationController.navigationBar.frame = frame;
        } completion:^(BOOL finished) {
            [self.navigationController.navigationBar setHidden:hiden];
        }];

    }else {
        [self.navigationController.navigationBar setHidden:hiden];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = self.navigationController.navigationBar.frame;
            frame.origin.y = 20;
            self.navigationController.navigationBar.frame = frame;
        } completion:^(BOOL finished) {
        }];

    }
}

#pragma mark - 长按手势
- (void)longPressAction:(UILongPressGestureRecognizer *)recognizer {
    
    CGPoint touchPoint = [recognizer locationInView:self.collectionView];
    _moveIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];

    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isEditing == NO) {
                self.isEditing = YES;
                [self.collectionView reloadData];
                [self.collectionView layoutIfNeeded];
            }
            if (_moveIndexPath.section == 0) {
                ItemCell *selectedItemCell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:_moveIndexPath];
                _originalIndexPath = [self.collectionView indexPathForItemAtPoint:touchPoint];
                if (!_originalIndexPath) {
                    return;
                }
                _snapshotView = [selectedItemCell.container snapshotViewAfterScreenUpdates:YES];
                _snapshotView.center = [recognizer locationInView:self.collectionView];
                [self.collectionView addSubview:_snapshotView];
                selectedItemCell.hidden = YES;
                [UIView animateWithDuration:0.2 animations:^{
                    _snapshotView.transform = CGAffineTransformMakeScale(1.03, 1.03);
                    _snapshotView.alpha = 0.98;
                }];
            }
            
        } break;
        case UIGestureRecognizerStateChanged: {
            
            _snapshotView.center = [recognizer locationInView:self.collectionView];
            
            if (_moveIndexPath.section == 0) {
                if (_moveIndexPath && ![_moveIndexPath isEqual:_originalIndexPath] && _moveIndexPath.section == _originalIndexPath.section) {
                    ItemGroup *homeGroup = self.itemGroups[0];
                    NSMutableArray *array = homeGroup.items;
                    NSInteger fromIndex = _originalIndexPath.item;
                    NSInteger toIndex = _moveIndexPath.item;
                    if (fromIndex < toIndex) {
                        for (NSInteger i = fromIndex; i < toIndex; i++) {
                            [array exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
                        }
                    }else{
                        for (NSInteger i = fromIndex; i > toIndex; i--) {
                            [array exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
                        }
                    }
                    [self.collectionView moveItemAtIndexPath:_originalIndexPath toIndexPath:_moveIndexPath];
                    _originalIndexPath = _moveIndexPath;
                }
            }
        } break;
        case UIGestureRecognizerStateEnded: {
            ItemCell *cell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:_originalIndexPath] ;
            cell.hidden = NO;
            [_snapshotView removeFromSuperview];
        } break;
            
        default: break;
    }
}

#pragma mark - 点击右上角按钮
- (void)rightUpperButtonDidTappedWithItemCell:(ItemCell *)itemCell {
    ItemModel *itemModel = itemCell.itemModel;
    if (itemModel.status == StatusMinusSign) {
        ItemGroup *homeGroup = self.itemGroups[0];
        [(NSMutableArray *)homeGroup.items removeObject:itemModel];
        for (ItemModel *model in self.allItemModel) {
            if ([itemModel.itemTitle isEqualToString:model.itemTitle]) {
                model.status = StatusPlusSign;
                break;
            }
        }
        UIView *snapshotView = [itemCell snapshotViewAfterScreenUpdates:YES];
        snapshotView.frame = [itemCell convertRect:itemCell.bounds toView:self.view];;
        [self.view addSubview:snapshotView];
        itemCell.hidden = YES;
        [UIView animateWithDuration:0.4 animations:^{
            snapshotView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:^(BOOL finished) {
            [snapshotView removeFromSuperview];
            itemCell.hidden = NO;
            [self.collectionView reloadData];
        }];
        
    }else if (itemModel.status == StatusPlusSign) {
        itemModel.status = StatusCheck;
        ItemGroup *homeGroup = self.itemGroups[0];
        ItemModel *homeItemModel = [[ItemModel alloc] init];
        homeItemModel.imageName = itemModel.imageName;
        homeItemModel.itemTitle = itemModel.itemTitle;
        homeItemModel.status = StatusMinusSign;
        [homeGroup.items addObject:homeItemModel];
        
        UIView *snapshotView = [itemCell snapshotViewAfterScreenUpdates:YES];
        snapshotView.frame = [itemCell convertRect:itemCell.bounds toView:self.view];
        [self.view addSubview:snapshotView];
        
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        
        ItemCell *lastCell = (ItemCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:homeGroup.items.count - 1 inSection:0]];
        lastCell.hidden = YES;
        CGRect targetFrame = [lastCell convertRect:lastCell.bounds toView:self.view];
        
        [UIView animateWithDuration:0.4 animations:^{
            snapshotView.frame = targetFrame;
        } completion:^(BOOL finished) {
            [snapshotView removeFromSuperview];
            lastCell.hidden = NO;
        }];
        
    }else if (itemModel.status == StatusCheck) {
        ///
    }
}

@end
