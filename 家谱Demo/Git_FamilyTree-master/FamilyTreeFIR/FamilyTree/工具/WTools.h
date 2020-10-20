//
//  WTools.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateFamModel.h"
#import "WIDModel.h"
#import "NSArray+WAllItemString.h"
#import "WFamilyModel.h"
#import "WDetailJPInfoModel.h"
#import "WJPPersonZBNumberModel.h"
#import "WJPListModel.h"
#import "WSearchModel.h"
#import "WpersonInfoModel.h"
#import "WShopCommonModel.h"
#import "WShopCartView.h"
#import "GoodsDetailsViewController.h"
#import "WGoodsDetailModel.h"
#import "MyOrdersViewController.h"
#import "BookingBtn.h"
#import "ShoppingFirestViewController.h"
@interface WTools : NSObject

UIKIT_EXTERN NSString * _Nonnull const kRequestCodecreategen;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygenlist;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerymygen;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygendeta;

UIKIT_EXTERN NSString * _Nonnull const kRequestCodeuploadgenan;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeuploadgentt;

//家谱
//查询家谱字辈成员列表
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequeryzbgemelist;
//查询家谱字辈成员详情
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygemedetailbyid;
//修改家谱
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeeditgen;
//修改家谱大数据字段
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeeditgenbigdata;
//申请加入家谱
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeapplyjoingen;
//获取家谱字辈
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygeneration;
//添加家谱成员
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeaddgeme;
//加入家谱
UIKIT_EXTERN NSString * _Nonnull const kRequestCodejoingen;
//查询家谱树
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerytreebygenid;
//查询待修改家谱成员详情
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygemedetailbyidforupdate;
//修改家谱成员详情
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeeditgemedetail;
//查询家谱所有成员
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygemelist;
//查询各字辈各成员详情列表
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygezblist;
//查询家谱字辈成员详情列表
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequeryzbgemedetaillist;
//进入家谱首页的接口
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetintogen;

//查询宗亲信息
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequeryclan;
//墓园
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeeditcemetery;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodecemeterdetail;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodecemeterylist;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodecreatecemetery;

//通知字段
UIKIT_EXTERN NSString * _Nonnull const kNotificationCodeManagerFam;

UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetgenalldata;
 /**上传家谱成员的头像*/
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeuploadgenimg;
//上传家谱共享图片
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeuploadgensha;
/** 编辑卷谱 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodechangejp;
/** 卷谱列表 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequeryjplist;

/** 搜索家谱 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodequerygenandgemelist;
//排行-获取每日之星
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetmyzxphb;


//商场
/** 商品列表 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetcomlist;
/** 商品详情 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetcomdetail;
/** 获取购物车 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetshopcar;
/** 添加购物车 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeaddshopcar;
/** 修改购物车 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeeditshopcar;
/** 删除购物车 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodedelshopcar;
/** 获取收货地址列表 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetrecaddlist;
/** 添加收货地址 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetaddtrecadd;

/** 修改收货地址 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeeditrecadd;
/** 删除收货地址 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodedelrecadd;
/** 确认订单信息 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetconorder;
/** 改变订单状态 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodechangeshoporder;
/** 获取订单详情 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetshoporderdetail;
/** 订单列表 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetshoporderlist;
/** 生成订单 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodecreateshoporder;
/** 支付结果 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodepayresult;
/** 求签祈福消费 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeqiuqianqifupay;
/** 添加订单评价 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeevaluateadd;
/** 查看订单评价 */
UIKIT_EXTERN NSString * _Nonnull const kRequestCodegetevaluate;

//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;
//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;
//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;
//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;
//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;
//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;
//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;
//UIKIT_EXTERN NSString * _Nonnull const kRequestCode<#uploadgentt#>;

UIKIT_EXTERN NSString * _Nonnull const kNotificationCodeAddMember;
UIKIT_EXTERN NSString * _Nonnull const KNotificationCodeSeletedMyFamilItem;
UIKIT_EXTERN NSString * _Nonnull const KNotificationCodeIntoFamSevice;

UIKIT_EXTERN NSString * _Nonnull const KNotificationCodeRankingPorChange;

UIKIT_EXTERN NSString * _Nonnull const kNSUserDefaultsMyFamilyID;
UIKIT_EXTERN NSString * _Nonnull const kNSUserDefaultsMyFamilyName;

UIKIT_EXTERN NSString * _Nonnull const kNSUserDefaultsgoodsDetail;

@end
