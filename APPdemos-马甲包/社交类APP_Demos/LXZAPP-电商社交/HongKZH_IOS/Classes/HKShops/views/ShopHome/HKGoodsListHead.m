//
//  HKGoodsListHead.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGoodsListHead.h"
#import "UIButton+LXMImagePosition.h"
@implementation HKGoodsListHead

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.tagLabel];
       // [self addSubview:self.moreBtn];
        [self addSubview:self.line];
    }
    return  self;
}
-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel =[[UILabel alloc] initWithFrame:CGRectMake(15,0,200,50)];
        [AppUtils getConfigueLabel:_tagLabel font:PingFangSCRegular15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"推荐商品"];
    }
    return _tagLabel;
}
-(UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _moreBtn.frame = CGRectMake(kScreenWidth-15-80,0,80,50);
        [_moreBtn setImage:[UIImage imageNamed:@"dp_gd"] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
        _moreBtn.titleLabel.font =PingFangSCRegular12;
         _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _moreBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
        [_moreBtn  setImagePosition:LXMImagePositionRight spacing:6];
        [_moreBtn addTarget:self action:@selector(checkMoreGoods) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

-(void)checkMoreGoods {
    if (self.block) {
        self.block();
    }
}
-(UIView *)line {
    if (!_line) {
        _line =[[UIView alloc] initWithFrame:CGRectMake(0,49,kScreenWidth,1)];
        _line.backgroundColor =RGB(226,226,226);
    }
    return _line;
}

@end
