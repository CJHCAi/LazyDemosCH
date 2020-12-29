//
//  HKLeSeeSowIngMapView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSeeSowIngMapView.h"
#import "HKSowIngView.h"
@interface HKLeSeeSowIngMapView()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSTimer *timer;
@end

@implementation HKLeSeeSowIngMapView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];;
        scrollView.delegate = self;;
                 //横竖两种滚轮都不显示
        scrollView.showsVerticalScrollIndicator = NO;;
        scrollView.showsHorizontalScrollIndicator = NO;;
                 //需要分页
        scrollView.pagingEnabled = YES;;
                 //不需要回弹（试了一下加不加应该都没什么影响）
        scrollView.bounces = NO;;
        [self addSubview:scrollView];;
        _scrollView = scrollView;;
    }
    return _scrollView;
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat w = kScreenWidth - 30;
    CGFloat mark = 5;
    for (int i = 0; i<imageArray.count; i++) {
        HKSowIngView*iconView = [[HKSowIngView alloc]init];
        [self.scrollView addSubview: iconView];
        iconView.model = imageArray[i];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) { make.left.equalTo(self.scrollView).offset(10+mark*(i+1)+i*w);
            make.top.bottom.equalTo(self.scrollView);
            make.width.mas_equalTo(w);
        }];
    }
    HKSowIngView*iconView = [[HKSowIngView alloc]init];
    [self.scrollView addSubview: iconView];
    iconView.model = imageArray.lastObject;
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(-w+10);
        make.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(w);
    }];
    HKSowIngView*lastIconView = [[HKSowIngView alloc]init];
    [self.scrollView addSubview: lastIconView];
    lastIconView.model = imageArray.firstObject;
    [lastIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(10+(imageArray.count+1)*5+imageArray.count*w);
        make.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(w);
    }];
    [_timer invalidate];
     _timer = nil;
   _timer = [NSTimer timerWithTimeInterval:2 target:self selector:@selector(createPersonLayer) userInfo:nil repeats:YES];
     [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)createPersonLayer{
    CGPoint point = self.scrollView.contentOffset;
    CGFloat x = point.x + kScreenWidth-30+5;
    [self.scrollView setContentOffset:CGPointMake(x, point.y) animated:YES];
    if (x>=self.imageArray.count*kScreenWidth) {
         [self.scrollView setContentOffset:CGPointMake(0, point.y) animated:NO];
    }
}
-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}
@end
