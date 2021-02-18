//
//  GoodNumberView.m
//  ListV
//
//  Created by imac on 16/7/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodNumberView.h"

@interface GoodNumberView()


@end

@implementation GoodNumberView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 36, 15)];
    
    titleLb.font = MFont(12);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.textColor = [UIColor lightGrayColor];
    titleLb.text = @"数量";
    self.numLabel = titleLb;
    [self addSubview:self.numLabel];
    UIView *countV = [[UIView alloc]initWithFrame:CGRectMake(50, 0, 80, 20)];
    [self addSubview:countV];
    countV.layer.cornerRadius = 3;
    countV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    countV.layer.borderWidth = 1;

    UIButton *reduceBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [countV addSubview:reduceBtn];
    reduceBtn.backgroundColor = LH_RGBCOLOR(220, 220, 220);
    [reduceBtn setTitle:@"一" forState:BtnNormal];
    reduceBtn.tag = 90;
    reduceBtn.titleLabel.font = MFont(13);
    [reduceBtn setTitleColor:[UIColor grayColor] forState:BtnNormal];
    [reduceBtn addTarget:self action:@selector(countChange:) forControlEvents:BtnTouchUpInside];

    _countLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(reduceBtn), 5, 40, 15)];
    [countV addSubview:_countLb];
    _countLb.font=MFont(13);
    _countLb.textAlignment = NSTextAlignmentCenter;
    _countLb.textColor = [UIColor redColor];
    _countLb.text = @"1";

    UIButton *addBtn = [[UIButton alloc]initWithFrame:CGRectMake(60, 0, 20, 20)];
    [countV addSubview:addBtn];
    addBtn.backgroundColor = LH_RGBCOLOR(220, 220, 220);
    [addBtn setTitle:@"十" forState:BtnNormal];
    addBtn.tag = 91;
    addBtn.titleLabel.font = MFont(13);
    [addBtn setTitleColor:[UIColor grayColor] forState:BtnNormal];
    [addBtn addTarget:self action:@selector(countChange:) forControlEvents:BtnTouchUpInside];

}

- (void)countChange:(UIButton *)sender{
    [self.delegate changeCountLb:_countLb action:sender];
}

@end
