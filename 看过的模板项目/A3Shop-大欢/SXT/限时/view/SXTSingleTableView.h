//
//  SXTSingleTableView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/22.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^newTableSelectGoodsIDBlock)(NSString *goodsID);

@interface SXTSingleTableView : UITableView

@property (assign, nonatomic)   BOOL isSingle;/**是不是新品团购*/

@property (strong, nonatomic)   NSArray *singleModelArray;              /** 存放新品数据模型的数组 */
@property (strong, nonatomic)   NSArray *groupModelArray;/**存放团购数据模型的数组*/

@property (copy, nonatomic)     newTableSelectGoodsIDBlock goodsIDBlock;/** 返回商品ID的block */

@end
