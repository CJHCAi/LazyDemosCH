//
//  HKBursingtShareView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBursingtShareView.h"
#import "HKDiscountView.h"
#import "HKBurstingActivityShareModel.h"
#import "UIImageView+HKWeb.h"
@interface HKBursingtShareView()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet HKDiscountView *discount;
@property (weak, nonatomic) IBOutlet UILabel *brusingtTitle;
//区分是爆款还是拼团.
@property (weak, nonatomic) IBOutlet UIImageView *sharetypeView;

@end

@implementation HKBursingtShareView
-(void)awakeFromNib{
    [super awakeFromNib];
}
- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKBursingtShareView" owner:self options:nil].lastObject;
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize{
    self.discount.font = PingFangSCMedium10;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick)];
    [self addGestureRecognizer:tap];
}
-(void)viewClick{
    if ([self.delegate respondsToSelector:@selector(gotoBurstingActivity)]) {
        [self.delegate gotoBurstingActivity];
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKBursingtShareView" owner:self options:nil].lastObject;
    if (self) {
        // TODO:init
        self.frame = frame;
        [self initialize];
    }
    return self;
}
-(void)setModel:(HKBurstingActivityShareModel *)model{
    _model = model;
    
    NSString * titles;
    if (model.type.integerValue ==SHARE_Type_Collage) {
        titles =@"【拼团抢劵】";
    }else {
        titles =@"【爆款抢卷】";
    }
    NSMutableAttributedString*strA = [[NSMutableAttributedString alloc]initWithString:titles];
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"EF593C"] range:NSMakeRange(0, strA.length)];
    NSMutableAttributedString*strb = [[NSMutableAttributedString alloc]initWithString:@"参与活动免费获好礼，您还在等什么"];
    [strA appendAttributedString:strb];
    [strA addAttribute:NSFontAttributeName value:PingFangSCMedium13 range:NSMakeRange(0, strA.length)];
    self.brusingtTitle.attributedText = strA;
    self.titleView.text = model.title;
    self.price.text = [NSString stringWithFormat:@"商品原价：¥%@",model.pintegral];
    self.discount.discount = model.discount.integerValue;
   // self.sharetypeView.image;;
    
    [self.iconView hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    
}

@end
