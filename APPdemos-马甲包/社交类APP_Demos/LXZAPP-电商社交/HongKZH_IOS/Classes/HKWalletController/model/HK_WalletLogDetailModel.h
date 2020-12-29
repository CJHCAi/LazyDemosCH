//
//Created by ESJsonFormatForMac on 18/08/27.
//

#import <Foundation/Foundation.h>

@class LogDetailData;
@interface HK_WalletLogDetailModel : NSObject

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) LogDetailData *data;

@property (nonatomic, assign) NSInteger code;

@end
@interface LogDetailData : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *remarks;

@property (nonatomic, copy) NSString *createDate;
//当前余额
@property (nonatomic, assign) double integral;;
//最近交易金额
@property (nonatomic, assign) NSInteger lastCurrency;

@property (nonatomic, copy) NSString *logId;

@end

