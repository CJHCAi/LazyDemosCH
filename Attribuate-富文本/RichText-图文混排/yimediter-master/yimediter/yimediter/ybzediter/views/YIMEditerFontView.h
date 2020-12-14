//
//  YIMEditerFontView.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerView.h"
#import "YIMEditerProtocol.h"
#import "YIMEditerTextStyle.h"

/**
 字体样式选择视图
 */
@interface YIMEditerFontView : YIMEditerView <YIMEditerStyleChangeObject>

@property(nonatomic,strong)YIMEditerTextStyle *textStyle;

@end
