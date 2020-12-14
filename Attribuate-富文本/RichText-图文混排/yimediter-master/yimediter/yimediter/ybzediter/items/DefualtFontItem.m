//
//  DefualtFontItem.m
//  yimediter
//
//  Created by ybz on 2017/12/1.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "DefualtFontItem.h"
#import "YIMEditerProtocol.h"
#import "YIMEditerFontView.h"
#import "YIMEditerStyle.h"

@interface DefualtFontItem()
@end

@implementation DefualtFontItem

-(instancetype)init{
    return [super initWithImage:[UIImage imageNamed:@"yimediter.bundle/font"]];
}

-(UIView*)menuItemInputView{
    return self.fontView;
}
-(YIMEditerFontView*)fontView{
    if (!_fontView) {
        _fontView = [[YIMEditerFontView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 280)];
        _fontView.textStyle = [YIMEditerTextStyle createDefualtStyle];
    }
    return _fontView;
}
@end
