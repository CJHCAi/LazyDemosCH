//
//  SXTClassListCollectionView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTClassListCollectionView.h"

#import "SXTClassListCollectionCell.h"



@interface SXTClassListCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)   UICollectionView *collectionView;              /** 创建一个collection */

@end

@implementation SXTClassListCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[SXTClassListCollectionCell class] forCellWithReuseIdentifier:@"SXTClassListCollectionCell"];
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.classListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"SXTClassListCollectionCell";
    SXTClassListCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    cell.classModel = self.classListArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectCoods) {
        _selectCoods([_classListArray[indexPath.row] GoodsId]);
    }
}





@end
