//
//  ZHBTitleViewPagerController.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/20.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBTitleViewPagerController.h"

NSInteger const static tagDifferent = 1000;
#define kUnderLineViewHeight 2
#define kTitleBarHieght 44
#define ktitleLabelFont 16
#define ktitleLabelColor ColorWithHex(0x555555)

@interface ZHBTitleViewPagerController ()

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIView *navTitleBarBtnView;
@property (nonatomic, strong) UILabel *navTitleBarLabel;
@property (nonatomic, strong) UIView *progressView;

@end

@implementation ZHBTitleViewPagerController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.animateDuration = 0.25;
    self.normalTextFont = [UIFont systemFontOfSize:15];
    self.progressHeight = kUnderLineViewHeight;
    self.changeIndexWhenScrollProgress = 1.0;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setUnderLineFrameWithIndex:self.curIndex animated:NO];
}

#pragma mark - setNav
- (void)setTitleViewDelegate:(id<ZHBTitleViewPagerControllerDataSource>)titleViewDelegate
{
    _titleViewDelegate = titleViewDelegate;
    
    self.titleArray = [self.titleViewDelegate arrayInZHBTitleViewPagerController];
    if (IsArrEmpty(self.titleArray)) {
        NSLog(@"titileArray不能为空");
    }
    
    [self addNavTitleBar];
}
- (void)addNavTitleBar
{
    // btnView
    CGFloat titleViewWidth = 60 * self.titleArray.count;
    CGFloat btnWidth = titleViewWidth / self.titleArray.count;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, titleViewWidth, kTitleBarHieght)];
    titleView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth * i, 0, titleViewWidth / self.titleArray.count, kTitleBarHieght)];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:ktitleLabelColor forState:UIControlStateNormal];
//        [button setTitleColor:redSwitchColor forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor clearColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:ktitleLabelFont];
        button.tag = i + tagDifferent;
        [button addTarget:self action:@selector(titleBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
    }
    self.navTitleBarBtnView = titleView;
    self.navTitleBarLabel.frame = CGRectMake(0, kTitleBarHieght, titleViewWidth, 44);
    
    // contentView
    UIView *navTitleBar = [[UIView alloc] initWithFrame:titleView.bounds];
    navTitleBar.backgroundColor = [UIColor clearColor];
    navTitleBar.clipsToBounds = YES;
    [navTitleBar addSubview:self.navTitleBarBtnView];
    [navTitleBar addSubview:self.navTitleBarLabel];
    
    self.navTitleBar = navTitleBar;
    self.navigationItem.titleView = self.navTitleBar;
}
// 按钮点击
- (void)titleBtnSelect:(UIButton *)btn
{
    [self moveToControllerAtIndex:btn.tag - tagDifferent animated:YES];
    [self setUnderLineFrameWithIndex:btn.tag - tagDifferent animated:YES];
    if ([self.titleViewDelegate respondsToSelector:@selector(titleViewPagerController:didSelectAtIndex:)])
    {
        [self.titleViewDelegate titleViewPagerController:self didSelectAtIndex:btn.tag - tagDifferent];
    }
}

#pragma mark - nav transform
- (void)upTransformWhenScorllToWeb
{
    [UIView animateWithDuration:0.4 animations:^{
        
        self.navTitleBarBtnView.y -= 44;
        self.navTitleBarLabel.y -= 44;
    }];
}
- (void)downTransformWhenScorllToTab
{
    [UIView animateWithDuration:0.4 animations:^{
       
        self.navTitleBarBtnView.y += 44;
        self.navTitleBarLabel.y += 44;
    }];
}

#pragma mark - override transition 重写父类动画
// 移到index处
- (void)transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated
{
    UIButton *fromBtn = [self buttonForIndex:fromIndex];
    [self setUnderLineFrameWithIndex:toIndex animated:fromBtn && animated ? animated: NO];
    
    if ([self.titleViewDelegate respondsToSelector:@selector(titleViewPagerController:didScrollToTabPageIndex:)]) {
        [self.titleViewDelegate titleViewPagerController:self didScrollToTabPageIndex:toIndex];
    }
}

#pragma mark - private 下划线移动的动画处理
// set up progress view frame
- (void)setUnderLineFrameWithIndex:(NSInteger)index animated:(BOOL)animated
{
    for (UIView *view in self.navTitleBarBtnView.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)view;
            if (button.tag - tagDifferent == index) {
                
                button.selected = YES;
            }else{
                button.selected = NO;
            }
        }
    }
    
    if (self.progressView.isHidden || self.countOfControllers == 0) {
        return;
    }
    CGRect buttonFrame = [self buttonFrameWithIndex:index];
    
    CGFloat progressCenterX = buttonFrame.origin.x + buttonFrame.size.width / 2;
    CGFloat progressCenterY = buttonFrame.origin.y + buttonFrame.size.height - self.progressHeight + 1;
    CGPoint pointCenter = CGPointMake(progressCenterX, progressCenterY);
    CGFloat width = 32;
    
    if (animated) {
        [UIView animateWithDuration:_animateDuration animations:^{
            self.progressView.size = CGSizeMake(width, self.progressHeight);
            self.progressView.center = pointCenter;
        }];
    }else {
        
        self.progressView.size = CGSizeMake(width, self.progressHeight);
        self.progressView.center = pointCenter;
    }
}
// BtnView获取Btn frame
- (CGRect)buttonFrameWithIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return CGRectZero;
    }
    CGRect rect = CGRectZero;
    for (UIView *view in self.navTitleBarBtnView.subviews) {
        
        if (view.tag - tagDifferent == index) {
            
            UIButton *titleBtn = (UIButton *)view;
            CGRect titleLabelFrame = titleBtn.titleLabel.frame;
            
            rect = CGRectMake((titleBtn.width - titleLabelFrame.size.width) / 2 + titleBtn.x, titleBtn.y, titleLabelFrame.size.width, titleBtn.height);
            
        }
    }
    return rect;
}
- (UIButton *)buttonForIndex:(NSInteger)index
{
    if (index >= self.countOfControllers) {
        return nil;
    }
    UIView *button;
    for (UIView *view in self.navTitleBarBtnView.subviews) {
        
        if (view.tag - tagDifferent == index) {
            button = view;
        }
    }
    return (UIButton *)button;
}


#pragma mark - lazy load
- (UIView *)progressView
{
    
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
//        _progressView.backgroundColor = redSwitchColor;
        [self.navTitleBarBtnView addSubview:_progressView];
    }
    return _progressView;
}
- (UIView *)navTitleBar
{
    if (!_navTitleBar) {
        _navTitleBar = [[UIView alloc] init];
        _navTitleBar.backgroundColor = [UIColor clearColor];
    }
    return _navTitleBar;
}
- (UIView *)navTitleBarBtnView
{
    if (!_navTitleBarBtnView) {
        _navTitleBarBtnView = [[UIView alloc] init];
        _navTitleBarBtnView.backgroundColor = [UIColor clearColor];
    }
    return _navTitleBarBtnView;
}
- (UILabel *)navTitleBarLabel
{
    if (!_navTitleBarLabel) {
        _navTitleBarLabel = [[UILabel alloc] init];
        _navTitleBarLabel.text = @"图文详情";
        _navTitleBarLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleBarLabel.textColor = ktitleLabelColor;
        _navTitleBarLabel.backgroundColor = [UIColor clearColor];
        _navTitleBarLabel.font = [UIFont systemFontOfSize:ktitleLabelFont];
    }
    return _navTitleBarLabel;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
