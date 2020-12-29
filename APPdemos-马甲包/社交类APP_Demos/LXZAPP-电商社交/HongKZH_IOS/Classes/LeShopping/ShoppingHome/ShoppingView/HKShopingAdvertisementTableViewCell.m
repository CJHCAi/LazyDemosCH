//
//  HKShopingAdvertisementTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopingAdvertisementTableViewCell.h"
#import "HKHKShopingAdvertisementItem.h"
@interface HKShopingAdvertisementTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conllecTIonH;

@end

@implementation HKShopingAdvertisementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
     [_collectionView registerNib:[UINib nibWithNibName:@"HKHKShopingAdvertisementItem" bundle:nil] forCellWithReuseIdentifier:@"HKHKShopingAdvertisementItem"];
    self.conllecTIonH.constant = ((kScreenWidth-30)/2-10)*9/17;
}
//-(UICollectionView *)collectionView{
//    if (!_collectionView) {
//
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
//        [_collectionView registerNib:[UINib nibWithNibName:@"HKReleasesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKReleasesCollectionViewCell"];
//        _collectionView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//    }
//    return _collectionView;
//}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKHKShopingAdvertisementItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHKShopingAdvertisementItem class]) forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth-30)/2, ((kScreenWidth-30)/2-10)*9/17);
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
    return 10;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegete  && [self.delegete respondsToSelector:@selector(enterNewVipControllerWithIndex:)]) {
        [self.delegete enterNewVipControllerWithIndex:indexPath.row];
    }
}
@end
