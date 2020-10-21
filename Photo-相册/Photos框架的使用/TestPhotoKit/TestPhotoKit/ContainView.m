//
//  ContainView.m
//  TestPhotoKit
//
//  Created by admin on 16/7/8.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ContainView.h"
@interface ContainView()

@property (nonatomic, weak) id<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> delegate;
@end

@implementation ContainView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>)delegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        [self setupViews];

    }
    return self;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = _delegate;
        _collectionView.dataSource = _delegate;
        [_collectionView registerNib:[UINib nibWithNibName:@"AlbumCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:ALBUMCELLID];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)setupViews {
    [self addSubview:self.collectionView];
}
@end
