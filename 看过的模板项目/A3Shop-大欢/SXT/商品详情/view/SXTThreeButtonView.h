//
//  SXTThreeButtonView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^addBuyCarBlock)();

@interface SXTThreeButtonView : UIView

@property (copy, nonatomic) addBuyCarBlock  addBlock;//加入购物车回调

@end
