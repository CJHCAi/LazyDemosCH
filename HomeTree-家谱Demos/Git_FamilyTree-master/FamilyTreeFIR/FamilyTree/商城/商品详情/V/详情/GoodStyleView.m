//
//  GoodStyleView.m
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodStyleView.h"

@interface GoodStyleView()

@property (strong,nonatomic) NSMutableArray *styleBtns;

@end

@implementation GoodStyleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 36, 15)];
    [self addSubview:titleLb];
    titleLb.font = MFont(12);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.textColor = [UIColor lightGrayColor];
    titleLb.text = @"款式：";

}

-(void)initStyleBtns:(NSMutableArray<GoodStyleModel*> *)arr{
    _styleBtns = [NSMutableArray array];
    for (int i=0 ; i<arr.count; i++) {
        CGFloat height = (i/2)*25;
        CGFloat width = (i%2)*75;
        UIButton *styleBtn = [[UIButton alloc]initWithFrame:CGRectMake(50+width, height, 70, 20)];
        [self addSubview:styleBtn];
        styleBtn.tag = i+11;
        styleBtn.backgroundColor = [UIColor whiteColor];
        [styleBtn setTitle:arr[i].goodStyle forState:BtnNormal];
        [styleBtn setTitleColor:LH_RGBCOLOR(90, 90, 90) forState:BtnNormal];
        [styleBtn addTarget:self action:@selector(chooseStyle:) forControlEvents:BtnTouchUpInside];
        styleBtn.titleLabel.font = MFont(12);
        styleBtn.layer.borderColor= [UIColor lightGrayColor].CGColor;
        styleBtn.layer.borderWidth = 1;
        styleBtn.layer.cornerRadius = 3;
        [_styleBtns addObject:styleBtn];
    }
}
#pragma mark ==更改显示并触发更改款式代理==
- (void)chooseStyle:(UIButton *)sender{
    for (UIButton *btn in _styleBtns) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            btn.backgroundColor = [UIColor redColor];
            btn.layer.borderColor = [UIColor redColor].CGColor;
        }else{
            [btn setTitleColor:LH_RGBCOLOR(90, 90, 90) forState:BtnNormal];
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
    [self.delegate goodStyleChoose:sender];
}

@end
