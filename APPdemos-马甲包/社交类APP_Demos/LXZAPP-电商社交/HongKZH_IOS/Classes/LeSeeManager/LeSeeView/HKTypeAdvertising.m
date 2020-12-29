//
//  HKTypeAdvertising.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/13.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTypeAdvertising.h"
#import "UIImage+YY.h"
#import "CorporateCategoryResponse.h"
@implementation HKTypeAdvertising
-(void)awakeFromNib{
    [super awakeFromNib];
}
-(void)setRespone:(CorporateCategoryResponse *)respone{
    _respone = respone;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<respone.data.count; i++) {
         CorporateCategoryModel*model = respone.data[i];
        int row = i/4;
        int l = i%4;
        UIButton*btn = [self getBtn:model.labelColor];
        btn.tag = i;
        if ((!respone.isOpen)&&row>0) {
            btn.hidden = YES;
        }else{
            btn.hidden = NO;
        }
       
        [btn setTitle:model.name forState:0];
        CGFloat w = (kScreenWidth - 60 - 15 - 30)/4;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(w);
            make.height.mas_equalTo(30);
            make.left.equalTo(self).offset(15+l*(w+10));
            make.top.equalTo(self).offset(15+row*(30+15));
        }];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        if (i == self.currentIndex) {
//            btn.selected = YES;
//        }
    }
}
-(void)btnClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(clickCategory:)]) {
        [self.delegate clickCategory:sender.tag];
    }
}
-(UIButton*)getBtn:(NSString*)labelColor{
    UIButton*btn = [[UIButton alloc]init];
    CGFloat w = (kScreenWidth - 60 - 15 - 30)/4;
    UIImage *image = [UIImage createImageWithColor:[UIColor colorFromHexString:labelColor] size:CGSizeMake(w, 30)];
    image = [image zsyy_imageByRoundCornerRadius:5];
    [btn setBackgroundImage:image forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [btn setTitleColor:[UIColor colorFromHexString:@"EF593C "] forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    return btn;
}
-(void)setOpenBtnWithIsOpen:(BOOL)isOpen{
    for (UIView*view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.hidden = isOpen;
        }
    }
    
}
@end
