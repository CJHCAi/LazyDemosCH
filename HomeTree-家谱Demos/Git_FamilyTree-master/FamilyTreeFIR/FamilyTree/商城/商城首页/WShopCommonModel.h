//
//  WShopCommonModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WShopCommonModel : NSObject
/**存放商品类型的id*/
@property (nonatomic,strong) NSDictionary *typeIdDic;
+(instancetype)shareWShopCommonModel;
@end
