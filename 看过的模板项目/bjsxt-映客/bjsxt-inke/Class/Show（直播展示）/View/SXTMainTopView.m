//
//  SXTMainTopView.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/2.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTMainTopView.h"

@interface SXTMainTopView ()

@property (nonatomic, strong) UIView * lineView;

@property (nonatomic, strong) NSMutableArray * buttons;

@end

@implementation SXTMainTopView

- (NSMutableArray *)buttons {
    
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (instancetype)initWithFrame:(CGRect)frame titleNames:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat btnW = self.width / titles.count;
        CGFloat btnH = self.height;
        
        for (NSInteger i = 0; i < titles.count; i ++) {
            
            UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [self.buttons addObject:titleBtn];
            
            NSString * vcName = titles[i];
            //设置按钮文字
            [titleBtn setTitle:vcName forState:UIControlStateNormal];
            //设置按钮颜色
            [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //设置字体
            titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            
            titleBtn.tag = i;
            
            titleBtn.frame = CGRectMake(i * btnW, 0, btnW, btnH);
            
            [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:titleBtn];
            
            
            if (i == 1) {
                
                CGFloat h = 2;
                CGFloat y = 40;
                
                [titleBtn.titleLabel sizeToFit];
                
                self.lineView = [[UIView alloc] init];
                self.lineView.backgroundColor = [UIColor whiteColor];
                self.lineView.height = h;
                self.lineView.width = titleBtn.titleLabel.width;
                self.lineView.top = y;
                self.lineView.centerX = titleBtn.centerX;
                
                [self addSubview:self.lineView];
            }
            
        }
        
    }
    return self;
}


//mainvc滚动时调用
- (void)scrolling:(NSInteger)tag {
    
    UIButton * button = self.buttons[tag];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.lineView.centerX = button.centerX;
        
    }];
}

//点击事件
- (void)titleClick:(UIButton *)button {
    
    self.block(button.tag);
    
    [self scrolling:button.tag];
}



@end
