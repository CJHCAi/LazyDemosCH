//
//  SXTSureOrderModel.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXTSureOrderModel : NSObject

/**商品个数*/
@property (copy, nonatomic) NSString *Count;

/**邮费*/
@property (copy, nonatomic) NSString *DeliverCost;

/**支付方式列表*/
@property (strong, nonatomic) NSArray *PayList;

/**订单中商品列表*/
@property (strong, nonatomic) NSArray *GoodsList;
/**订单金额*/
@property (copy, nonatomic) NSString *GoodsPrice;
/**返回信息*/
@property (copy, nonatomic) NSString *Message;
/**是否成功*/
@property (copy, nonatomic) NSString *result;
@end
