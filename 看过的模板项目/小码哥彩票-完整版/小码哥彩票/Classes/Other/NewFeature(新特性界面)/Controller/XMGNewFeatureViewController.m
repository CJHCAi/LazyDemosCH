//
//  XMGNewFeatureViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/30.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//
#define XMGPages 4

#import "XMGNewFeatureViewController.h"
#import "XMGNewFeatureCell.h"
#import "XMGTabBarController.h"
// 展示图片的控件应该添加到collectionView上

@interface XMGNewFeatureViewController ()

@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic, weak) UIImageView *guideView;
@property (nonatomic, weak) UIImageView *guideLargetView;
@property (nonatomic, weak) UIImageView *guideSmallView;
@property (nonatomic, weak) UIButton *startButton;

@end

@implementation XMGNewFeatureViewController

static NSString *ID = @"cell";



// 1.初始化的时候必须设置布局参数，通常使用系统提供的流水布局UICollectionViewFlowLayout
// 2.cell必须通过注册
// 3.自定义cell

- (instancetype)init{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    layout.itemSize = XMGScreenBounds.size;
    // 设置cell之间间距
    layout.minimumInteritemSpacing = 0;
    // 设置行距
    layout.minimumLineSpacing = 0;
//
//    // 设置每一组的内间距
//    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    return  [super initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    // 注册cell
    [self.collectionView registerClass:[XMGNewFeatureCell class] forCellWithReuseIdentifier:ID];
    
    [self setUpAllChildView];
    
}


#pragma mark - UICollectionView有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


#pragma mark - 返回第section组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return XMGPages;
}

#pragma mark - 返回每个cell长什么样
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    XMGNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSString *imageName = [NSString stringWithFormat:@"guide%ldBackground",indexPath.item + 1];
    cell.image = [UIImage imageNamed:imageName];
    cell.backgroundColor=[UIColor purpleColor];
    // 告诉cell什么时候是最后一行
//        [cell setUpIndexPath:indexPath count:XMGPages];

    return cell;
    
}


#pragma mark - 添加所有子控件
- (void)setUpAllChildView
{
    // guide1
    UIImageView *guide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]];
    _guideView = guide;
    guide.centetX = self.view.centetX;
    [self.collectionView addSubview:guide];
    
    // guideLine
    UIImageView *guideLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLine"]];
    guideLine.x -= 170;
    [self.collectionView addSubview:guideLine];
    
    // largerText
    UIImageView *largerText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLargeText1"]];
    largerText.centetX = self.view.centetX;
    largerText.centetY = self.view.height * 0.7;
    _guideLargetView = largerText;
    [self.collectionView addSubview:largerText];
    
    // smallText
    UIImageView *smallText = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideSmallText1"]];
    smallText.centetX = self.view.centetX;
    smallText.centetY = self.view.height * 0.8;
    [self.collectionView addSubview:smallText];
    _guideSmallView = smallText;
    
    
     UIButton * startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setBackgroundImage:[UIImage imageNamed:@"guideStart"] forState:UIControlStateNormal];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
    startButton.centetX =self.view.centetX-50;
    startButton.centetY= self.view.height * 0.85;
    startButton.width=100;
    startButton.height=50;
    startButton.hidden=YES;
    [self.collectionView addSubview:startButton];
    _startButton=startButton;
}

// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 获取当前x偏移量
    CGFloat curOffsetX = scrollView.contentOffset.x;
    // 获取差值
    CGFloat delta = curOffsetX - _lastOffsetX;
    
    _guideView.x += 2 *  delta;
    _guideLargetView.x += 2 * delta;
    _guideSmallView.x +=  2 * delta;
    _startButton.x += 2 * delta;
    
    [UIView animateWithDuration:0.25 animations:^{
        _guideView.x -=  delta;
        _guideLargetView.x -= delta;
        _guideSmallView.x -=   delta;
        _startButton.x -= delta;
    }];
    int page = curOffsetX / self.view.width + 1;
    if (page==XMGPages) {
        _startButton.hidden=NO;
    }else{
        _startButton.hidden=YES;
    }
    
    // 修改控件的内容
    _guideView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d",page]];
    _guideLargetView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideLargeText%d",page]];
    _guideSmallView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideSmallText%d",page]];
    _lastOffsetX = curOffsetX;
    
}

// 点击立即体验按钮
- (void)start
{
    // 跳转到核心界面,push,modal,切换跟控制器的方法
    XMGKeyWindow.rootViewController = [[XMGTabBarController alloc] init];
   
    CATransition *anim = [CATransition animation];
    anim.duration = 0.5;
    anim.type = @"rippleffect";
    [XMGKeyWindow.layer addAnimation:anim forKey:nil];
}

@end
