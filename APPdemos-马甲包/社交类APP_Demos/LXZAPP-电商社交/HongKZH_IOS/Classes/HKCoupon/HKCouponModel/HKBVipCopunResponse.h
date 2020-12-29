//
//Created by ESJsonFormatForMac on 18/10/11.
//

#import <Foundation/Foundation.h>

@class HKVipData;
@interface HKBVipCopunResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKVipData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKVipData : NSObject

@property (nonatomic, copy) NSString *couponId;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *beginDate;

@end

