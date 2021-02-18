//
//  ScrollerView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ScrollerView.h"


@interface ScrollerView()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView; /*滚动图*/
@property (nonatomic,strong) UIPageControl *pageContro; /*分页控件*/
@property (nonatomic,strong) UIImageView *leftImage; /*滚动图左*/
@property (nonatomic,strong) UIImageView *centerImage; /*中*/
@property (nonatomic,strong) UIImageView *rightImage; /*右*/

@property (nonatomic,strong) NSTimer *timer; /*定时器*/



@end

@implementation ScrollerView
-(void)dealloc{
    //摧毁定时器
    [self.timer invalidate];
}
- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)imageNames
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (!imageNames) {
            [self initData];
        }else{
            _imageNames = imageNames;
        }
        
        [self initUI];
        
        
    }
    return self;
}
#pragma mark *** 初始化数据 ***
-(void)initData{
    _imageNames = [@[@"icon_1",@"lunbo_bg",@"icon_2",@"icon_3"] mutableCopy];
}

#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.leftImage];
    [self.scrollView addSubview:self.centerImage];
    [self.scrollView addSubview:self.rightImage];
    [self addSubview:self.pageContro];
    [self updateImageView];
    
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0f];
}


#pragma mark *** 轮播更新图片 ***
-(void)updateImageView{
//    self.leftImage.image = MImage(_imageNames.lastObject);
//    self.centerImage.image = MImage(_imageNames[0]);
//    self.rightImage.image = MImage(_imageNames[1]);
    
    if ([self.imageNames[0] rangeOfString:@"http"].location != NSNotFound) {
        [self.leftImage setImageWithURL:[NSURL URLWithString:self.imageNames.lastObject] placeholder:MImage(@"icon_3")];
        
        [self.centerImage setImageWithURL:[NSURL URLWithString:self.imageNames[0]] placeholder:MImage(@"icon_1")];
        
        [self.rightImage setImageWithURL:[NSURL URLWithString:self.imageNames[1]] placeholder:MImage(@"lunbo_bg")];
    }else{
        self.leftImage.image = MImage(_imageNames.lastObject);
        self.centerImage.image = MImage(_imageNames[0]);
        self.rightImage.image = MImage(_imageNames[1]);
    }
    
    
    
    self.pageContro.numberOfPages = _imageNames.count;
    
}

#pragma mark *** respondsToTimer ***

-(void)respondsToTimer{
    //改变滚动图偏移
    [self.scrollView setContentOffset:CGPointMake(2*SelfView_width, 0) animated:YES];
}

#pragma mark *** UIScrollViewDelegate ***

// 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 暂停timer
    self.timer.fireDate = [NSDate distantFuture];
}

// 停止拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // 启动timer
    self.timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2.0f];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x>=2*SelfView_width) {
        id firstObj = [_imageNames firstObject];
        [_imageNames removeObject:firstObj];
        [_imageNames addObject:firstObj];
        _pageContro.currentPage = self.pageContro.currentPage == _imageNames.count - 1 ? 0 : ++ self.pageContro.currentPage;
        
    }else if (scrollView.contentOffset.x<=0){
        id lastObj = [_imageNames lastObject];
        [_imageNames removeObject:_imageNames.lastObject];
        [_imageNames insertObject:lastObj atIndex:0];
        self.pageContro.currentPage = self.pageContro.currentPage == 0 ? _imageNames.count - 1 : -- self.pageContro.currentPage;
    }else{
        return;
    }
    [self updateImageView];
    [scrollView setContentOffset:CGPointMake(SelfView_width, 0) animated:NO];
}


#pragma mark *** getters ***

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake(3*self.bounds.size.width, SelfView_height);
        _scrollView.contentOffset = CGPointMake(SelfView_width, 0);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
    }
    return _scrollView;
}
-(UIImageView *)leftImage{
    if (!_leftImage) {
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SelfView_width, SelfView_height)];
        _leftImage.backgroundColor = [UIColor blueColor];
    }
    return _leftImage;
}


-(UIImageView *)centerImage{
    if (!_centerImage) {
        _centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(SelfView_width, 0, SelfView_width, SelfView_height)];
        _centerImage.backgroundColor = [UIColor purpleColor];
        
        
    }
    return _centerImage;
}

-(UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectMake(2*SelfView_width, 0, SelfView_width, SelfView_height)];
        _rightImage.backgroundColor = [UIColor blackColor];
    }
    return _rightImage;
}
-(UIPageControl *)pageContro{
    if (!_pageContro) {
        _pageContro = [[UIPageControl alloc] init];
        _pageContro.bounds = CGRectMake(0, 0, SelfView_width, 30);
        _pageContro.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.scrollView.frame)-CGRectGetMidY(_pageContro.bounds));
        
    }
    return _pageContro;
}
-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
        
    }
    return _timer;
}
@end
