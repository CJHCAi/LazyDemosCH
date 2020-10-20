//
//  GoodBottomView.m
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodBottomView.h"

@implementation GoodBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    NSArray *arr =@[@"加入购物车",@"立即购买"];
    for (int i=0; i<2; i++) {
        UIButton *actionBtn = [[UIButton alloc]initWithFrame:CGRectMake(i*self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
        [self addSubview:actionBtn];
        actionBtn.tag = i;
        actionBtn.titleLabel.font = MFont(15);
        [actionBtn setTitle:arr[i] forState:BtnNormal];
        if (i) {
            actionBtn.backgroundColor = [UIColor redColor];
            [actionBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
        }else{
            actionBtn.backgroundColor = [UIColor whiteColor];
            [actionBtn setTitleColor:[UIColor lightGrayColor] forState:BtnNormal];
        }
        [actionBtn addTarget:self action:@selector(shopAction:) forControlEvents:BtnTouchUpInside];
    }
}

- (void)shopAction:(UIButton*)sender{
    [self.delegate payOrShop:sender];
}

@end
