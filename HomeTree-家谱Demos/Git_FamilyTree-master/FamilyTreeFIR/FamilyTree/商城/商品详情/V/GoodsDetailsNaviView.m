//
//  GoodsDetailsNaviView.m
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodsDetailsNaviView.h"

@interface GoodsDetailsNaviView()
@property (strong,nonatomic) NSMutableArray *LineArr;
@end

@implementation GoodsDetailsNaviView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    _LineArr = [NSMutableArray array];
    NSArray *titleArr = @[@"商品",@"详情",@"评价"];
    for (int i =0 ; i<3; i++) {
        UIView *NaviV = [[UIView alloc]initWithFrame:CGRectMake(__kWidth/18+i*__kWidth*2/9, 0, 35, 44)];
        [self addSubview:NaviV];
        NaviV.backgroundColor = [UIColor clearColor];

        UIButton *naviBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 43)];
        [NaviV addSubview:naviBtn];
        [naviBtn setTitle:titleArr[i] forState:BtnNormal];
        [naviBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
        naviBtn.backgroundColor = [UIColor clearColor];
        naviBtn.titleLabel.font = MFont(15);
        naviBtn.tag = i;
        [naviBtn addTarget:self action:@selector(changeNavi:) forControlEvents:BtnTouchUpInside];

        UIImageView *lineV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43, 35, 1)];
        [NaviV addSubview:lineV];
        lineV.backgroundColor = [UIColor whiteColor];
        lineV.hidden = YES;
        lineV.tag = i;
        if (naviBtn.tag ==0) {
            lineV.hidden=NO;
        }
        [_LineArr addObject:lineV];
    }
}
#pragma mark ==直接更改导航栏显示==
-(void)chooseView:(NSInteger)sender{
    for (UIImageView *IV in _LineArr) {
        if(IV.tag == sender){
            IV.hidden =NO;
        }else{
            IV.hidden = YES;
        }
    }
}
#pragma mark ==按钮控制视图变哈==
- (void)changeNavi:(UIButton*)sender{
    for (UIImageView *IV in _LineArr) {
        if (IV == _LineArr[sender.tag]) {
            IV.hidden = NO;
        }else{
            IV.hidden = YES;
        }
    }
    [self.delegate changeView:sender];
}

@end
