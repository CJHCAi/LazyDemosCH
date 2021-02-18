//
//  OrderBottomView.m
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "OrderBottomView.h"

@implementation OrderBottomView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];

    }
    return self;
}

- (void)initView{
    UIView *totalV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 85)];
    [self addSubview:totalV];
    totalV.backgroundColor = [UIColor whiteColor];
    NSArray *titleArr = @[@"商品金额",@"运费",@"优惠"];
    for (int i= 0; i<3; i++) {
        UILabel *titleLb =[[UILabel alloc]initWithFrame:CGRectMake(15, 15+20*i, 70, 20)];
        [totalV addSubview:titleLb];
        titleLb.font = MFont(15);
        titleLb.text = titleArr[i];
        titleLb.textAlignment = NSTextAlignmentLeft;

        UILabel *detailLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-100, 15+22*i, 65, 20)];
        [totalV addSubview:detailLb];
        detailLb.font = MFont(13);
        detailLb.textColor = [UIColor redColor];
        detailLb.textAlignment = NSTextAlignmentRight;
        if (i==0) {
            _orderQuoteLb = detailLb;
        }else if (i==1){
            _orderFreightLb =detailLb;
        }else{
            _concessionsLb = detailLb;
        }
    }
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(totalV), __kWidth, 9)];
    [self addSubview:lineV];
    lineV.backgroundColor = LH_RGBCOLOR(230, 230, 230);

    UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectYH(lineV), __kWidth, 46)];
    [self addSubview:bottomV];
    bottomV.backgroundColor = [UIColor whiteColor];

    _orderPayLb = [[UILabel  alloc]initWithFrame:CGRectMake(15, 15, __kWidth-25-__kWidth*4/9, 15)];
    [bottomV addSubview:_orderPayLb];
    _orderPayLb.textAlignment = NSTextAlignmentRight;
    _orderPayLb.textColor = [UIColor redColor];
    _orderPayLb.font = MFont(14);

    UIButton *clearBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth*5/9, 0, __kWidth*4/9, 46)];
    [bottomV addSubview:clearBtn];
    clearBtn.backgroundColor = [UIColor redColor];
    clearBtn.titleLabel.font = MFont(15);
    [clearBtn setTitle:@"结算" forState:BtnNormal];
    [clearBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [clearBtn addTarget:self action:@selector(clearAction:) forControlEvents:BtnTouchUpInside];
}

- (void)clearAction:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(OrderBottonView:didTapClearButton:)]) {
        [_delegate OrderBottonView:self didTapClearButton:sender];
    };
    NSLog(@"结算");
}

@end
