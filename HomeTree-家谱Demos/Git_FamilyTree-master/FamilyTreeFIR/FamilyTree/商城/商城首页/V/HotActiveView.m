//
//  HotActiveView.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "HotActiveView.h"
#import "HotActiVeCell.h"

@interface HotActiveView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//@property (strong,nonatomic) NSArray<GoodsDatalist *> *hotArr;
@end

@implementation HotActiveView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)initView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, self.frame.size.height) collectionViewLayout:flowLayout];
    [self addSubview:_collectionV];
    _collectionV.scrollEnabled = NO;
    _collectionV.backgroundColor = [UIColor whiteColor];
    [_collectionV registerClass:[HotActiVeCell class] forCellWithReuseIdentifier:@"HotActiVeCell"];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    
}

#pragma mark ==初始化赋值==
-(void)setinitValue:(NSArray<GoodsDatalist *> *)hotArr{
    
    _hotArr = hotArr;
    [self initView];
    
}


#pragma mark -UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _hotArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HotActiVeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotActiVeCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[HotActiVeCell alloc]initWithFrame:CGRectMake(0, 0, __kWidth/2, (__kWidth)*11/36)];
    }
    
    GoodsDatalist *goods = _hotArr[indexPath.row];
    
    cell.goodNameLb.text = goods.CoConame;
    CGFloat money = goods.CoprActpri;
    cell.payMoneyLb.text = [NSString stringWithFormat:@"¥%.1f",money];
    CGFloat moneyYJ = goods.CoprMoney;
    cell.quoteLb.text = [NSString stringWithFormat:@"¥%.1f",moneyYJ];
    NSMutableAttributedString *quoteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",cell.quoteLb.text]];
    [quoteStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(0, quoteStr.length)];
    cell.quoteLb.attributedText = quoteStr;//加横线
    cell.goodIV.imageURL = [NSURL URLWithString:goods.CoCover];
    cell.goodId = [NSString stringWithFormat:@"%ld",(long)goods.CoId];
    cell.goodTypeId = [NSString stringWithFormat:@"%ld",(long)goods.CoprId];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HotActiVeCell *cell = (HotActiVeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate selectCellGoodsId:cell.goodId];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(__kWidth/2, (__kWidth)*11/36);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
