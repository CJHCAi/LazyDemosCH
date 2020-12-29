//
//Created by ESJsonFormatForMac on 18/10/25.
//

#import <Foundation/Foundation.h>

@class HKPriseData;
@interface HKPostPriseResonse : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKPriseData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKPriseData : NSObject

@property (nonatomic, copy) NSString *praiseCount;

@end

