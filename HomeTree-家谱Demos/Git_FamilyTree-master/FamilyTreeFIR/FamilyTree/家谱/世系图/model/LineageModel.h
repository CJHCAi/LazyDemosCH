//
//  LineageModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LineageDatalistModel,LineageLevelInfoModel;
@interface LineageModel : NSObject

@property (nonatomic, strong) NSArray<LineageDatalistModel *> *datalist;

@property (nonatomic, strong) NSArray<LineageLevelInfoModel *> *levelinfo;

@end
@interface LineageDatalistModel : NSObject
/** 是否可再查询*/
@property (nonatomic, assign) BOOL hit;
/** 性别*/
@property (nonatomic, copy) NSString *sex;
/** 头像图片*/
@property (nonatomic, copy) NSString *head;
/** 家谱成员ID*/
@property (nonatomic, assign) NSInteger userid;
/** 父成员ID*/
@property (nonatomic, assign) NSInteger parentid;
/** 配偶信息关系表*/
@property (nonatomic, strong) NSArray *spouse;
/** 生日*/
@property (nonatomic, copy) NSString *birth;
/** 排序,表示此成员在本代中的排序位置*/
@property (nonatomic, assign) NSInteger seq;
/** 描述*/
@property (nonatomic, copy) NSString *descript;
/** 关系，表示此成员和查询成员的称呼关系*/
@property (nonatomic, copy) NSString *relation;
/** 姓名*/
@property (nonatomic, copy) NSString *username;
/** 层级，表示此成员为家谱中的第几代*/
@property (nonatomic, assign) NSInteger layers;
/** 有几个儿子*/
@property (nonatomic, assign) NSInteger haveSon;
@end

@interface LineageLevelInfoModel : NSObject
/** 承代数*/
@property (nonatomic, assign) NSInteger level;
/** 承代关系*/
@property (nonatomic, assign) NSInteger relation;

@end

