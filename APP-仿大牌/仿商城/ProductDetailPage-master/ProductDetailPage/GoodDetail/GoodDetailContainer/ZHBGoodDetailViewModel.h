//
//  ZHBGoodDetailViewModel.h
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/20.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZHBProdictDetailInfoModel;
@class ZHBProductAttrsInfoModel;
@class APXProductCommentAllModel;
@class APXProductCommentModel;
@class APXLatestOrder;
@class APXRecommendAndRank;
@class APXBuyerShowModel;
@class APXActivityLinkModel;

@interface ZHBGoodDetailViewModel : NSObject

/*****  子商品  ****/
@property (nonatomic, strong, readonly) ZHBProdictDetailInfoModel *productInfo;

/*****  商品属性  ****/
@property (nonatomic, strong, readonly) NSArray <ZHBProductAttrsInfoModel *>*productAttrsInfoArray;

// 下面2者差别在于提示语组合方式不一样一个是 XX:XX 一个是XX,XX
//  加入购物车提示语,以及向下一层传递eg.颜色:银色 尺寸:ipnone7
@property (nonatomic, copy) NSString *chooseStandardLabelText;
// 已选提示语,eg.银色,iPhone7 用数组来装,实际上需要的字符串
@property (nonatomic, strong) NSMutableArray *selectedStandardLabelArray;
// 请选择XXX提示语
@property (nonatomic, copy) NSString *showTipNoSelectedText;

/*****  主商品各个字段  ****/
@property (nonatomic, strong, readonly) NSArray *tags;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *subName; // 副标题
@property (nonatomic, strong, readonly) NSString *productId;
@property (nonatomic, strong) NSString *status; // 状态 6-下架 5-可供销售 不为5不可供销售
@property (nonatomic, assign) BOOL isExistCanSale; // 是否存在可售
@property (nonatomic, strong, readonly) NSString *shareUrl;
@property (nonatomic, strong) NSString *productNormURL; // 规格参数介绍页网址
@property (nonatomic, strong) NSString *productDesURL; // 商品描述介绍页网址
@property (nonatomic, strong, readonly) NSString *isOneyuan; // 是否是一元商品
@property (nonatomic, strong, readonly) NSString *isRookie; // 是否是新人专区商品
@property (nonatomic, strong, readonly) NSString *logoUrl; // 二维码logoUrl

@property (nonatomic, strong, readonly) NSString *supplierId; // 供应商id
@property (nonatomic, strong, readonly) NSString *infoLimitTime;// 限时抢兑字段

@property (nonatomic, strong, readonly) APXActivityLinkModel *activityLink; // 活动链接(商品名称下方)


/*****  评论  ******/
@property (nonatomic, strong, readonly) APXProductCommentAllModel *productCommentHeaderModel;
@property (nonatomic, strong, readonly) NSMutableArray <APXProductCommentModel *>* productCommentArray;
/***** 买家秀  ******/
@property (nonatomic, strong, readonly) APXBuyerShowModel *buyerShow;

/*****  组别数组  ******/
@property (nonatomic, strong, readonly) NSMutableArray *sectionItem;

/*****  最新订单  ******/
@property (nonatomic, strong, readonly) NSArray <APXLatestOrder *> *latestOrder;

/***** 为您推荐和排行榜 ******/
@property (nonatomic, strong, readonly) APXRecommendAndRank *recommendAndRank;


+ (instancetype)viewModelWithGoodInfoData:(NSDictionary *)data;

- (void)updateRecommend:(APXRecommendAndRank *)recommendAndRank;

- (void)updateProductInfoWithGoodDetailInfo:(NSDictionary *)data;

@end
