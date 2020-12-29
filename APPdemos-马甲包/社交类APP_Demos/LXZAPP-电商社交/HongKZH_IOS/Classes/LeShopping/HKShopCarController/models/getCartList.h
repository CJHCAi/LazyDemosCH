//
//Created by ESJsonFormatForMac on 18/07/19.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class getCartListData,getCartListDataProducts;
@interface getCartList : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) NSArray<getCartListData *> *data;

//@property (nonatomic, assign) NSInteger code;
@property(nonatomic, assign) BOOL isSelectAll;
@end
@interface getCartListData : NSObject

@property (nonatomic, strong) NSMutableArray<getCartListDataProducts *> *products;

@property (nonatomic, copy) NSString *headImg;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *mediaUserId;
@property(nonatomic, assign) BOOL isSelectList;
@property(nonatomic, assign) double selectPrice;

@property (nonatomic,assign) NSInteger allCouponCount;

@property (nonatomic,assign) NSInteger randomID;
@end

@interface getCartListDataProducts : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *activityPrice;

@property (nonatomic, assign) NSInteger productNumber;

@property (nonatomic, copy) NSString *colorName;

@property (nonatomic, copy) NSString *cartId;

@property (nonatomic, copy) NSString *activityType;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *specName;

@property (nonatomic, copy) NSString *currentTime;

@property (nonatomic, copy) NSString *limitTime;

@property (nonatomic, assign) NSInteger number;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *mediaUserId;

@property (nonatomic, copy) NSString *skuId;

@property (nonatomic, assign) NSInteger isStorage;
@property(nonatomic, assign) BOOL isSelect;
@property (nonatomic,assign) NSInteger couponCount;

@property (nonatomic,assign) NSInteger userIntegral;
@property (nonatomic,assign) NSInteger countOffsetCoin;


@property (nonatomic,assign) BOOL isSelectCoin;
@property (nonatomic, copy)NSString *couponId;

@property (nonatomic,assign) NSInteger randomID;
@end

