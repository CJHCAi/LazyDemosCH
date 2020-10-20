//
//  ZJGridLayoutViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/11.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJGridLayoutViewController.h"
#import "ZJWaterLayoutCollectionViewCell.h"
#import "ZJGridLayout.h"

@interface ZJGridLayoutViewController ()
<UICollectionViewDataSource, UICollectionViewDelegate>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *imageNames;

@end

@implementation ZJGridLayoutViewController
static NSString *ItemIdentifier = @"ItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"网格布局";
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJWaterLayoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageNames[indexPath.row]]];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect size = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        ZJGridLayout *layout = [[ZJGridLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];
       
       [_collectionView registerClass:[ZJWaterLayoutCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)imageNames
{
    if (!_imageNames) {
        _imageNames = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            [_imageNames addObject:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        }
    }
    return _imageNames;
}
@end
