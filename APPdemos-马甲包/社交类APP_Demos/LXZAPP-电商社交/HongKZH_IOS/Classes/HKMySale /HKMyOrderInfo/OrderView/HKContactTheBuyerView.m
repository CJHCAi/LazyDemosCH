//
//  HKContactTheBuyerView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKContactTheBuyerView.h"
#import "UIView+Xib.h"
@interface HKContactTheBuyerView()
@property (weak, nonatomic) IBOutlet UIView *contactView;

@end

@implementation HKContactTheBuyerView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contactBuyer)];
    [self.contactView addGestureRecognizer:tap];
}
-(void)contactBuyer{
    if ([self.delegate respondsToSelector:@selector(toCellContact)]) {
        [self.delegate toCellContact];
    }
}
@end
