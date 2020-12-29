//
//Created by ESJsonFormatForMac on 18/10/08.
//

#import <Foundation/Foundation.h>

@class HKCollageResBaseData,HKCollageImgs;
@interface HKCollageResPonse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKCollageResBaseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKCollageResBaseData : NSObject

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *collageCouponId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, assign) NSInteger num;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, strong) NSArray<HKCollageImgs *> *imgs;

@property (nonatomic, copy) NSString *ctitle;

@end

@interface HKCollageImgs : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@end

