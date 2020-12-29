//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import <Foundation/Foundation.h>

@class IncomeDa ,Days;
@interface HK_MyIncomeModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) IncomeDa *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface IncomeDa : NSObject
//资产交易中
@property (nonatomic, assign) NSInteger transactionIntegral;

@property (nonatomic, strong) NSArray<Days *> *days;
//资产结算中
@property (nonatomic, assign) NSInteger settlementIntegral;
//当前时间总交易量
@property (nonatomic, assign) NSInteger countIntegral;

@end

@interface Days : NSObject

@property (nonatomic, assign) double integral;;

@property (nonatomic, copy) NSString *dates;

@end

