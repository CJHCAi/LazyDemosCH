//
//  YJSliderPointView.m
//  YJCustomPointSlider
//
//  Created by 于英杰 on 2019/5/15.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJSliderPointView.h"
#import "UIView+YJUiView.h"



@interface YJSliderPointView ()

{
    CGFloat piceMoney;
    NSString *maxMoney;
    NSString *minMoney;
    CGFloat _with;
    NSInteger _sectionIndex;

}

@property(nonatomic,strong)NSMutableArray*itemarray;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) CAGradientLayer *lineLayer;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorLocationArray;
@property (nonatomic, strong) UIView *TapTip;//滑块
@property (nonatomic, strong) UILabel *TapTiplable;

#define TapTip_W       16.0
#define SLiderLine_H    1.0

@end

@implementation YJSliderPointView

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        [self SetupUI];
    }
    return self;
    
}

-(void)SetupUI{
    
    /**默认的是升序*/
    _itemarray= @[@"2",@"4",@"6",@"8",@"10"].mutableCopy;
    [self addSubview:self.lineView];
    [self SetupTip];
    self.backgroundColor = [UIColor orangeColor];
    
}

-(void)SetupTip{
    
    CGFloat num = [[NSString stringWithFormat:@"%@",[_itemarray lastObject]] doubleValue];
    // 比率
    piceMoney =  num / self.lineView.frame.size.width;
    // 一段的长度 均分
    _with = self.lineView.frame.size.width / _itemarray.count;
    for (int i=0; i<=_itemarray.count; i++) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(i *_with+4, self.lineView.frame.origin.y - 4, 8, 8);
        view.layer.cornerRadius=4;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        view.layer.borderWidth = 1;
        [self addSubview:view];
    }
    [self addSubview:self.TapTiplable];
    [self addSubview:self.TapTip];

}

- (void)PanEvent:(UIPanGestureRecognizer *)gesture{
    
    //NSLog(@"%@",gesture.view);
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [gesture translationInView:self];
        CGFloat y = gesture.view.center.y;
        CGFloat x = gesture.view.center.x +point.x;
        if (x <self.lineView.frame.origin.x) {
            x = self.lineView.frame.origin.x;
        }
        if (x > self.lineView.width+TapTip_W/2) {
            x =  self.lineView.width+TapTip_W/2;
        }
        gesture.view.center = CGPointMake(x, y);
        [gesture setTranslation:CGPointMake(0, 0) inView:self];
        minMoney = [NSString stringWithFormat:@"%.1f",(x-TapTip_W/2)*piceMoney];
        _TapTiplable.centerX=x;
        _TapTiplable.text =minMoney;
    }
    else if(gesture.state == UIGestureRecognizerStateEnded){
    }
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(TapTip_W/2, self.height/2, self.frame.size.width-TapTip_W, SLiderLine_H)];
        _lineView.backgroundColor = [UIColor clearColor];
        [_lineView.layer addSublayer:self.lineLayer];
    }
    return _lineView;
}

- (UIView *)TapTip{
    if (!_TapTip) {
        _TapTip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TapTip_W, TapTip_W)];
        _TapTip.center = CGPointMake(TapTip_W/2, self.height/2+SLiderLine_H/2);
        _TapTip.layer.cornerRadius = 8;
        _TapTip.layer.masksToBounds = YES;
        _TapTip.backgroundColor = [UIColor orangeColor];
        _TapTip.alpha = 1;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(PanEvent:)];
        [_TapTip addGestureRecognizer:pan];
    }
    return _TapTip;
}
- (UILabel *)TapTiplable{
    if (!_TapTiplable) {
        _TapTiplable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        _TapTiplable.center = CGPointMake(self.lineView.frame.origin.x, self.height/2+SLiderLine_H/2-20);
        _TapTiplable.font = [UIFont systemFontOfSize:13];
        _TapTiplable.backgroundColor = [UIColor clearColor];
        _TapTiplable.textAlignment=NSTextAlignmentCenter;
        _TapTiplable.text=@"0.0";
    }
    return _TapTiplable;
}
-(CAGradientLayer*)lineLayer{
    if (_lineLayer==nil) {
        self.colorArray = @[(id)[[UIColor colorWithHex:0xFF5E37] CGColor],
                            (id)[[UIColor colorWithHex:0xFFA301] CGColor],
                            (id)[[UIColor colorWithHex:0x10B345] CGColor]];
        self.colorLocationArray = @[@0.4, @0.6, @1];
        _lineLayer =  [CAGradientLayer layer];
        _lineLayer.frame = CGRectMake(0, 0, _lineView.frame.size.width, 1);
        [_lineLayer setLocations:self.colorLocationArray];
        [_lineLayer setColors:self.colorArray];
        [_lineLayer setStartPoint:CGPointMake(0, 0)];
        [_lineLayer setEndPoint:CGPointMake(1, 0)];
    }
    return _lineLayer;
}
@end
