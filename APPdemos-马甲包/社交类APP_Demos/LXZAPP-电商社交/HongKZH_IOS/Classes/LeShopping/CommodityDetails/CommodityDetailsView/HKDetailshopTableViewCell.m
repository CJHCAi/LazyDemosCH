//
//  HKDetailshopTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetailshopTableViewCell.h"
#import "CommodityDetailsRespone.h"
#import "UIImageView+HKWeb.h"
#import "UIView+BorderLine.h"
#import "HKDetailshopItem.h"
@interface HKDetailshopTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation HKDetailshopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btn borderForColor:[UIColor colorWithRed:239.0/255.0 green:89.0/255.0 blue:60.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
    // Initialization code
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HKDetailshopItem" bundle:nil] forCellWithReuseIdentifier:@"HKDetailshopItem"];
}

#pragma mark - 代理方法 Delegate Methods


// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.respone.data.recs.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKDetailshopItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKDetailshopItem class]) forIndexPath:indexPath];
    cell.model = self.respone.data.recs[indexPath.item];
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/3, 192);
}


// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(gotoDetailsWithID:)]) {
        CommodityDetailsesRecs *model = self.respone.data.recs[indexPath.item];
        [self.delegate gotoDetailsWithID:model.productId];
    }
}

- (IBAction)PushShop:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoShopsWithShopId:)]) {
        [self.delegate gotoShopsWithShopId:self.respone.data.shopId];
    }
}
-(void)setRespone:(CommodityDetailsRespone *)respone{
    _respone = respone;
    [self.collectionView reloadData];
    [self.iconView hk_sd_setImageWithURL:respone.data.shop.imgSrc placeholderImage:kPlaceholderHeadImage];
    self.name.text = respone.data.shop.name;
    self.desc.text = [NSString stringWithFormat:@"商品数量%ld  已拼%ld",respone.data.shop.num,respone.data.shop.orders];
}
@end
