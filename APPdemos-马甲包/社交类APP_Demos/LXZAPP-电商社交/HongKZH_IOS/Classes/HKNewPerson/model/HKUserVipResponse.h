//
//Created by ESJsonFormatForMac on 18/10/10.
//

#import <Foundation/Foundation.h>

@class HKUserVipBaseData,HKUserVipList;
@interface HKUserVipResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKUserVipBaseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKUserVipBaseData : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *vipCouponId;

@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, strong) NSArray<HKUserVipList *> *imgs;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *remarks;

@end

@interface HKUserVipList : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@end

