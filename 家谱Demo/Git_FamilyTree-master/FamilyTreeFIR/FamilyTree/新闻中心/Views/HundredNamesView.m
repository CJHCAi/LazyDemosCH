//
//  HundredNamesView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "HundredNamesView.h"
#import "CustonCollectionViewCell.h"
#import "FamilyNamesViewController.h"
static NSString *const kReusableCollecCellIdentifier = @"CollectioncellIdentifier";

@interface HundredNamesView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    NSTimer *_timer;
    NSInteger _contentOffsetX;
}


@end
@implementation HundredNamesView

-(void)dealloc{
    [_timer invalidate];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addSubview:self.collectionView];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
        _contentOffsetX = 5.9;
        [_timer fireDate];

    }
    return self;
}

#pragma mark *** timerEvents ***

-(void)respondsToTimer{
    CGPoint contenOff = self.collectionView.contentOffset;
    [self.collectionView setContentOffset:CGPointMake(contenOff.x+_contentOffsetX, 0) animated:YES];
}

#pragma mark *** ScollViewDelegate ***


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x>=scrollView.contentSize.width-self.bounds.size.width) {
        _contentOffsetX = -5;
    }
    if (scrollView.contentOffset.x<=0) {
        _contentOffsetX = 5;
    }
    
}
#pragma mark *** collectionViewDataSource ***

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.BJXArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kReusableCollecCellIdentifier forIndexPath:indexPath];
    //cell.displayLabel.text = @"王";
    
    cell.hundredsNamesModel = self.BJXArr[indexPath.row];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FamilyNamesViewController *famName = [[FamilyNamesViewController alloc] initWithTitle:@"百家姓" image:nil];
    famName.FaId = self.BJXArr[indexPath.row].FaId;
    [[self viewController].navigationController pushViewController:famName animated:YES];
}


#pragma mark *** getters ***
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(50, 30);
        flowLayout.minimumLineSpacing = 0*AdaptationWidth();
        flowLayout.minimumInteritemSpacing = 0*AdaptationWidth();
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:AdaptationFrame(0, 32, self.bounds.size.width/AdaptationWidth(), 257) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CustonCollectionViewCell class] forCellWithReuseIdentifier:kReusableCollecCellIdentifier];
        
    }
    return _collectionView;
}




@end
