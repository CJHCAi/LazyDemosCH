//
//  ZJLineLayoutViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/13.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJLineLayoutViewController.h"
#import "ZJWaterLayoutCollectionViewCell.h"
#import "ZJLineScaleFlowLayout.h"
#import "ZJBlurEffect.h"

@interface ZJLineLayoutViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView      *backgroundImageV;
@property (nonatomic, strong)  UICollectionView *collectionView;
@property (nonatomic, strong)  NSMutableArray          *images;

@property (nonatomic, assign)  CGFloat startX;
@property (nonatomic, assign)  CGFloat endX;
@property (nonatomic, assign)  CGFloat startY;
@property (nonatomic, assign)  CGFloat endY;
@property (nonatomic, assign)  NSInteger currentIndex;

@property (nonatomic, strong)    ZJLineScaleFlowLayout *layout;

@end

@implementation ZJLineLayoutViewController

static NSString *ItemIdentifier = @"ItemIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"流水布局";
    self.view.backgroundColor=[UIColor whiteColor];
    [self setRightItem];
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ZJWaterLayoutCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.images[indexPath.row]]];
    return cell;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.startX = scrollView.contentOffset.x;
    self.startY = scrollView.contentOffset.y;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.endX = scrollView.contentOffset.x;
    self.endY = scrollView.contentOffset.y;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self cellToCenter];
    });
}
- (void)cellToCenter{
    //最小滚动距离
    float  dragMinDistance;
    if (self.layout.lineDirection == ZJWaterHorizontal){
        dragMinDistance = self.collectionView.bounds.size.height/20.0f;
    }else{
        dragMinDistance = self.collectionView.bounds.size.width/20.0f;
    }
    
    if (self.startX - self.endX >= dragMinDistance) {
        self.currentIndex -= 1; //向右
    }else if (self.endX - self.startX >= dragMinDistance){
        self.currentIndex += 1 ;//向左
    }
    if (self.startY - self.endY >= dragMinDistance) {
        self.currentIndex -= 1; //向上
    }else if (self.endY - self.startY >= dragMinDistance){
        self.currentIndex += 1 ;//向下
    }
    NSInteger maxIndex  = [self.collectionView numberOfItemsInSection:0] - 1;
    self.currentIndex = self.currentIndex <= 0 ? 0 :self.currentIndex;
    self.currentIndex = self.currentIndex >= maxIndex ? maxIndex : self.currentIndex;
    
    self.backgroundImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.images[self.currentIndex]]];
    if (self.layout.lineDirection == ZJWaterHorizontal){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
    }else{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
}

#pragma mark - lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGRect size = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        ZJLineScaleFlowLayout *layout = [[ZJLineScaleFlowLayout alloc] init];
        self.layout = layout;
        _collectionView = [[UICollectionView alloc] initWithFrame:size collectionViewLayout:layout];
        [_collectionView registerClass:[ZJWaterLayoutCollectionViewCell class] forCellWithReuseIdentifier:ItemIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        //        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.backgroundView = self.backgroundImageV;
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIImageView *)backgroundImageV
{
    if (_backgroundImageV == nil) {
        _backgroundImageV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _backgroundImageV.image = [UIImage imageNamed:@"1.jpg"];
        [ZJBlurEffect blurEffect:_backgroundImageV];
    }
    return _backgroundImageV;
}

- (NSMutableArray *)images
{
    if(_images == nil)
    {
        _images = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 30; i++) {
            
            [_images addObject:[NSString stringWithFormat:@"%zd.jpg", i]];
        }
    }
    return _images;
}

#pragma mark 设置右侧item
- (void)setRightItem
{
    UIButton *rightItem  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(0, 0, 50, 30);
    [rightItem setTitle:@"切换布局" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightItem addTarget:self action:@selector(clickRightItemBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItemBar = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    [self.navigationItem setRightBarButtonItem:rightItemBar];
}

#pragma mark - rightItem的监听方法
- (void)clickRightItemBar
{
    self.backgroundImageV.image = [UIImage imageNamed:@"1.jpg"];
    self.currentIndex = 0;
    if (self.layout.lineDirection == ZJWaterHorizontal)
    {
        self.layout.lineDirection = ZJWaterVertical;
        [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    } else {
        self.layout.lineDirection = ZJWaterHorizontal;
        [self.collectionView setCollectionViewLayout:self.layout animated:YES];
    }
    [self.collectionView reloadData];
}


@end
