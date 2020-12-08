//
//  ARSearchFooter.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARSearchFooter.h"
#import "Masonry.h"

@interface ARSearchFooter()

@property (nonatomic, strong) UIView *buttonView; // 按钮数组

@end

@implementation ARSearchFooter

static NSInteger const kButtonCount = 10;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(0));
        }];
        
        _buttonView = [[UIView alloc] init];
        _buttonView.backgroundColor = RGB(196, 196, 196);
        [self addSubview:_buttonView];
        [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(view.mas_bottom);
            //make.height 与按钮分割线相关，296是iphone5上刚刚好的数值
            make.height.equalTo(@(261));
        }];
        
        NSInteger lineCount = 2;
        CGFloat width = (ARScreenWidth-2) / lineCount;
        CGFloat height = (105-3) / lineCount;
        
        CGFloat margin = 1;
        CGFloat x = 0;
        CGFloat y = 0;
        
        for (NSInteger index = 0; index < kButtonCount; index++) {
            NSInteger line = index / lineCount;
            NSInteger colunms = index % lineCount;
            x = (width + margin) * colunms;
            y = margin + (height + margin) * line;
            UIButton *button = [[UIButton alloc] init];
            button.frame = CGRectMake(x, y, width, height);
            button.backgroundColor = [UIColor whiteColor];
            button.tag = index;
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setBackgroundImage:[UIImage imageNamed:@"buttonBackground"] forState:UIControlStateHighlighted];
            if (index == 9) {
                [button setTitleColor:RGB(220, 41, 32) forState:UIControlStateNormal];
                [button setImage:[UIImage imageNamed:@"BookContent_huanyuanshuaxin_sl"] forState:UIControlStateNormal];
                [button setContentMode:UIViewContentModeLeft];
                
                [button addTarget:self action:@selector(changeKeyWord:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
            }
            [_buttonView addSubview:button];
            
        }
        
    }
    return self;
}

- (void)search:(UIButton *)sender {
    !self.searchCallBack ? : self.searchCallBack(sender.tag);
}

- (void)changeKeyWord:(UIButton *)sender {
    !self.changeKeyWord ? : self.changeKeyWord(sender.tag);
}

- (void)setKeywords:(NSArray *)keywords {
    _keywords = keywords;
    for (NSInteger index=0; index<kButtonCount; index++) {
        UIButton *button = self.buttonView.subviews[index];
        [button setTitle:keywords[index] forState:UIControlStateNormal];
    }
}

@end
