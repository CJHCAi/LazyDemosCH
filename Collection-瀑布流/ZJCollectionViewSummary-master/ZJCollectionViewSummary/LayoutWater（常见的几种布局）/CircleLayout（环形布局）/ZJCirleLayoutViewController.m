//
//  ZJCirleLayoutViewController.m
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

#import "ZJCirleLayoutViewController.h"
#import "ZJCirleLayout.h"
#import "ZJGridLayout.h"
#import "ZJWaterLayoutCollectionViewCell.h"

@interface ZJCirleLayoutViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

/** collectionView */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据 */
@property (nonatomic, strong) NSMutableArray *images;

@end

@implementation ZJCirleLayoutViewController
static NSString *ItemIdentifier = @"ItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"环形布局";
    [self.view addSubview:self.collectionView];
    
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZJWaterLayoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.images[indexPath.row]]];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.images removeObjectAtIndex:indexPath.item];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect size = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 160);
        ZJCirleLayout *layout = [[ZJCirleLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];
        [_collectionView registerClass:[ZJWaterLayoutCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor blackColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSMutableArray *)images
{
    if (!_images) {
        _images = [NSMutableArray array];
        for (int i = 0; i < 20; i++) {
            [_images addObject:[NSString stringWithFormat:@"%d.jpg", i + 1]];
        }
    }
    return _images;
}
@end
