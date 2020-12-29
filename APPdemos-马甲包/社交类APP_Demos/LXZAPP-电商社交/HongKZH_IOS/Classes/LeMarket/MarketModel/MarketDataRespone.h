//
//Created by ESJsonFormatForMac on 18/10/19.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class MarketData;
@interface MarketDataRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) MarketData *data;

//@property (nonatomic, assign) NSInteger code;

@end
@interface MarketData : NSObject

@property (nonatomic, assign) double integral;;

@property (nonatomic, assign) NSInteger bean;

@property (nonatomic, assign) NSInteger lobo;

@end

