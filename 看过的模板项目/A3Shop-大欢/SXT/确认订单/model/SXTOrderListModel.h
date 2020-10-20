//
//  SXTOrderListModel.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXTOrderListModel : NSObject
/**商品ID*/
@property (copy, nonatomic) NSString *GoodsId;
/**商品缩略图*/
@property (copy, nonatomic) NSString *ImgView;
/**商品标题*/
@property (copy, nonatomic) NSString *Title;
/**商品数量*/
@property (assign, nonatomic) NSInteger GoodsCount;
/**价格*/
@property (assign, nonatomic) CGFloat Price;
/**商品重量*/
@property (assign, nonatomic) CGFloat Weight;
@end
