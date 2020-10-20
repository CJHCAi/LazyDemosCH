//
//  ZHBGoodDetailViewModel.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/20.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBGoodDetailViewModel.h"
#import "ZHBProdictDetailInfoModel.h"
#import "ZHBProductAttrsInfoModel.h"

#import "APXProductModel.h"


@interface ZHBGoodDetailViewModel ()

@property (nonatomic, strong, readwrite) ZHBProdictDetailInfoModel *productInfo;
@property (nonatomic, strong, readwrite) NSArray <ZHBProductAttrsInfoModel *>*productAttrsInfoArray;

@property (nonatomic, strong, readwrite) NSArray *tags;
@property (nonatomic, strong, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSString *subName; // 副标题
@property (nonatomic, strong, readwrite) NSString *productId;
//@property (nonatomic, strong, readwrite) NSString *status; // 状态 6-下架 5-可供销售 不为5不可供销售
//@property (nonatomic, assign, readwrite) BOOL isExistCanSale; // 是否存在可售
@property (nonatomic, strong, readwrite) NSString *shareUrl;
//@property (nonatomic, strong) NSString *productNormURL; // 规格参数介绍页网址
//@property (nonatomic, strong) NSString *productDesURL; // 商品描述介绍页网址
@property (nonatomic, strong, readwrite) NSString *isOneyuan; // 是否是一元商品
@property (nonatomic, strong, readwrite) NSString *isRookie; // 是否是新人专区商品
@property (nonatomic, strong, readwrite) NSString *logoUrl; // 二维码logo Url

@property (nonatomic, strong, readwrite) APXActivityLinkModel *activityLink; // 活动链接(商品名称下方)

@property (nonatomic, strong, readwrite) NSString *supplierId; // 商品描述介绍页网址
@property (nonatomic, strong, readwrite) NSString *infoLimitTime;


// 买家秀
@property (nonatomic, strong, readwrite) APXBuyerShowModel *buyerShow;

@property (nonatomic, strong, readwrite) NSMutableArray *sectionItem; // sectionType数组

@property (nonatomic, strong, readwrite) NSArray <APXLatestOrder *> *latestOrder; // 最新订单

/***** 为您推荐和排行榜 ******/
@property (nonatomic, strong, readwrite) APXRecommendAndRank *recommendAndRank;

@end

@implementation ZHBGoodDetailViewModel

+ (instancetype)viewModelWithGoodInfoData:(NSDictionary *)data
{
//    if (IsNilOrNull(data)) {
//        return nil;
//    }
    NSLog(@"商品详情%@",data);
    ZHBGoodDetailViewModel *goodDetailVM = [[ZHBGoodDetailViewModel alloc] init];
    
    // others
    goodDetailVM.tags = [data objectForKey:@"tags"];
    goodDetailVM.name = [data objectForKey:@"name"];
    goodDetailVM.subName = [data objectForKey:@"subName"];
    goodDetailVM.productId = [data objectForKey:@"productId"];
    goodDetailVM.status = [data objectForKey:@"status"];
    goodDetailVM.shareUrl = [data objectForKey:@"shareUrl"];
    goodDetailVM.productNormURL = [data objectForKey:@"productNormURL"];
    goodDetailVM.productDesURL = [data objectForKey:@"productDesURL"];
    goodDetailVM.supplierId = [data objectForKey:@"supplierId"];
    goodDetailVM.infoLimitTime = [data objectForKey:@"infoLimitTime"];
    goodDetailVM.isExistCanSale = [[data objectForKey:@"isExistCanSale"] boolValue];
    goodDetailVM.isOneyuan = [data objectForKey:@"isOneyuan"];
    goodDetailVM.isRookie = [data objectForKey:@"isRookie"];
    goodDetailVM.logoUrl = [data objectForKey:@"logoUrl"];

    goodDetailVM.productInfo = [ZHBProdictDetailInfoModel yy_modelWithDictionary:[data objectForKey:@"productInfo"]];
    
    goodDetailVM.productAttrsInfoArray = [NSArray yy_modelArrayWithClass:[ZHBProductAttrsInfoModel class] json:[data objectForKey:@"productAttrsInfo"]];
                                          
                                        
    // 设置行,因为评论行有可能没有
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    [arrayM addObject:@(GoodDetailSectionTypeBasicInfo)];

    
    goodDetailVM.sectionItem = arrayM;

    
    
    
    return goodDetailVM;
}

- (void)updateRecommend:(APXRecommendAndRank *)recommendAndRank
{
    self.recommendAndRank = recommendAndRank;
}

- (void)updateProductInfoWithGoodDetailInfo:(NSDictionary *)data
{
    self.productInfo = [ZHBProdictDetailInfoModel yy_modelWithJSON:[data objectForKey:@"productInfo"]];
    // 刷新
    self.productAttrsInfoArray = [NSArray yy_modelArrayWithClass:[ZHBProductAttrsInfoModel class] json:[data objectForKey:@"productAttrsInfo"]];
    
    // standard 父类 赋值 bottonsValue.fatherType
    for (ZHBProductAttrsInfoModel *attrsInfo in self.productAttrsInfoArray) {
        // 遍历大属性下的bottons 红色等属性
        for (ZHBBottonsValueModel *bottonsValue in attrsInfo.value) {
            bottonsValue.fatherType = attrsInfo.type;
        }
    }
}

#pragma mark - lazy
- (NSMutableArray *)selectedStandardLabelArray
{
    if (!_selectedStandardLabelArray) {
        _selectedStandardLabelArray = [[NSMutableArray alloc] init];
    }
    return _selectedStandardLabelArray;
}


- (NSMutableArray *)sectionItem
{
    if (!_sectionItem) {
        _sectionItem = [[NSMutableArray alloc] init];
    }
    return _sectionItem;
    
}


@end
