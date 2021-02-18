//
//  TypeView.m
//  TypeView
//
//  Created by weizhongming on 2017/4/17.
//  Copyright © 2017年 航磊_. All rights reserved.
//

//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define RGB(r, g, b)  [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#import "TypeView.h"

static BOOL isrefresh;

static int scrollViewPage; //scrollView在第几页

static CGFloat beginX; //记录当前的x位置

static BOOL left; //是否左滑

static CGFloat scrollViewHeight; //高度

@implementation TypeView


- (void)dealloc{

    
    [_observerScrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        scrollViewHeight = frame.size.height;
        
        isrefresh = NO;
        self.lineView_Width = 15;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.showsVerticalScrollIndicator = FALSE;
        self.scrollView.showsHorizontalScrollIndicator = FALSE;
        self.scrollView.scrollsToTop = NO;
        [self addSubview:self.scrollView];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = RGB(240, 7, 119);
        [self.scrollView addSubview:self.lineView];
        

    }
    return self;
}

/**
 *  监听属性值发生改变时回调
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (_observerScrollView.contentOffset.x == SCREEN_WIDTH *(self.lastButton.tag -100)) {
        return;
    }
    [self lineViewFram:_observerScrollView.contentOffset.x];
}

// 添加监听
- (void)setObserverScrollView:(UIScrollView *)observerScrollView{

    _observerScrollView = observerScrollView;
    [observerScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];

}


- (void)updateView:(id)datas{
    
    self.dataArray = datas;
    
    if (!isrefresh) {
        
        isrefresh = YES;
    }else{
        
        return;
    }
    
    scrollViewPage = self.typeIndex;
    
    //    首先给scrollview一个比较大的宽度，因为在循环里才确定最终宽度，先给一个宽度可以进入直接显示在点击的分类那一处
    self.scrollView.contentSize = CGSizeMake(1000, scrollViewHeight);
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.tag = 100 +i;
        [button setTitle:self.dataArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
        CGFloat buttonWidth = [self widthOfString:self.dataArray[i] font:13 height:110];
        
        if (i == 0) {
            
            button.frame = CGRectMake(0, 0, 30 + buttonWidth, self.scrollView.frame.size.height -3);
        }else{
            
            UIButton *lastBtn = (UIButton *)[self viewWithTag:100 +i -1];
            button.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame), 0, 30 + buttonWidth, self.scrollView.frame.size.height -3);
        }
        
        //        button.titleLabel.minimumScaleFactor = 0.5;
        //        button.titleLabel.adjustsFontSizeToFitWidth=YES;
        if (i == self.typeIndex) {
            
            self.lastButton = button;
            [button setTitleColor:RGB(240, 7, 119) forState:UIControlStateNormal];
            
            self.lineView.frame = CGRectMake(CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2, CGRectGetMaxY(button.frame), self.lineView_Width, 3);
            
            [self.scrollView setContentOffset:CGPointMake(MAX(0, MIN(button.frame.origin.x -SCREEN_WIDTH /2, self.scrollView.contentSize.width -SCREEN_WIDTH)), 0) animated:YES];
            
        }
        
        [self.scrollView addSubview:button];
    }
    
    UIButton *button = (UIButton *)[self viewWithTag:100 +self.dataArray.count -1];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame), 30);
    
}


- (void)buttonClick:(UIButton *)button{
    
    //    如果点击了已经选中的button,直接return
    if (button.tag == self.lastButton.tag) {
        
        return;
    }
    
    //    如果点击的button的tag小于记录的上一个button,那就是往左点击
    if (button.tag < self.lastButton.tag) {
        left = YES;
    }else{
        
        left = NO;
    }
    
    [self.lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:RGB(240, 7, 119) forState:UIControlStateNormal];
    
    self.lastButton = button;
    
    self.lineView.frame = CGRectMake(CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2, CGRectGetMaxY(button.frame), self.lineView_Width, 3);
    
    if (self.resendBlock) {
        
        self.resendBlock(button.tag -100);
    }
    
    
    [_observerScrollView setContentOffset:CGPointMake(SCREEN_WIDTH *(button.tag -100), 0) animated:NO];

    //    最小取0，最大取scrollView得长度终点
    [self.scrollView setContentOffset:CGPointMake(MAX(0, MIN(button.frame.origin.x -SCREEN_WIDTH /2, self.scrollView.contentSize.width -SCREEN_WIDTH)), 0) animated:YES];

}

- (void)lineViewFram:(CGFloat)enge{
    
    if (enge == beginX) {
        
        return;
    }
    
    //    如果滑动到第一个，就不再向左滑动
    if (enge < 0) {
        
        UIButton *button = (UIButton *)[self viewWithTag:100];
        
        self.lineView.frame = CGRectMake((button.frame.size.width -self.lineView_Width) /2, self.frame.size.height -3, self.lineView_Width, 3);
        
        return;
    }else if (enge > SCREEN_WIDTH *self.dataArray.count){
        
        //    如果滑动到最后一个，就不再向右滑动
        UIButton *button = (UIButton *)[self viewWithTag:100 +self.dataArray.count -1];
        
        self.lineView.frame = CGRectMake(button.frame.size.width *(self.dataArray.count -1) + (button.frame.size.width -self.lineView_Width) /2, self.frame.size.height -3, self.lineView_Width, 3);
        
        return;
    }
    
    scrollViewPage = enge /SCREEN_WIDTH;
    
    if (left) {
        
        UIButton *button = (UIButton *)[self viewWithTag:100 +enge /SCREEN_WIDTH +1];
        self.lastButton = button;
        
        if ((enge -SCREEN_WIDTH *scrollViewPage) < SCREEN_WIDTH /2) {
            
            UIButton *leftBtn = (UIButton *)[self viewWithTag:100 +scrollViewPage];
            
            self.lineView.frame = CGRectMake(CGRectGetMinX(leftBtn.frame) +(leftBtn.frame.size.width -self.lineView_Width) /2, self.frame.size.height -3, self.lineView_Width + (enge -SCREEN_WIDTH *scrollViewPage) /(SCREEN_WIDTH -30) * (leftBtn.frame.size.width +button.frame.size.width), 3);
            
        }else{
            
            UIButton *leftBtn = (UIButton *)[self viewWithTag:100 +scrollViewPage];
            
            //            按下面的scrollView滑动的距离下面线应该改变的长度
            CGFloat width = (SCREEN_WIDTH *(button.tag -100) -enge) / (SCREEN_WIDTH /2) *((CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2) -((CGRectGetMinX(leftBtn.frame) +(leftBtn.frame.size.width -self.lineView_Width) /2)));
            
            self.lineView.frame = CGRectMake((CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2) - width, self.frame.size.height -3, self.lineView_Width +width, 3);
            
        }
        
    }else{
        
        UIButton *button = (UIButton *)[self viewWithTag:100 +enge /SCREEN_WIDTH];
        self.lastButton = button;
        
        if ((enge -SCREEN_WIDTH *scrollViewPage) < SCREEN_WIDTH /2) {
            
            UIButton *rightBtn = (UIButton *)[self viewWithTag:100 +scrollViewPage +1];
            
            self.lineView.frame = CGRectMake(CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2, self.frame.size.height -3, self.lineView_Width + (enge -SCREEN_WIDTH *scrollViewPage) /(SCREEN_WIDTH -30) * (button.frame.size.width +rightBtn.frame.size.width), 3);
            
        }else{
            
            UIButton *rightBtn = (UIButton *)[self viewWithTag:100 +scrollViewPage +1];
            
            //            按下面的scrollView滑动的距离下面线应该改变的长度
            CGFloat width = (enge - SCREEN_WIDTH *(button.tag -100) -SCREEN_WIDTH /2) / (SCREEN_WIDTH /2) *(((CGRectGetMinX(rightBtn.frame) +(rightBtn.frame.size.width -self.lineView_Width) /2 +self.lineView_Width)) - (CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2) -self.lineView_Width);
            
            //            下面的那条线最长时候的长度
            CGFloat maxWidth = CGRectGetMinX(rightBtn.frame) +(rightBtn.frame.size.width -self.lineView_Width) /2 +self.lineView_Width - (CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2);
            
            self.lineView.frame = CGRectMake((CGRectGetMinX(button.frame) +(button.frame.size.width -self.lineView_Width) /2) + width, self.frame.size.height -3, maxWidth -width, 3);
        }
    }
    
    int page = (int)enge /SCREEN_WIDTH +1;
    
    
    if (enge < beginX) {
        
        left = YES;
        [self.lastButton setTitleColor:[self LeftButtonTitleTextColor:enge] forState:UIControlStateNormal];
        UIButton *button = (UIButton *)[self viewWithTag:100 +page -1];
        [button setTitleColor:[self LeftNextButtonTitleTextColor:enge] forState:UIControlStateNormal];
        
        //        self.lastButton = button;
        
    }else{
        
        left = NO;
        [self.lastButton setTitleColor:[self RithtButtonTitleTextColor:enge] forState:UIControlStateNormal];
        
        UIButton *button = (UIButton *)[self viewWithTag:100 +page];
        [button setTitleColor:[self RithtNextButtonTitleTextColor:enge] forState:UIControlStateNormal];
        
        //        self.lastButton = button;
    }
    
    
}

// 往右滑动当前按钮的颜色
- (UIColor *) RithtButtonTitleTextColor:(CGFloat)enge{
    
    CGFloat r = 240 - (fabs((enge -SCREEN_WIDTH *scrollViewPage)) /SCREEN_WIDTH *240);
    CGFloat g = 7 - (fabs((enge -SCREEN_WIDTH *scrollViewPage)) /SCREEN_WIDTH *7);
    CGFloat b = 119 - (fabs((enge -SCREEN_WIDTH *scrollViewPage)) /SCREEN_WIDTH *119);
    
    return RGB(r, g, b);
}
// 往左滑动当前按钮的颜色
- (UIColor *) LeftButtonTitleTextColor:(CGFloat)enge{
    
    int page = (int)enge /SCREEN_WIDTH +1;
    
    CGFloat r = 240 - (fabs((enge - page *SCREEN_WIDTH)) /SCREEN_WIDTH *240);
    CGFloat g = 7 - (fabs((enge - page *SCREEN_WIDTH)) /SCREEN_WIDTH *7);
    CGFloat b = 119 - (fabs((enge - page *SCREEN_WIDTH)) /SCREEN_WIDTH *119);
    
    return RGB(r, g, b);
}

// 往右滑动下个按钮的颜色
- (UIColor *) RithtNextButtonTitleTextColor:(CGFloat)enge{
    
    CGFloat r = (fabs((enge -SCREEN_WIDTH *scrollViewPage)) /SCREEN_WIDTH *240);
    CGFloat g = (fabs((enge -SCREEN_WIDTH *scrollViewPage)) /SCREEN_WIDTH *7);
    CGFloat b = (fabs((enge -SCREEN_WIDTH *scrollViewPage)) /SCREEN_WIDTH *119);
    
    return RGB(r, g, b);
}
// 往左滑动下个按钮的颜色
- (UIColor *) LeftNextButtonTitleTextColor:(CGFloat)enge{
    
    int page = (int)enge /SCREEN_WIDTH +1;
    
    CGFloat r = (fabs((enge - page *SCREEN_WIDTH)) /SCREEN_WIDTH *240);
    CGFloat g = (fabs((enge - page *SCREEN_WIDTH)) /SCREEN_WIDTH *7);
    CGFloat b = (fabs((enge - page *SCREEN_WIDTH)) /SCREEN_WIDTH *119);
    
    return RGB(r, g, b);
}



- (void)scrollViewNumber:(int)number{
    
    UIButton *button = (UIButton *)[self viewWithTag:100 +number];
    [self.lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:RGB(240, 7, 119) forState:UIControlStateNormal];
    
    self.lastButton = button;
    
    
    scrollViewPage = number;
    
    if (self.scrollView.contentSize.width < SCREEN_WIDTH) {
        return;
    }
    
    //    最小取0，最大取scrollView得长度终点
    [self.scrollView setContentOffset:CGPointMake(MAX(0, MIN(button.frame.origin.x -SCREEN_WIDTH /2, self.scrollView.contentSize.width -SCREEN_WIDTH)), 0) animated:YES];
    
}

- (void)scrollViewBegin:(CGFloat)begin{
    
    beginX = begin;
}


/**
 *  动态获取label的宽度
 *
 *  @param string label展示的文字
 *  @param font   文字的尺寸
 *  @param height label的高度
 *
 *  @return label的宽度
 */
- (CGFloat) widthOfString:(NSString *)string font:(int)font height:(CGFloat)height{
    
    NSDictionary * dict=[NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:font] forKey:NSFontAttributeName];
    CGRect rect=[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return rect.size.width;
}

@end
