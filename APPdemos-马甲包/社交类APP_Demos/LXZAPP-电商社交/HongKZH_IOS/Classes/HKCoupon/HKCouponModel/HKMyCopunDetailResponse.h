//
//Created by ESJsonFormatForMac on 18/10/08.
//

#import <Foundation/Foundation.h>

@class HKMycopunData,HKMycopunImgs;
@interface HKMyCopunDetailResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMycopunData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMycopunData : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *beginTime;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, assign) NSInteger pintegral;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, strong) NSArray<HKMycopunImgs *> *imgs;

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *couponId;

@end

@interface HKMycopunImgs : NSObject

@property (nonatomic, copy) NSString *imgSrc;

@property (nonatomic, copy) NSString *productId;

@end

