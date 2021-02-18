//
//  WTools.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WTools.h"

@implementation WTools

//创建家谱
NSString * _Nonnull const kRequestCodecreategen = @"creategen";

//查询家谱列表
NSString * _Nonnull const kRequestCodequerygenlist = @"querygenlist";
//查询我的家谱
NSString * _Nonnull const kRequestCodequerymygen = @"querymygen";
//查询家谱详情
NSString * _Nonnull const kRequestCodequerygendeta = @"querygendeta";

#pragma mark *** 未测试接口 ***

//查询家谱字辈成员列表
NSString * _Nonnull const kRequestCodequeryzbgemelist = @"queryzbgemelist";
//查询家谱字辈成员详情
NSString * _Nonnull const kRequestCodequerygemedetailbyid = @"querygemedetailbyid";

//修改家谱
NSString * _Nonnull const kRequestCodeeditgen = @"editgen";
//修改家谱大数据字段
NSString * _Nonnull const kRequestCodeeditgenbigdata = @"editgenbigdata";
//申请加入家谱
NSString * _Nonnull const kRequestCodeapplyjoingen = @"applyjoingen";
//获取家谱字辈
NSString * _Nonnull const kRequestCodequerygeneration = @"querygeneration";
//添加家谱成员
NSString * _Nonnull const kRequestCodeaddgeme = @"addgeme";
//加入家谱
NSString * _Nonnull const kRequestCodejoingen = @"joingen";
//查询家谱树
NSString * _Nonnull const kRequestCodequerytreebygenid = @"querytreebygenid";
//查询待修改家谱成员详情
NSString * _Nonnull const kRequestCodequerygemedetailbyidforupdate = @"querygemedetailbyidforupdate";
//修改家谱成员详情
NSString * _Nonnull const kRequestCodeeditgemedetail = @"editgemedetail";

//查询所有成员列表
NSString * _Nonnull const kRequestCodequerygemelist = @"querygemelist";
//查询各字辈各成员详情列表
NSString * _Nonnull const kRequestCodequerygezblist = @"querygezblist";

//查询家谱字辈成员详情列表
NSString * _Nonnull const kRequestCodequeryzbgemedetaillist = @"queryzbgemedetaillist";

//进入家谱首页的接口
NSString * _Nonnull const kRequestCodegetintogen = @"getintogen";

//查询宗亲信息--只有接口没数据，传了参数就失败。
NSString * _Nonnull const kRequestCodequeryclan = @"queryclan";
//所有子数据
NSString * _Nonnull const kRequestCodegetgenalldata = @"getgenalldata";
/**上传家谱成员的头像*/
NSString * _Nonnull const kRequestCodeuploadgenimg = @"uploadgenimg";

//上传祖先头像
NSString * _Nonnull const kRequestCodeuploadgenan = @"uploadgenan";
//上传家谱图腾头像
NSString * _Nonnull const kRequestCodeuploadgentt = @"uploadgentt";
//上传家谱共享图片
NSString * _Nonnull const kRequestCodeuploadgensha = @"uploadgensha";
//上传家谱共享视频
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";


/** 编辑卷谱 */
NSString * _Nonnull const kRequestCodechangejp = @"changejp";
/** 卷谱列表 */
NSString * _Nonnull const kRequestCodequeryjplist = @"queryjplist";

/** 搜索家谱 */
NSString * _Nonnull const kRequestCodequerygenandgemelist = @"querygenandgemelist";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";
//NSString * _Nonnull const kRequestCode<#querymygen#> = @"<#querymygen#>";

//添加墓园
NSString * _Nonnull const kRequestCodecreatecemetery = @"createcemetery";
//编辑墓园
NSString * _Nonnull const kRequestCodeeditcemetery = @"editcemetery";
//墓园详情
NSString * _Nonnull const kRequestCodecemeterdetail = @"cemeterdetail";
//墓园列表
NSString * _Nonnull const kRequestCodecemeterylist = @"cemeterylist";
//排行-获取每日之星
NSString * _Nonnull const kRequestCodegetmyzxphb = @"getmyzxphb";

//商场
/** 商品列表 */
NSString * _Nonnull const kRequestCodegetcomlist = @"getcomlist";
/** 商品详情 */
NSString * _Nonnull const kRequestCodegetcomdetail = @"getcomdetail";
/** 获取购物车 */
NSString * _Nonnull const kRequestCodegetshopcar = @"getshopcar";
/** 添加购物车 */
NSString * _Nonnull const kRequestCodeaddshopcar = @"addshopcar";
/** 修改购物车 */
NSString * _Nonnull const kRequestCodeeditshopcar = @"editshopcar";
/** 删除购物车 */
NSString * _Nonnull const kRequestCodedelshopcar = @"delshopcar";
/** 获取收货地址列表 */
NSString * _Nonnull const kRequestCodegetrecaddlist = @"getrecaddlist";
/** 添加收货地址 */
NSString * _Nonnull const kRequestCodegetaddtrecadd = @"addrecadd";


/** 修改收货地址 */
NSString * _Nonnull const kRequestCodeeditrecadd = @"editrecadd";
/** 删除收货地址 */
NSString * _Nonnull const kRequestCodedelrecadd = @"delrecadd";
/** 确认订单信息 */
NSString * _Nonnull const kRequestCodegetconorder = @"getconorder";
/** 改变订单状态 */
NSString * _Nonnull const kRequestCodechangeshoporder = @"changeshoporder";
/** 获取订单详情 */
NSString * _Nonnull const kRequestCodegetshoporderdetail = @"getshoporderdetail";
/** 订单列表 */
NSString * _Nonnull const kRequestCodegetshoporderlist = @"getshoporderlist";
/** 生成订单 */
NSString * _Nonnull const kRequestCodecreateshoporder = @"createshoporder";
/** 支付结果 */
NSString * _Nonnull const kRequestCodepayresult = @"payresult";
/** 求签祈福消费 */
NSString * _Nonnull const kRequestCodeqiuqianqifupay = @"qiuqianqifupay";
/** 添加订单评价 */
NSString * _Nonnull const kRequestCodeevaluateadd = @"evaluateadd";
/** 查看订单评价 */
NSString * _Nonnull const kRequestCodegetevaluate = @"getevaluate";


//管理家谱通知字段

NSString * _Nonnull const kNotificationCodeManagerFam = @"managerFame";
NSString * _Nonnull const kNotificationCodeAddMember = 	@"kNotificationCodeAddMember";
NSString * _Nonnull const KNotificationCodeSeletedMyFamilItem = @"SeletedMyFamilItem";
NSString * _Nonnull const KNotificationCodeIntoFamSevice = @"IntoFamSevice";
NSString * _Nonnull const KNotificationCodeRankingPorChange = @"RankingPorChange";


//我的家谱名字和id，存储在本地
NSString * _Nonnull const kNSUserDefaultsMyFamilyID = @"UserDefaultsMyFamilyID";
NSString * _Nonnull const kNSUserDefaultsMyFamilyName = @"UserDefaultsMyFamilyName";
//商品详情需要的数据
NSString * _Nonnull const kNSUserDefaultsgoodsDetail = @"goodsDetail";

@end
