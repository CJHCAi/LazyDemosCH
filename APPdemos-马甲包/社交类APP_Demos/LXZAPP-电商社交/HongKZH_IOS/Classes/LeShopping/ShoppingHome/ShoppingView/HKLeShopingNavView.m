//
//  HKLeShopingNavView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeShopingNavView.h"
#import "HKLeSeeSearchBtn.h"
#import "HKShoppingViewModel.h"
#import "NSString+Extend.h"
#import "UIImage+YY.h"
@interface HKLeShopingNavView()<HKLeSeeSearchBtnDelegate>
@property (weak, nonatomic) IBOutlet HKLeSeeSearchBtn *seacchBtn;
@property (weak, nonatomic) IBOutlet UIButton *cartNumBtn;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@end

@implementation HKLeShopingNavView

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKLeShopingNavView" owner:self options:nil].firstObject;
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
        self.seacchBtn.delegate = self;
        
    
        [self loadCartNum];
    }
    return self;
}
-(void)loadCartNum{
    [HKShoppingViewModel mediaShopCartCountSuccess:^(HKBaseResponeModel *responde) {
        if (responde.responeSuc) {
            NSInteger numI = [((NSNumber*)responde.data) integerValue];
            if (numI>0) {
                self.cartNumBtn.hidden = NO;
                dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *num = [NSString stringWithFormat:@"%ld",numI];
                    CGSize size = [num hk_boundingRectWithSize:CGSizeMake(MAXFLOAT, 13) fonts:PingFangSCMedium10];
                    UIImage *image = [[UIImage createImageWithColor:[UIColor colorFromHexString:@"EF593C"] size:CGSizeMake(size.width+10, 13)]zsyy_imageByRoundCornerRadius:6];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.cartNumBtn setBackgroundImage:image forState:0];
                        [self.cartNumBtn setTitle:num forState:0];
                    });
                });
            }else{
                self.cartNumBtn.hidden = YES;
            }
        }else{
            self.cartNumBtn.hidden = YES;
        }
    }];
}
-(void)setNavTitle{
   [self.seacchBtn setTitle:@"请输入商品名称" isCenter:NO backColor:[UIColor whiteColor] cornerRadius:15 width:self.width];
}
- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gotoVc:)]) {
        [self.delegate gotoVc:sender.tag];
    }
}
-(void)gotoSearch{
    if ([self.delegate respondsToSelector:@selector(goToSearchVc)]) {
        [self.delegate goToSearchVc];
    }
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    self.cartBtn.selected = isSelect;
    self.seacchBtn.isSelect = isSelect;
}
@end
