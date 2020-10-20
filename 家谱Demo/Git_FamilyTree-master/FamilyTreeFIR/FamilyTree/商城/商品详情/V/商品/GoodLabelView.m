//
//  GoodLabelView.m
//  ListV
//
//  Created by imac on 16/7/28.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodLabelView.h"

@implementation GoodLabelView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        self.backgroundColor =[UIColor whiteColor];
    }
    return self;
}

- (void)initView{
    
    
    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, __kWidth, 20)];
    [self addSubview:titleLb];
    titleLb.font = MFont(20);
    titleLb.textColor = LH_RandomColor;
    titleLb.text = @"商品详情";
    titleLb.textAlignment = NSTextAlignmentCenter;

    _detaiLb = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectYH(titleLb)+10, __kWidth-30, 100)];
    [self addSubview:_detaiLb];
    _detaiLb.font = MFont(14);
    _detaiLb.textAlignment = NSTextAlignmentLeft;
    _detaiLb.numberOfLines = 0;
    _detaiLb.textColor = LH_RGBCOLOR(90, 90, 90);
    
}
/**
 *  更新约束
 */
-(void)refreshFrame{
    NSString *str = _detaiLb.text;
    CGSize size = [str sizeWithFont:_detaiLb.font constrainedToSize:CGSizeMake(__kWidth-30, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    [_detaiLb setFrame:CGRectMake(15, 45, __kWidth-30, size.height)];

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, __kWidth, size.height+45+10);
}

@end
