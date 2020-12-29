//
//  HKAdvertisingAtlasTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAdvertisingAtlasTableViewCell.h"
#import "AllAlbumByUserRespone.h"
#import "HKAtlasCollectionViewCell.h"
#import "UIImageView+HKWeb.h"
@interface HKAdvertisingAtlasTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HKAdvertisingAtlasTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HKAtlasCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKAtlasCollectionViewCell"];
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.respone.data.list.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKAtlasCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKAtlasCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell.iconView hk_sd_setImageWithURL:[self.respone.data.list[indexPath.item] coverPhoto]placeholderImage:kPlaceholderImage];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(225, 169);
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
-(void)setRespone:(AllAlbumByUserRespone *)respone{
    _respone = respone;
    [self.collectionView reloadData];
}
@end
