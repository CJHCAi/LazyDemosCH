//
//  HKSelfMediaTranslateCategory.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSelfMediaTranslateCategory.h"
#import "HKSelfMediaTranslateCategoryCollectionViewCell.h"
@interface HKSelfMediaTranslateCategory()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation HKSelfMediaTranslateCategory
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        // TODO:init
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI{
    [self addSubview:self.collectionView];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKSelfMediaTranslateCategoryCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKSelfMediaTranslateCategoryCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKSelfMediaTranslateCategoryCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKSelfMediaTranslateCategoryCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    if (self.selectIndex == indexPath.item) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/4, 50);
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(itemClick:)]) {
        [self.delegate itemClick:indexPath.item];
    }
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    if (self.dataArray.count>0) {
        [self.collectionView reloadData];
    }
}
@end
