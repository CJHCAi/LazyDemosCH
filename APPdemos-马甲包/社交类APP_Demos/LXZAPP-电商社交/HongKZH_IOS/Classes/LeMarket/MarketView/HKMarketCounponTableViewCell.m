//
//  HKMarketCounponTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMarketCounponTableViewCell.h"
#import "HKHKMarketCounponCollectionViewCell.h"
#import "HKMarketGoodsCollectionViewCell.h"
@interface HKMarketCounponTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HKMarketCounponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.iconView.image = [UIImage imageNamed:@"htbg"];
     [_collectionView registerNib:[UINib nibWithNibName:@"HKHKMarketCounponCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKHKMarketCounponCollectionViewCell"];
     [_collectionView registerNib:[UINib nibWithNibName:@"HKMarketGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKMarketGoodsCollectionViewCell"];
}
#pragma mark - 代理方法 Delegate Methods

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataArray.count>0) {
        return self.dataArray.count;
    }
    return 1;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 0) {
        HKHKMarketCounponCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKHKMarketCounponCollectionViewCell" forIndexPath:indexPath];
        if (self.dataArray.count>0) {
            cell.model = self.dataArray[indexPath.item];
        }else{
            cell.model = nil;
        }
        
        return cell;
    }else{
        HKMarketGoodsCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKMarketGoodsCollectionViewCell" forIndexPath:indexPath];
        if (self.dataArray.count>0) {
            cell.model = self.dataArray[indexPath.item];
        }else{
            cell.model = nil;
        }
        
        return cell;
    }

}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count>0) {
         return CGSizeMake(116, 151);
    }else{
        return CGSizeMake(kScreenWidth - 40, 151);
    }
   
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
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
}
@end
