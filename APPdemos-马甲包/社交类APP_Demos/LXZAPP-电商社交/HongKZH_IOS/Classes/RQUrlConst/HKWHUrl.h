//
//  HKWHUrl.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#ifndef HKWHUrl_h
#define HKWHUrl_h

#define get_LeFriendsearch @"friend/search"
#define get_recommendFans  @"user/recommendFans"//推荐用户
#define get_mobile @"user/mobile"//通讯录信息
#define get_myseller @"sell/myseller"//我的售卖
#define get_myUpperProduct @"sell/myUpperProduct"//出售商品列表
#define get_myLowerProduct @"sell/myLowerProduct"//已下架商品列表
#define get_getLuckyBurstFriends @"shop/getLuckyBurstFriends"
#define get_getMediaProductById @"sell/getMediaProductById"//乐购-个人商品详情
#define get_deleteareafreight @"mediaShop/deleteareafreight"//删除子运费
#define  get_savefreight @"mediaShop/savefreight"//保存运费(增加和修改运费都使用这个)
#define get_freightList @"mediaShop/freightList"//运费列表
#define get_updateProductByImg @"mediaShop/updateProductByImg"//修改商品带图片的
#define get_deleteProductByImgId @"sell/deleteProductByImgId"//删除商品image
#define get_deleteSku @"sell/deleteSku"// 删除商品型号
#define get_deleteProduct @"sell/deleteProduct" //删除商品
#define get_myAllProduct @"sell/myAllProduct" //搜索商品列表
#define get_upperLowerProduct @"sell/upperLowerProduct" //商品上下架
#define get_sellerorderListByState @"sell/sellerorderListByState"//订单列表
#define get_sellerorderListHeader @"sell/sellerorderListHeader"//订单头部
#define get_sellerorderListByState @"sell/sellerorderListByState"//订单列表
#define get_mysellAfterSale  @"sell/mysellAfterSale"//售后列表
#define get_sellerorderList @"sell/sellerorderList"//搜索订单
#define get_expresList @"sell/expresList"//快递公司
#define get_sellerOrderDeliver @"sell/sellerOrderDeliver"//发货
#define get_sellerupdateorderprice @"sell/sellerupdateorderprice"//修改订单价格

#define get_sellerupdatecloseorder @"sell/sellerupdatecloseorder"

#define get_orderAfterSale @"sell/orderAfterSale"
#define get_getUserReturnAddressList @"sell/getUserReturnAddressList"//退货地址
#define get_addUserReturnAddress @"sell/addUserReturnAddress"//增加修改退货地址
#define  get_agreeReturnGoods @"sell/agreeReturnGoods"//同意退货
#define get_sellerApprovalOrder @"sell/sellerApprovalOrder"
#define get_sellerRefuseOrder @"sell/sellerRefuseOrder"//拒绝退款带图片
#define get_getCategorySearchAdvList @"mediaAdv/getCategorySearchAdvList"
#define get_getMainAllCategoryList @"mediaAdv/getMainAllCategoryList"
#define get_refuseReturnGoods @"sell/refuseReturnGoods"//决绝退货
#define get_sellerRefuseOrderNotImg @"sell/sellerRefuseOrderNotImg"//拒绝退款不带图片
#define get_sellerProof @"sell/sellerProof"//商家举证
#define get_myPosts @"user/myPosts"//我的帖子列表
#define get_myRepliesPosts @"user/myRepliesPosts"//回帖列表
#define get_myDelPosts @"user/myDelPosts"//帖子回收站
#define get_friendDeletePost @"friend/deletePost"//帖子删除
#define get_myPraisePost @"user/myPraisePost"//我的点赞
#define get_praisePost @"friend/praisePost"
#define get_myForwardPost @"user/myForwardPost"//我的转发通知
#define get_myData @"user/myData"//乐i首页接口
#define get_getCirclePost @"friend/getCirclePost"
#define  get_getAdvCommentsByCommentId @"adv/getAdvCommentsByCommentId"
#define  get_getCityAdvMediaInfo @"cityAdv/getCityAdvMediaInfo"

#define get_getMainList @"shop/getMainList"
#define get_deleteCartByid @"mediaShop/deleteCartByid"//删除购物车
#define get_getMyCouponsByProductId @"shop/getMyCouponsByProductId" //乐购-我的-商品-优惠券列表
#define get_getProductSkuBySku @"shop/getProductSkuBySku"
#define get_getLuckyBurst @"shop/getLuckyBurst" //获取爆款活动类型 

#define get_getLuckyBurstList @"shop/getLuckyBurstList"

#define get_buyLuckyBurst @"shop/buyLuckyBurst"//乐购-购买爆款优惠券
#define get_getLuckyBurstByAdv @"shop/getLuckyBurstByAdv"//乐购-爆款优惠-看视频获取能量
#define get_getLuckyBurstByFriend @"shop/getLuckyBurstByFriend"//乐购-爆款优惠-好友点赞获取能量
#define get_luckyBurstDetail @"shop/luckyBurstDetail"
#define get_shopSearchProductHistory @"shop/shopSearchProductHistory"
#define get_searchHistory @"mediaAdv/searchHistory"
#define get_searchProduct @"shop/searchProduct"
#define get_releaseConfig @"release/releaseConfig"
#define get_searchProductList @"shop/searchProductList"//乐购-搜索-商品列表
#define get_searchMedias @"mediaAdv/searchMedia"
#define get_searchProductList @"shop/searchProductList"//乐购-搜索-商品列表
#define get_getEnterpriseListByCategory @"enterpriseAdv/getEnterpriseListByCategory"//获取企业广告分类数据
#define get_searchMediaList @"mediaAdv/searchMediaList"
#define get_myDataMarket @"game/myData"
#define get_myNormalCoupon @"game/myNormalCoupon"
#define get_gameMyProduct @"game/myProduct"

#define get_getRedPacketsMediaAdvById @"mediaAdv/getRedPacketsMediaAdvById"
#define get_endPlayMediaAdvById @"mediaAdv/endPlayMediaAdvById"
#define get_endPlayEnterpriseAdvById @"enterpriseAdv/endPlayEnterpriseAdvById"
#define get_shopEmptySearchHistory @"shop/emptySearchHistory"//清空乐购搜索历史
#define get_mediaAdvEmptySearchHistory @"mediaAdv/emptySearchHistory"
#define get_bottomProductList @"shop/bottomProductList"
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define KReleaseConfig [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"releaseConfig.data"]
#define KExpresListData [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"expresListData.data"]

#define KCityListData [PATH_OF_DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"cityListData.data%@.data",APP_Version]]
#define KCountryListData [PATH_OF_DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"CountryListData%@.data",APP_Version]]
#define KHKUserCategoryListRespone [PATH_OF_DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"HKUserCategoryListRespone%@.data",APP_Version]]
#define KinitDataPath  [PATH_OF_DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"APPData_V%@.data",APP_Version]]
#define KinitShopDataPath  [PATH_OF_DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"APPShopData_V%@.data",APP_Version]]
#define VersionAuditStaue @"VersionAuditStaue"
#define kNotificationNavLoadData @"NotificationNavLoadData"
#endif /* HKWHUrl_h */
