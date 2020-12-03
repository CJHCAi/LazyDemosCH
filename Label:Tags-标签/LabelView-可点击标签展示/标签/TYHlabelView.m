//
//  TYHlabelView.m
//  标签
//
//  Created by Vieene on 16/7/29.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "TYHlabelView.h"
@interface TYHlabelView ()
@end
@implementation TYHlabelView
- (instancetype)initWithLabelArray:(NSArray *)array viewframe:(CGRect)frame
{
    if (self = [super init]) {
        self.frame = frame;
        [self addLabel:array];
    }
    return self;
}
- (void)addLabel:(NSArray*)labels
{
    UIFont *font = [UIFont systemFontOfSize:10];
    CGFloat x = 10;
    CGFloat y = 10;
    for (int i = 0; i < labels.count; i++)
    {
        NSString *str = labels[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        NSDictionary *userAttributes = @{NSFontAttributeName:font};
        CGRect adjustedRect = [str boundingRectWithSize:CGSizeMake(FLT_MAX, 30)
                                                options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                             attributes:userAttributes
                                                context:nil];
        CGFloat with = adjustedRect.size.width + 10;
        
        if ((with+x) > self.frame.size.width) {
            y = y+40;
            x = 10;
            if (y > self.frame.size.height) {
                break;
            }
        }
        
        button.frame = CGRectMake(x, y, with, 24);
        x = x+with+5;
        button.tag = i;
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = font;
        button.backgroundColor = [UIColor orangeColor];
        
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(hotTagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}
- (void)hotTagButtonClick:(UIButton *)btn
{
    if (_Clickblock) {
        _Clickblock(btn);
    }
}
@end
