//
//  UrlConst.h
//  XiYou_IOS
//
//  Created by reganan on 16/1/23.
//  Copyright © 2016年 reganan. All rights reserved.
//

#ifndef UrlConst_h
#define UrlConst_h

#if Urldebug
    #define Host @"https://cs.api.hongkzh.com/v1/"
#define host_share @"http://47.95.5.235:8084/"
    //#define Host @"http://192.168.100.104:8083/v1/"
//#define Host  @"https://192.168.200.38:8083/v1/"
 //#define Host @"https://api.hongkzh.cn/v1/"
#else
     #define host_share @"https://h5.hongkzh.cn/v1/"
      #define Host @"https://api.hongkzh.cn/v1/"
//#define Host @"http://47.95.5.235:8084/"
#endif
#import "HKWHUrl.h"

//
#define host_imgText @"http://test2.img.hongkzh.com"
/*!
 *  brand
 */
#define get_selfMedia @"app/login"
/*!
 *  brand
 */
#define get_enterpriseCarouselList @"enterpriseAdv/getEnterpriseCarouselList"

#define get_enterpriseCategoryList @"enterpriseAdv/getEnterpriseCategoryList"

#define get_enterpriseHotAdvTypeList @"enterpriseAdv/getEnterpriseHotAdvTypeList"

#define get_enterpriseHotAdvList @"enterpriseAdv/getEnterpriseHotAdvList"

#define get_carouselList @"adv/getCarouselList"

#define get_recommendList @"adv/getRecommendList"

#define get_hotAdvList @"adv/getHotAdvList"

#define get_enterpriseAdvById @"enterpriseAdv/getEnterpriseAdvById"

#define get_allAlbumByUserId @"user/getAllAlbumByUserId"

#define get_allProductByUserId @"user/getAllProductByUserId"

#define get_praise @"enterpriseAdv/praise"

#define get_collection @"enterpriseAdv/collection"

#define get_mainCarouselList @"mediaAdv/getMainCarouselList"

#define get_mainHotAdvList @"mediaAdv/getMainHotAdvList"

#define get_mainAllCategoryList @"mediaAdv/getMainAllCategoryList"

#define get_mainTop10List @"mediaAdv/getMainTop10List"

#define get_ainNearbyAdvList @"mediaAdv/getMainNearbyAdvList"

#define get_categoryCarouselList @"mediaAdv/getCategoryCarouselList"

#define get_categoryTop10List @"mediaAdv/getCategoryTop10List"

#define get_categoryHotAdvList @"mediaAdv/getCategoryHotAdvList"

#define get_categoryNearbyAdvList @"mediaAdv/getCategoryNearbyAdvList"

#define get_categoryCirclesList @"mediaAdv/getCategoryCirclesList"

#define get_mediaAdvAdvById @"mediaAdv/getMediaAdvAdvById"


#define get_mediaAdvpraise @"mediaAdv/praise"

#define get_mediaAdvcollection @"mediaAdv/collection"

#define get_mainList @"shop/getMainList"
 //乐购-->推荐
#define get_categoryList @"shop/getCategoryList" //乐购-一级分类

#define get_subCategoryList @"shop/getSubCategoryList"//乐购-子分类商品
//乐购-->新品
#define get_newMainList @"shop/getNewMainList"//乐购-新品主页

#define get_newProductList @"shop/getNewProductList" //乐购-本期新品

#define get_categoryProductList @"shop/getCategoryProductList"

#define get_luckyBurstALLList @"shop/getLuckyBurstALLList" //乐购爆款商品列表

#define get_shopGetLuckyBurstById @"shop/getLuckyBurstById" //乐购爆款商品详情

#define get_seckillALLList @"shop/getSeckillALLList"// 乐购秒杀列表

#define get_shopGetSeckillById @"shop/getSeckillById" //乐购秒杀详情

#define get_shopGetProductDiscountsById @"shop/getProductDiscountsById" //乐购折扣商品详情

#define get_discountsList @"shop/getDiscountsList" //乐购 折扣商品列表

#define get_productById @"shop/getProductById" //乐购商品详情

#define get_productCommentById @"shop/getProductCommentById" //乐购评价列表

#define get_login @"user/login"


#define get_friendList @"friend/friendList"

#define get_circleList @"friend/circleList"

#define get_forwardPost @"friend/forwardPost"

#define get_friendDynamic @"friend/getFriendDynamic"

#define get_groupInfo @"friend/getGroupInfo"

#define get_joinGroup @"friend/joinGroup"

#define get_frindQuitGroup @"friend/quitGroup" //退出圈子

#define get_dissMissGroup @"friend/dismissGroup"//解散圈子

#define get_userCategoryList @"mediaAdv/getUserCategoryList"
//获取自媒体用户信息....
#define get_userInfo @"mediaAdv/getUserInfo"
//个人中心 获取自媒体视频列表
#define get_FuserMediasList @"mediaAdv/getUserMediasList"
//个人中心 通过ID获取商品列表
#define get_FuserProductsList @"mediaAdv/getUserProductsList"

#define get_infoMediaAdvCommentList @"adv/getInfoMediaAdvCommentList"

#define get_addUserCategory @"mediaAdv/addUserCategory"

#define get_chinaList @"adv/getChinaList"

#define get_countryStateList @"adv/getCountryStateList"

#define get_categoryQuery @"mediaAdv/getCategoryQuery"

#define get_categoryQueryList @"mediaAdv/getCategoryQueryList"

#define get_Main @"cityAdv/getMain"

#define get_CityAdvList @"cityAdv/getCityAdvList"

#define get_cityNearbyAdvList @"cityAdv/getCityNearbyAdvList"

#define get_cityInfoById @"cityAdv/getCityInfoById"

#define get_categoryCityAdvList @"cityAdv/getCategoryCityAdvList"

#define get_allHots @"cityAdv/getAllHots"

#define get_cityAdvInfo @"cityAdv/getCityAdvInfo"

#define get_cityAdvPraise @"cityAdv/praise"

#define get_cityAdvcollection @"cityAdv/collection"

#define get_circleCategory @"friend/circleCategory"

#define get_circleCategoryList @"friend/circleCategoryList"

#define get_userDeliveryAddressList @"shop/getUserDeliveryAddressList"//获取用户收货地址

#define get_addUserDeliveryAddress @"shop/addUserDeliveryAddress"

#define get_recruitCategoryCarouselList @"recruit/getCategoryCarouselList"

#define get_EnterpriseRecruitList @"recruit/getEnterpriseRecruitList"

#define get_RecruitCategoryCirclesList @"recruit/getCategoryCirclesList"

#define get_baseData @"init/data"


/**
 初始化电商数据

 @return nil
 */
#define get_shopData @"init/shopData"

#define get_recruitSearchHistory @"recruit/recruitSearchHistory"

#define get_searchRecruit @"recruit/searchRecruit"

#define get_recruitInfo @"recruit/getRecruitInfo"

#define get_createGroup @"friend/createGroup"

#define get_groupMemberInfo @"friend/getGroupMemberInfo"

#define get_kickOutGroup @"friend/kickOutGroup"

#define get_updateGroupIntroduction @"friend/updateGroupIntroduction"

#define get_buyBooth @"friend/buyBooth"

#define get_productList @"friend/getProductList"

#define get_addCircleProduct @"friend/addCircleProduct"

#define get_saveCityAdv @"cityAdv/saveCityAdv"


#define get_enterpriseRecruitListById @"recruit/getEnterpriseRecruitListById"

#define get_infoMediaAdvCommentReplyList @"adv/getInfoMediaAdvCommentReplyList"

#define get_savePost @"friend/savePost"

#define get_savePostPhoto @"friend/savePostPhoto"

#define get_comment @"adv/comment"

#define get_praiseMediaAdvComment @"adv/praiseMediaAdvComment"

#define get_cityReward @"cityAdv/reward" //城市打赏

#define get_weMediaReward @"adv/reward" //自媒体打赏

//招聘相关
#define get_choiceRecruit @"recruit/choiceRecruit"  //选择发布
#define get_UpdateAuthenticationEnterpriseInfo @"recruit/updateAuthenticationEnterpriseInfo"    //企业认证
//#define get_EnterpriseRecruitListById   @"recruit/getEnterpriseRecruitListById" //职位企业信息
#define get_RecruitEnterpriseInfo @"recruit/getRecruitEnterpriseInfo"   //获得企业信息
#define get_RecruitPosition @"recruit/getRecruitPosition"   //获得发布的职位
#define get_updateEnterpriseInfo @"recruit/updateEnterpriseInfo"   //保存企业详细信息
#define get_updateRecruitPositionDetailInfo @"recruit/updateRecruitPositionDetailInfo"      //保存企业职位详细信息

//个人简历
#define get_UserEducational @"recruit/getUserEducational"   //教育经历列表
#define get_UserExperience @"recruit/getUserExperience" //获得个人工作经历列表
#define get_recruitUserInfo @"recruit/getUserInfo"  //获取个人信息
#define get_updateUserBaseInfo @"recruit/updateUserBaseInfo"    //修改个人基本信息
#define get_updateCareerIntentions  @"recruit/updateCareerIntentions"   //修改职业意向
#define get_updateUserEducational @"recruit/updateUserEducational"      //修改教育经历
#define get_deleteUserEducational @"recruit/deleteUserEducational"  //删除个人教育经历
#define get_updateUserExperience   @"recruit/updateUserExperience"  //修改个人工作经历
#define get_deleteUserExperience @"recruit/deleteUserExperience"    //删除个人工作经历
#define get_updateUserContent @"recruit/updateUserContent"      //修改自我描述
#define get_updateUserPortrait @"recruit/updateUserPortrait"   //修改个人简历头像

//视频标签
#define get_getAllTags    @"adv/getAllTags"
#define get_searchTags   @"adv/searchTags"
#define get_userHistoryList @"user/historyList" //用户历史观看记录
#define get_userHistoryAdd  @"user/historyAdd" //增加用户观看历史记录
#define get_userHistoryDelete @"user/historyDelete"//删除用户历史记录

//视频发布
#define get_UserProductList @"friend/getProductList"    //我的商品
#define get_buyBooth_releaseVideo   @"mediaAdv/buyBooth"    //购买展位
#define get_releasePublic @"release/releasePublic"  //发布公共模块
#define get_releaseRecruit @"release/releaseRecruit"    //发布招聘
#define get_releaseResume   @"release/releaseResume"    //发布简历
#define get_releasePhotography @"release/releasePhotography"    //发布摄影
#define get_releaseMarry @"release/releaseMarry"    //发布征婚交友
#define get_updateUserData @"recruit/updateUserData"  //修改个人资料

#define get_saveProductDetailImg @"mediaShop/saveProductDetailImg"  //添加商品详情-上传图片

#define get_saveProduct @"mediaShop/saveProduct"  //添加商品

#define get_mediaShopAddCart @"mediaShop/addCart" //加入购物车

#define get_mediaShopCartCount @"mediaShop/cartCount" //购物车数量

#define get_mediaShopCartIsStroage @"mediaShop/cartIsStorage" //购物车是否加入储物箱

#define get_cartList @"mediaShop/cartList"  //购物车列表

#define get_mediaShopChangeAddress  @"mediaShop/changeAddress" //更改购物车地址

#define get_preorder @"mediaShop/preorder"  //预下单
#define get_saveOrder_mediaShop @"mediaShop/saveOrder"  //结算下单
#define get_payOrder_mediaShop @"mediaShop/payOrder"  //支付订单
#define get_cartIsStorage_mediaShop @"mediaShop/cartIsStorage"  //加入储物箱

#define get_userOrderList_mediaShop @"mediaShop/userOrderList"  //订单列表
#define get_userOrderInfo  @"mediaShop/userOrderInfo"  //订单详情

#define get_userOrderRefund @"mediaShop/userOrderRefund" //申请退款

#define get_userOrderRefundAfter @"mediaShop/userOrderRefundAfter" //申请售后

#define get_userOrderComplaint @"mediaShop/userOrderComplaint"//买家投诉

#define get_mediaShopbuyerProof @"mediaShop/buyerProof" //买家举证

#define get_logisticsInformation @"mediaShop/logisticsInformation"//获取订单物流信息

#define get_confirmCollectGoods @"mediaShop/confirmCollectGoods" //确认收货

#define  get_mediaShopcanceluserOrder @"mediaShop/canceluserOrder" //取消订单

#define get_mediaShopDeleteuserOrder @"mediaShop/deleteuserOrder" //删除订单

#define get_deleteUserDeliveryAddress @"shop/deleteUserDeliveryAddress" //删除收货地址

#define get_mediaShopMyAfterSale  @"mediaShop/myAfterSale" //买家 我的售后退款

#define get_mediaShopcanceluserOrderComplaint @"mediaShop/canceluserOrderComplaint"//买家取消订单投诉

#define get_mediaShopcanceluserOrderRefundAndGoods @"mediaShop/canceluserOrderRefundAndGoods"//买家取消退货退款
#define get_mediaShopcanceluserOrderRefund  @"mediaShop/canceluserOrderRefund"//取消退款

#define get_mediaShopreturnLogistics  @"mediaShop/returnLogistics"//买家填写退货物流

//个人信息相关
#define get_MyVideo @"user/myVideo" //我的视频
#define get_myVideoCategory @"user/myVideoCategory" //我的视频分类
#define get_myTravels    @"user/myTravels"   //我的游记
#define get_myCollection @"user/myCollection"   //我的收藏
#define get_myCollectionCategory    @"user/myCollectionCategory"    //我的收藏分类
#define get_myPraise    @"user/myPraise"        //我的点赞
#define get_myPraiseCategory    @"user/myPraiseCategory"    //我的点赞分类

#define get_myFollows @"user/myFollows" //我关注的人
#define get_myFollowsEnterprise @"user/myFollowsEnterprise" //我关注的企业
#define get_myFans @"user/myFans"   //我的粉丝
#define get_followAdd @"user/followAdd"     //通过用户id关注
#define get_followDelete @"user/followDelete" //取消关注


//**************  我的应聘  *******************//

#define get_myApply @"user/myApply"     //我的应聘
#define get_editResume @"user/editResume"     //编辑简历
#define get_updateReleaseResume  @"release/updateReleaseResume" //发布简历 没有文件上传的
#define get_deleteResumeImg @"release/deleteResumeImg" //删除简历附件
#define get_myResumePreview    @"user/myResumePreview"     //我的简历预览
#define get_myDelivery @"user/myDelivery"   //我的投递
#define get_recruitDeliveryRecruitInfo @"recruit/deliveryRecruitInfo" //投递简历

#define get_HKrecruitDdeleteSearchHistory @"recruit/deleteSearchHistory" //删除历史记录
#define get_HKrecruitemptySearchHistory @"recruit/emptySearchHistory" //清空搜索历史
#define get_userGetUserResumeList @"user/getUserResumeList" //人才搜索列表

//屏蔽公司
#define get_shieldCompany @"recruit/getShieldCompany" //获取用户屏蔽公司列表
#define get_addShieldCompany @"recruit/addShieldCompany"    //用户屏蔽公司增加
#define get_deleteShieldCompany    @"recruit/deleteShieldCompany"   //用户屏蔽公司删除

#define get_myRecruit @"user/myRecruit" //企业招聘

#define get_myRecruitRecommend @"user/myRecruitRecommend" //企业招聘-推荐

#define get_editRecruitment @"user/editRecruitment" //编辑招聘
#define get_updateReleaseRecruit @"release/updateReleaseRecruit" //编辑招聘 没有文件

#define get_RecruitByUserId @"user/getRecruitByUserId" //职位上线列表
#define get_RecruitDownByUserId @"user/getRecruitDownByUserId" //职位下线列表

#define get_updateRecruitById @"user/updateRecruitById"       //职位刷新
#define get_upRecruitById    @"user/upRecruitById"   //职位上线
#define get_deleteRecruitById @"user/deleteRecruitById"    //职位删除
#define get_downRecruitById @"user/downRecruitById"    //职位下线
//圈子相关
#define get_friendSearchfriendList @"friend/searchfriendList" //搜索好友

#define get_friendUpdateGroupRemind @"friend/updateGroupRemind" //修改圈子提醒

#define  get_cityAdvSaveCityAdv  @"cityAdv/saveCityAdv"  //写游记


#define get_myCandidate @"user/myCandidate" //候选人列表
#define get_usermyTalentCollection @"user/myTalentCollection"//人才收藏列表

//注册相关
#define get_usePresendMessage @"user/presendMessage" //预发短信 获得一个和推送相关的ID
#define get_userSendregistermessage @"user/sendregistermessage"//获取验证码
#define get_userRegister  @"user/register" //进行注册
#define get_sendloginmessage @"user/sendloginmessage"
//登录相关
#define get_userLoginQQ @"user/qqlogin" //QQ登录
#define get_userweixinlogin @"user/weixinlogin" //微信登录
#define get_userSendforgetmessage @"user/sendforgetmessage" //忘记密码
#define get_userSendloginmessage @"user/sendloginmessage" //手机号登录短信
#define get_userSetForgetCode @"user/setForgetCode" //设置忘记密码

//钱包相关
#define get_userMyWallet  @"user/myWallet" //我的钱包
#define get_userMyWalletLog  @"user/myWalletLog" //我的钱包明细
#define get_userMyWalletLogDetails @"user/myWalletLogDetails"//我的钱包明细详情

#define get_usergetUserIntegral @"user/getUserIntegral" //获取用户最新乐币数量

#define get_sellerorderListByTransaction @"sell/sellerorderListByTransaction"//资产交易中
#define get_sellerorderListBySettlement @"sell/sellerorderListBySettlement"//资产结算中
#define get_UserMyIncome  @"user/myIncome" //我的收入报表
#define get_sellSellerorderFlow  @"sell/sellerorderFlow" //我的订单流水

#define get_resumeCollection @"user/resumeCollection"   //简历收藏
#define get_notGoodResume @"user/notGoodResume" //简历不符

#define get_searchcircleList @"friend/searchcircleList" //搜索圈子

#define get_userqqbind  @"user/qqbind" //绑定QQ
#define get_userweixinbind @"user/weixinbind" //绑定微信

#define get_phoneLgin @"user/login" //手机密码登录
#define get_loginByCode @"user/loginByCode"  //手机号验证码登录
#define get_userSetFirstInfo @"user/setFirstInfo" //完善用户信息第一步
#define get_userSetSecondInfo @"user/setSecondInfo" //完善用户信息第二步
#define get_userGetUserLabel @"user/getUserLabel" //获取用户标签
#define get_userSaveUserLabel @"user/saveUserLabel"//保存用户标签
#define get_mediaAdv_getMainAllCategoryList @"mediaAdv/getMainAllCategoryList" //获取自媒体所有分类
#define get_mediaAdvAddUserCategory  @"mediaAdv/addUserCategory"  //增加用户自媒体分类
#define get_mediaShopUpdateCart  @"mediaShop/updateCart" //修改某购物车下商品的数量
#define get_userUpdateMobile @"user/updateMobile" //修改手机号
#define get_userUpdateregistermessage @"user/updateregistermessage" //修改手机号短息
#define get_userGetUserInfoById @"user/getUserInfoById" //通过用户ID获取账户信息
#define get_userSetUserMobile @"user/setUserMobile" //设置手机号

#define get_friendAddBlack @"friend/addBlack"  //增加黑名单
#define get_friendRemoveBlack  @"friend/removeBlack" //删除黑名单
#define get_friendBlackList @"friend/blackList" //黑名单列表

#define get_userIsShop  @"user/isShop" //是否申请过商家
#define get_userApplyShop @"user/applyShop" //申请商家
#define get_userIsRealName  @"user/isRealName" //是否实名认证
#define get_userApplyRealName  @"user/applyRealName" //申请实名认证
#define get_userFeedback @"user/feedback" //意见反馈

/********** 拼团 ***********/
#define get_shopGetCollageList @"shop/getCollageList" //获取拼团列表
#define shop_getCollageByCouponId @"shop/getCollageByCouponId"//获取拼团详情
#define get_shopBuyCollageByCouponId @"shop/buyCollageByCouponId"//购买拼团优惠券
#define get_shopBuyCollageByOrderId @"shop/buyCollageByOrderId"//拼团
#define get_shopgetCouponsByProductId @"shop/getCouponsByProductId"//乐购 优惠券列表
#define get_shopGetCollageByOrderNumber @"shop/getCollageByOrderNumber"//获取拼团订单详情

/***********优惠券 ***********/
#define get_usermyCoupon  @"user/myCoupon" //我的优惠券
#define get_usermyQualificationCoupon @"user/myQualificationCoupon" //我的新人专享优惠券
#define get_userdeleteCoupon @"user/deleteCoupon" //删除优惠券
#define get_shopGgetCouponByCouponId @"shop/getCouponByCouponId"//优惠券详情
#define get_DiscountsList @"shop/getDiscountsList" //获取折扣列表

/******** 新人专享****************/
#define get_shopGetNewUserVip @"shop/getNewUserVip"  //获取新人专享主页顶部数据
#define shop_GetNewUserVipList @"shop/getNewUserVipList" //获取新人专享类型下列表数据
#define get_shopGetNewUserVipCouponByCouponId @"shop/getNewUserVipCouponByCouponId" //新人专享优惠券详情
#define get_shopBuyNewUserVipCoupon @"shop/buyNewUserVipCoupon"//购买新人专享优惠券

/****** 自媒体分类********/
#define mediaAdvGetMediaTop10List @"mediaAdv/getMediaTop10List" //自媒体top10
#define mediaAdvGetMediaCirclesList @"mediaAdv/getMediaCirclesList" //自媒体圈子
#define mediaAdvGetMediaHotAdvList @"mediaAdv/getMediaHotAdvList" //自媒体人气
#define mediaAdvGgetMediaNearbyAdvList @"mediaAdv/getMediaNearbyAdvList"//自媒体分页
/***********店铺 ***********/
#define get_shopGetShopById @"shop/getShopById" //店铺主页
#define get_shopGetShopRemProduct @"shop/getShopRemProduct" //乐购店铺推荐商品
#define get_shopCollectShopById @"shop/collectShopById"//收藏店铺
#define get_shopGetShopProduct @"shop/getShopProduct"//商品页
#define get_shopGetShopProductByOrder @"shop/getShopProductByOrder" //热销页
#define get_shopGetShopProductByCreate @"shop/getShopProductByCreate"//上新页
#define get_shopGetShopInfo @"shop/getShopInfo" //店铺信息.

/******** 乐友圈子接口 **********/
#define get_UpdateGroupCoverImgSrc @"friend/updateGroupCoverImgSrc" //修改圈子封面
#define get_UpdateGroupCategory @"friend/updateGroupCategory" //修改圈子频道
#define get_UpdateGroupIntroduction @"friend/updateGroupIntroduction" //修改圈子简介
#define get_UpdateGroupName @"friend/updateGroupName" //修改圈子名称
#define get_UpdateGroupUpperLlimit @"friend/updateGroupUpperLlimit"//修改圈子上限
#define get_UpupdateGroupValidate @"friend/updateGroupValidate" //修改圈子验证方式
#define get_KickOutGroup  @"friend/kickOutGroup" //踢出圈子
#define get_FriendSavePost @"friend/savePost" //发布帖子
#define get_CityAdvSaveCityAdv @"cityAdv/saveCityAdv"//发布游记
#define get_CityAdvSaveCityAdvPhoto @"cityAdv/saveCityAdvPhoto"//上传游记图片

#define get_FriendsavePostPhoto @"friend/savePostPhoto" //发帖子图片
#define get_userSelectUserIntegral @"user/selectUserIntegral"//我的收益
#define get_friendAddFriend @"friend/addFriend"//增加好友
#define get_friendBuyBooth @"friend/buyBooth" //购买展位
#define get_friendGetPost @"friend/getPost" //帖子详情
#define get_friendPraisePost @"friend/praisePost"//帖子点赞
#define get_friendGetInfoPostCommentList  @"friend/getInfoPostCommentList"//获取帖子评论列表
#define get_friendSsetTop @"friend/setTop" //置顶
#define get_friendSetSelected @"friend/setSelected"//精选
#define get_friendSetNotice @"friend/setNotice"//公告
#define get_friendPostComment @"friend/postComment" //发表评论
#define get_friendPraisePostComment @"friend/praisePostComment"//评论点赞
#define get_friendGetInfoPostCommentReplyList @"friend/getInfoPostCommentReplyList"//获取帖子评论付汇列表
#define get_friendGetInfoPostCommentByCommentId @"friend/getInfoPostCommentByCommentId"//获取评论回复详情
#define get_shopGetMediaProductById @"shop/getMediaProductById"//圈子商品点击
#define get_friendAddCircleProduct @"friend/addCircleProduct"//增加圈子商品

#define get_enterpriseAdvGetEnterpriseId @"enterpriseAdv/getEnterpriseId"//获取企业信息
#define get_enterpriseAdvGetEnterpriseReleaseAdvList @"enterpriseAdv/getEnterpriseReleaseAdvList" //发布历史列表
#define getmediaShopCartCount @"mediaShop/cartCount"//获取购物车数量
#define get_mediaShopRechargeOrder @"mediaShop/rechargeOrder"//自媒体充值

#define get_CompanyuserFollowAdd @"user/followAdd"//关注企业
/********** 支付*************/
#define payWeixinnotify @"pay/weixinnotify"//微信异步通知
#define payWeixinpay @"pay/weixinpay" //创建微信支付

/***** 城市********/
#define get_cityAdvCollection @"cityAdv/collection"//收藏
#define get_cityAdvPraise @"cityAdv/praise"//点赞
#define get_cityAdvReward @"cityAdv/reward"//打赏
#define get_advGetRecommendMain @"adv/getRecommendMain" //乐看推荐获取轮播图
#define get_mediaAdvGetMainHotAdvList @"mediaAdv/getMainHotAdvList"//获取推荐分页信息
#define get_mediaAdvGetMediaSearchCirclesList  @"mediaAdv/getMediaSearchCirclesList "//获取自媒体圈子筛选.

#define get_userUpdateUserHeadImg @"user/updateUserHeadImg"//更改用户头像
#define get_friendDeleteCircleProduct @"friend/deleteCircleProduct"//删除圈子商品




#endif /* UrlConst_h */
