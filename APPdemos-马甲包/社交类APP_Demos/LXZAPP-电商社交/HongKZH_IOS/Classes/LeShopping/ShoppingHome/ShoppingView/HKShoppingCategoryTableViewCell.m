//
//  HKShoppingCategoryTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShoppingCategoryTableViewCell.h"
#import "HKHKShoppingCategoryItem.h"
@interface HKShoppingCategoryTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation HKShoppingCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.collectionView];
   
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKHKShoppingCategoryItem" bundle:nil] forCellWithReuseIdentifier:@"HKHKShoppingCategoryItem"];
        _collectionView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
#pragma mark - 代理方法 Delegate Methods
// 设置分区

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// 每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKHKShoppingCategoryItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHKShoppingCategoryItem class]) forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    return cell;
}
// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/5, 77);
}


// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(gotoCategryVC:)]) {
        [self.delegate gotoCategryVC:self.dataArray[indexPath.item]];
    }
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        if (dataArray.count>5) {
          make.height.mas_equalTo(77*2);
        }else{
            make.height.mas_equalTo(77);
        }
        
    }];
    [self.collectionView reloadData];
}
@end
