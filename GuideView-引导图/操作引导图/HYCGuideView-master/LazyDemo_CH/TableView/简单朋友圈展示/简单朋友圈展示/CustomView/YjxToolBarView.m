//
//  ToolBarView.m
//  TableviewLayout
//
//  Created by 闫继祥 on 2019/7/16.
//  Copyright © 2019 yang.sun. All rights reserved.
//

#import "YjxToolBarView.h"
#import "UIColor+YMHex.h"

#import "Masonry.h"
@implementation YjxToolBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 获取到约束后的控件frame
    self.line.frame = CGRectMake(0, 0, self.frame.size.width, 1.0);
    
    self.buttonLeft.frame = CGRectMake(0, 1.0, (self.frame.size.width-1.0)/2, self.frame.size.height);
    
    self.line1.frame = CGRectMake(self.buttonLeft.frame.size.width+self.buttonLeft.frame.origin.x, 7.5, 1.0, self.frame.size.height-15);

    self.buttonRight.frame = CGRectMake(self.line1.frame.size.width+self.line1.frame.origin.x, 1.0, self.buttonLeft.frame.size.width, self.frame.size.height);

}
- (void)setUI {
    
    _line = [[UIView alloc] init];
    _line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:_line];
    
    _line1 = [[UIView alloc] init];
    _line1.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self addSubview:_line1];

    _buttonLeft = [YSLCustomButton buttonWithType:UIButtonTypeCustom];
    _buttonLeft.backgroundColor = [UIColor whiteColor];
    [_buttonLeft addTarget:self action:@selector(buttonLeftClick) forControlEvents:UIControlEventTouchUpInside];
    _buttonLeft.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonLeft setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_buttonLeft setTitle:@"第一个按钮" forState:(UIControlStateNormal)];
    [_buttonLeft setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    _buttonLeft.ysl_spacing = 2.0;
    _buttonLeft.ysl_buttonType = YSLCustomButtonImageLeft;
    [self addSubview:_buttonLeft];

    _buttonRight = [YSLCustomButton buttonWithType:UIButtonTypeCustom];
    _buttonRight.backgroundColor = [UIColor whiteColor];
    [_buttonRight addTarget:self action:@selector(buttonRightClick) forControlEvents:UIControlEventTouchUpInside];
    _buttonRight.titleLabel.font = [UIFont systemFontOfSize:14];
    [_buttonRight setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [_buttonRight setTitle:@"第二个按钮" forState:(UIControlStateNormal)];
    [_buttonRight setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
    _buttonRight.ysl_spacing = 2.0;
    _buttonRight.ysl_buttonType = YSLCustomButtonImageLeft;
    [self addSubview:_buttonRight];
    
}
//左侧按钮点击
- (void)buttonLeftClick {
    [self.btnDelegate BtnLeftClicked];
}
//右侧按钮点击
- (void)buttonRightClick{
    [self.btnDelegate BtnRightClicked];
}
@end
