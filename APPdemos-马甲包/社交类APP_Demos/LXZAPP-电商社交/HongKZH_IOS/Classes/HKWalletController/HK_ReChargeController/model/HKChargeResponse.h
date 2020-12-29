//
//Created by ESJsonFormatForMac on 18/10/30.
//

#import <Foundation/Foundation.h>

@class HKChargeData;
@interface HKChargeResponse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKChargeData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKChargeData : NSObject

@property (nonatomic, copy) NSString *orderNumber;

@property (nonatomic, assign) NSInteger money;

@end

