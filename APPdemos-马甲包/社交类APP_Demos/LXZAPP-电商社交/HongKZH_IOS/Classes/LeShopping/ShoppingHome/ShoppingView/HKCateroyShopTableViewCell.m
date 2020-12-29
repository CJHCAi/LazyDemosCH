//
//  HKCateroyShopTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCateroyShopTableViewCell.h"
#import "HKHKCateroyShopItem.h"
@interface HKCateroyShopTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSIndexPath* selectItem;

@end

@implementation HKCateroyShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"HKHKCateroyShopItem" bundle:nil] forCellWithReuseIdentifier:@"HKHKCateroyShopItem"];
    
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
    
    HKHKCateroyShopItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHKCateroyShopItem class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    if (self.selectItem.item == indexPath.item) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //return CGSizeMake(kScreenWidth/4, 55);
    return CGSizeMake((kScreenWidth-44)/self.dataArray.count,55);
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectItem = indexPath;
    [self.collectionView reloadData];
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray =dataArray;
    [self.collectionView reloadData];
}
-(void)setSelectItem:(NSIndexPath*)selectItem{
    _selectItem = selectItem;
    if ([self.delegate respondsToSelector:@selector(selectShop:)]) {
        [self.delegate selectShop:selectItem];
    }
}
@end
