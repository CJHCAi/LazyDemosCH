//
//  ZJGroupingCollectionViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/5/28.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJGroupingCollectionViewController.h"
#import "ZJGroupingCollectionViewFlowLayout.h"
#import "ZJGroupingCollectionViewCell.h"
#import "ZJCollectionViewRightIndex.h"

@interface ZJGroupingCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ZJCollectionViewRightIndexDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic, strong)  ZJCollectionViewRightIndex  *collectionViewIndex;

@end

@implementation ZJGroupingCollectionViewController

static NSString *ItemIdentifier = @"ItemIdentifier";

static NSString *groupingCollectionViewHeadID = @"ZJGroupingCollectionViewHeadID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分组及添加索引";
    [self.view addSubview:self.collectionView];
    [self setDataArrayAndListArray];
    [self.view addSubview:self.collectionViewIndex];
    
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setDataArrayAndListArray
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"allBrand" ofType:@"plist"];
    _dataArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *listA = [NSMutableArray array];
    [_dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [listA addObject:obj[@"brandKey"]];
    }];
    self.listArray = [NSArray arrayWithArray:listA];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDictionary *dict = self.dataArray[section];
    NSArray *brandA = dict[@"brands"];
    
    return brandA.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJGroupingCollectionViewCell *cell;
    
    if (cell == nil) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    }
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *brandA = dict[@"brands"];
    NSDictionary *brandDict = brandA[indexPath.row];
    
//    NSString *urlStr = brandDict[@"pic_id"];
//    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    cell.imageV.backgroundColor = randomColor;
    cell.nameLabel.text = brandDict[@"name"];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *reusableHeaderView = nil;
        
        if (reusableHeaderView==nil) {
            
            reusableHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:groupingCollectionViewHeadID forIndexPath:indexPath];
            
            reusableHeaderView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
            
            UILabel *label = (UILabel *)[reusableHeaderView viewWithTag:100];
            if (!label) {
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 40)];
                label.tag = 100;
                [reusableHeaderView addSubview:label];
            }
            NSDictionary *dict = self.dataArray[indexPath.section];
            
            label.text = dict[@"brandKey"];
        }
        return reusableHeaderView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- ZJCollectionViewRightIndexDelegate
-(void)collectionViewIndex:(ZJCollectionViewRightIndex *)collectionViewIndex didselectionAtIndex:(NSInteger)index withTitle:(NSString *)title{
    
    if ([_collectionView numberOfSections]>index&&index>-1) {
        
        UICollectionViewLayoutAttributes *attributes = [_collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]];
        CGRect rect = attributes.frame;
        [_collectionView setContentOffset:CGPointMake(_collectionView.frame.origin.x, rect.origin.y - 40) animated:YES];
        
    }
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect size = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        ZJGroupingCollectionViewFlowLayout *layout = [[ZJGroupingCollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];
        [_collectionView registerClass:[ZJGroupingCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
        _collectionView.showsHorizontalScrollIndicator=NO;
        _collectionView.showsVerticalScrollIndicator=NO;
        _collectionView.backgroundColor=[UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:groupingCollectionViewHeadID];
    }
    return _collectionView;
}

- (ZJCollectionViewRightIndex *)collectionViewIndex
{
    if (_collectionViewIndex == nil) {
        _collectionViewIndex = [[ZJCollectionViewRightIndex alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, 0, 20, SCREEN_HEIGHT)];
        _collectionViewIndex.titleIndexes = self.listArray;
        _collectionViewIndex.color = [UIColor blackColor];
        _collectionViewIndex.isSelectVisible = YES;
        CGRect rect = _collectionViewIndex.frame;
        rect.size.height = _collectionViewIndex.titleIndexes.count * 16;
        rect.origin.y = (SCREEN_HEIGHT - rect.size.height) / 2 + 64;
        _collectionViewIndex.frame = rect;
        _collectionViewIndex.collectionDelegate = self;
    }
    return _collectionViewIndex;
}
@end
