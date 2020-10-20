//
//  SDEditFilterItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDEditFilterItemsView.h"
#import "SDFilterImageCollectionViewCell.h"
#import "SDFilterFunctionModel.h"
@interface SDEditFilterItemsView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) UICollectionView * collectioview;
@end

@implementation SDEditFilterItemsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setFilterList:(NSArray *)filterList
{
    _filterList = filterList;
    
    [self.collectioview reloadData];
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filterList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDFilterImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SDFilterImageCollectionViewCell ReuseIdentifier] forIndexPath:indexPath];

    SDFilterFunctionModel * filterModel = self.filterList[indexPath.row];
    
    [cell loadFilterModel:filterModel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.filterList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDFilterFunctionModel * model = obj;
        model.isSelected = false;
    }];
    SDFilterFunctionModel * model = self.filterList[indexPath.row];
    model.isSelected = true;
    
    [collectionView reloadData];
    
}


- (UICollectionView *)collectioview
{
    if (!_collectioview) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(MAXSize(300), self.bounds.size.height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        UICollectionView * theView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        theView.delegate = self;
        theView.dataSource = self;
        [theView registerClass:[SDFilterImageCollectionViewCell class] forCellWithReuseIdentifier:[SDFilterImageCollectionViewCell ReuseIdentifier]];
        [theView setBackgroundColor:[UIColor whiteColor]];
        
        theView.showsHorizontalScrollIndicator = false;
        [self addSubview:theView];
        _collectioview = theView;
    }
    return _collectioview;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
