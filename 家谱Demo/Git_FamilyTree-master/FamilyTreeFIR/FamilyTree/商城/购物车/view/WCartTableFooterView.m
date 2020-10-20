//
//  WCartTableFooterView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WCartTableFooterView.h"

@implementation WCartTableFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.footSelectBtn];
        [self addSubview:self.priceLabel];
        [self addSubview:self.clearPrice];
    }
    return self;
}
#pragma mark *** events ***
-(void)respondsToMyBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(WCartTableFooterView:didSelectedButton:)]) {
        [_delegate WCartTableFooterView:self didSelectedButton:sender];
    };
}
#pragma mark *** getters ***
-(UIButton *)footSelectBtn{
    if (!_footSelectBtn) {
        _footSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, self.bounds.size.height)];
        [_footSelectBtn setTitle:@"全选" forState:0];
        [_footSelectBtn addTarget:self action:@selector(respondsToMyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_footSelectBtn setTitleColor:[UIColor blackColor] forState:0];
        _footSelectBtn.titleLabel.font = WFont(30);
    }
    return _footSelectBtn;
}
-(UILabel *)priceLabel{
    if (!_priceLabel) {
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(self.footSelectBtn)+20, 0, 95*AdaptationWidth(), self.bounds.size.height)];
        theLabel.text = @"合计：";
        theLabel.textAlignment = NSTextAlignmentRight;
        theLabel.font = WFont(30);
        [self addSubview:theLabel];
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(theLabel), 0, 100, self.bounds.size.height)];
        _priceLabel.textColor = [UIColor redColor];
        _priceLabel.text = theLabel.text;
        _priceLabel.textAlignment = 0;
        _priceLabel.text = @"¥0.0";
    }
    return _priceLabel;
}
-(UIButton *)clearPrice{
    if (!_clearPrice) {
        _clearPrice = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-240*AdaptationWidth(), 2, 240*AdaptationWidth(), self.bounds.size.height-2)];
        [_clearPrice setTitleColor:[UIColor whiteColor] forState:0];
        _clearPrice.backgroundColor = LH_RGBCOLOR(227, 0, 35);
        _clearPrice.titleLabel.font = WFont(30);
        [_clearPrice addTarget:self action:@selector(respondsToMyBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_clearPrice setTitle:@"去结算" forState:0];
    }
    return _clearPrice;
}

@end
