//
//  CDTabBar.m
//  CustomTabbar
//
//  Created by Dong Chen on 2017/9/1.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDTabBar.h"

@interface CDTabBar()
@property (nonatomic, strong) UIButton *middleBtn;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation CDTabBar

- (void)layoutSubviews{
    [super layoutSubviews];
    [self addSubview:self.sendBtn];
    
    
//    [self.sendBtn setImagePositionWithType:SSImagePositionTypeTop spacing:4];
    // 其他位置按钮
    NSUInteger count = self.subviews.count;
    for (NSUInteger i = 0 , j = 0; i < count; i++){
        UIView *view = self.subviews[i];
        Class class = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:class]){
            view.width = self.width / 5.0;
            view.x = self.width * j / 5.0;
            j++;
            if (j == 2){
                j++;
            }
        }
    }

}

// 中间按钮点击
- (void)didClickPublishBtn:(UIButton*)sender {
    if (self.didMiddBtn) {
        self.didMiddBtn();
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (self.isHidden == NO){
        CGPoint newP = [self convertPoint:point toView:self.middleBtn];
        if ( [self.middleBtn pointInside:newP withEvent:event]){
            return self.middleBtn;
        }else{
            return [super hitTest:point withEvent:event];
        }
    }else{
        return [super hitTest:point withEvent:event];
    }
}

- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setImage:[UIImage imageNamed:@"tabar_plus_normal"] forState:UIControlStateNormal];
        [_sendBtn setTitle:@"" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [_sendBtn addTarget:self action:@selector(didClickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sendBtn.adjustsImageWhenHighlighted = NO;
        _sendBtn.size = CGSizeMake(self.bounds.size.width/5.0, 70);
        _sendBtn.centerX = self.width / 2;
        _sendBtn.centerY = 12;
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.middleBtn = _sendBtn;
    }
    return _sendBtn;
}

@end
