//
//  OrderStatusView.m
//  ListV
//
//  Created by imac on 16/8/1.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "OrderStatusView.h"

@interface OrderStatusView()

@property (strong,nonatomic) NSMutableArray *BtnsArr;

@end

@implementation OrderStatusView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initTypeArr:(NSArray *)arr{
    _BtnsArr = [NSMutableArray array];
    CGFloat w = __kWidth/arr.count;
    for (int i =0 ; i<arr.count; i++) {
        UIButton * typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(w*i, 0, w, 40)];
        [self addSubview:typeBtn];
        typeBtn.titleLabel.font = MFont(14);
        typeBtn.tag = i+33;
        [typeBtn setTitle:arr[i] forState:BtnNormal];
        [typeBtn setTitleColor:[UIColor blackColor] forState:BtnNormal];
        if (typeBtn.tag == 33) {
            [typeBtn setTitleColor:[UIColor redColor] forState:BtnNormal];
        }
        [typeBtn addTarget:self action:@selector(chooseType:) forControlEvents:BtnTouchUpInside];
        [_BtnsArr addObject:typeBtn];
    }

}

- (void)chooseType:(UIButton *)sender{
    for (UIButton *btn in _BtnsArr) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor redColor] forState:BtnNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:BtnNormal];
        }
    }
    [self.delegate orderTypeChoose:sender];
}

@end
