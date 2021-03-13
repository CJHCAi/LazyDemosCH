#import "DDYVoiceIndicator.h"
#import "DDYKeyboardConfig.h"

@interface DDYVoiceIndicator ()
/** 圆点 */
@property (nonatomic, strong) UIView *circleView;
/** 标签容器 */
@property (nonatomic, strong) UIView *labelContainer;
/** 相对比例 */
@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation DDYVoiceIndicator

- (UIView *)circleView {
    if (!_circleView) {
        _circleView = [[UIView alloc] initWithFrame:CGRectMake(self.ddy_W/2.-kbVoiceCircleWH/2., 0, kbVoiceCircleWH, kbVoiceCircleWH)];
        _circleView.backgroundColor = [UIColor redColor];
        _circleView.layer.masksToBounds = YES;
        _circleView.layer.cornerRadius = kbVoiceCircleWH/2.;
    }
    return _circleView;
}

- (UIView *)labelContainer {
    if (!_labelContainer) {
        _labelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kbVoiceCircleWH, self.ddy_W, self.ddy_H - kbVoiceCircleWH)];
        
        UIButton *button1 = [self buttonTitle:@"变声" tag:100 superView:_labelContainer];
        UIButton *button2 = [self buttonTitle:@"对讲" tag:101 superView:_labelContainer];
        UIButton *button3 = [self buttonTitle:@"录音" tag:102 superView:_labelContainer];
        button2.ddy_CenterX = self.ddy_W/2;
        button1.ddy_Right = button2.ddy_X - 10;
        button3.ddy_X = button2.ddy_Right + 10;
        // 相对比例
        _scale = (button2.ddy_CenterX-button1.ddy_CenterX)/self.ddy_W;
    }
    return _labelContainer;
}

+ (instancetype)indicatorWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 圆点指示
        [self addSubview:self.circleView];
        // 标签容器
        [self addSubview:self.labelContainer];
    }
    return self;
}

- (UIButton *)buttonTitle:(NSString *)title tag:(NSInteger)tag superView:(UIView *)superView {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 30, kbVoiceLabalH)];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:kbVoiceLabalFont]];
    [button setTitleColor:DDY_Mid_Black forState:UIControlStateNormal];
    [button setTitleColor:DDY_Red forState:UIControlStateSelected];
    [button sizeToFit];
    [button setTag:tag];
    [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
    [superView addSubview:button];
    return button;
}

- (void)handleClick:(UIButton *)button {
    if (self.changeIndexBlock) {
        self.changeIndexBlock(button.tag-100);
    }
}

- (void)scrollWithAssociateScrollView:(UIScrollView *)scrollView {
    self.labelContainer.transform = CGAffineTransformMakeTranslation((scrollView.ddy_W - scrollView.contentOffset.x)*self.scale, 0);
    self.selectedIndex = (scrollView.contentOffset.x +  scrollView.ddy_W/2) / scrollView.ddy_W;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        for (UIButton *button in self.labelContainer.subviews) {
            button.selected = (selectedIndex == (button.tag-100));
        }
    }
}

@end
