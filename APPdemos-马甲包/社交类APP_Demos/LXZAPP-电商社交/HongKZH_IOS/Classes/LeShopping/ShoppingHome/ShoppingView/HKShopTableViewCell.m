//
//  HKShopTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopTableViewCell.h"
#import "HKShopItem.h"
@interface HKShopTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h;


@end

@implementation HKShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"HKShopItem" bundle:nil] forCellWithReuseIdentifier:@"HKShopItem"];

}
#pragma mark - 代理方法 Delegate Methods
// 设置分区


// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKShopItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKShopItem class]) forIndexPath:indexPath];
    cell.shopM = self.dataArray[indexPath.item];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count>1) {
        return CGSizeMake(kScreenWidth/2, 60);
    }else{
        return CGSizeMake(kScreenWidth, 60);
    }
    
}
// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HKLeShopHomeShopes *items =self.dataArray[indexPath.item];
    if (self.delegete && [self.delegete respondsToSelector:@selector(enterShopDetail:)]) {
        [self.delegete enterShopDetail:items.shopId
    
         ];
    }
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView reloadData];
    int row = dataArray.count*0.5;
    if (dataArray.count%2>0) {
       row = row+1;
    }
    self.h.constant = 60*row;
}
@end
