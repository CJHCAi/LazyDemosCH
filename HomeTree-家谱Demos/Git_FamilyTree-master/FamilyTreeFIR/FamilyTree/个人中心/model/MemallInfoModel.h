//
//  MemallInfoModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MemallInfoGrysModel,MemallInfoGrqwModel,MemallInfoGrxcModel,MemallInfoScbzModel,MemallInfoJzdtModel,MemallInfoHyjpModel;
@interface MemallInfoModel : NSObject
/** 个人签运模型*/
@property (nonatomic, strong) MemallInfoGrqwModel *grqw;
/** 生辰八字模型*/
@property (nonatomic, strong) MemallInfoScbzModel *scbz;
/** 个人相册数组*/
@property (nonatomic, strong) NSArray<MemallInfoGrxcModel *> *grxc;
/** 个人运势数组*/
@property (nonatomic, strong) MemallInfoGrysModel *grys;
/** 家族动态数组*/
@property (nonatomic, strong) NSArray<MemallInfoJzdtModel *> *jzdt;
/** 会员家谱数组*/
@property (nonatomic, strong) NSArray<MemallInfoHyjpModel *> *hyjp;


@end

@interface MemallInfoGrysModel : NSObject
/** 健康指数*/
@property (nonatomic, copy) NSString *health;
/** 幸运色*/
@property (nonatomic, copy) NSString *color;
/** 财富指数*/
@property (nonatomic, copy) NSString *money;
/** 时间*/
@property (nonatomic, copy) NSString *datetime;
/** 幸运数字*/
@property (nonatomic, assign) NSInteger number;
/** 速配星座*/
@property (nonatomic, copy) NSString *qfeiend;
/** 总结*/
@property (nonatomic, copy) NSString *summary;
/** 工作指数*/
@property (nonatomic, copy) NSString *work;
/** 综合指数*/
@property (nonatomic, copy) NSString *all;
/** 运程星座*/
@property (nonatomic, copy) NSString *name;
/** 爱情指数*/
@property (nonatomic, copy) NSString *love;

@end

@interface MemallInfoGrqwModel : NSObject
/** 签文好坏*/
@property (nonatomic, copy) NSString *qwhh;
/** 求签签号*/
@property (nonatomic, assign) NSInteger qh;

@end

@interface MemallInfoGrxcModel : NSObject
/** 个人相册ID*/
@property (nonatomic, assign) NSInteger imgid;
/** 个人相册图片路径*/
@property (nonatomic, copy) NSString *imgurl;

@end


@interface MemallInfoScbzModel : NSObject
/** 五行*/
@property (nonatomic, copy) NSString *wx;
/** 生辰*/
@property (nonatomic, copy) NSString *scbz;
/** 五行数*/
@property (nonatomic, copy) NSString *wxnum;

@end

@interface MemallInfoJzdtModel : NSObject
/** 家族动态标题id*/
@property (nonatomic, copy) NSString *arid;
/** 标题*/
@property (nonatomic, copy) NSString *artitle;

@end

@interface MemallInfoHyjpModel : NSObject

/** 家谱名*/
@property (nonatomic, copy) NSString *jpname;
/** 姓名*/
@property (nonatomic, copy) NSString *jphyname;
/** 第几代*/
@property (nonatomic, assign) NSInteger jpdai;
/** 字辈*/
@property (nonatomic, copy) NSString *jpzb;
/** 家中排行*/
@property (nonatomic, assign) NSInteger jpph;
/** 头像路径地址*/
@property (nonatomic, copy) NSString *imgpath;

@end


@interface DevoutModel : NSObject
/** 月虔诚度*/
@property (nonatomic, assign) NSInteger qcdy;
/** 总虔诚度*/
@property (nonatomic, assign) NSInteger qcdz;
/** 虔诚等级*/
@property (nonatomic, copy) NSString *qcdch;
@end
