//
//  SXTBuyCarListView.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/30.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^returnChangeDataBlock)();

@interface SXTBuyCarListView : UITableView

@property (strong, nonatomic)   NSMutableArray *buyCarList;/**接收购物车请求回来的数据*/
@property (copy, nonatomic)   returnChangeDataBlock changeDataBlock;              /** 修改controller中的数据 */
@end
