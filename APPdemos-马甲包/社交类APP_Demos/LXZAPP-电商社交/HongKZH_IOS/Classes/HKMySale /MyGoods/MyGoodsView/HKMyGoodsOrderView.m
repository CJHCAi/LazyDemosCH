//
//  HKMyGoodsOrderView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyGoodsOrderView.h"
#import "UIView+Xib.h"
@interface HKMyGoodsOrderView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HKMyGoodsOrderView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
}
-(void)setOrderType:(MYUpperProductOrder)orderType{
    _orderType = orderType ;
    switch (orderType) {
        case MYUpperProductOrder_time:{
            self.titleLabel.text = @"添加时间";
        }
            
            break;
        case MYUpperProductOrder_SalesVolume:{
            self.titleLabel.text = @"销量";
        }
            
            break;
        case MYUpperProductOrder_AAturnover:{
            self.titleLabel.text = @"成交额";
        }
            
            break;
        case MYUpperProductOrder_Stock:{
            self.titleLabel.text = @"库存";
        }
            
            break;
        default:
            break;
    }
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.titleLabel.textColor = [UIColor colorWithRed:85.0/255.0 green:142.0/255.0 blue:240.0/255.0 alpha:1];
        self.userInteractionEnabled = NO;
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
         self.userInteractionEnabled = YES;
    }
}
- (IBAction)btnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(goodsOrderType:)]) {
        [self.delegate goodsOrderType:self.orderType];
    }
}

@end
