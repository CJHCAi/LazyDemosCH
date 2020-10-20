//
//  TitlesView.m
//  老淘宝详情
//
//  Created by Kobe24 on 2018/3/7.
//  Copyright © 2018年 SYD. All rights reserved.
//

#import "TitlesView.h"
#import "ToolHeader.h"

@interface TitlesView ()

@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, strong)NSMutableArray *titleBtnArray;
@property (nonatomic, strong)UIView *indicateLine;

@end


@implementation TitlesView

- (instancetype)initWithTitleArray:(NSArray *)titleArray{
    if (self = [super init]) {
        _titleArray = titleArray;
        _titleBtnArray = [NSMutableArray array];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, kTabTitleViewHeight);
        CGFloat btnWidth = SCREEN_WIDTH/titleArray.count;
        for (int i = 0; i < titleArray.count ; i ++) {
            UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnWidth * i, 0, btnWidth, kTabTitleViewHeight)];
            [titleBtn setTitle:_titleArray[i] forState:UIControlStateNormal];
            if (i == 0) {
                [titleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }else{
               [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            titleBtn.tag = i;
            [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:titleBtn];
            [_titleBtnArray addObject:titleBtn];
        }
        
        _indicateLine = [[UIView alloc] initWithFrame:CGRectMake(0, kTabTitleViewHeight - 1, btnWidth, 1)];
        _indicateLine.backgroundColor = [UIColor blueColor];
        [self addSubview:_indicateLine];
        
    }
    return self;
}
- (void)titleBtnClick:(UIButton *)btn{
    NSInteger numBtn = btn.tag;
    [self setItemSelected:numBtn];
    if (self.titleClickBlock) {
        self.titleClickBlock(numBtn);
    }
}

- (void)setItemSelected:(NSInteger)column{
    
    for (int i = 0; i < _titleBtnArray.count; i ++) {
        UIButton *btn = _titleBtnArray[i];
        if (btn.tag == column) {
            [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    CGFloat lineWidth = SCREEN_WIDTH/_titleBtnArray.count;
    _indicateLine.frame = CGRectMake(lineWidth * column, kTabTitleViewHeight - 1, lineWidth, 1);
    
}

@end
