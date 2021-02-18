//
//  GoodColorView.m
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodColorView.h"

@interface GoodColorView()

@property (strong,nonatomic) NSMutableArray *colorBtns;

@end

@implementation GoodColorView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _colorBtns = [NSMutableArray array];
        UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 36, 15)];
        [self addSubview:titleLb];
        titleLb.font = MFont(12);
        titleLb.textColor = [UIColor lightGrayColor];
        titleLb.textAlignment = NSTextAlignmentLeft;
        titleLb.text = @"颜色：";

            }
    return self;
}

-(void)initBtnsArray:(NSMutableArray<GoodColorModel*> *)arr{
    for (int i=0; i<arr.count; i++) {
        CGFloat height = (i/4)*25;
        CGFloat width = (i%4)*50;
        UIButton *colorBtn = [[UIButton alloc]initWithFrame:CGRectMake(50+width, height, 40, 20)];
        [self addSubview:colorBtn];
        colorBtn.tag = i;
        [colorBtn setTitle:arr[i].goodColor forState:BtnNormal];
        colorBtn.titleLabel.font = MFont(12);
        [colorBtn setTitleColor:LH_RGBCOLOR(90, 90, 90) forState:BtnNormal];
        colorBtn.backgroundColor = [UIColor whiteColor];
        colorBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        colorBtn.layer.cornerRadius = 3;
        colorBtn.layer.borderWidth = 1;
        [_colorBtns addObject:colorBtn];
        [colorBtn addTarget:self action:@selector(chooseColor:) forControlEvents:BtnTouchUpInside];
    }

}
#pragma mark ==更改显示并触发选择颜色代理==
- (void)chooseColor:(UIButton *)sender{
    for (UIButton *btn in _colorBtns) {
        if (btn.tag == sender.tag) {
            btn.backgroundColor = [UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            btn.layer.borderColor = [UIColor redColor].CGColor;
        }else{
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:LH_RGBCOLOR(90, 90, 90) forState:BtnNormal];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    [self.delegate goodColorChoose:sender];
}

@end
