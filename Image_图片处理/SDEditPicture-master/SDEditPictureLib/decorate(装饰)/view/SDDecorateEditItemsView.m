//
//  SDDecorateEditItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDecorateEditItemsView.h"

#import "SDDecorateFunctionModel.h"

#import "SDDecorateEditItemsCollectionViewCell.h"

@interface SDDecorateEditItemsView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView * theCollectionView;


@end

@implementation SDDecorateEditItemsView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_configView];
    }
    return self;
}

- (void)sd_configView
{
    [self theCollectionView];
}

- (void)setDecorateList:(NSArray *)decorateList
{
    _decorateList = decorateList;
    SDDecorateFunctionModel * model = [self.decorateList firstObject];
    @weakify_self;
    [[RACObserve(model, isSelected) distinctUntilChanged] subscribeNext:^(id x) {
        @strongify_self;
        [self.theCollectionView reloadData];
    }];

    [self.theCollectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.decorateList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    SDDecorateEditItemsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SDDecorateEditItemsCollectionViewCell ReuseIdentifier] forIndexPath:indexPath];
    SDDecorateFunctionModel * model = self.decorateList[row];
    
    [cell loadDecorateModel:model];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0 ) {
        
        SDDecorateFunctionModel* resetModel = self.decorateList[row];
        // 通知下去，我这里点击了 reset Model
        [resetModel.done_subject sendNext:@"1"];
        
        return;
    }
    
    SDDecorateFunctionModel * model = self.decorateList[row];
    // 这里只是通知，不会发送啥东西的
    [model.done_subject sendNext:@"1"];
    
}



- (UICollectionView *)theCollectionView
{
    if (!_theCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(MAXSize(240), self.bounds.size.height);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        UICollectionView * theView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [self addSubview:theView];
        
        theView.dataSource = self;
        theView.delegate = self;
        
        [theView registerClass:[SDDecorateEditItemsCollectionViewCell class] forCellWithReuseIdentifier:[SDDecorateEditItemsCollectionViewCell ReuseIdentifier]];
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
