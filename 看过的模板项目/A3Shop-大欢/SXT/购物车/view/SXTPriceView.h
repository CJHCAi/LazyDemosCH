//
//  SXTPriceView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^gotoInsertBlock)();
@interface SXTPriceView : UIView
@property (strong, nonatomic)   UILabel *priceLabel;              /** 商品价格 */

@property (copy, nonatomic) gotoInsertBlock gotoInsert;//去结算回调

@end
