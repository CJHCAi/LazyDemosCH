//
//  NeedRushView.m
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "NeedRushView.h"
#import "NeedRushCell.h"

@interface NeedRushView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong,nonatomic) UICollectionView *collectionV;

@property (strong,nonatomic) NSArray<GoodsDatalist*> *rushArr;
@end

@implementation NeedRushView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setNeedView:(NSArray<GoodsDatalist *> *)rushArr{
    _rushArr = rushArr;
    
    [self initView];
}

-(void)initView{
    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake((__kWidth-160)/2, 0, __kWidth, 30)];
    [self addSubview:headV];
    headV.backgroundColor = [UIColor whiteColor];

    UIImageView *rushIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 15, 15)];
    [headV addSubview:rushIV];
    rushIV.layer.cornerRadius = 7.5;
    rushIV.image = MImage(@"grab");

    UILabel *rushTLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(rushIV)+4, 12, 36, 15)];
    [headV addSubview:rushTLb];
    rushTLb.font = MFont(14);
    rushTLb.text = @"必抢";
    rushTLb.textAlignment = NSTextAlignmentLeft;

    UILabel *rushDLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(rushTLb), 14, 100, 14)];
    [headV addSubview:rushDLb];
    rushDLb.textAlignment = NSTextAlignmentLeft;
    rushDLb.textColor = LH_RGBCOLOR(120, 120, 120);
    rushDLb.font = MFont(12);
    rushDLb.text = @"热卖好货必须哄抢";

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    _collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectYH(headV), __kWidth, self.frame.size.height-30) collectionViewLayout:flowLayout];
    [self addSubview:_collectionV];
      _collectionV.scrollEnabled = NO;
    [_collectionV registerClass:[NeedRushCell class] forCellWithReuseIdentifier:@"NeedRushCell"];
    _collectionV.backgroundColor = [UIColor whiteColor];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;

}
#pragma mark -UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _rushArr.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NeedRushCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NeedRushCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NeedRushCell alloc]initWithFrame:CGRectMake(0, 0, __kWidth/4, __kWidth/36*13)];
    }

    
    GoodsDatalist *goods = _rushArr[indexPath.row];
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
    NeedRushCell *cell = (NeedRushCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate selectCellRushGoodsId:cell.goodId];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(__kWidth/4, __kWidth*13/36);
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
