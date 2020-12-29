//
//  HKPublicHeader.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#ifndef HKPublicHeader_h
#define HKPublicHeader_h
typedef enum{
    OrderFormStatue_waitPay = 1,//1 等待付款
    OrderFormStatue_verify = 2,//2 确定订单
    OrderFormStatue_payed = 3,//3 已支付
    OrderFormStatue_cnsignment = 4,//4 已发货
    OrderFormStatue_consignee = 5,//5 已收货
    OrderFormStatue_store = 6,//6 暂存储
    OrderFormStatue_finish = 7,//7 已完成
    OrderFormStatue_cancel =8,//8 已取消
    OrderFormStatue_resale = 9,//9 已转售
    OrderFormStatue_close = 10//10 已关闭
}OrderFormStatue;
typedef enum{
    AfterSaleViewStatue_Application = 10,//10 申请退款
    AfterSaleViewStatue_cancel = 20,//20 取消退款
    AfterSaleViewStatue_Agree = 30,//30 同意退款
    AfterSaleViewStatue_Refuse = 40,//40拒绝退款
    AfterSaleViewStatue_finish = 45,//5 退款完成
    AfterSaleViewStatue_Complaint = 50,//50 买家投诉
    AfterSaleViewStatue_cancelComplaint = 55,//55买家取消投诉
    AfterSaleViewStatue_ApplicationReturn =60,//申请退货退款
    AfterSaleViewStatue_cancelApplicationReturn = 65,// 取消退货退款
    AfterSaleViewStatue_SendReturnDelivery = 66,//已发退货快递
    AfterSaleViewStatue_AgreeReturn = 70,//70同意退货退款
     AfterSaleViewStatue_RefuseReturn = 80,//80拒绝退货退款
    AfterSaleViewStatue_ReturnFinish = 90,//90退货退款完成
    AfterSaleViewStatue_ProofOfBuyer  = 100,//100买家举证
    AfterSaleViewStatue_ProofOfBuyerseller  = 110// 110卖家举证
}AfterSaleViewStatue;

typedef enum{
    MyPostType_MyEdit = 0,//自己编辑
    MyPostType_Goods = 1,//乐购商品
    MyPostType_MediaM = 2,//自媒体
    MyPostType_Post = 3,//帖子
    MyPostType_Travels = 4,//游记
    MyPostType_MediaMVoideo = 5,//自媒体视频
    MyPostType_Advertising = 6//广告
}MyPostType;
typedef enum{
    HKSowingModelType_SelfMediaM = 1,//自媒体
    HKSowingModelType_Advertising = 2,//企业广告
    HKSowingModelType_CityAdvertising = 3,//城市广告
    HKSowingModelType_Traditional = 4//传统文化
}HKSowingModelType;
typedef enum{
    HKPalyStaue_play = 1,
    HKPalyStaue_stop = 2,
    HKPalyStaue_Success = 3,
    HKPalyStaue_End = 4,
    HKPalyStaue_close = 5,
    HKPalyStaue_pause = 6,
    HKPalyStaue_resume = 7
}HKPalyStaue;
typedef enum {
    Cater_videoCatergory = 1 , //视频
    Cater_collectionCaterGory  = 2, //收藏
    Cater_priseCaterGory = 3//点赞
    
} VideoCatergoryType;


typedef enum {
    FollowsFan_Fans = 1 , //我的粉丝
    FollowsFans_MyFollow  = 2, //我关注的个人
    FollowsFans_EnterPriseFollow = 3//我关注的企业
} FollowFansType;


typedef enum {
    HKPayType_LeShopOrder = 1 , //乐购订单支付
    HKPayType_Charge = 2, // APP充值
    HKPayType_Backstage= 3,// 后台充值
    HKPayType_GameOrder =4,//游戏订单
    HKPayType_GameCharge =5 //游戏充值
} HKPayType;

typedef void(^SDWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL);
#import "HKBaseResponeModel.h"


#endif /* HKPublicHeader_h */
