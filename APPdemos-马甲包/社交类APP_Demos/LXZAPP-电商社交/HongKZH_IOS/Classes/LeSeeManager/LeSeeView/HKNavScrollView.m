//
//  HKNavScrollView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKNavScrollView.h"
#import "HKNavItemCollectionViewCell.h"
@interface HKNavScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSMutableArray *btnArray;
@property (nonatomic, strong)UIView *selectLine;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UICollectionView *collectionView;
@end

@implementation HKNavScrollView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//    }];
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"HKNavItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HKNavItemCollectionViewCell"];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _collectionView.bounds.size.height-1, _collectionView.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        [_collectionView addSubview:line];
        UIView *selectLine = [[UIView alloc]initWithFrame:CGRectMake(0, _collectionView.bounds.size.height-2, 70, 2)];
        _selectLine = selectLine;
        selectLine.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:146.0/255.0 blue:255.0/255.0 alpha:1];
        [_collectionView addSubview:selectLine];
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
    return self.navArray.count;
}

// 设置cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HKNavItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKNavItemCollectionViewCell class]) forIndexPath:indexPath];
    if (self.navArray.count>0) {
        if (self.item == indexPath.item) {
            cell.isSelect = YES;
        }else{
            cell.isSelect = NO;
        }
        cell.text = self.navArray[indexPath.row];
    }
    return cell;
}

// 设置cell大小 itemSize：可以给每一个cell指定不同的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(70, self.bounds.size.height);
}


// 设置UIcollectionView整体的内边距（这样item不贴边显示）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // 上 左 下 右
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// 设置minimumLineSpacing：cell上下之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 设置minimumInteritemSpacing：cell左右之间最小的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// 选中cell的回调
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.item = indexPath.item;
    
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        _scrollView = scrollView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = NO;
    }
    return _scrollView;
}
-(void)setItem:(NSInteger)item{
    _item = item;
    [UIView animateWithDuration:0.1 animations:^{
        self.selectLine.x = item*70;
    }];
    
    [self.collectionView reloadData];
    self.selectCategory((int)item);
}
-(void)setNavArray:(NSMutableArray *)navArray{
    _navArray = navArray;
    [self.collectionView reloadData];

        
    
}
@end
