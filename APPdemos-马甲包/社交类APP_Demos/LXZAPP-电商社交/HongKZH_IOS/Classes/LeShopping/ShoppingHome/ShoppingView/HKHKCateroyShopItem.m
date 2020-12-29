//
//  HKHKCateroyShopItem.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHKCateroyShopItem.h"
@interface HKHKCateroyShopItem()
@property (weak, nonatomic) IBOutlet UIButton *name;

@end

@implementation HKHKCateroyShopItem

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HKLeShopHomeHotsshopes *)model{
    _model = model;
    [self.name setTitle:model.categoryName forState:0];
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
    if (isSelect) {
        self.name.selected = YES;
    }else{
        self.name.selected = NO;
    }
}
@end
