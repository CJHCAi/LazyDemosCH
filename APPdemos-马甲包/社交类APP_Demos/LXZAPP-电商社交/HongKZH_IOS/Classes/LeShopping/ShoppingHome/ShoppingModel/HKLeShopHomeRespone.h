//
//Created by ESJsonFormatForMac on 18/09/27.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class HKLeShopHomeDatas,HKLeShopHomeCategoryes,HKLeShopHomeToSelectedproducts,HKLeShopHomeLuckyvouchers,HKLeShopHomeCarouseles,HKLeShopHomeHotsshopes,HKLeShopHomeShopes;
@interface HKLeShopHomeRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKLeShopHomeDatas *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface HKLeShopHomeDatas : NSObject

@property (nonatomic, strong) NSArray<HKLeShopHomeCategoryes *> *categorys;

@property (nonatomic, strong) NSArray<HKLeShopHomeToSelectedproducts *> *selectedProducts;

@property (nonatomic, strong) NSMutableArray<HKLeShopHomeLuckyvouchers *> *luckyVoucher;

@property (nonatomic, strong) NSMutableArray<HKLeShopHomeCarouseles *> *carousels;

@property (nonatomic, strong) NSArray<HKLeShopHomeHotsshopes *> *hotsShops;

@end

@interface HKLeShopHomeCategoryes : NSObject

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, copy) NSString *categoryName;

@property (nonatomic, copy)NSString *imgSrc;
@end

@interface HKLeShopHomeToSelectedproducts : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) double integral;;
@end

@interface HKLeShopHomeLuckyvouchers : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, assign) NSInteger sortDate;

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, assign) NSInteger currentHour;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, assign) NSInteger endDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, assign) NSInteger discountIntegral;

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger beginDate;

@property (nonatomic,assign) NSInteger difference;
@property (nonatomic,assign) NSInteger startDifference;
@end

@interface HKLeShopHomeCarouseles : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *model;

@property (nonatomic, assign) NSInteger imgRank;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *specialId;

@end

@interface HKLeShopHomeHotsshopes : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *categoryId;

@property (nonatomic, strong) NSArray<HKLeShopHomeShopes *> *shops;

@property (nonatomic, copy) NSString *categoryName;

@end

@interface HKLeShopHomeShopes : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, copy) NSString *imgSrc;

@end

