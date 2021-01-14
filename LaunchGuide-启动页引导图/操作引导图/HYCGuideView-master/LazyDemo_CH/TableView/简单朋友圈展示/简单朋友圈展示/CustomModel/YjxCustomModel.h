//
//  Model.h
//  TableviewLayout
//
//  Created by 闫继祥 on 2019/7/16.
//  Copyright © 2019 yang.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YjxCustomModel : NSObject
//头像
@property(nonatomic, copy)NSString *iconImg;
//昵称
@property(nonatomic, copy)NSString *nickname;
//时间
@property(nonatomic, copy)NSString *timeStr;
//个人等级 或者星级
@property(nonatomic, copy)NSString *personal;
//n文字内容
@property(nonatomic, copy)NSString *textContent;

//图片
@property(nonatomic, strong)NSArray *imageArr;

//id
@property(nonatomic, copy)NSString *idStr;

@end

NS_ASSUME_NONNULL_END
