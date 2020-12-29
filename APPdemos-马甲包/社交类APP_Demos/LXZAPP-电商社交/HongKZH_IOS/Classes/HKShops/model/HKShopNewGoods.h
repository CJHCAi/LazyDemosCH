//
//Created by ESJsonFormatForMac on 18/10/08.
//

#import <Foundation/Foundation.h>

@class HKShopNewGoodData,HKShopNewGoodsList,HKShopNewGoodsProduct;
@interface HKShopNewGoods : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKShopNewGoodData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKShopNewGoodData : NSObject

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger totalRow;

@property (nonatomic, assign) NSInteger pageNumber;

@property (nonatomic, assign) BOOL lastPage;

@property (nonatomic, assign) BOOL firstPage;

@property (nonatomic, strong) NSArray<HKShopNewGoodsList *> *list;

@property (nonatomic, assign) NSInteger totalPage;

@end

@interface HKShopNewGoodsList : NSObject

@property (nonatomic, copy) NSString *day1;

@property (nonatomic, strong) NSArray<HKShopNewGoodsProduct *> *products;

@end

@interface HKShopNewGoodsProduct : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger couponCount;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) double integral;

@property (nonatomic, copy) NSString *subtitle;

@end

