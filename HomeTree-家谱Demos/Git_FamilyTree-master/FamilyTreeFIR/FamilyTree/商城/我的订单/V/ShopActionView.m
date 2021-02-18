//
//  ShopActionView.m
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ShopActionView.h"

@interface ShopActionView()

@property (strong,nonatomic) NSMutableArray *btnsArr;

@end

@implementation ShopActionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initWith:(NSInteger)type{
    switch (type) {
        case 0:{
            for (int i=0; i<2; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-25-__kWidth*19/45+(10+__kWidth*19/90)*i, 0, __kWidth*19/90, 28)];
                [self addSubview:btn];
                btn.tag = i+1;
                btn.layer.cornerRadius = 3;
                btn.layer.borderWidth = 1;
                btn.titleLabel.font = MFont(12);
                [btn addTarget:self action:@selector(orderAction:) forControlEvents:BtnTouchUpInside];
                if (i) {
                    [btn setTitle:@"立即付款" forState:BtnNormal];
                    [btn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
                    btn.backgroundColor = [UIColor redColor];
                    btn.layer.borderColor = [UIColor redColor].CGColor;

                }else{
                    [btn setTitle:@"取消订单" forState:BtnNormal];
                    [btn setTitleColor:[UIColor grayColor] forState:BtnNormal];
                    btn.layer.borderColor = LH_RGBCOLOR(120, 120, 120).CGColor;
                    btn.backgroundColor = [UIColor whiteColor];
                }
            }

        }
            break;
        case 1:{
            UIButton *delBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-15-__kWidth*19/90, 0, __kWidth*19/90, 28)];
            [self addSubview:delBtn];
            delBtn.backgroundColor = [UIColor whiteColor];
            [delBtn setTitleColor:[UIColor grayColor] forState:BtnNormal];
            [delBtn setTitle:@"删除订单" forState:BtnNormal];
            delBtn.tag = 3;
            delBtn.titleLabel.font = MFont(12);
            delBtn.layer.cornerRadius = 3;
            delBtn.layer.borderWidth = 1;
            delBtn.layer.borderColor = LH_RGBCOLOR(120, 120, 120).CGColor;
            [delBtn addTarget:self action:@selector(orderAction:) forControlEvents:BtnTouchUpInside];
        }
            break;
        case 2:{
            UIButton *remindBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-15-__kWidth*19/90, 0, __kWidth*19/90, 28)];
            [self addSubview:remindBtn];
            remindBtn.backgroundColor = [UIColor whiteColor];
            [remindBtn setTitle:@"提醒发货" forState:BtnNormal];
            [remindBtn setTitleColor:[UIColor grayColor] forState:BtnNormal];
            remindBtn.tag = 4;
            remindBtn.titleLabel.font = MFont(12);
            remindBtn.layer.cornerRadius = 3;
            remindBtn.layer.borderWidth = 1;
            remindBtn.layer.borderColor = LH_RGBCOLOR(120, 120, 120).CGColor;
            [remindBtn addTarget:self action:@selector(orderAction:) forControlEvents:BtnTouchUpInside];
        }
            break;
        case 3:{
            UIButton *sureReciveBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-15-__kWidth*19/90, 0, __kWidth*19/90, 28)];
            [self addSubview:sureReciveBtn];
            sureReciveBtn.backgroundColor = [UIColor redColor];
            [sureReciveBtn setTitle:@"确认收货" forState:BtnNormal];
            [sureReciveBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            sureReciveBtn.tag = 5;
            sureReciveBtn.titleLabel.font = MFont(12);
            sureReciveBtn.layer.cornerRadius = 3;
            sureReciveBtn.layer.borderColor = [UIColor redColor].CGColor;
            sureReciveBtn.layer .borderWidth = 1;
            [sureReciveBtn addTarget:self action:@selector(orderAction:) forControlEvents:BtnTouchUpInside];
        }
            break;
        case 4:{
            UIButton *endDelBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-25-__kWidth*29/90, 0, __kWidth*19/90, 28)];
            [self addSubview:endDelBtn];
            endDelBtn.backgroundColor = [UIColor whiteColor];
            [endDelBtn setTitle:@"删除订单" forState:BtnNormal];
            [endDelBtn setTitleColor:[UIColor grayColor] forState:BtnNormal];
            endDelBtn.tag = 6;
            endDelBtn.titleLabel.font = MFont(12);
            endDelBtn.layer.cornerRadius = 3;
            endDelBtn.layer.borderWidth = 1;
            endDelBtn.layer.borderColor = LH_RGBCOLOR(120, 120, 120).CGColor;
            [endDelBtn addTarget:self action:@selector(orderAction:) forControlEvents:BtnTouchUpInside];

            UIButton *evaluateBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-15-__kWidth/9, 0, __kWidth/9, 28)];
            [self addSubview:evaluateBtn];
            evaluateBtn.backgroundColor = [UIColor redColor];
            [evaluateBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
            [evaluateBtn setTitle:@"评价" forState:BtnNormal];
            evaluateBtn.tag = 7;
            evaluateBtn.titleLabel.font = MFont(12);
            evaluateBtn.layer.cornerRadius = 3;
            evaluateBtn.layer.borderWidth = 1;
            evaluateBtn.layer.borderColor = [UIColor redColor].CGColor;
            [evaluateBtn addTarget:self action:@selector(orderAction:) forControlEvents:BtnTouchUpInside];
        }
            break;
        default:
            break;
    }
}

- (void)orderAction:(UIButton*)sender{
    [self.delegate shopAction:sender];
}

@end
