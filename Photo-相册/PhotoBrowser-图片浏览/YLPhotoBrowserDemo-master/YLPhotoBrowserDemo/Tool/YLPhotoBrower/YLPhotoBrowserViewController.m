//
//  YLPhotoBrowserViewController.m
//  SportChina
//
//  Created by 杨磊 on 2018/3/20.
//  Copyright © 2018年 Beijing Sino Dance Culture Media Co.,Ltd. All rights reserved.
//

#import "YLPhotoBrowserViewController.h"
#import "YLPBCollectionViewCell.h"
#import "SDWebImagePrefetcher.h"
#define YLPBCELL @"YLPBCollectionViewCell"
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

@interface YLPhotoBrowserViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@end

@implementation YLPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //防止iOS11 页面向下移动20
    if (@available(iOS 11.0, *)) {
        [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self setupLayoutAndCollectionView];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)setupLayoutAndCollectionView
{
    self.view.backgroundColor = [UIColor blackColor];

    UICollectionViewFlowLayout *layout= [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[YLPBCollectionViewCell class] forCellWithReuseIdentifier:YLPBCELL];
    [self.collectionView reloadData];
    self.collectionView.contentOffset = CGPointMake(SCREEN_WIDTH * self.index, 0);
    [self cusNav];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YLPBCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:YLPBCELL forIndexPath:indexPath];
    NSString *model = [self.dataAry objectAtIndex:indexPath.item];
    cell.model = model;
    @WeakObj(self);
    cell.click = ^{
        [selfWeak hideBar];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat scrollW = SCREEN_WIDTH;
    NSInteger indexf = (offsetX + scrollW * 0.5) / scrollW;
    self.bottomLabel.text = [NSString stringWithFormat:@"%ld/%ld",indexf + 1,self.dataAry.count];
}

- (NSMutableArray *)dataAry {
    if (!_dataAry) {
        _dataAry = [NSMutableArray new];
    }
    return _dataAry;
}
#pragma mark - 头部
- (void)cusNav
{
    UIView *navBack = [UIView new];
    navBack.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.view addSubview:navBack];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = navBack.bounds;
    [navBack.layer addSublayer:gradientLayer];
    
    self.customNav = navBack;
    
    UIImageView *imgLeft = [UIImageView new];
    imgLeft.frame = CGRectMake(15, 32, 22, 22);
    imgLeft.image = [UIImage imageNamed:@"icon_nav_return_white"];
    [navBack addSubview:imgLeft];
    
    UIImageView *imgRight = [UIImageView new];
    imgRight.frame = CGRectMake(SCREEN_WIDTH - 15 - 22, 30, 22, 22);
    imgRight.image = [UIImage imageNamed:@"icon_nav_download"];
    [navBack addSubview:imgRight];
    
    UIButton *buttonLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonLeft.frame = CGRectMake(0, 0, 64, 64);
    [buttonLeft addTarget:self action:@selector(popvc) forControlEvents:UIControlEventTouchUpInside];
    [navBack addSubview:buttonLeft];
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(SCREEN_WIDTH - 64, 0, 64, 64);
    [buttonRight addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    [navBack addSubview:buttonRight];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, SCREEN_HEIGHT - 85, SCREEN_WIDTH, 85);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18.f];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    label.text = [NSString stringWithFormat:@"%ld/%ld",self.index+1,self.dataAry.count];
    self.bottomLabel = label;
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[UIColor clearColor].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor];
    gradientLayer2.locations = @[@0.0, @1.0];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(0, 1.0);
    gradientLayer2.frame = label.bounds;
    [label.layer addSublayer:gradientLayer2];
}

- (void)hideBar
{
    CGRect top = self.customNav.frame;
    CGRect bot = self.bottomLabel.frame;
    if (top.origin.y == 0)
    {//隐藏
        top.origin.y = -64;
        bot.origin.y = SCREEN_HEIGHT;
        [UIView animateWithDuration:0.3 animations:^{
            self.customNav.frame = top;
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomLabel.frame = bot;
        }];
    }else
    {//出现
        top.origin.y = 0;
        bot.origin.y = SCREEN_HEIGHT - 85;
        [UIView animateWithDuration:0.3 animations:^{
            self.customNav.frame = top;
        }];
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomLabel.frame = bot;
        }];
    }
}
#pragma mark - 返回
- (void)popvc
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下载图片
- (void)download
{
    int index = self.collectionView.contentOffset.x / SCREEN_WIDTH;
    NSString *imgeUrl = [self.dataAry objectAtIndex:index];
    imgeUrl = [imgeUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *netUrl = [NSURL URLWithString:imgeUrl];
    SDWebImagePrefetcher *magePre = [SDWebImagePrefetcher sharedImagePrefetcher];
    [magePre prefetchURLs:@[netUrl] progress:^(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls) {
        UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imgeUrl];
        UIImageView *textimage = [[UIImageView alloc] initWithImage:cachedImage];

        UIImageWriteToSavedPhotosAlbum(textimage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        self.indicator = [[UIActivityIndicatorView alloc] init];
        self.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.indicator.center = self.view.center;
        [[UIApplication sharedApplication].keyWindow addSubview:self.indicator];
        [self.indicator startAnimating];
        
    } completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
    }];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [self.indicator removeFromSuperview];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
