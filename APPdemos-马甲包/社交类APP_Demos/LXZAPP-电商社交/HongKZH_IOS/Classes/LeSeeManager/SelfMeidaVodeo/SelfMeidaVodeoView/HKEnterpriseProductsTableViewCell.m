//
//  HKEnterpriseProductsTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/8.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEnterpriseProductsTableViewCell.h"
#import "HKEnterpriseProductsCollectionViewCell.h"
@interface HKEnterpriseProductsTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HKEnterpriseProductsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HKEnterpriseProductsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKEnterpriseProductsCollectionViewCell"];
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
    HKEnterpriseProductsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKEnterpriseProductsCollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(110, 140);
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
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}
@end
