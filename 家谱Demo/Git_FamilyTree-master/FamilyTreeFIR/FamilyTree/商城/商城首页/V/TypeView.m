
//
//  TypeView.m
//  ListV
//
//  Created by imac on 16/8/5.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "TypeView.h"
#import "GuessLikeCell.h"

@interface TypeView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionV;

@property (strong,nonatomic) NSArray<GoodsDatalist *> *typeArr;

@end

@implementation TypeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)setTypeView:(NSMutableArray<GoodsDatalist *> *)typeArr{
    _typeArr = typeArr;
    _collectionV.frame =CGRectMake(5, 0, __kWidth-10,(__kWidth*5/18+80)*(_typeArr.count/2+_typeArr.count%2));
    [_collectionV reloadData];
}

- (void)initView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(5, 0, __kWidth-10,(__kWidth*5/18+80)*(_typeArr.count/2+_typeArr.count%2)) collectionViewLayout:flowLayout];
    [self addSubview:_collectionV];
    _collectionV.scrollEnabled = NO;
    [_collectionV registerClass:[GuessLikeCell class] forCellWithReuseIdentifier:@"GuessLikeCell"];
    _collectionV.backgroundColor = [UIColor whiteColor];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;

}
#pragma mark -UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%lu",(unsigned long)_typeArr.count);
    return _typeArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GuessLikeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GuessLikeCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[GuessLikeCell alloc]initWithFrame:CGRectMake(0, 0, (__kWidth-10)/2, __kWidth*5/18+80)];
    }
    GoodsDatalist *goods = _typeArr[indexPath.row];
    cell.goodIV.imageURL = [NSURL URLWithString:goods.CoCover];
    cell.goodNameLb.text = goods.CoConame;
    CGFloat money = goods.CoprActpri;
    cell.payMoneyLb.text = [NSString stringWithFormat:@"¥%.1f",money];
    CGFloat moneyYJ = goods.CoprMoney;
    cell.quoteLb.text = [NSString stringWithFormat:@"¥%.1f",moneyYJ];
    NSMutableAttributedString *quoteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",cell.quoteLb.text]];
    [quoteStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(0, quoteStr.length)];
    cell.quoteLb.attributedText = quoteStr;//加横线
    cell.shoppingBtn.tag = indexPath.row;
    [cell.shoppingBtn addTarget:self action:@selector(addInto:) forControlEvents:BtnTouchUpInside];
    cell.goodId = [NSString stringWithFormat:@"%ld",(long)goods.CoId];
    cell.goodTypeId = [NSString stringWithFormat:@"%ld",(long)goods.CoprId];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GuessLikeCell *cell = (GuessLikeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate selectTypeCellGoodsId:cell.goodId];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((__kWidth-10)/2, __kWidth*5/18+80);
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

#pragma mark ==加入购物车==
- (void)addInto:(UIButton*)sender{
    NSLog(@"商品%ld加入购物车",(long)sender.tag);
    GuessLikeCell *cell = (GuessLikeCell *)[self.collectionV cellForItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    [TCJPHTTPRequestManager requestPostAddtoCartWithGoodNumber:cell.goodId goodsTypeId:cell.goodTypeId];
}

@end
