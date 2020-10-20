//
//  ZHBProductAttrsInfoModel.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/29.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZHBBottonsValueModel;
@class ZHBBottonsModel;

#pragma mark - ZHBProductAttrsInfoModel
@interface ZHBProductAttrsInfoModel : NSObject

@property (nonatomic, copy) NSString *title; // eg.商品颜色,尺寸
@property (nonatomic, copy) NSString *type; // eg.color,size
@property (nonatomic, strong) NSMutableArray <ZHBBottonsValueModel *>*value;

@property (nonatomic, assign) BOOL isSelected;
@end

#pragma mark - ZHBBottonsValueModel
@interface ZHBBottonsValueModel : NSObject

@property (nonatomic, copy) NSString * fatherType;
@property (nonatomic, strong) NSArray <ZHBBottonsModel *>*bottons;
@property (nonatomic, copy) NSString *name; // name

@property (nonatomic, assign) BOOL isSelected; // 是否选中,决定是否高亮(展示属性)
@property (nonatomic, assign) BOOL isSpec; // 是否可选(展示属性) 是否有这种规格
@property (nonatomic, assign) BOOL isNoStock; // 是否有库存(展示属性)

@end

#pragma mark - ZHBBottonsModel

@interface ZHBBottonsModel : NSObject

@property (nonatomic, copy) NSString *bottonId;
@property (nonatomic, copy) NSString *isStock; //(库存)

@end
