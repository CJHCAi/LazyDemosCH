//
//  HKShoppingActivityTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShoppingActivityTableViewCell.h"
#import "HKHKShoppingActivityItem.h"
#import "HKLeShopHomeRespone.h"
@interface HKShoppingActivityTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;

@end

@implementation HKShoppingActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"HKHKShoppingActivityItem" bundle:nil] forCellWithReuseIdentifier:@"HKHKShoppingActivityItem"];
}
#pragma mark - 代理方法 Delegate Methods


// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.selectedProducts.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKHKShoppingActivityItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHKShoppingActivityItem class]) forIndexPath:indexPath];
   
        cell.productsM = self.selectedProducts[indexPath.item];
   
   
    return cell;
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


// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(115, 170);
}
// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(gotoDetailsWithID:)]) {
        HKLeShopHomeToSelectedproducts *model = self.selectedProducts[indexPath.item];
        [self.delegate gotoDetailsWithID:model.productId];
    }
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    self.titleImage.image = [UIImage imageNamed:@"sy_bkqq"];
    [self.collectionView reloadData];
}
-(void)setSelectedProducts:(NSArray *)selectedProducts{
    _selectedProducts = selectedProducts;
    
    self.titleImage.image = [UIImage imageNamed:@"sy_jxsp"];
    [self.collectionView reloadData];
}
- (IBAction)more:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoMore)]) {
        [self.delegate gotoMore];
    }
}
@end
