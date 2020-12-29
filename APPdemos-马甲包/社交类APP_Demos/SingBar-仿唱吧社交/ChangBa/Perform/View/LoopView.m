//
//  LoopView.m
//  轮播图
//
//  Created by tarena on 16/9/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "LoopView.h"
#import <UIImageView+WebCache.h>

@implementation LoopView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *fl = [UICollectionViewFlowLayout new];
   
        fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.cv = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:fl];
        self.cv.showsHorizontalScrollIndicator = NO;
        
        self.cv.delegate = self;
        self.cv.dataSource = self;
        [self addSubview:self.cv];
        
        
        [self.cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.cv.pagingEnabled = YES;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moveAction) userInfo:nil repeats:YES];
      
    }
    return self;
}

-(void)moveAction{
    
    NSIndexPath *currentIndex = [[self.cv indexPathsForSelectedItems]lastObject];
    
    NSInteger row = currentIndex.row + 1;
    NSInteger section = currentIndex.section;
    if (row==self.images.count) {
        row = 0;
        section+=1;
    }
    
    [self.cv selectItemAtIndexPath: [NSIndexPath indexPathForRow:row inSection:section] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
    
    
    
}



-(void)setImages:(NSArray *)images{
    _images = images;
    
    //让cv开始时显示到中间的位置
    [self.cv selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:5000] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
  
    
}


#pragma mark UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 10000;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *iv = [cell viewWithTag:1];
    if (!iv) {
        iv = [[UIImageView alloc]initWithFrame:cell.bounds];
        [cell addSubview:iv];
        iv.tag = 1;
    }
    if (![self.images[indexPath.row] isKindOfClass:[UIImage class]]) {
        [iv sd_setImageWithURL:self.images[indexPath.row]];
    }else{
//        iv.image = [UIImage imageNamed:self.images[indexPath.row]];
        iv.image = self.images[indexPath.row];
    }
    
    return cell;
    
    
}

//控制显示大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    return self.bounds.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,0,0,0);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(moveAction) userInfo:nil repeats:YES];

}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

}
//结束减速
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    当滚动停止的时候
    //取到当前显示的cell
    UICollectionViewCell *cell = [self.cv.visibleCells lastObject];
    //    获取cell的位置
    NSIndexPath *index = [self.cv indexPathForCell:cell];
    //    选中到 获取的位置
    [self.cv selectItemAtIndexPath:index animated:NO scrollPosition:UICollectionViewScrollPositionRight];
}

@end
