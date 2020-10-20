//
//  SDCutEditItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDCutEditItemsView.h"
#import "SDCutEditItemsCollectionViewCell.h"

#import "SDCutFunctionModel.h"

@interface SDCutEditItemsView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView * theCollectionView;

@property (nonatomic, strong) SDCutFunctionModel * resetFunctionModel;

@end

@implementation SDCutEditItemsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setCutList:(NSArray *)cutList
{
    _cutList = cutList;
    
    [self.theCollectionView reloadData];
    
    
    [self addMonitorResetFunctionModel];
}

- (void)addMonitorResetFunctionModel
{
    self.resetFunctionModel = self.cutList[0];
    @weakify_self;
    [[RACObserve(self.resetFunctionModel, isSelected) distinctUntilChanged] subscribeNext:^(id x) {
        BOOL selected = [x boolValue];
        if (selected) {
            @strongify_self;
            [self.theCollectionView reloadData];
        }
    }];
    
}

- (void)sd_resetFunctionModel
{
    [self.cutList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDCutFunctionModel * model = obj;
         model.isSelected = false;
        if (model.cutModel == SDCutFunctionFree) {
            model.isSelected = true;
        }
    }];
    
    [self.theCollectionView reloadData];
    
    
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cutList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDCutEditItemsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SDCutEditItemsCollectionViewCell ReuseIdentifier] forIndexPath:indexPath];
    
    SDCutFunctionModel * model = self.cutList[indexPath.row];
    
    [cell loadCutFunctionModel:model];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        // 点击了重置
        SDCutFunctionModel * model = self.cutList[row]; // 一定是第一个啦
        
        [model.done_subject sendNext:@"1"]; // 这里不用关心 传了什么值,只要接受到通知了就好了
        
        return;
    }
    
    [self.cutList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDCutFunctionModel * model = obj;
        if (model.cutModel != SDCutFunctionReset) {
            model.isSelected = false;
        }
    }];
    
    SDCutFunctionModel * model = self.cutList[row];
    
    model.isSelected = true;
    
    
    [collectionView reloadData];
    
    
}


- (UICollectionView *)theCollectionView
{
    if (!_theCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(MAXSize(216), self.bounds.size.height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        UICollectionView * theView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [self addSubview:theView];
        
        theView.dataSource = self;
        theView.delegate = self;
        
        [theView registerClass:[SDCutEditItemsCollectionViewCell class] forCellWithReuseIdentifier:[SDCutEditItemsCollectionViewCell ReuseIdentifier]];
        theView.backgroundColor = [UIColor whiteColor];
        
        theView.showsHorizontalScrollIndicator = false;
        _theCollectionView = theView;
    }
    return _theCollectionView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
