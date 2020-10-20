//
//  SXTClassCollectionView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTClassCollectionView.h"
#import "SXTEffectClassCollectionViewCell.h"
#import "SXTClassCollectionViewCell.h"
#import "SXTCollectionHeadReusableView.h"


@interface SXTClassCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation SXTClassCollectionView
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[SXTEffectClassCollectionViewCell class] forCellWithReuseIdentifier:@"SXTEffectClassCollectionViewCell"];
        [self registerClass:[SXTClassCollectionViewCell class] forCellWithReuseIdentifier:@"SXTClassCollectionViewCell"];
        [self registerClass:[SXTCollectionHeadReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SXTCollectionHeadReusableView"];
        
    }
    
    return self;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.effectArray.count;
    }else if (section == 1){
        return self.classicClassArray.count;
    }else
        return self.recommendClassArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *identify = @"SXTEffectClassCollectionViewCell";
        SXTEffectClassCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        cell.effectModel = _effectArray[indexPath.row];
        return cell;
    }else{
        static NSString *identify = @"SXTClassCollectionViewCell";
        SXTClassCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (indexPath.section == 1) {
            cell.recommendModel = _classicClassArray[indexPath.row];
        }else{
            cell.recommendModel = _recommendClassArray[indexPath.row];
        }
        return cell;
    }
    
}
//创建sectionHeader的方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    //kind:种类，一共两种，一种是header,一种是footer
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        SXTCollectionHeadReusableView * reusable = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SXTCollectionHeadReusableView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            reusable.titleLabelText = @"功效分类";
            reusable.backgroundColor = RGB(239, 248, 251);
        }else if (indexPath.section == 1){
            reusable.titleLabelText = @"经典品牌";
            reusable.backgroundColor = RGB(252, 244, 243);
        }else{
            reusable.titleLabelText = @"推荐品牌";
            reusable.backgroundColor = RGB(252, 244, 243);
        }
        
        
        return reusable;
    }
    
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectCellBlock) {
        _selectCellBlock([self makeParameterDic:indexPath]);
    }
}

- (NSDictionary *)makeParameterDic:(NSIndexPath *)indexPath{
    NSDictionary *dic = nil;
    if (indexPath.section == 0) {
        dic = @{@"ShopID":[_effectArray[indexPath.row] GoodsType],@"Type":@"TypeId",@"URL":@"classifyApp/appTypeGoodsList.do"};
    }else if (indexPath.section == 1){
        dic = @{@"ShopID":[_classicClassArray[indexPath.row] ShopId],@"Type":@"ShopId",@"URL":@"appShop/appShopGoodsList.do"};
    }else{
        dic = @{@"ShopID":[_recommendClassArray[indexPath.row] ShopId],@"Type":@"ShopId",@"URL":@"appShop/appShopGoodsList.do"};
    }
    return dic;
}
@end
