//
//  SXTGoodsListViewController.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTBaseViewController.h"

@interface SXTGoodsListViewController : SXTBaseViewController

@property (strong, nonatomic)   NSArray *searchList;/** 搜索返回的数据 */
/**标记字典*/
@property (strong, nonatomic) NSMutableDictionary *idDictionary;

@end
