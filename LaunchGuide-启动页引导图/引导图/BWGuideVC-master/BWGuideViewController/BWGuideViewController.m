//
//  BWGuideViewController.m
//  BWGuideViewController
//
//  Created by syt on 2019/12/20.
//  Copyright © 2019 syt. All rights reserved.
//

#import "BWGuideViewController.h"
#import "BWGuideCollectionViewCell.h"
#import "BWTabBarViewController.h"


@interface BWGuideViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *imgs;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation BWGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.blueColor;
    [self loadSubViews];
}

- (void)loadSubViews
{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
}



#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BWGuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"guide" forIndexPath:indexPath];
    BOOL isHiden = indexPath.item == self.imgs.count - 1 ? NO : YES;
    [cell updateContent:[NSString stringWithFormat:@"%@", self.imgs[indexPath.item]] isHiden:isHiden];
    cell.enterButtonClick = ^{
        [self jumpMainVC];
    };
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / k_Screen_Width;
}

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    if (self.pageControl.currentPage == self.imgs.count - 1) {
//        [self jumpMainVC];
//    }
//}

- (void)jumpMainVC
{
    [self presentViewController:[BWTabBarViewController new] animated:NO completion:nil];
}















#pragma mark - lazy loading

- (NSArray *)imgs
{
    if (!_imgs) {
        _imgs = @[@"walkthrough_1.jpg", @"walkthrough_2.jpg", @"walkthrough_3.jpg"];
    }
    return _imgs;
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake(k_Screen_Width, k_Screen_Height);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 0.0;
        _layout.minimumInteritemSpacing = 0.0;
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.contentSize = CGSizeMake(k_Screen_Width * self.imgs.count, 0);
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[BWGuideCollectionViewCell class] forCellWithReuseIdentifier:@"guide"];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(k_Screen_Width / 2 - 50, k_Screen_Height - k_TabBar_DValue_Height - 30, 100, 30)];
        _pageControl.numberOfPages = self.imgs.count;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = UIColor.whiteColor;
        _pageControl.currentPageIndicatorTintColor = UIColor.redColor;
    }
    return _pageControl;
}





@end
