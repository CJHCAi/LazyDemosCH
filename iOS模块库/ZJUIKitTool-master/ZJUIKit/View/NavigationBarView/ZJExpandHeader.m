//
//  ZJExpandHeader.m
//  ZJUIKit
//
//  Created by dzj on 2018/1/31.
//  Copyright © 2018年 kapokcloud. All rights reserved.
//

#import "ZJExpandHeader.h"
NSString *const ZJTableViewControllerDeallocNotification = @"ZJTableViewControllerDeallocNotification";
#define CExpandContentOffset @"contentOffset"

@interface ZJExpandHeader()

/** <#digest#> */
@property (weak, nonatomic) UIScrollView *scrollView;

/** <#digest#> */
@property (weak, nonatomic) UIView *expandView;

/** <#digest#> */
@property (assign, nonatomic) CGFloat expandHeight;

/** <#digest#> */
@property (assign, nonatomic) CGFloat originTop;

@end

@implementation ZJExpandHeader
- (void)dealloc{
    
    [self removeObserver];
}

+ (instancetype)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    ZJExpandHeader *expandHeader = [ZJExpandHeader new];
    [expandHeader expandWithScrollView:scrollView expandView:expandView];
    return expandHeader;
}

- (void)expandWithScrollView:(UIScrollView*)scrollView expandView:(UIView*)expandView{
    
    _expandHeight = CGRectGetHeight(expandView.frame);
    
    _scrollView = scrollView;
    
    _originTop = _scrollView.contentInset.top;
    
    _scrollView.contentInset = UIEdgeInsetsMake(_expandHeight + _originTop, _scrollView.contentInset.left, _scrollView.contentInset.bottom, _scrollView.contentInset.right);
    [_scrollView insertSubview:expandView atIndex:0];
    [_scrollView addObserver:self forKeyPath:CExpandContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [_scrollView setContentOffset:CGPointMake(0, -_expandHeight - _originTop)];
    
    _expandView = expandView;
    
    //使View可以伸展效果  重要属性
    _expandView.contentMode= UIViewContentModeScaleAspectFill;
    _expandView.clipsToBounds = YES;
    
    [self reSizeView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeObserver) name:ZJTableViewControllerDeallocNotification object:_scrollView.viewController];
}

- (void)removeObserver
{
    if (_scrollView) {
        [_scrollView removeObserver:self forKeyPath:CExpandContentOffset];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ZJTableViewControllerDeallocNotification object:_scrollView.viewController];
        
        _scrollView = nil;
    }
    _expandView = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (![keyPath isEqualToString:CExpandContentOffset]) {
        return;
    }
    [self scrollViewDidScroll:_scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if(offsetY < (_expandHeight + _originTop) * -1) {
        CGRect currentFrame = _expandView.frame;
        currentFrame.origin.y = offsetY + _originTop;
        currentFrame.size.height = -1*(offsetY + _originTop);
        _expandView.frame = currentFrame;
    }
    
}

- (void)reSizeView{
    
    //重置_expandView位置
    [_expandView setFrame:CGRectMake(0, -1*(_expandHeight), CGRectGetWidth(_expandView.frame), _expandHeight)];
    
}

- (UIView *)headerView
{
    return _expandView;
}
@end
