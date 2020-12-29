//
//Created by ESJsonFormatForMac on 18/09/27.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class CommodityDetailesData,CommodityDetailsesComment,CommodityDetailsesShop,CommodityDetailsesImages,CommodityDetailsesCoupons,CommodityDetailsesRecs,CommodityDetailsesColors,CommodityDetailsesSkus,CommodityDetailsesSpecs;
@interface CommodityDetailsRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) CommodityDetailesData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface CommodityDetailesData : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, strong) NSArray<CommodityDetailsesSpecs *> *specs;

@property (nonatomic, copy) NSString *afterService;

@property (nonatomic, assign) NSInteger lb;

@property (nonatomic, strong) NSArray<CommodityDetailsesRecs *> *recs;

@property (nonatomic, strong) CommodityDetailsesShop *shop;

@property (nonatomic, copy) NSString *subtitle;

@property (nonatomic, strong) CommodityDetailsesComment *comment;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<CommodityDetailsesColors *> *colors;

@property (nonatomic, copy) NSString *descript;

@property (nonatomic, strong) NSArray<CommodityDetailsesSkus *> *skus;

@property (nonatomic, strong) NSArray<CommodityDetailsesImages *> *images;

@property (nonatomic, strong) NSArray<CommodityDetailsesCoupons *> *coupons;

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger orders;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy)NSString * stocks;

@property (nonatomic, copy)NSString *skuId;

@property (nonatomic, copy)NSString *mediaUserId;

@property (nonatomic, copy)NSString *userId;
@end

@interface CommodityDetailsesComment : NSObject

@property (nonatomic, copy) NSString *orderDate;

@property (nonatomic, copy) NSString *uName;

@property (nonatomic, copy) NSString *commentId;

@property (nonatomic, copy) NSString *rName;

@property (nonatomic, copy) NSString *colorName;

@property (nonatomic, assign) NSInteger star;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *replyUserId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *specName;

@property (nonatomic, copy) NSString *rheadImg;

@property (nonatomic, copy) NSString *replyContent;

@property (nonatomic, copy) NSString *images;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *content;

@end

@interface CommodityDetailsesShop : NSObject

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, assign) NSInteger orders;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *imgSrc;

@end

@interface CommodityDetailsesImages : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@end

@interface CommodityDetailsesCoupons : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *couponId;

@end

@interface CommodityDetailsesRecs : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *subtitle;

@end

@interface CommodityDetailsesColors : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *productColorId;
@property(nonatomic, assign) CGFloat w;
@end

@interface CommodityDetailsesSkus : NSObject

@property (nonatomic, copy) NSString *productSpecId;

@property (nonatomic, copy) NSString *skuId;

@property (nonatomic, assign) NSInteger stocks;

@property (nonatomic, copy)NSString *discount;

@property (nonatomic, copy) NSString *productColorId;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) double integral;;

@end

@interface CommodityDetailsesSpecs : NSObject

@property (nonatomic, copy) NSString *productSpecId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *productId;
@property (nonatomic,assign) CGFloat w;
@end

