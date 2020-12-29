//
//Created by ESJsonFormatForMac on 18/08/28.
//

#import <Foundation/Foundation.h>

@class HKMySaleModel;
@interface HKMySaleRespone : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) HKMySaleModel *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface HKMySaleModel : NSObject

@property (nonatomic, assign) NSInteger completeCount;

@property (nonatomic, assign) NSInteger deliveryCount;

@property (nonatomic, copy) NSString *integral;

@property (nonatomic, assign) NSInteger refundsCount;

@property (nonatomic, assign) NSInteger payCount;

@property (nonatomic, assign) NSInteger visitors;

@end

