


//
//  ZPScrollerScaleView.m
//  ChooseRoleScroller
//
//  Created by admin on 2019/7/31.
//  Copyright © 2019 April. All rights reserved.
//

#import "ZPScrollerScaleView.h"

#define BaseTag 722 //基础Tag数值
@implementation ZPScrollerScaleViewConfig
@end
@interface ZPScrollerScaleView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;

/**当前偏移所在位置*/
@property (nonatomic, assign) NSInteger pageIndex;

/**判断滑动方向*/
@property (nonatomic, assign) CGFloat lastContentOffset;

/**记录当前滚动位置*/
@property (nonatomic, assign) CGFloat lastOffsetX;

/**子项配置*/
@property (nonatomic, strong) ZPScrollerScaleViewConfig *config;

@end

@implementation ZPScrollerScaleView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if([self pointInside:point withEvent:event]){
        return _contentView;
    }
    return [super hitTest:point withEvent:event];
}
- (instancetype)initWithConfig:(ZPScrollerScaleViewConfig *)config{
    _config = config;
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        [self addSubview:self.contentView];
    }
    return self;
}
-(CGFloat)pageMagin{
    
    return ([UIScreen mainScreen].bounds.size.width - self.config.pageSize.width)/2;
}
- (UIScrollView *)contentView{
    if(!_contentView){
        CGSize pageSize = self.config.pageSize;
        _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.pageMagin,0, pageSize.width, pageSize.height)];
        _contentView.delegate = self;
        _contentView.pagingEnabled = YES;
        _contentView.backgroundColor = self.backgroundColor;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.clipsToBounds = NO;
        _contentView.contentSize = CGSizeMake(500 * pageSize.width, pageSize.height);
        
    }
    return _contentView;
}
#pragma mark - 无限滚动 以及 滚动缩放处理

/**
 当前展示的视图
 
 @return 当前展示的视图下标
 */
- (NSInteger)currentIndex{
    
    NSInteger pageIndex = self.contentView.contentOffset.x/self.config.pageSize.width;
    return pageIndex % self.items.count;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _lastContentOffset = scrollView.contentOffset.x;
    
}
- (void)itemViewStartAnimationWithContentOffset:(CGFloat)contentOffsetX{
    
    CGFloat pageSizeW = [UIScreen mainScreen].bounds.size.width - self.pageMagin*2;
    NSInteger pageIndex = contentOffsetX/pageSizeW;
    
    CGFloat scrale = (contentOffsetX/pageSizeW - pageIndex);
    if(scrale >= 0.99){
        [self exchangeItemViewPosition]; //完成一次显示, 调整子视图位置
    }
    if(scrale <= 0){
        return;
    }
    
    //视图(左)
    NSInteger currentIndex = (pageIndex%self.items.count);
    NSInteger nextIndex = ((currentIndex+1)>(self.items.count-1)?0:(currentIndex+1));;
    
    //视图缩放值(左)
    CGFloat scraleCurrent = self.config.scaleMax - (self.config.scaleMax-self.config.scaleMin)*scrale;
    CGFloat scraleNext = (self.config.scaleMax-self.config.scaleMin) *scrale +self.config.scaleMin;
    
    if (contentOffsetX < _lastContentOffset ){ //向右
        currentIndex = currentIndex +1 >= self.items.count?0:currentIndex +1;
        nextIndex = ((currentIndex-1)<0?self.items.count-1:(currentIndex-1));
        scraleCurrent = (self.config.scaleMax-self.config.scaleMin) *scrale +self.config.scaleMin;
        scraleNext = self.config.scaleMax - (self.config.scaleMax-self.config.scaleMin)*scrale;
    }
    
    
    UIView * subViewCurrent = [self.contentView viewWithTag:currentIndex+BaseTag];
    subViewCurrent.transform = CGAffineTransformMakeScale( scraleCurrent,  scraleCurrent);
    UIView * subViewNext = [self.contentView viewWithTag:nextIndex+BaseTag];
    subViewNext.transform = CGAffineTransformMakeScale(scraleNext,  scraleNext);
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //首次显示
    if (_lastOffsetX == 0) {
        [self itemViewStartAnimationWithContentOffset:scrollView.contentOffset.x];
        _lastOffsetX = scrollView.contentOffset.x;
        return;
    }
    if(_lastOffsetX  > scrollView.contentOffset.x){ //向左滑动
        
        for (CGFloat i = _lastOffsetX; i >= scrollView.contentOffset.x; i--) {
            [self itemViewStartAnimationWithContentOffset:i];
        }
        
    }else{//向右滑动
        for (CGFloat i = _lastOffsetX; i < scrollView.contentOffset.x; i++) {
            [self itemViewStartAnimationWithContentOffset:i];
        }
    }
    _lastOffsetX = scrollView.contentOffset.x;
}

/**
 滚动结束调整子视图位置
 */
- (void)exchangeItemViewPosition{
    self.pageIndex = self.contentView.contentOffset.x/([UIScreen mainScreen].bounds.size.width  - self.pageMagin*2);
    CGSize pageSize = self.config.pageSize;
    self.contentView.contentSize  = CGSizeMake(self.contentView.contentSize.width + pageSize.width, pageSize.height);
    if (self.contentView.contentOffset.x < _lastContentOffset ){
        //向右
        NSInteger currentIndex = (self.pageIndex%self.items.count);
        NSInteger needMoveIndex = currentIndex-2 < 0?self.items.count+(currentIndex-2):currentIndex-2;
        UIView * subView = [self.contentView viewWithTag:BaseTag + needMoveIndex];
        subView.transform = CGAffineTransformMakeScale(self.config.scaleMin, self.config.scaleMin);
        subView.center = CGPointMake((self.pageIndex-2) * pageSize.width+pageSize.width/2, subView.center.y);

    }else{
        //向左
        NSInteger currentIndex = (self.pageIndex%self.items.count);
        NSInteger needMoveIndex = currentIndex+2 > self.items.count-1?(currentIndex+2 -self.items.count):currentIndex+2;
        UIView * subView = [self.contentView viewWithTag:BaseTag + needMoveIndex];
        subView.transform = CGAffineTransformMakeScale(self.config.scaleMin, self.config.scaleMin);
        subView.center = CGPointMake((self.pageIndex+2) * pageSize.width+pageSize.width/2, subView.center.y);

    }
}
/**添加子view*/
- (void)setItems:(NSArray<UIView *> *)items{
    _items = items;
    
    CGSize pageSize = self.config.pageSize;
    
    //将视图摆在中间, 并且消除求余误差
    CGFloat centerIetm = self.contentView.contentSize.width * 0.5;
    NSInteger pageIndex = centerIetm/pageSize.width;
    NSInteger pageOffsetIndex = pageIndex % self.items.count;
    centerIetm = centerIetm - pageOffsetIndex * pageSize.width;
    
    for(int i =0; i < items.count;i++){
        UIView * view = items[i];
        view.tag = BaseTag + i;
        view.frame = CGRectMake(i * pageSize.width + self.config.ItemMaingin + centerIetm, 0, pageSize.width-self.config.ItemMaingin*2, pageSize.height);
        [_contentView addSubview:view];
        view.transform = CGAffineTransformMakeScale(self.config.scaleMin, self.config.scaleMin);
    }
    //这是默认显示
    UIView * view = [self.contentView viewWithTag:self.defalutIndex+BaseTag];
    view.transform = CGAffineTransformMakeScale(self.config.scaleMax, self.config.scaleMax);
    [self.contentView setContentOffset:CGPointMake(centerIetm + pageSize.width*self.defalutIndex, 0)];
    [self configDefult:self.defalutIndex];
}


/**当默认值较小和较大的时候制造循环轮播条件*/
- (void)configDefult:(NSInteger)defultIndex{
    NSInteger currentIndex = 0;
    NSInteger needMoveIndex = 0;
    NSInteger currentIndex2 = 0;
    NSInteger needMoveIndex2 = 0;
    CGFloat shouldOffset = 0;
    if(_defalutIndex <= 1){ //将最大和第二大的视图调整位置
         currentIndex = 0;
         needMoveIndex = self.items.count -1;
         currentIndex2 = self.items.count -1;
         needMoveIndex2 = self.items.count -2;
        shouldOffset = -self.config.pageSize.width;
    }else if(_defalutIndex >= self.items.count -2){//将最小和第二小的视图调整位置
         currentIndex = self.items.count -1;
         needMoveIndex = 0;
         currentIndex2 = 0;
         needMoveIndex2 = 1;
        shouldOffset = self.config.pageSize.width;

    }
    
    UIView * currentView = [self.contentView viewWithTag:BaseTag + currentIndex];
    UIView * needMoveView = [self.contentView viewWithTag:BaseTag + needMoveIndex];
    needMoveView.transform = CGAffineTransformMakeScale(self.config.scaleMin, self.config.scaleMin);
    needMoveView.center = CGPointMake(currentView.center.x + shouldOffset, needMoveView.center.y);
   
    
    UIView * currentView2 = [self.contentView viewWithTag:BaseTag + currentIndex2];
    UIView * needMoveView2 = [self.contentView viewWithTag:BaseTag + needMoveIndex2];
    needMoveView2.transform = CGAffineTransformMakeScale(self.config.scaleMin, self.config.scaleMin);
    needMoveView2.center = CGPointMake(currentView2.center.x + shouldOffset, needMoveView2.center.y);
}

@end
