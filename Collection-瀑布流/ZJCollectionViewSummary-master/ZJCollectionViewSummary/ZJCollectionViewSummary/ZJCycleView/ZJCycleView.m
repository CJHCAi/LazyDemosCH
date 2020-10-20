//
//  ZJCycleView.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/9.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJCycleView.h"
#import "ZJCycleViewCell.h"
#import "ZJPageControl.h"
#import "UIImageView+WebCache.h"

//轮播间隔
static CGFloat timeInterval = 3.0f;
static CGFloat controlHeight = 35.0f;

@interface ZJCycleView ()<UICollectionViewDelegate,UICollectionViewDataSource>

//UI相关
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) ZJPageControl *pageControl;

@property (nonatomic, weak) NSTimer *timer;

//数据
@property (nonatomic, strong) NSMutableArray *data;

@property (nonatomic, strong) UIImage *placeholderImage;

@end

@implementation ZJCycleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _autoCycleTimeInterval = timeInterval;
        _showPageControl = YES;
        _pageControlLocation = ZJCyclePageContolLocationLeft;
        _pageContolStyle = ZJCyclePageContolStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self addSubview:self.collectionView];
    if (self.showPageControl) {
        [self addSubview:self.pageControl];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(showNext) userInfo:nil repeats:YES];
}

/**
 初始化方法
 
 @param frame 位置尺寸
 @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
 @param placeholderImage 占位图片
 @return ZJCycleView对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray <NSString *> *)imageUrls
             placeholderImage:(UIImage*)placeholderImage
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initialization];
        _cycleViewType = CycleViewImage;
        _autoCycleTimeInterval = timeInterval;
        _showPageControl = YES;
        _pageControlLocation = ZJCyclePageContolLocationLeft;
        _pageContolStyle = ZJCyclePageContolStyleNone;
        [self setupUI];
        _data = [self setDataWithArray:imageUrls];
        [_collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
        self.placeholderImage = placeholderImage;
        _pageControl.numberOfPages = imageUrls.count;
    }
    return self;
}

/**
 初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20
 
 @param frame 位置尺寸
 @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
 @param titles 每张图片对应要显示的文字数组
 @param placeholderImage 占位图片
 @return ZJCycleView对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    imageUrls:(NSArray <NSString *> *)imageUrls
                       titles:(NSArray <NSString *> *)titles
             placeholderImage:(UIImage*)placeholderImage
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initialization];
        //初始化数据
        _cycleViewType = CycleViewSeparateTitleAndImage;
        _autoCycleTimeInterval = timeInterval;
        _showPageControl = NO;
        //设置UI（先初始化数据，在设置UI）
        [self setupUI];
        _data = [self setDataWithArray:imageUrls];
        [_collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
        _titles = [self setDataWithArray:titles];
        self.placeholderImage = placeholderImage;
        _pageControl.numberOfPages = imageUrls.count;
    }
    return self;
}

/**
 初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20
 
 @param frame 位置尺寸
 @param arrayDict 是字典数组：（字典结构为：@{@"imageUrl":@"",@"title":@""}）imageUrl可以是本地的，也可以是网络的图片链接
 @param placeholderImage 占位图片
 @return ZJCycleView对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                    arrayDict:(NSArray <NSDictionary *> *)arrayDict
             placeholderImage:(UIImage*)placeholderImage
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self initialization];
        _cycleViewType = CycleViewMergeTitleAndImage;
        _autoCycleTimeInterval = timeInterval;
        _showPageControl = NO;
        [self setupUI];
        _data = [self setDataWithArray:arrayDict];
        [_collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
        self.placeholderImage = placeholderImage;
        _pageControl.numberOfPages = arrayDict.count;
    }
    return self;
}

/**
 初始化方法
 
 @param frame 位置尺寸
 @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
 @param placeholderImage 占位图片
 @return ZJCycleView对象
 */
+ (instancetype)cycleViewWithFrame:(CGRect)frame
                         imageUrls:(NSArray <NSString *> *)imageUrls
                  placeholderImage:(UIImage *)placeholderImage
{
    ZJCycleView *cycleView = [[self alloc] initWithFrame:frame imageUrls:imageUrls placeholderImage:placeholderImage];
    
    return cycleView;
}

/**
 初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20
 
 @param frame 位置尺寸
 @param imageUrls 需要加载的图片数组，可以是本地的，也可以是网络的图片
 @param titles 每张图片对应要显示的文字数组
 @param placeholderImage 占位图片
 @return ZJCycleView对象
 */
+ (instancetype)cycleViewWithFrame:(CGRect)frame
                    imageUrls:(NSArray <NSString *> *)imageUrls
                       titles:(NSArray <NSString *> *)titles
             placeholderImage:(UIImage*)placeholderImage
{
    ZJCycleView *cycleView = [[self alloc] initWithFrame:frame imageUrls:imageUrls titles:titles placeholderImage:placeholderImage];
    
    return cycleView;
}

/**
 初始化方法：图片带文字说明的不显示分页控件，但是会有总数和当前页的显示：2/20
 
 @param frame 位置尺寸
 @param arrayDict 是字典数组（字典结构为：@{@"imageUrl":@"",@"title":@""}）:imageUrl可以是本地的，也可以是网络的图片链接
 @param placeholderImage 占位图片
 @return ZJCycleView对象
 */
+ (instancetype)cycleViewWithFrame:(CGRect)frame
                         arrayDict:(NSArray <NSDictionary *> *)arrayDict
                  placeholderImage:(UIImage*)placeholderImage
{
    ZJCycleView *cycleView = [[self alloc] initWithFrame:frame arrayDict:arrayDict placeholderImage:placeholderImage];
    
    return cycleView;
}

#pragma mark -
#pragma mark CollectionViewDelegate&DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellId = @"ZJCycleViewCell";
    
    ZJCycleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    if (self.data.count > 0) {
        NSString *currentPage = [NSString stringWithFormat:@"%ld / %lu",(long)indexPath.row,self.data.count - 2];
        NSString *currentStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:currentPage];
        UIFont *font = [UIFont systemFontOfSize:20];
        [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,currentStr.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(currentStr.length,currentPage.length-currentStr.length)];
        cell.currentPageL.attributedText = attrString;
    }
    if (self.cycleViewType == CycleViewMergeTitleAndImage) {
        NSDictionary *dict = self.data[indexPath.row];
        if ([self isJudgeValidUrl:dict[@"imageUrl"]]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"imageUrl"]] placeholderImage:self.placeholderImage];
        }else{
            cell.imageView.image = [UIImage imageNamed:dict[@"imageUrl"]];
        }
        cell.titleL.text = dict[@"title"];
    }else if(self.cycleViewType == CycleViewImage){
        if ([self isJudgeValidUrl:self.data[indexPath.row]]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.data[indexPath.row]] placeholderImage:self.placeholderImage];
        }else{
            cell.imageView.image = [UIImage imageNamed:self.data[indexPath.row]];
        }
        cell.titleBackgroundView.hidden = YES;
    }else if(self.cycleViewType == CycleViewSeparateTitleAndImage){
        if ([self isJudgeValidUrl:self.data[indexPath.row]]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.data[indexPath.row]] placeholderImage:self.placeholderImage];
        }else{
            cell.imageView.image = [UIImage imageNamed:self.data[indexPath.row]];
        }
        cell.titleL.text = self.titles[indexPath.row];
    }
    return cell;
}

//手动拖拽结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self cycleScroll];
    //拖拽动作后间隔3s继续轮播
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:self.autoCycleTimeInterval]];
}

//自动轮播结束
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self cycleScroll];
}

//循环显示
- (void)cycleScroll
{
    NSInteger page = _collectionView.contentOffset.x/_collectionView.bounds.size.width;
    if (page == 0) {//滚动到左边
        _collectionView.contentOffset = CGPointMake(_collectionView.bounds.size.width * (_data.count - 2), 0);
        _pageControl.currentPage = _data.count - 2;
    }else if (page == _data.count - 1){//滚动到右边
        _collectionView.contentOffset = CGPointMake(_collectionView.bounds.size.width, 0);
        _pageControl.currentPage = 0;
    }else{
        _pageControl.currentPage = page - 1;
    }
}

#pragma mark -
#pragma mark Setter
- (void)setTitles:(NSArray<NSString *> *)titles
{
    _titles = [self setDataWithArray:titles];
    _pageControl.hidden = YES;
    [_collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
    _pageControl.numberOfPages = titles.count;
}

- (void)setImages:(NSArray<NSString *> *)images
{
    _data = [self setDataWithArray:images];
    [_collectionView setContentOffset:CGPointMake(_collectionView.bounds.size.width, 0)];
    _pageControl.numberOfPages = images.count;
}

#pragma mark -
#pragma mark 轮播方法
//自动显示下一个
- (void)showNext
{
    //手指拖拽是禁止自动轮播
    if (_collectionView.isDragging) {return;}
    CGFloat targetX =  _collectionView.contentOffset.x + _collectionView.bounds.size.width;
    [_collectionView setContentOffset:CGPointMake(targetX, 0) animated:true];
}

- (void)dealloc
{
    [_timer invalidate];
}
#pragma mark - set方法
- (void)setPageContolStyle:(ZJCyclePageContolStyle)pageContolStyle
{
    _pageContolStyle = pageContolStyle;
    
    if (pageContolStyle == ZJCyclePageContolStyleNone) {
        self.pageControl.pointSize = CGSizeMake(8, 8);
    }else if (pageContolStyle == ZJCyclePageContolStyleRectangle){
        self.pageControl.pointSize = CGSizeMake(10, 4);
        
        self.pageControl.currentImage = [self createImageColor:[UIColor redColor] size:CGSizeMake(10, 5)];
        self.pageControl.pageImage = [self createImageColor:[UIColor blueColor] size:CGSizeMake(10, 5)];
        
    }else if(pageContolStyle == ZJCyclePageContolStyleImage){
        self.pageControl.pointSize = CGSizeMake(8, 8);
        self.pageControl.currentImage =[UIImage imageNamed:@"check"];
        self.pageControl.pageImage =[UIImage imageNamed:@"check1"];
    }
}

//颜色生成图片
- (UIImage *)createImageColor:(UIColor *)color size:(CGSize)size
{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    //绘制颜色区域
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    [color setFill];
    [path fill];
    
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 当选中的ZJCyclePageContolStyle 是ZJCyclePageContolStyleImage, 图片类型的时候调用，如果不调用使用默认图片
 
 @param currentImage 选中图片
 @param pageImage 默认图片
 */
-(void)currentImage:(UIImage *)currentImage
          pageImage:(UIImage*)pageImage
{
    self.pageControl.currentImage = currentImage;
    self.pageControl.pageImage = pageImage;
}
/**
 当选中的ZJCyclePageContolStyle 不是ZJCyclePageContolStyleImage,如果不使用默认颜色，可以调用此方法设置
 
 @param currentColor 选中颜色
 @param pageColor 默认颜色
 */
-(void)currentColor:(UIColor *)currentColor
          pageColor:(UIColor *)pageColor
{
    self.pageControl.currentPageIndicatorTintColor = currentColor;
    self.pageControl.pageIndicatorTintColor = pageColor;
}

- (NSMutableArray *)setDataWithArray:(NSArray *)array
{
    NSMutableArray *data = [NSMutableArray arrayWithArray:array];
    [data addObject:array.firstObject];
    [data insertObject:array.lastObject atIndex:0];
    return data;
}

- (BOOL)isJudgeValidUrl:(NSString *)urlStr
{
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlPredicate evaluateWithObject:urlStr];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = true;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[ZJCycleViewCell class]  forCellWithReuseIdentifier:@"ZJCycleViewCell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (ZJPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[ZJPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - controlHeight, self.bounds.size.width, controlHeight)];
        _pageControl.pointSize = CGSizeMake(8, 8);
        _pageControl.pageIndicatorTintColor = [UIColor blueColor];
        _pageControl.enabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

@end
