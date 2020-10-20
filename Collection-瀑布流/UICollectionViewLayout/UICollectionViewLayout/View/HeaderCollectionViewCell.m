

//
//  HeaderCollectionViewCell.m
//  UICollectionViewLayout
//
//  Created by lujh on 2017/5/22.
//  Copyright © 2017年 lujh. All rights reserved.
//

#import "HeaderCollectionViewCell.h"
#import "ShufflingCollectionViewCell.h"
#import "HederCollectionViewLayout.h"

@implementation HeaderCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor orangeColor];
        // 初始化SubViews
        [self setupSubViews];
    }
    return self;
}

#pragma mark -初始化SubViews

- (void)setupSubViews {

    CGFloat H = self.frame.size.height;
    // UIScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, H);
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor greenColor];
    [self addSubview:self.scrollView];

    
    //UIPageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2, H - 40, 0, 20)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = 2;
    [self addSubview:self.pageControl];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    
    // UICollectionView
    HederCollectionViewLayout *layout = [[HederCollectionViewLayout alloc]init];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2, self.scrollView.frame.size.height) collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.scrollView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ShufflingCollectionViewCell class] forCellWithReuseIdentifier:@"ShufflingCollectionViewCell"];
   
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return  12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShufflingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShufflingCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
    
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    NSInteger section = indexPath.section;
    
    NSLog(@"section =%lu  row =%lu",section ,row);
    
}

#pragma mark -UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    self.pageControl.currentPage = page;
    
}

@end
