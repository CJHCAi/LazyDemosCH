//
//  HKTBurstingableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTBurstingableViewCell.h"
#import "HKHKTBurstingableItem.h"
@interface HKTBurstingableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation HKTBurstingableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collection.delegate = self;
    self.collection.dataSource = self;
    [self.collection registerNib:[UINib nibWithNibName:@"HKHKTBurstingableItem" bundle:nil] forCellWithReuseIdentifier:@"HKHKTBurstingableItem"];
}

#pragma mark

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
//    return self.respone.data.allCategorys.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HKHKTBurstingableItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HKHKTBurstingableItem" forIndexPath:indexPath];
    cell.productsM = self.dataArray[indexPath.item];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth-65, 170);
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray =dataArray;
    [self.collection reloadData];
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(gotoBurstingable:)]) {
        [self.delegate gotoBurstingable:self.dataArray[indexPath.item]];
    }
}
- (IBAction)toMoreClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoBurstingable:)]) {
        [self.delegate gotoBurstingable:nil];
    }
}
@end
