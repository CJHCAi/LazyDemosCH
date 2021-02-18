
//
//  ShoppingTypeView.m
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ShoppingTypeView.h"
#import "ShoppingTypeCell.h"

@interface ShoppingTypeView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong,nonatomic) UICollectionView *collectionView;

@end

@implementation ShoppingTypeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    CGFloat w=self.frame.size.width;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.headerReferenceSize = CGSizeMake(0, 0);
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, __kWidth/4) collectionViewLayout:flowLayout];
    [self addSubview:_collectionView];
    flowLayout.itemSize = CGSizeMake(w/4, w/4);
    flowLayout.minimumLineSpacing =0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView.backgroundColor = LH_RGBCOLOR(236, 236, 236);
    _collectionView.delegate =self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[ShoppingTypeCell class] forCellWithReuseIdentifier:@"ShoppingTypeCell"];
}

#pragma mark -UICollectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShoppingTypeCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ShoppingTypeCell alloc]initWithFrame:CGRectMake(0, 0, __kWidth/4, __kWidth/4)];
    }
    NSArray *titleArr = @[@"实物物品",@"虚拟物品",@"同城热卖",@"优惠专区"];
    NSArray *imageNames = @[@"real",@"virtual",@"selling",@"preferential"];
    cell.typeLb.text = titleArr[indexPath.row];
    cell.typeIV.image = MImage(imageNames[indexPath.row]);
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingTypeCell *cell = (ShoppingTypeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate pushViewTitle:cell.typeLb.text];
}


@end
